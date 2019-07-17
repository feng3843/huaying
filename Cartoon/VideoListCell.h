//
//  VideoListCell.h
//  Cartoon
//
//  Created by hanyong on 2019/4/22.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoListCell : UITableViewCell
@property (nonatomic , strong) VideoListModel *model;
@end

NS_ASSUME_NONNULL_END
