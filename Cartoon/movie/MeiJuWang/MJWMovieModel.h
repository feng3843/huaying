//
//  MJWMovieModel.h
//  Cartoon
//
//  Created by zxh on 2020/2/20.
//  Copyright © 2020 hanyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJWMovieModel : NSObject
@property (nonatomic , copy)  NSString *year;
@property (nonatomic , copy)  NSString *diqu;
@property (nonatomic , copy)  NSString *cname;
@property (nonatomic , copy)  NSString *pic;
@property (nonatomic , copy)  NSString *state;
@property (nonatomic , copy)  NSString *name;
@property (nonatomic , strong) NSMutableArray *zu;
@property (nonatomic , assign) int movieId;
@property (nonatomic , copy)  NSString *text;

@end

NS_ASSUME_NONNULL_END
