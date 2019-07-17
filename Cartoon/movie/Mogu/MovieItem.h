//
//  MovieItem.h
//  Cartoon
//
//  Created by zxh on 2019/6/21.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieItem : NSObject
@property (nonatomic , copy)  NSString *actor;
@property (nonatomic , copy)  NSString *name;
@property (nonatomic , copy)  NSString *note;
@property (nonatomic , assign) int vid;
@property (nonatomic , copy)  NSString *pic;
@property (nonatomic , copy)  NSString *info;
@property (nonatomic , strong) NSArray *play;
@end

NS_ASSUME_NONNULL_END
