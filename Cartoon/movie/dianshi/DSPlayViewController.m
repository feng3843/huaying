//
//  DSPlayViewController.m
//  Cartoon
//
//  Created by zxh on 2019/8/20.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "DSPlayViewController.h"
#import "SuperPlayer.h"
#import "SPWeiboControlView.h"


@interface DSPlayViewController ()<SuperPlayerDelegate>

/** 播放器View的父视图*/
@property (nonatomic) UIView *playerFatherView;
@property (strong, nonatomic) SuperPlayerView *playerView;
@property (nonatomic , strong) SuperPlayerModel *playerModel;

@property (nonatomic , strong) UILabel *urlL;
@property (nonatomic , strong) UITextView *textView;


@end

@implementation DSPlayViewController

- (void)dealloc {
    [self.playerView resetPlayer];  //非常重要
    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    self.view.backgroundColor = [UIColor blackColor];
    
    //显示的播放界面
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 88, ScreenWidth, 40)];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    //播放界面
    self.playerFatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 128, ScreenWidth, ScreenWidth*9.0f/16.0f)];
    self.playerFatherView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerFatherView];
    //设置播放器
    self.playerView = [[SuperPlayerView alloc] init];
    
    SuperPlayerViewConfig *config = [[SuperPlayerViewConfig alloc]init];
    config.hwAcceleration = NO;
    config.maxCacheItem = 20;
    config.playerType = PLAYER_AVPLAYER;//zxh zzxxhh 启用avplayer可以减少某些卡顿
    self.playerView.playerConfig = config;
    
    // 设置代理
    self.playerView.fatherView = self.playerFatherView;
    self.playerView.delegate = self;
    //创建模型
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    self.playerModel = playerModel;
    playerModel.videoURL = self.playUrl;
    
    //设置控制view
    SPWeiboControlView *controlView = [SPWeiboControlView new];
    controlView.videoTitle = self.name;
    self.playerView.controlView = controlView;
    
    
    //播放模型
    [self.playerView playWithModel:self.playerModel];
    
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playerFatherView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.playerFatherView.frame) - 60)];
    [self.view addSubview:view1];
    
    self.urlL = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, ScreenWidth - 100, 20)];
    self.urlL.textColor = [UIColor whiteColor];
    self.urlL.font = [UIFont systemFontOfSize:8] ;
    [view1 addSubview:self.urlL];
    self.urlL.text = self.playUrl;
    self.urlL.numberOfLines = 2;
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 45, screenW - 20, 300)];
    self.textView.textColor = [UIColor whiteColor];
    self.textView.userInteractionEnabled = NO;
    self.textView.font = [UIFont systemFontOfSize:8] ;
    self.textView.backgroundColor = [UIColor blackColor];
    [view1 addSubview:self.textView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInfo:) name:@"VOD_LOG_INFO" object:nil];
}

-(void)getInfo:(NSNotification *)notify{
    NSDictionary *dict = notify.userInfo;
    NSString *str = dict[@"logText"];
    NSMutableString *strText = [NSMutableString stringWithFormat:@"%@\n",self.textView.text];
    [strText appendString:str];
    self.textView.text = strText;
    [self.textView scrollRangeToVisible:NSMakeRange(strText.length - 1, 1)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.playerModel) {
        [self.playerView resume];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.playerView pause];
}

#pragma mark - 状态控制
// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;

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

#pragma mark - SuperPlayerDelegate
/** 返回事件 */
- (void)superPlayerBackAction:(SuperPlayerView *)player{
    if (!self.playerView.isFullScreen){
        [self backClick];
    }
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

-(void)superPlayerPlayBtnClick:(SuperPlayerView *)player{
//    [self.playerView playWithModel:self.playerModel];
}


@end
