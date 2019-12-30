//
//  TestViewController.m
//  Cartoon
//
//  Created by zxh on 2019/12/30.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "TestViewController.h"
#import "RSA.h"
#import "NSString+Common.h"
#import "ToJsonTool.h"
#import "ReactiveObjC.h"

static NSString * const RSA_PublicKey               = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtN3iBTvp5t8Leyr4A0eCMgV1n/2x7KKPcgghZtS+Fu5bEAzSc+SQ7eiz9HOtOSY6PkXXIyQb6J5C5DfIWOn7ImeEetl13xPBGPlDdrdG82vRo1C2vGioo40GyKOZVb3DnxfdFiNbffTFd4sugm5zsrSXmX2+C/uspElu1ctjfKicnUnpd0Z0Jo6+nw8BN4yujQK+kTdpNzKVk2Ia3c5HUohw+xPBTt1L4vLKaxwYkP+7hEDwAfhA4r3NkEcuGfVyjyvyucbh7en6+vjL3K7xJE0VhNCmjKaYiUVC12qKC1KqLJZc4Z2KjBSaubkrZjXZUCW6t04YuNCpIFtEv2k3hwIDAQAB";

@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (nonatomic , strong) NSMutableArray *phoneList;
@property (nonatomic , assign) dispatch_semaphore_t sem;
@end

@implementation TestViewController

- (IBAction)startRegistePhone:(id)sender {
    
    int num = 2;
    if ([self.numTF.text intValue] == 0) {
       num = 2;
    }else{
        num = [self.numTF.text intValue];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手机" message:[NSString stringWithFormat:@"确定要注册(%d)个手机用户么？",num] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showProgress:0];
        // 创建队列组，可以使多个网络请求异步执行，执行完之后再进行操作
                   dispatch_group_t group = dispatch_group_create();
                   //创建全局队列
                   dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
                   dispatch_group_async(group, queue, ^{
                       for (int i = 0; i< num; i++) {
                           [SVProgressHUD showProgress:i*1.0/(num) status:[NSString stringWithFormat:@"%.1f%%",i*100.0/(num)]];
                           dispatch_semaphore_t sem =  dispatch_semaphore_create(0);
                           self.sem = sem;
                           [self registByPhone];
                       }
                       [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                       [SVProgressHUD dismiss];
                   });
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)startRegisteThird:(id)sender {
    int num = 2;
       if ([self.numTF.text intValue] == 0) {
          num = 2;
       }else{
           num = [self.numTF.text intValue];
       }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"第三方" message:[NSString stringWithFormat:@"确定要注册(%d)个第三方用户么？",num] preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
     UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
         [SVProgressHUD showProgress:0];
         // 创建队列组，可以使多个网络请求异步执行，执行完之后再进行操作
                    dispatch_group_t group = dispatch_group_create();
                    //创建全局队列
                    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
                    dispatch_group_async(group, queue, ^{
                        for (int i = 0; i< num; i++) {
                            [SVProgressHUD showProgress:i*1.0/(num) status:[NSString stringWithFormat:@"%.1f%%",i*100.0/(num)]];
                            dispatch_semaphore_t sem =  dispatch_semaphore_create(0);
                            self.sem = sem;
                            [self loginByThirdLoginModel];
                        }
                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                        [SVProgressHUD dismiss];
                    });
     }];
     [alert addAction:cancel];
     [alert addAction:sure];
     [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)loginDaliy:(id)sender {
    
    [SVProgressHUD showInfoWithStatus:@"未实现"];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showProgress:0];
    
    // 创建队列组，可以使多个网络请求异步执行，执行完之后再进行操作
    dispatch_group_t group = dispatch_group_create();
    //创建全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i< self.phoneList.count; i++) {
            NSString *phone = self.phoneList[i];
            [SVProgressHUD showProgress:i*1.0/(self.phoneList.count) status:[NSString stringWithFormat:@"%.1f%%",i*100.0/(self.phoneList.count)]];
            dispatch_semaphore_t sem =  dispatch_semaphore_create(0);

            NSString *requestUrl = @"https://www.jifenkoudai.com/auth/oauth/token";
            NSDictionary *params = @{@"grant_type":@"password",
                                     @"scope":@"server",
                                     @"username":phone,
                                     @"password":@"123456"
            };
            NSDictionary *headerDict = @{
                @"Authorization":@"Basic ZWJlaTplYmVp"
            };
            [XPNetWorkTool requestWithType:HttpRequestTypePost withHttpHeaderFieldDict:headerDict withUrlString:requestUrl withParaments:params withSuccessBlock:^(NSDictionary *responseObject) {
                
                NSString *token = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
                NSMutableDictionary *params =@{}.mutableCopy;
                   params[@"tokenDevice"] = @"112233445566";
                   NSString * jsonString = [ToJsonTool  convertToJsonData:params];
                   
                   AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                   NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString: @"https://www.jifenkoudai.com/admin/user/editAccessInfo" parameters:nil error:nil];
                   req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
                   [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                   [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                   
                   [req setValue:token forHTTPHeaderField:@"Authorization"];
                   [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
                   [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                       dispatch_semaphore_signal(sem);
                       if (!error) {
                           NSLog(@"更新dv成功");
                       } else {
                           NSLog(@"更新失败");
                       }
                       
                   }] resume];
                
                
            } withFailureBlock:^(NSString *errorMsg) {
                [SVProgressHUD showInfoWithStatus:errorMsg];
                dispatch_semaphore_signal(sem);
            } progress:^(float progress) {
                
            }];
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        }
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD dismiss];
    });
}





//手机注册
- (void)registByPhone{
   
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"123456" forKey:@"password"];
    int regfrom = arc4random() % 2 + 1;
    [params setObject:@(regfrom) forKey:@"regfrom"];
    //随机手机号码
    NSArray *phone3Array = @[@"13",@"14",@"15",@"16",@"17",@"18",@"19"];
    int index = arc4random()%7;
    NSString *phone = phone3Array[index];
    NSString *sufStr = [NSString stringWithFormat:@"%ld",(long)(arc4random() % 888888888) + 100000000];
    phone = [phone stringByAppendingString:sufStr];
    
    NSLog(@"%@",phone);
     

    //RSA加密
    NSString *encryptStr = [RSA encryptString:phone publicKey:RSA_PublicKey];
    [params setObject:encryptStr forKey:@"username"];

    NSString * jsonString = [ToJsonTool  convertToJsonData:params];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://www.jifenkoudai.com/admin/user" parameters:nil error:nil];
    req.timeoutInterval = 5;
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if ([responseObject[@"code"] intValue ] != 0) {
                [SVProgressHUD showInfoWithStatus:responseObject[@"msg"]];
            }else{
                [self loadLoginRequest:phone];
            }
        } else {
            
        }
    }];
  [task resume];
    
  dispatch_semaphore_wait(self->_sem, DISPATCH_TIME_FOREVER);
}


#pragma mark - 账号密码登录来获取token
-(void)loadLoginRequest:(NSString *)phone{
    NSString *requestUrl = @"https://www.jifenkoudai.com/auth/oauth/token";
    NSDictionary *params = @{@"grant_type":@"password",
                             @"scope":@"server",
                             @"username":phone,
                             @"password":@"123456"
                             };
    NSDictionary *headerDict = @{
    @"Authorization":@"Basic ZWJlaTplYmVp"
    };
    [XPNetWorkTool requestWithType:HttpRequestTypePost withHttpHeaderFieldDict:headerDict withUrlString:requestUrl withParaments:params withSuccessBlock:^(NSDictionary *responseObject) {
        NSString *token = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
        [self loadUserInfoDataWithToken:token];
        //记录手机号码
        int regfrom = arc4random() % 10 ;
        if (regfrom <= 3) {
            [self.phoneList addObject:phone];
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneList forKey:@"phoneList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } withFailureBlock:^(NSString *errorMsg) {
        [SVProgressHUD showInfoWithStatus:errorMsg];
       
    } progress:^(float progress) {

    }];
}



//第三方注册
- (void)loginByThirdLoginModel{
    //0--微信。1--qq 2--sina
    //随机平台
    int type = arc4random()%11;
    NSString *openid = @"";
    NSString *chartArray = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789RSTUVWXYZabcdefghijklmnopHIJKLMNOPQRST";
    
    if (type<=6) {//微信
        type = 0;
        openid = @"oW6NH0";
        for (int i = 0; i<22; i++) {
            NSString *p = [chartArray substringWithRange:NSMakeRange(arc4random()%(chartArray.length-3), 1)];
           openid = [openid stringByAppendingString:p];
        }
    }else if(6 <type && type <= 9){
        type = 1;
        int loc = arc4random()%(chartArray.length-1);
        long lengthMAX = chartArray.length -1 - loc;
        int len = arc4random()%lengthMAX;
        openid = [[chartArray substringWithRange:NSMakeRange(loc, len)] md5] ;
    }else{
        type = 2;
        openid = [NSString stringWithFormat:@"%ld",(long)(1000000000 + arc4random()%8888888888)];
    }
    
    int regfrom = arc4random() % 2 + 1;
    
    NSLog(@"----%d ,------ %@  --%d",type,openid,regfrom);

    NSString *requestUrl = @"https://www.jifenkoudai.com/auth/social/token";
    //RSA加密
    NSString *encrypt_openidStr = [RSA encryptString:[NSString stringWithFormat:@"Thirdparty  %@",openid] publicKey:RSA_PublicKey];
    NSDictionary *params = @{
                             @"grant_type":@"openid" ,
                             @"scope":@"server" ,
                             @"openid":encrypt_openidStr,
                             @"type":[NSString stringWithFormat:@"%d",type],
                             @"regfrom":@(regfrom)   //1-ios 2=安卓
                             };

    NSDictionary *headerDict = @{
                                 @"Authorization":@"Basic ZWJlaTplYmVp"
                                 };

    
    [XPNetWorkTool requestWithType:HttpRequestTypePost withHttpHeaderFieldDict:headerDict withUrlString:requestUrl withParaments:params withSuccessBlock:^(NSDictionary *responseObject) {//获得token和refreshtoken
   
        NSString *token = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
        [self loadUserInfoDataWithToken:token];
        
    } withFailureBlock:^(NSString *errorMsg) {
        
    } progress:^(float progress) {
        
    }];
    dispatch_semaphore_wait(self->_sem, DISPATCH_TIME_FOREVER);
//         });
}



-(void)loadUserInfoDataWithToken:(NSString *)token{
    NSString *requestUrl = @"https://www.jifenkoudai.com/admin/user/info";
    NSDictionary *headerDict = [NSDictionary dictionaryWithObjectsAndKeys:token, @"Authorization", nil];
  
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:headerDict withUrlString:requestUrl withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        dispatch_semaphore_signal(self->_sem);
        [self changeUmenDeviceToken:token];
        
    } withFailureBlock:^(NSString *errorMsg) {
        dispatch_semaphore_signal(self->_sem);
    } progress:^(float progress) {

    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.phoneList = [NSMutableArray arrayWithCapacity:40];
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneList"];
    [self.phoneList addObjectsFromArray:array];
}


//更改deviceToken
-(void)changeUmenDeviceToken:(NSString *)token{
    NSMutableDictionary *params =@{}.mutableCopy;
    params[@"tokenDevice"] = @"112233445566";
    NSString * jsonString = [ToJsonTool  convertToJsonData:params];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString: @"https://www.jifenkoudai.com/admin/user/editAccessInfo" parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [req setValue:token forHTTPHeaderField:@"Authorization"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"更新dv成功");
            int regfrom = arc4random() % 7 ;
            if (regfrom <= 4) {
                [self reportInstallAction];
            }
        } else {
            NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
        }
        
    }] resume];
}


//上报安装
-(void)reportInstallAction{
    int regfrom = arc4random() % 2 ;
    NSDictionary *params = @{
                             @"downloadWay":@(regfrom)
                             };
    NSString *requestURl = @"https://www.jifenkoudai.com/video/api/installApk/insertInstallApk";
    [XPNetWorkTool requestWithType:HttpRequestTypePost withHttpHeaderFieldDict:nil withUrlString:requestURl withParaments:params withSuccessBlock:^(NSDictionary *responseObject) {
         
    } withFailureBlock:^(NSString *errorMsg) {

    } progress:^(float progress) {

    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
