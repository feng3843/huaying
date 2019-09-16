//
//  DDTopicModel.h
//  Cartoon
//
//  Created by zxh on 2019/9/16.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDTopicModel : NSObject
@property (nonatomic , copy)  NSString *topic_pic;
@property (nonatomic , copy)  NSString *topic_name;
@property (nonatomic , strong) NSMutableArray *topic_rel_vod_list;

@end

NS_ASSUME_NONNULL_END
