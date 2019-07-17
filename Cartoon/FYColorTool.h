//
//  FYColorTool.h
//  LiveStreamingDemo
//
//  Created by 陈飞洋 on 2017/6/13.
//  Copyright © 2017年 陈飞洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FYColorTool : NSObject

+ (UIColor *)colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)alpha;
+ (UIColor *)colorFromR:(float)R G:(float)G B:(float)B alpha:(CGFloat)alpha;
+ (UIColor *)randomColor;
+ (UIColor *)colorWithblue;
+ (UIColor *)colorWithred;
+ (UIColor *)colorWithgreen;
+ (UIColor *)colorWithblueH;
+ (UIColor *)colorWithredH;
+ (UIColor *)colorWithgreenH;
+ (UIColor *)colorWithEqua;
+ (UIColor *)colorWithCellHeight;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
