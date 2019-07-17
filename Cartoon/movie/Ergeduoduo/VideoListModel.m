//
//  VideoListModel.m
//  Cartoon
//
//  Created by hanyong on 2019/4/22.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "VideoListModel.h"


@implementation VideoListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"vid":@"id"};
}
@end
