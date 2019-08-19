//
//  M3u8ResourceLoader_OC.h
//  Cartoon
//
//  Created by zxh on 2019/8/15.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVAssetResourceLoader.h>

@interface M3u8ResourceLoader_OC : NSObject <AVAssetResourceLoaderDelegate>

+ (M3u8ResourceLoader_OC *)shared;
- (AVPlayerItem *)playItemWith: (NSString *)url;

@end
