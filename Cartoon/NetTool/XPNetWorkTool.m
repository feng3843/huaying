//
//  XPNetWorkTool.m
//  XianPao
//
//  Created by XiaoBao on 2018/8/15.
//  Copyright © 2018年 hanyong. All rights reserved.
//

#import "XPNetWorkTool.h"

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isKindOfClass:[NSNull class]]) || ([(_ref) isEqual:@"(null)"]))

@implementation XPNetWorkTool
#pragma mark - shareManager
/**
 *  获得全局唯一的网络请求实例单例方法
 *
 *  @return 网络请求类的实例
 */

+(instancetype)shareManager
{
    
    static XPNetWorkTool * manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://cartoon.ergeduoduo.com/"]];
        
    });
    
    return manager;
}


#pragma mark - 重写initWithBaseURL
/**
 *
 *
 *  @param url baseUrl
 *
 *  @return 通过重写夫类的initWithBaseURL方法,返回网络请求类的实例
 */

-(instancetype)initWithBaseURL:(NSURL *)url
{
    
    if (self = [super initWithBaseURL:url]) {
        
        NSAssert(url,@"您需要为您的请求设置baseUrl");
        
        /**设置请求超时时间*/
        
        self.requestSerializer.timeoutInterval = 6;
        
        /**设置相应的缓存策略*/
        
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        
        /**分别设置请求以及相应的序列化器*/
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
        
        response.removesKeysWithNullValues = YES;//移除空值
        
        self.responseSerializer = response;
        
        //        /**复杂的参数类型 需要使用json传值-设置请求内容的类型*/
        //
        //        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        /**设置接受的类型*/
        [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
        
        //        /**设置apikey ------类似于自己应用中的tokken---此处仅仅作为测试使用*/
        //        [self.requestSerializer setValue:[CommParms shareInstance].user.token ? [CommParms shareInstance].user.token : @"C47B1071" forHTTPHeaderField:@"token"];
        
//        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];        
    }
    
    return self;
}


#pragma mark - 网络请求的类方法---get/post
/**
 *  网络请求的实例方法
 *
 *  @param type         get / post
 *  @param headDict     请求头设置
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 *  @param progress 进度
 */

+(void)requestWithType:(HttpRequestType)type withHttpHeaderFieldDict:(NSDictionary *)headDict withUrlString:(NSString *)urlString withParaments:(id)paraments withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock progress:(downloadProgress)progress
{
    if (IsNilOrNull(headDict) || ![headDict isKindOfClass:[NSDictionary class]]){
        [XPNetWorkTool shareManager].requestSerializer = [AFHTTPRequestSerializer serializer];
    }else{
        NSArray *keys = headDict.allKeys;
        for (NSString * key in keys) {
            [[XPNetWorkTool shareManager].requestSerializer setValue:headDict[key] forHTTPHeaderField:key];
        }
    }
    
    switch (type) {
            
        case HttpRequestTypeGet:
        {
            
            
            [[XPNetWorkTool shareManager] GET:urlString parameters:paraments progress:^(NSProgress * _Nonnull downloadProgress) {
                
                progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                successBlock(responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString *reason = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
                if (IsNilOrNull(reason) || [reason isEqualToString:@"(null)"]) {

                    failureBlock(reason);
                    return;
                }else{
//                    [SVProgressHUD showInfoWithStatus:reason];
                    failureBlock(reason);
                    return;
                }

            }];
            break;
        }
            
        case HttpRequestTypePost:
            
        {
            [[XPNetWorkTool shareManager] POST:urlString parameters:paraments progress:^(NSProgress * _Nonnull uploadProgress) {
                
                progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSInteger responseCode = [responseObject[@"code"] integerValue];
                if (responseCode == -5) {

                    failureBlock(responseObject[@"msg"]);
                    return;
                }
                else if (responseCode == 110) {//110  页面无法展示
                    failureBlock(responseObject[@"msg"]);
                    return;
                }
                else if (responseCode != 0) {
                    failureBlock(responseObject[@"msg"]);
                    return;
                }

                successBlock(responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //处理服务器自定义返回的错误
//                NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
//                NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSDictionary *dic = [str mj_JSONObject];
//                if (dic) {//后台返回的错误事件
//                    BOOL error_description_isNULL = IsNilOrNull(dic[@"error_description"]);
//                    if([dic[@"error"] isEqualToString:@"invalid_token"] || ([dic[@"error"] isEqualToString:@"unauthorized"] && !error_description_isNULL && [dic[@"error_description"] hasPrefix:@"Full authentication"])){//token失效  || 用户未授权
//                        GDDLog(@"token失效！！！需要重新登录！！！！");
//                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NEED_REFRESH_TOKEN object:nil];
//                        failureBlock(@"服务器开小差了,再试一次");
//                        return ;
//                    }else if([dic[@"status"] intValue] == 401){//新用户注册
//                        failureBlock(@"401");//新用户登录返回401
//                        return ;
//                    }else if ([dic[@"error"] isEqualToString:@"invalid_grant"] && !error_description_isNULL && [dic[@"error_description"] hasPrefix:@"Invalid refresh token:"]){
//                        [SVProgressHUD showInfoWithStatus:@"登录过期"];//本地refresh_token也失效
//                        [CommParms shareInstance].user = nil;
//                        [[CommParms shareInstance] saveUser];
//                        failureBlock(@"登录过期");
//                        return;
//                    }else if ([dic[@"error"] isEqualToString:@"invalid_grant"] && !error_description_isNULL && ([dic[@"error_description"] hasPrefix:@"User is disabled"] || [dic[@"error_description"] hasPrefix:@"账号已被禁用"])){//账号被封禁
//                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_IS_DISABLED object:nil];
//                        failureBlock(@"用户被封禁");
//                        return;
//                    }else if ([dic[@"code"] intValue] == 1 && [dic[@"msg"] isEqualToString:@"授权失败，禁止访问"] ){//账号被封禁
//                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_IS_DISABLED object:nil];
//                        failureBlock(@"用户被封禁");
//                        return;
//                    }else if ([dic[@"status"] intValue] == 500 && [dic[@"error"] isEqualToString:@"Internal Server Error"] ){//服务器出错
//                        [SVProgressHUD showInfoWithStatus:@"服务器错误"];
//                    }else if ([dic[@"error"] isEqualToString:@"invalid_grant"] && !error_description_isNULL && [dic[@"error_description"] hasPrefix:@"用户名不存在"] ){//用户名或密码错误
//                        failureBlock(@"用户名或密码错误");
//                        return ;
//                    }else if ([dic[@"error"] isEqualToString:@"unauthorized"] && error_description_isNULL){//用户名不存在
//                        failureBlock(@"用户名不存在");
//                        return ;
//                    }
//                }else{
//                    //处理网络请求失败
//                    NSString *reason = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
//                        if (IsNilOrNull(reason) || [reason isEqualToString:@"(null)"]) {
//                             [SVProgressHUD showInfoWithStatus:@"服务器异常"];
//                             failureBlock(@"服务器异常");
//                             return;
//                        }else{
//                            [SVProgressHUD showInfoWithStatus:reason];
//                             failureBlock(reason);
//                             return;
//                        }
//                }
//                failureBlock(dic[@"msg"] ? dic[@"msg"] :[NSString stringWithFormat:@"%@", dic[@"error"]]);
            }];
            break;
        }
            
        case HttpRequestTypePut:
            
        {
            [[XPNetWorkTool shareManager] PUT:urlString parameters:paraments success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSInteger responseCode = [responseObject[@"code"] integerValue];
                if (responseCode == -5) {

                    failureBlock(responseObject[@"msg"]);
                    return;
                }
                else if (responseCode != 0) {
                    failureBlock(responseObject[@"msg"]);
                    return;
                }
                successBlock(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

//                NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
//                NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSDictionary *dic = [str mj_JSONObject];
//                if (dic) {
//                    failureBlock(dic[@"msg"] ? dic[@"msg"] :[NSString stringWithFormat:@"%@", dic[@"status"]]);
//                }else{
//                    if (IsNilOrNull(error)) {
//                        [SVProgressHUD showInfoWithStatus:@"网络异常"];
//                    }
//                    NSString *reason = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSURLErrorKey]];
//                    failureBlock(reason);
//                }
            }];
            break;
        }
            
    }
    
}







#pragma mark - 多图上传
/**
 *  上传图片
 *
 *  @param operations   上传图片等预留参数---视具体情况而定 可移除
 *  @param imageArray   上传的图片数组
 *  @parm width      图片要被压缩到的宽度
 *  @param urlString    上传的url---请填写完整的url
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 *
 */
+(void)uploadImageWithOperations:(NSDictionary *)operations withImageArray:(NSArray *)imageArray withtargetWidth:(CGFloat )width withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailurBlock:(requestFailure)failureBlock withUpLoadProgress:(uploadProgress)progress
{   
    [[XPNetWorkTool shareManager] POST:urlString parameters:operations constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSUInteger i = 0 ;
        
        /**出于性能考虑,将上传图片进行压缩*/
        for (UIImage * image in imageArray) {
            
            //image的分类方法
            UIImage *  resizedImage =image ;//  [UIImage IMGCompressed:image targetWidth:width];
            
            NSData * imgData = UIImageJPEGRepresentation(resizedImage, .5);
            
            //拼接data
            [formData appendPartWithFileData:imgData name:@"file" fileName:[NSString stringWithFormat:@"picflie%ld.jpg",(long)i] mimeType:@"image/jpg"];
            
            i++;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        NSInteger responseCode = [responseObject[@"code"] integerValue];
        if (responseCode != 0) {
            failureBlock(responseObject[@"msg"]);
            return;
        }
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *reason = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        if (IsNilOrNull(reason)|| [reason isEqualToString:@"(null)"]) {
            return;
        }
        failureBlock(reason);
        
    }];
}




@end
