//
//  LVPlayVodDetailVC.m
//  XianPao
//
//  Created by hanyong on 2019/3/22.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "LVPlayVodDetailVC.h"
#import "SuperPlayer.h"
#import "SPWeiboControlView.h"
#import "PlayModel.h"


#define COMMENT_TV_H 60
#define DEFAULT_TV_H 33

@interface LVPlayVodDetailVC ()<SuperPlayerDelegate>

/** 播放器View的父视图*/
@property (nonatomic) UIView *playerFatherView;
@property (strong, nonatomic) SuperPlayerView *playerView;
@property (nonatomic , strong) SuperPlayerModel *playerModel;

@property (nonatomic , strong) UILabel *intoL;
@property (nonatomic , strong) UILabel *nameL;
@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) PlayModel *selectedModel;
@property (nonatomic , strong) UIButton *selectedBtn;

@end

@implementation LVPlayVodDetailVC

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
    //    _playerView.controlView = [SPWeiboControlView new];
    // 设置代理
    self.playerView.fatherView = self.playerFatherView;
    self.playerView.delegate = self;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playerFatherView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.playerFatherView.frame))];
    [self.view addSubview:self.scrollView];
    
    self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 0, 15)];
    self.nameL.textColor = [UIColor whiteColor];
    self.nameL.font = [UIFont systemFontOfSize:12] ;
    [self.scrollView addSubview:self.nameL];
    self.nameL.numberOfLines = 1;
    
    self.intoL = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 0, 0)];
    self.intoL.textColor = [UIColor whiteColor];
    self.intoL.font = [UIFont systemFontOfSize:12] ;
    [self.scrollView addSubview:self.intoL];
    self.intoL.numberOfLines = 0;
    
    self.intoL.text = self.item.info;
    self.nameL.text = self.item.name;
    CGSize size = [self.item.info boundingRectWithSize:CGSizeMake(screenW - 40, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
    CGRect frame = self.intoL.frame;
    frame.size = size;
    self.intoL.frame = frame;

    float Margin = 20;
    float x = 0;
    float y = CGRectGetMaxY(self.intoL.frame) + 20;
    float h = 34;
    
    for (int i = 0 ; i < self.item.play.count ;i++) {
        PlayModel *model = self.item.play[i];
        
        UIButton *btn = [[UIButton alloc]init];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [self.scrollView addSubview:btn];
        UIImage *img = [[self imageWithColor:[FYColorTool colorFromHexRGB:@"4595FA" alpha:1]] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        UIImage *imgsel = [[self imageWithColor:[FYColorTool colorFromHexRGB:@"FF0000" alpha:1]] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [btn setBackgroundImage:imgsel forState:UIControlStateSelected];
        btn.selected = NO;
        btn.tag = i;
        [btn setTitle:model.text forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        CGSize size = CGSizeMake(btn.bounds.size.width + 20 < 45 ? 45 : btn.bounds.size.width + 20, h);
        CGFloat btnX = 0;
        CGFloat btnY = 0;
        CGFloat btnW = size.width;
        CGFloat btnH = h;
        if (i == 0) {
            self.selectedModel = model;
            self.selectedBtn = btn;
            btn.selected = YES;
        }
        
        //每次X递增Margin
        x = Margin + x;
        //计算btn的X
        btnX = x;
        if (btnX + btnW + Margin > screenW) {//如果超长，换行 y递增 x=0
            y = y + Margin + h;
            btnX = 0 + Margin;
        }
        //计算btn的Y
        btnY = y;
        //设置btnframe
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        //累加x，用于下次计算
        x = btnX + size.width ;
    }
    UIScrollView *sc = (UIScrollView *)self.scrollView;
    sc.contentSize = CGSizeMake(0, y + 50);
   
}

-(void)btnClick:(UIButton *)btn{
    if (self.selectedBtn != btn) {
        self.selectedBtn.selected = NO;
    }
    btn.selected = !btn.selected;
    self.selectedBtn = btn;

    PlayModel *model = self.item.play[btn.tag];
    if (self.selectedModel != model) {
        self.selectedModel = model;
        //播放新的model
        NSLog(@"播放新的model");
        [self PlayWithPlayModel:model];
    }
    NSLog(@"%@",model.url);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //创建模型
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    playerModel.videoURL = self.selectedModel.url;
    self.playerModel = playerModel;
    //播放模型
    [self.playerView playWithModel:playerModel];
}

-(void)PlayWithPlayModel:(PlayModel *)model{
    self.playerModel.videoURL = model.url;
    [self.playerView playWithModel:self.playerModel];
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


@end
