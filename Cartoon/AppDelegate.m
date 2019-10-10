//
//  AppDelegate.m
//  Cartoon
//
//  Created by hanyong on 2019/4/22.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "AppDelegate.h"
#import "NetTool/XPNetWorkTool.h"
#import "HomeViewController.h"
#import "WRNavigation/WRNavigationBar.h"
#import <CoreFoundation/CoreFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController =  [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init] ];
    [self.window makeKeyAndVisible];
    

    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back_white"];
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"back_white"];
    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:[UIColor blackColor]];
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:[FYColorTool colorFromHexRGB:@"#FFFFFF" alpha:1.0f]];
    // 设置导航栏标题默认颜色
    [WRNavigationBar wr_setDefaultNavBarTitleColor:[FYColorTool colorFromHexRGB:@"#FFFFFF" alpha:1.0f]];
    
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setMaximumDismissTimeInterval:5];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];// 弹出框内容颜色
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
    [SVProgressHUD setInfoImage:nil];
    
  
    return YES;
}



-(void)xiazai{
    //mac云音乐保存路径
    // @"/Users/{你的用户名}/Library/Containers/com.netease.163music/Data/Library/Caches/online_play_cache"
    //源文件夹
    NSString *inPutFileRoot = @"/Users/mac/Desktop/未命名文件夹 6";
    //输出文件夹
    NSString *outPutFileRoot = @"/Users/mac/Desktop/未命名文件夹 7/";
    
    //读取需要解密的所有文件路径
    NSFileManager *manger = [NSFileManager defaultManager];
    NSArray *arr = [manger subpathsAtPath:inPutFileRoot];
    //循环解密
    for (NSString *path in arr) {
        //如果不是uc!结尾，不解密
        if (![path hasSuffix:@"uc!"]) {
            continue;
        }
        //截取musicID
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"-_-_"];
        NSString *mID = [path substringToIndex:[path rangeOfCharacterFromSet:set].location];
        //请求网络，获取音乐名字
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.imjad.cn/cloudmusic/?type=detail&id=%@",mID]];
        NSURLSessionDataTask *downsession = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //获取音乐名字
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *songs = res[@"songs"];
            NSDictionary *firstOb = songs[0];
            NSDictionary *al = firstOb[@"al"];
            NSString *name = al[@"name"];
            //读取数据data
            NSData *tempData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",inPutFileRoot,path]];
            //解密数据
            Byte *testByte = (Byte *)[tempData bytes];
            for(int i=0;i<[tempData length];i++){
                testByte[i] = testByte[i] ^ 0xa3;
            }
            //生成新数据
            NSData *newData = [NSData dataWithBytes:testByte length:tempData.length];
            //拼接目标文件名字
            NSString *outPutFileName = [NSString stringWithFormat:@"%@%@.mp3",outPutFileRoot,name];
            //写文件
            [newData writeToFile:outPutFileName  atomically:YES];
        }];
        
        [downsession resume];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
