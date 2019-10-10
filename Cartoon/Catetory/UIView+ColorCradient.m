//
//  UIView+ColorCradient.m
//  XianPao
//
//  Created by XiaoBao on 2018/8/2.
//  Copyright © 2018年 hanyong. All rights reserved.
//

#import "UIView+ColorCradient.h"
#import "FYColorTool.h"

@implementation UIView (ColorCradient)
+(void)setColorCradient:(UIButton *)sender  with:(CGRect)frame{
     CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[FYColorTool colorFromHexRGB:@"#9000FE" alpha:1 ].CGColor, (__bridge id)[FYColorTool colorFromHexRGB:@"#D200FE" alpha:1 ].CGColor];
    gradientLayer.locations = @[@0.3, @0.8];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = gradientLayer.frame = CGRectMake(0, 0, 355, frame.size.height);;
    [sender.layer addSublayer:gradientLayer];
}
@end
