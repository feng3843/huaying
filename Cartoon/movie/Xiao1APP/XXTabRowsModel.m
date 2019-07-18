//
//  XXTabRowsModel.m
//  Cartoon
//
//  Created by zxh on 2019/7/17.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "XXTabRowsModel.h"
#import "XXMovieListModel.h"

@implementation XXTabRowsModel
+(NSDictionary *)mj_objectClassInArray{
    return @{@"vodrows":[XXMovieListModel class]};
}
@end
