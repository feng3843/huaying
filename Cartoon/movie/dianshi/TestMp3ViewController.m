//
//  TestMp3ViewController.m
//  Cartoon
//
//  Created by zxh on 2019/9/11.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "TestMp3ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TestMp3ViewController ()
@property (nonatomic , strong) AVPlayer *player;
@property (nonatomic , strong) AVPlayerItem *playItem;
@end

@implementation TestMp3ViewController{
    BOOL _needSkip;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://1253690353.vod2.myqcloud.com/3308ed44vodgzp1253690353/81f77f9f5285890793899652272/YNFeiPaOXG0A.mp3"];
    //youxiao
//    NSURL *url = [NSURL URLWithString:@"http://1253690353.vod2.myqcloud.com/3308ed44vodgzp1253690353/26b671345285890793898013091/NNlJJX4RAnAA.mp3"];
    
    AVAsset *asset = [AVAsset assetWithURL:url];

    AVPlayerItem *playItem = [AVPlayerItem playerItemWithAsset:asset];
    //添加监听
    [playItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.playItem = playItem;
    
    self.player = [AVPlayer playerWithPlayerItem:playItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //设置模式
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.contentsScale = [UIScreen mainScreen].scale;
    playerLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer addSublayer:playerLayer];
    //添加声音
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
             withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                   error:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //监听播放失败时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logError:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logError:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logError:) name:AVPlayerItemNewAccessLogEntryNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logError:) name:AVPlayerItemNewErrorLogEntryNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logError:) name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:nil];

}
    
-(void)logError:(NSNotification *)not{
    NSLog(@"%@",not.userInfo);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.playItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
}

-(void)playEnd{
    NSLog(@"end~~~~~~~");
}

//监听回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    NSLog(@"%@   %@",keyPath,change);
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
    }else if ([keyPath isEqualToString:@"status"]){
        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
            NSLog(@"playerItem is ready");
            [self.player play];
        } else{
            NSLog(@"load break   %@",keyPath);
            [self playEnd];
        }
    }
}


@end
