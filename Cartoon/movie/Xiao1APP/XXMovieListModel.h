//
//  XXMovieListModel.h
//  Cartoon
//
//  Created by zxh on 2019/7/17.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXMovieListModel : NSObject
@property (nonatomic , copy)  NSString *episode_statustext;
@property (nonatomic , copy)  NSString *title;
@property (nonatomic , copy)  NSString *vodid;
@property (nonatomic , copy)  NSString *intro;
@property (nonatomic , strong) NSArray *playlist;
@property (nonatomic , copy)  NSString *coverpic;
@end

NS_ASSUME_NONNULL_END
