//
//  DDOffLinePlayVC.m
//  Cartoon
//
//  Created by zxh on 2019/10/9.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "DDOffLinePlayVC.h"
#import "DDDetailVC.h"
#import "SuperPlayer.h"
#import "SPWeiboControlView.h"
#import "DDPlayModel.h"
#import "DDListModel.h"

@interface DDOffLinePlayVC ()<SuperPlayerDelegate>

/** 播放器View的父视图*/
@property (nonatomic) UIView *playerFatherView;
@property (strong, nonatomic) SuperPlayerView *playerView;
@property (nonatomic , strong) SuperPlayerModel *playerModel;

@property (nonatomic , strong) UILabel *intoL;
@property (nonatomic , strong) UILabel *nameL;
@property (nonatomic , strong) UILabel *lastL;
@property (nonatomic , strong) UILabel *urlL;
@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) DDPlayModel *selectedModel;
@property (nonatomic , strong) UIButton *selectedBtn;
@property (nonatomic , strong) NSMutableArray *playLists;
@property (nonatomic , strong) NSMutableArray *downloadLists;
@property (nonatomic , assign) BOOL isFullScreen;
@end

@implementation DDOffLinePlayVC

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

    -(void)resumeMovie{
        if (self.playerView.state != StatePlaying ) {
            [self.playerView resume];
        }
    }

    -(void)stopMovie{
        if (self.playerView.state != StateStopped && self.playerView.state != StatePause ) {
            [self.playerView pause];
        }
    }

    - (void)viewDidLoad{
        [super viewDidLoad];
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(resumeMovie) name:@"NeedResumeMovie" object:nil];
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(stopMovie) name:@"NeedStopMovie" object:nil];
        
    //创建模型
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    self.playerModel = playerModel;
    [self getVodDetailInfo];
}

-(void)getVodDetailInfo{
    NSString *urlstr = self.vodModel.urlStr;
        if (urlstr.length > 0) {
                NSArray *urlArray = [urlstr componentsSeparatedByString:@"#"];
                self.playLists = [NSMutableArray array];
                
            for (int i = 1; i <= urlArray.count; i++) {
                NSString *url = urlArray[i-1];
                DDPlayModel *model = [DDPlayModel new];
                NSArray *modelList = [url componentsSeparatedByString:@"$"];
                if (modelList.count > 1) {
                    model.name = modelList[0];
                     model.url = modelList[1];
                    [self.playLists addObject:model];
                }else{
                    model.name = [NSString stringWithFormat:@"%0d",i];
                     model.url = modelList[0];
                    [self.playLists addObject:model];
                }
            }

            //下载地址
            NSString *downUrl = self.vodModel.vod_down_url;
            if (downUrl.length > 0) {
                    NSArray *urlArray = [downUrl componentsSeparatedByString:@"#"];
                    self.downloadLists = [NSMutableArray array];
                     for (int i = 1; i <= urlArray.count; i++) {
                         NSString *url = urlArray[i-1];
                         if (url.length < 5) {
                             continue;
                         }
                         DDPlayModel *model = [DDPlayModel new];
                         NSArray *modelList = [url componentsSeparatedByString:@"$"];
                         if (modelList.count > 1) {
                             model.name = modelList[0];
                             model.url = modelList[1];
                             [self.downloadLists addObject:model];
                         }else{
                             model.name = [NSString stringWithFormat:@"%0d",i];
                             model.url = modelList[0];
                             [self.downloadLists addObject:model];
                         }
                     }
            }
            
            [self setUI];
            return ;
        }
    [SVProgressHUD showInfoWithStatus:@"获取详情失败！！！！"];
}

-(void)setUI{
    NSLog(@"%@,%@",self.playLists,self.vodModel);
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
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playerFatherView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.playerFatherView.frame) - 60)];
    [self.view addSubview:self.scrollView];
    
    UIButton *bottombtn = [[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.scrollView.frame), screenW - 80, 30)];
    [bottombtn setTitle:@"隐藏" forState:UIControlStateNormal];
    [bottombtn setTitle:@"显示" forState:UIControlStateSelected];
    [bottombtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [bottombtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [bottombtn addTarget:self action:@selector(bottombtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottombtn];
    
    
    self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth - 150, 15)];
    self.nameL.textColor = [UIColor whiteColor];
    self.nameL.font = [UIFont systemFontOfSize:12] ;
    [self.scrollView addSubview:self.nameL];
    self.nameL.numberOfLines = 1;
    
    self.lastL = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 130, 0, 130, 15)];
    self.lastL.textColor = [UIColor whiteColor];
    self.lastL.font = [UIFont systemFontOfSize:9 weight:UIFontWeightMedium];
    NSString *mid = [NSString stringWithFormat:@"DD%@",self.vodModel.vod_id];
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:mid];
    self.lastL.text = [NSString stringWithFormat:@"上次观看:%@",str];
    [self.scrollView addSubview:self.lastL];
    
    self.urlL = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, ScreenWidth - 100, 20)];
    self.urlL.textColor = [UIColor whiteColor];
    self.urlL.font = [UIFont systemFontOfSize:8] ;
    [self.scrollView addSubview:self.urlL];
    self.urlL.numberOfLines = 2;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(screenW - 60, 15, 60, 20)];
       [btn setTitle:@"go" forState:UIControlStateNormal];
       btn.backgroundColor = [UIColor redColor];
       btn.layer.cornerRadius = 5;
       [btn addTarget:self action:@selector(goWeb) forControlEvents:UIControlEventTouchUpInside];
       [self.scrollView addSubview:btn];
    
    self.intoL = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 0, 0)];
    self.intoL.textColor = [UIColor whiteColor];
    self.intoL.font = [UIFont systemFontOfSize:12] ;
    [self.scrollView addSubview:self.intoL];
    self.intoL.numberOfLines = 0;
    
    
    self.intoL.text = self.vodModel.vod_content;
    self.nameL.text = self.vodModel.vod_name;
    CGSize size = [self.vodModel.vod_content boundingRectWithSize:CGSizeMake(screenW - 40, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
    CGRect frame = self.intoL.frame;
    frame.size = size;
    self.intoL.frame = frame;
    
    float Margin = 20;
    float x = 0;
    float y = CGRectGetMaxY(self.intoL.frame) + 20;
    float h = 34;
    
    for (int i = 0 ; i < self.self.playLists.count ;i++) {
        DDPlayModel *model = self.playLists[i];
        
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
        [btn setTitle:model.name forState:UIControlStateNormal];
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
        if (str && [str isEqualToString:model.name]) {
            self.selectedModel = model;
            self.selectedBtn.selected = NO;
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

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, y + 50, 200, 20)];
    label.text = @"备用地址";
    label.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:label];
    y = y + 80;
    x = 0;
       for (int i = 0 ; i < self. downloadLists.count ;i++) {
           DDPlayModel *model = self.downloadLists[i];
           
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
           [btn setTitle:model.name forState:UIControlStateNormal];
           [btn addTarget:self action:@selector(downbtnClick:) forControlEvents:UIControlEventTouchUpInside];
           [btn sizeToFit];
           CGSize size = CGSizeMake(btn.bounds.size.width + 20 < 45 ? 45 : btn.bounds.size.width + 20, h);
           CGFloat btnX = 0;
           CGFloat btnY = 0;
           CGFloat btnW = size.width;
           CGFloat btnH = h;
        
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
       sc.contentSize = CGSizeMake(screenW, y + 50);
    
    
    BOOL flag = NO;
    if (self.selectedModel == [self.playLists firstObject]) {
        flag = YES;
    }
    [self PlayWithPlayModel:self.selectedModel needSave:flag];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.scrollView scrollRectToVisible:self.selectedBtn.frame animated:YES];
    });
    
}

-(void)goWeb{
UIPasteboard *sb = [UIPasteboard generalPasteboard];
sb.string = self.playerModel.videoURL;
[SVProgressHUD showInfoWithStatus:@"复制成功"];
return;
}


-(void)downbtnClick:(UIButton *)btn{
    if (self.selectedBtn != btn) {
        self.selectedBtn.selected = NO;
    }
    btn.selected = !btn.selected;
    self.selectedBtn = btn;
    
    DDPlayModel *model = self.downloadLists[btn.tag];
    if (self.selectedModel != model) {
        self.selectedModel = model;
        //播放新的model
        NSLog(@"播放新的model");
        [self PlayWithPlayModel:model needSave:YES];
    }
    NSLog(@"%@",model.url);
}

-(void)btnClick:(UIButton *)btn{
    if (self.selectedBtn != btn) {
        self.selectedBtn.selected = NO;
    }
    btn.selected = !btn.selected;
    self.selectedBtn = btn;
    
    [self.scrollView scrollRectToVisible:self.selectedBtn.frame animated:YES];
    
    DDPlayModel *model = self.playLists[btn.tag];
    if (self.selectedModel != model) {
        self.selectedModel = model;
        //播放新的model
        NSLog(@"播放新的model");
        [self PlayWithPlayModel:model needSave:YES];
    }
    NSLog(@"%@",model.url);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}

-(void)PlayWithPlayModel:(DDPlayModel *)model needSave:(BOOL)save{
    [self.playerView resetPlayer];
    if (save) {
        NSString *mid = [NSString stringWithFormat:@"DD%@",self.vodModel.vod_id];
        NSString *str = model.name;
        self.lastL.text = [NSString stringWithFormat:@"上次观看:%@",str];
        [[NSUserDefaults standardUserDefaults] setValue:str forKey:mid];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.urlL.text = @"重设播放器";
    self.playerModel.videoURL = model.url;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.urlL.text = model.url;
    });
    [self.playerView playWithModel:self.playerModel];
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


-(void)bottombtnclick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.scrollView.hidden = YES;
    }else{
        self.scrollView.hidden = NO;
    }
}

@end
