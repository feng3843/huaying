//
//  VideoListModel.h
//  Cartoon
//
//  Created by hanyong on 2019/4/22.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoListModel : NSObject
//"id":10000225,"name":"汪汪队立大功","restype":"duoduo","pic":"https:\/\/r1.ykimg.com\/050C000056B0821667BC3C47A9064E0E"
@property (nonatomic , copy) NSString *vid;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *restype;
@property (nonatomic , copy) NSString *pic;
@end

NS_ASSUME_NONNULL_END
