//
//  WMMovieModel.m
//  Cartoon
//
//  Created by zxh on 2019/8/19.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "WMMovieModel.h"
#import "MJExtension.h"
@implementation WMMovieModel
//@property (nonatomic , copy)  NSString *actor;
//@property (nonatomic , copy)  NSString *name;
//@property (nonatomic , copy)  NSString *note;
//@property (nonatomic , copy) NSString *vid;
//@property (nonatomic , copy)  NSString *pic;
//@property (nonatomic , copy)  NSString *info;
//@property (nonatomic , copy) NSString *play;
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"actor":@"d_starring",
             @"name":@"d_name",
             @"note":@"d_remarks",
             @"vid":@"d_id",
             @"pic":@"d_pic",
             @"info":@"d_content",
             @"play":@"d_playurl",
             };
}
MJCodingImplementation
@end
