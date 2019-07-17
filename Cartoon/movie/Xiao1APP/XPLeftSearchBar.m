//
//  XPLeftSearchBar.m
//  XianPao
//
//  Created by hanyong on 2019/2/26.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "XPLeftSearchBar.h"

@interface XPLeftSearchBar () <UITextFieldDelegate>

// placeholder 和icon 和 间隙的整体宽度
//@property (nonatomic, assign) CGFloat placeholderWidth;

@end

// icon宽度
//static CGFloat const searchIconW = 20.0;
// icon与placeholder间距
//static CGFloat const iconSpacing = 10.0;
// 占位文字的字体大小
static CGFloat const placeHolderFont = 15.0;

@implementation XPLeftSearchBar
//searchBar其实就是一个view包装了一个textField
- (void)layoutSubviews {
    [super layoutSubviews];
    //mini模式，不显示背景
    self.searchBarStyle = UISearchBarStyleMinimal;
    //去除背景色
    self.backgroundColor = [UIColor clearColor];

    for (UIView *view in [self.subviews lastObject].subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)view;
            // 重设textField的frame
            field.frame = CGRectMake(0, 4, self.frame.size.width, 36);
            // 设置背景色
            field.borderStyle = UITextBorderStyleNone;
            field.layer.cornerRadius = 18;
            field.layer.masksToBounds = YES;
            field.backgroundColor = [FYColorTool colorFromHexRGB:@"#F3F3F3" alpha:1];
            
            [field setTintColor:[FYColorTool colorFromHexRGB:@"#F3F3F3" alpha:1]];

            field.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];

            field.leftView.frame = CGRectMake(0, 0, 25, 25);
            field.leftView.contentMode = UIViewContentModeCenter;

            // 设置占位文字字体颜色
            [field setValue:[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
            [field setValue:[UIFont systemFontOfSize:placeHolderFont] forKeyPath:@"_placeholderLabel.font"];

            if (@available(iOS 11.0, *)) {
                // 先默认居中placeholder
//                [self setPositionAdjustment:UIOffsetMake((field.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
                [self setPositionAdjustment:UIOffsetMake(0, 0) forSearchBarIcon:UISearchBarIconSearch];
            }
        }
    }
}

//// 开始编辑的时候重置为靠左
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    // 继续传递代理方法
//    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
//        [self.delegate searchBarShouldBeginEditing:self];
//    }
////    if (@available(iOS 11.0, *)) {
////        [self setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
////    }
//    return YES;
//}
//// 结束编辑的时候设置为居中
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
//        [self.delegate searchBarShouldEndEditing:self];
//    }
////    if (@available(iOS 11.0, *)) {
////        [self setPositionAdjustment:UIOffsetMake((textField.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
////    }
//    return YES;
//}

// 计算placeholder、icon、icon和placeholder间距的总宽度
//- (CGFloat)placeholderWidth {
//    if (!_placeholderWidth) {
//        CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:placeHolderFont]} context:nil].size;
//        _placeholderWidth = size.width + iconSpacing + searchIconW;
//    }
//    return _placeholderWidth;
//}


@end
