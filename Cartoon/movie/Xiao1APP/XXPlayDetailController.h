//
//  XXPlayDetailController.h
//  Cartoon
//
//  Created by zxh on 2019/7/17.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXMovieListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XXPlayDetailController : UIViewController
@property (nonatomic , strong) XXMovieListModel *model;
@property (nonatomic , copy)  NSString *playUrl;
@end

NS_ASSUME_NONNULL_END
