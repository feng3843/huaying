//
//  FYColorTool.m
//  LiveStreamingDemo
//
//  Created by 陈飞洋 on 2017/6/13.
//  Copyright © 2017年 陈飞洋. All rights reserved.
//

#import "FYColorTool.h"
#define DEFAULT_VOID_COLOR [UIColor blackColor]

@implementation FYColorTool

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)alpha
{
    NSString *cString = [[inColorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (UIColor *)colorFromR:(float)R G:(float)G B:(float)B alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:alpha];
}

+ (UIColor *)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (UIColor *)colorWithblue{
    return [self colorFromHexRGB:@"31adda" alpha:1.0];
}

+ (UIColor *)colorWithred{
    return [self colorFromHexRGB:@"de3e3e" alpha:1.0];
}

+ (UIColor *)colorWithgreen{
    return [self colorFromHexRGB:@"9ad000" alpha:1.0];
}

+ (UIColor *)colorWithblueH{
    return [self colorFromHexRGB:@"0a8bb5" alpha:1.0];
}

+ (UIColor *)colorWithredH{
    return [self colorFromHexRGB:@"eb4b4b" alpha:1.0];
}

+ (UIColor *)colorWithgreenH{
    return [self colorFromHexRGB:@"8eb816" alpha:1.0];
}

+ (UIColor *)colorWithEqua{
    return [self colorFromHexRGB:@"a6a5a7" alpha:1.0];
}

+ (UIColor *)colorWithCellHeight{
    return [UIColor colorWithWhite:0 alpha:0.6];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
