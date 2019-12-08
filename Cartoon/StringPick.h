//
//  StringPick.h
//  GuardAngel
//
//  Created by 朱鑫华 on 16/10/17.
//  Copyright © 2016年 GA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyBasicBlock)(id result);
@interface StringPick : UIView

@property (retain, nonatomic) UIPickerView *pickerView;

@property (nonatomic, copy) MyBasicBlock selectBlock;

@property (nonatomic,strong) NSArray  * dataArray;

- (void)popPickerView;
@end
