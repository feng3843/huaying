//
//  TestPlayController.m
//  Cartoon
//
//  Created by zxh on 2020/3/11.
//  Copyright © 2020 hanyong. All rights reserved.
//

#import "TestPlayController.h"
#import "SuperPlayer.h"
#import "SPWeiboControlView.h"


@interface TestPlayController ()<SuperPlayerDelegate>

/** 播放器View的父视图*/
@property (nonatomic) UIView *playerFatherView;
@property (strong, nonatomic) SuperPlayerView *playerView;
@property (nonatomic , strong) SuperPlayerModel *playerModel;

@property (nonatomic , assign) BOOL isFullScreen;


@end

@implementation TestPlayController

- (void)dealloc {
    [self.playerView resetPlayer];  //非常重要
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"%@释放了",self.class);
}

- (void)didMoveToParentViewController:(nullable UIViewController *)parent
{
    if (parent == nil) {
        if (!SuperPlayerWindowShared.isShowing) {
            [self.playerView resetPlayer];
        }
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    //创建模型
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    self.playerModel = playerModel;
    
    [self setUI];
}


-(void)setUI{

    self.view.backgroundColor = [UIColor blackColor];
    
    //显示的播放界面
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    //播放界面
    self.playerFatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenWidth*9.0f/16.0f)];
    self.playerFatherView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerFatherView];
    
    //设置播放器
    self.playerView = [[SuperPlayerView alloc] init];
    SuperPlayerViewConfig *config = [SuperPlayerViewConfig new];
    config.hwAcceleration = NO;
    self.playerView.playerConfig = config;
    // 设置代理
    self.playerView.fatherView = self.playerFatherView;
    self.playerView.delegate = self;
    
    self.playerModel = [SuperPlayerModel new];
    self.playerModel.videoURL = @"rtmp://9250.liveplay.myqcloud.com/live/9250_51041332";
    [self.playerView playWithModel:self.playerModel];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}



#pragma mark - 状态控制
// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.playerView.isFullScreen;
}

-(BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (self.isFullScreen) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationUnknown] forKey:@"orientation"];
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        });
            
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationUnknown] forKey:@"orientation"];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
         });
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - SuperPlayerDelegate
-(void)superPlayerFullScreenChanged:(SuperPlayerView *)player{
    if (player.isFullScreen) {
        self.isFullScreen = YES;
        [self supportedInterfaceOrientations];
    }else{
        self.isFullScreen = NO;
        [self supportedInterfaceOrientations];
    }
}

/** 返回事件 */
- (void)superPlayerBackAction:(SuperPlayerView *)player{
    if (!self.playerView.isFullScreen){
        [self backClick];
    }
}

-(void)superPlayerDidEnd:(SuperPlayerView *)player{
    
}

#pragma mark - 返回

- (void)backClick {
    [self.playerView resetPlayer];  //非常重要
    [self.navigationController popViewControllerAnimated:YES];
}

// 颜色转为图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 开启上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(ref, color.CGColor);
    // 渲染上下文
    CGContextFillRect(ref, rect);
    // 从上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}



@end
