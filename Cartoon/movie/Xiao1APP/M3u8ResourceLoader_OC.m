//
//  M3u8ResourceLoader_OC.m
//  Cartoon
//
//  Created by zxh on 2019/8/15.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M3u8ResourceLoader_OC.h"

static NSString *apple_m3u8 = @"#EXTM3U\n#EXT-X-PLAYLIST-TYPE:EVENT\n#EXT-X-TARGETDURATION:10\n#EXT-X-VERSION:3\n#EXT-X-MEDIA-SEQUENCE:0\n#EXTINF:10, no desc\n#EXT-X-KEY:METHOD=AES-128,URI=\"ckey://devimages.apple.com/samplecode/AVARLDelegateDemo/BipBop_gear3_segmented/crypt0.key\", IV=0x3ff5be47e1cdbaec0a81051bcc894d63\nrdtp://devimages.apple.com/samplecode/AVARLDelegateDemo/BipBop_gear3_segmented/fileSequence0.ts\n#EXTINF:10, no desc\nrdtp://devimages.apple.com/samplecode/AVARLDelegateDemo/BipBop_gear3_segmented/fileSequence1.ts\n#EXTINF:10, no desc\nrdtp://devimages.apple.com/samplecode/AVARLDelegateDemo/BipBop_gear3_segmented/fileSequence2.ts\n#EXTINF:10, no desc\nrdtp://devimages.apple.com/samplecode/AVARLDelegateDemo/BipBop_gear3_segmented/fileSequence3.ts\n#EXTINF:10, no desc\nrdtp://devimages.apple.com/samplecode/AVARLDelegateDemo/BipBop_gear3_segmented/fileSequence4.ts\n#EXT-X-ENDLIST";

@interface M3u8ResourceLoader_OC() {
    NSString *m3u8_url_vir;
    NSString *m3u8_url;
}

@end

@implementation M3u8ResourceLoader_OC

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [M3u8ResourceLoader_OC shared];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [M3u8ResourceLoader_OC shared];
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return [M3u8ResourceLoader_OC shared];
}

+ (M3u8ResourceLoader_OC *)shared {
    static M3u8ResourceLoader_OC *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone: nil] init];
    });
    return instance;
}

- (M3u8ResourceLoader_OC *)init {
    self = [super init];
    m3u8_url_vir = @"m3u8Scheme://abcd.m3u8";
    return self;
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSString *url = [[[loadingRequest request] URL] absoluteString];
    if (!url) {
        return false;
    }
    if ([url hasSuffix: @".ts"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *newUrl = [url stringByReplacingOccurrencesOfString: @"rdtp" withString: @"http"];
            NSURL *url = [[NSURL alloc] initWithString: newUrl];
            if (url) {
                NSURLRequest *redirect = [[NSURLRequest alloc] initWithURL: url];
                [loadingRequest setRedirect: redirect];
                [loadingRequest setResponse: [[NSHTTPURLResponse alloc] initWithURL: [redirect URL] statusCode: 301 HTTPVersion: nil headerFields: nil]];
                [loadingRequest finishLoading];
            } else {
                [self finishLoadingError: loadingRequest];
            }
        });
        return true;
    }
    if ([url isEqualToString: m3u8_url_vir]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [self M3u8Request: self->m3u8_url];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *m3u8String = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                    //提取出所有ts片段
                    NSArray *array = [m3u8String componentsSeparatedByString:@"\n"];
                    // 筛选出 .ts 文件
                    NSMutableArray *listArr = [NSMutableArray arrayWithCapacity:array.count];
                    for (NSString *str in array) {
                        if ([str containsString:@".ts"]) {
                            [listArr addObject:str];
                        }
                    }
                    //修改ts片段
                    NSString *newM3u8String =m3u8String;
                    for(NSString *str in listArr) {
                        NSString *baseUrl = [self->m3u8_url stringByDeletingLastPathComponent];
                        NSString *newStr = [baseUrl stringByAppendingPathComponent:str];
                        newM3u8String = [newM3u8String stringByReplacingOccurrencesOfString: str withString: newStr];
                    }
                    newM3u8String = [newM3u8String stringByReplacingOccurrencesOfString: @"key.key" withString: [[self->m3u8_url stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"key.key"]];
                    NSLog(@"%@",newM3u8String);

                    NSData *data = [newM3u8String dataUsingEncoding: NSUTF8StringEncoding];
                    [[loadingRequest dataRequest] respondWithData: data];
                    [loadingRequest finishLoading];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self finishLoadingError: loadingRequest];
                });
            }
        });
        return true;
    }
    if (![url hasSuffix: @".ts"] && ![url isEqualToString: m3u8_url_vir]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *newUrl = [url stringByReplacingOccurrencesOfString: @"ckey" withString: @"http"];
            NSURL *url = [[NSURL alloc] initWithString: newUrl];
            if (url) {
                NSData *data = [[NSData alloc] initWithContentsOfURL: url];
                if (data) {
                    [[loadingRequest dataRequest] respondWithData: data];
                    [loadingRequest finishLoading];
                } else {
                    [self finishLoadingError: loadingRequest];
                }
            } else {
                [self finishLoadingError: loadingRequest];
            }
        });
        return true;
    }
    return false;
}

- (void)finishLoadingError: (AVAssetResourceLoadingRequest *)loadingRequest {
    [loadingRequest finishLoadingWithError: [[NSError alloc] initWithDomain: NSURLErrorDomain code: 400 userInfo: nil]];
}

- (NSData *)M3u8Request: (NSString *)url {

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];

    return data;
}

- (AVPlayerItem *)playItemWith: (NSString *)url {
    m3u8_url = url;
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL: [[NSURL alloc] initWithString: m3u8_url_vir] options: nil];
    [[urlAsset resourceLoader] setDelegate: self queue: dispatch_get_main_queue()];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset: urlAsset];
    return item;
}

@end
