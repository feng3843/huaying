//
//  XPGameVC.m
//  Cartoon
//
//  Created by zxh on 2019/10/30.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "XPGameVC.h"
#import <WebKit/WebKit.h>

@interface XPGameVC ()<WKScriptMessageHandler>
@property (nonatomic , strong) WKWebView *webView;
@property (nonatomic , strong) WKUserContentController *userContentController;
@end

@implementation XPGameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    //注册供js调用的方法
    _userContentController =[[WKUserContentController alloc]init];
    configuration.userContentController = _userContentController;
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
    
    [_userContentController addScriptMessageHandler:self name:@"Browser"];

    [self.view addSubview:self.webView];
    
    NSURL *url = [NSURL URLWithString:@"https://h5.51xianwan.com/try/iOS/try_list_ios.aspx?ptype=1&appsign=100&deviceid=423423-adfkf-23423-23233&appid=1011&keycode=bb93a0b16fbb0efd5aeec747c7773ce4"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url] ];
    
//    NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"index.html"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
//    [self.webView loadRequest: request];
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 64, 40, 40)];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


-(void)goBack{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if(message.name == nil || [message.name isEqualToString:@""]){
           return;
       }
       //message.body : js 传过来值
       NSLog(@"%@",message.body);
      //message.name  js发送的方法名称
      //每个方法传不传参数, 传什么类型的参数, 需要和后台确定
       if([message.name  isEqualToString:@"Browser"]){
           NSDictionary *Dic = message.body;
           //获取 js 传来的参数
//             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [Dic objectForKey:@"body"] ]]];
           NSLog(@"%@",[Dic objectForKey:@"body"] );
           
           
           [SVProgressHUD setBackgroundColor:[UIColor redColor]];
           [SVProgressHUD showInfoWithStatus:[Dic objectForKey:@"body"]];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
           });
           
//           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[Dic objectForKey:@"body"] preferredStyle:UIAlertControllerStyleAlert];
//              UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//              }];
//              [alert addAction:action];
//              [self presentViewController:alert animated:YES completion:nil];
           
       }
}

@end
