//
//  MovieCell.h
//  Cartoon
//
//  Created by zxh on 2019/6/21.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieItem.h"
#import "XXMovieListModel.h"
#import "WMModel.h"
#import "DWSJModel.h"
#import "KKModel.h"
#import "DDMovieItem.h"
#import "DDListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell
@property (nonatomic , strong) MovieItem *item;
@property (nonatomic , strong) XXMovieListModel *xxModel;
@property (nonatomic , strong) WMModel *wmModel;
@property (nonatomic , strong) DWSJModel *dwsjModel;
@property (nonatomic , strong) KKModel *kkModel;
@property (nonatomic , strong) DDMovieItem *ddModel;
@property (nonatomic , strong) DDListModel *ddOffLineModel;
@end

NS_ASSUME_NONNULL_END
