//
//  MJWzuModel.m
//  Cartoon
//
//  Created by zxh on 2020/2/20.
//  Copyright © 2020 hanyong. All rights reserved.
//

#import "MJWzuModel.h"
#import "MJWPlayModel.h"


@implementation MJWzuModel
+(NSDictionary *)mj_objectClassInArray{
    return @{@"ji":[MJWPlayModel class]};
}
@end
