//
//  MoiveSectionModel.m
//  Cartoon
//
//  Created by zxh on 2019/8/1.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "MoiveSectionModel.h"
#import "MovieItem.h"

@implementation MoiveSectionModel
+(NSDictionary *)mj_objectClassInArray{
    return @{@"videos":[MovieItem class]};
}
@end
