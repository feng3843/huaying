//
//  XXTabModel.m
//  Cartoon
//
//  Created by zxh on 2019/7/17.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "XXTabModel.h"
#import "XXTabRowsModel.h"
#import "XXMovieListModel.h"

@implementation XXTabModel
+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"dayrows":[XXMovieListModel class],
             @"nestedrows":[XXTabRowsModel class],
             @"hotrows":[XXMovieListModel class]
             };
}
@end
