//
//  DDTopicModel.m
//  Cartoon
//
//  Created by zxh on 2019/9/16.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "DDTopicModel.h"
#import "DDMovieItem.h"
@implementation DDTopicModel
+(NSDictionary *)mj_objectClassInArray{
    return @{@"topic_rel_vod_list":[DDMovieItem class]};
}
@end
