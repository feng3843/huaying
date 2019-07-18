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
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 300, screenW, screenH - 300)];
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
    
   
}

@end
