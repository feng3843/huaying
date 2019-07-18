//
//  XXMovieListModel.m
//  Cartoon
//
//  Created by zxh on 2019/7/17.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "XXMovieListModel.h"
#import "XXPlayModel.h"
@implementation XXMovieListModel
+(NSDictionary *)mj_objectClassInArray{
    return @{@"playlist":[XXPlayModel class]};
}
@end
