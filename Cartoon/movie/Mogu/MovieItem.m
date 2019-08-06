//
//  MovieItem.m
//  Cartoon
//
//  Created by zxh on 2019/6/21.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "MovieItem.h"
#import "MJExtension.h"
@implementation MovieItem
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"vid":@"id"};
}
MJCodingImplementation
@end
