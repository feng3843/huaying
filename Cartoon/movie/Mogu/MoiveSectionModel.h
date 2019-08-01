//
//  MoiveSectionModel.h
//  Cartoon
//
//  Created by zxh on 2019/8/1.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoiveSectionModel : NSObject
@property (nonatomic , copy)  NSString *title;
@property (nonatomic , copy)  NSString *type;
@property (nonatomic , strong) NSArray *videos;
@end

NS_ASSUME_NONNULL_END
