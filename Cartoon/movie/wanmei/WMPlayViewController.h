//
//  WMPlayViewController.h
//  Cartoon
//
//  Created by zxh on 2019/8/19.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMMovieModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMPlayViewController : UIViewController
@property (nonatomic , strong) WMMovieModel *item;
@end

NS_ASSUME_NONNULL_END
