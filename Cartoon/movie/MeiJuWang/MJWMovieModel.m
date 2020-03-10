//
//  MJWMovieModel.m
//  Cartoon
//
//  Created by zxh on 2020/2/20.
//  Copyright © 2020 hanyong. All rights reserved.
//

#import "MJWMovieModel.h"
#import "MJWzuModel.h"
@implementation MJWMovieModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"zu":[MJWzuModel class]};
}

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"movieId":@"id"};
}
@end
