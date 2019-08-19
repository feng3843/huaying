//
//  HomeViewController.m
//  Cartoon
//
//  Created by zxh on 2019/7/17.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "HomeViewController.h"
#import "movie/Mogu/MoGuController.h"
#import "movie/Xiao1APP/XXYSViewController.h"
#import "movie/kuaikan/KKViewController.h"
#import "movie/wanmei/WMViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController
- (IBAction)moguClick:(id)sender {
    MoGuController *vc = [[MoGuController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)xiaoxiaoClick:(id)sender {
    XXYSViewController *vc = [[XXYSViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)kuaikanclick:(id)sender {
    KKViewController *vc = [[KKViewController alloc]init];
    vc.url = @"http://app123.66s.cc/qian50m.html";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)wanmeiClick:(id)sender {
    WMViewController *vc = [[WMViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)xxxxx{

}

@end
