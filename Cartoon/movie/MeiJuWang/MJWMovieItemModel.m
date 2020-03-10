//
//  MJWMovieItemModel.m
//  Cartoon
//
//  Created by zxh on 2020/2/20.
//  Copyright © 2020 hanyong. All rights reserved.
//

#import "MJWMovieItemModel.h"

@implementation MJWMovieItemModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"movieId":@"id"};
}
@end
