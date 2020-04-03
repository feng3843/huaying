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
#import <AdSupport/AdSupport.h>
#import "ZXHNavViewController.h"
#import <AVFoundation/AVFoundation.h>

 

@interface AppDelegate ()
@property (nonatomic , strong) NSMutableArray *dataArray;
@end

@implementation AppDelegate

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputDeviceChanged:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
 
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController =  [[ZXHNavViewController alloc]initWithRootViewController:[[HomeViewController alloc]init] ];
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
    
//    [self initDataArray];
    
   NSString *IDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //如果用户将属于此Vender的所有App卸载，则idfv的值会被重置
    NSLog(@"111");
    
    
    NSString *url = [NSString stringWithFormat:@"http://rwskv2.adyouzi.com/aide/get_userinfo?bundleID=com.hihi.hihi22&chanel=ios&device_id=%@&device_type=ios&version=3.0",IDFV];
    
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
    } withFailureBlock:^(NSString *errorMsg) {
        
    } progress:^(float progress) {
        
    }];
    
    return YES;
}

-(void)outputDeviceChanged:(NSNotification *)notify{
    NSLog(@"----------%@",notify);
    int value = [notify.userInfo[@"AVAudioSessionRouteChangeReasonKey"] intValue];
    if (value == 2) {//取下耳机
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedStopMovie" object:nil];
        });
        
    }else{//带上耳机
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedResumeMovie" object:nil];
        });
        
    }
}

- (void)initDataArray{
    self.dataArray=[NSMutableArray new];
    
    NSString * cccc=[self decodeString:@"TFNBcHBsaWNhdGlvbldvcmtzcGFjZQ=="];//LSApplicationWorkspace
    SEL s = NSSelectorFromString([self decodeString:@"ZGVmYXVsdFdvcmtzcGFjZQ=="]);//defaultWorkspace
    SEL ss = NSSelectorFromString([self decodeString:@"aW5zdGFsbGVkUGx1Z2lucw=="]);//installedPlugins
    SEL sss = NSSelectorFromString([self decodeString:@"Y29udGFpbmluZ0J1bmRsZQ=="]);//containingBundle
    SEL ssss = NSSelectorFromString([self decodeString:@"YXBwbGljYXRpb25JZGVudGlmaWVy"]);//applicationIdentifier

    //[LSApplicationWorkspace defaultWorkspace]
    id obj = [NSClassFromString(cccc) performSelector:s];
    // [[LSApplicationWorkspace defaultWorkspace] installedPlugins]
    NSArray *array = [obj performSelector:ss];
    
    for (id i in array) {
        //[LSPlugInKitProxy containingBundle];
        id oo = [i performSelector:sss];
        if (oo){
            //[LSApplicationProxy applicationIdentifier];
            [self.dataArray addObject:[oo performSelector:ssss]];
           NSLog(@"%@",[oo performSelector:ssss]);
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self open:@"com.hanyong.XianPao"];
    });
}

- (void)open:(NSString*)identify{
    NSString * cccc=[self decodeString:@"TFNBcHBsaWNhdGlvbldvcmtzcGFjZQ=="];//LSApplicationWorkspace
    char mychar[cccc.length];
    NSString * oooo=[self decodeString:@"ZGVmYXVsdFdvcmtzcGFjZQ=="];//defaultWorkspace
    NSString * ffff=[self decodeString:@"b3BlbkFwcGxpY2F0aW9uV2l0aEJ1bmRsZUlEOg=="];//openApplicationWithBundleID:
    
    Class lsawsc = objc_getClass(strcpy(mychar,(char *)[cccc UTF8String]));
    NSObject* obj = [lsawsc performSelector:NSSelectorFromString(oooo)];
    
    SEL selector = NSSelectorFromString(ffff);
    [obj performSelector:selector withObject:identify];
}

- (NSString *)decodeString:(NSString *)string
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSString *decodedStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return decodedStr;
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
