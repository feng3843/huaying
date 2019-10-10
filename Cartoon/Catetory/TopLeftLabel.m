//
//  TopLeftLabel.m
//  XianPao
//
//  Created by hanyong on 2018/10/8.
//  Copyright © 2018年 hanyong. All rights reserved.
//

#import "TopLeftLabel.h"

@implementation TopLeftLabel
- (id)initWithFrame:(CGRect)frame {

    return [super initWithFrame:frame];

}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {

    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];

    textRect.origin.y = bounds.origin.y;

    return textRect;

}

-(void)drawTextInRect:(CGRect)requestedRect {

    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];

    [super drawTextInRect:actualRect];

}
@end
