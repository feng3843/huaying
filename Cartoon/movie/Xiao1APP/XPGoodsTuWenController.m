//
//  XPGoodsTuWenController.m
//  XianPao
//
//  Created by zxh on 2019/7/3.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "XPGoodsTuWenController.h"
#import <WebKit/WebKit.h>

@interface XPGoodsTuWenController ()<UIScrollViewDelegate>
@property (nonatomic , strong) WKWebView *webView;
@property (nonatomic , assign) BOOL videoFullScreen;
@end

@implementation XPGoodsTuWenController


-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setUI];
}

-(void)setHtml:(NSString *)html{
    _html = html;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView loadHTMLString:html baseURL:nil];
    });
}


-(void)setUI{
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0,300, screenW, screenH-300)];
    [self.view addSubview:self.webView];
    self.webView.backgroundColor = [UIColor blackColor];
    
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.scrollEnabled = NO;
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoBeginFullScreen)
                                                 name:UIWindowDidBecomeVisibleNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoStopFullScreen)
                                                 name:UIWindowDidBecomeHiddenNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)handleDeviceOrientationDidChange {
    
    if (!self.videoFullScreen) {
        
        return;
    }
    
    UIDevice *device = [UIDevice currentDevice];
    switch (device.orientation) {
        case UIDeviceOrientationLandscapeLeft:
            [self startFullScreenRight];
            NSLog(@"屏幕向左横置");
            break;
            
        case UIDeviceOrientationLandscapeRight:
            [self startFullScreenLeft];
            NSLog(@"屏幕向右橫置");
            break;
            
        case UIDeviceOrientationPortrait:
            [self endFullScreen];
            NSLog(@"屏幕直立");
            break;
    }
}

- (void)startFullScreenRight {
    NSLog(@"进入全屏");
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarOrientation: UIInterfaceOrientationLandscapeRight];
    application.keyWindow.transform = CGAffineTransformMakeRotation(M_PI / 2);
    application.keyWindow.bounds = CGRectMake(0, 0, screenW, screenH);
}

- (void)startFullScreenLeft {
    
    NSLog(@"进入全屏");
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarOrientation: UIInterfaceOrientationLandscapeRight];
    application.keyWindow.transform = CGAffineTransformMakeRotation(3 * M_PI / 2);
    application.keyWindow.bounds = CGRectMake(0, 0, screenW, screenH);
}

- (void)endFullScreen {
    NSLog(@"退出全屏XXXX");
    UIApplication *application=[UIApplication sharedApplication];
    [application setStatusBarOrientation: UIInterfaceOrientationPortrait];
    application.keyWindow.bounds = CGRectMake(0, 0, screenW, screenH);
    application.keyWindow.transform = CGAffineTransformIdentity;
    [application setStatusBarHidden:NO];
}


- (void)videoBeginFullScreen {
    
    self.videoFullScreen = YES;
}

- (void)videoStopFullScreen {
    
    self.videoFullScreen = NO;
    UIApplication *application=[UIApplication sharedApplication];
    [application setStatusBarOrientation: UIInterfaceOrientationPortrait];
    [application setStatusBarHidden:NO];
}

@end
