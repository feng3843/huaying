//
//  StringPick.m
//  GuardAngel
//
//  Created by 朱鑫华 on 16/10/17.
//  Copyright © 2016年 GA. All rights reserved.
//

#import "StringPick.h"

#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height

@interface StringPick () <UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger selectRow;
}
@end

@implementation StringPick
-(instancetype)init{
    self = [super init];
    if(self){
        [self setUI];
    }
    return self;
}

-(void)setUI{
//    self.frame = CGRectMake(0, 0, screenW, screenH);
//    self.backgroundColor = [UIColor clearColor];
//
//    //遮罩
//    UIButton *coverBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - 248)];
//    [coverBtn addTarget:self action:@selector(popPickerView) forControlEvents:UIControlEventTouchUpInside];
//    [coverBtn setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"7f7f7f"]];
//    [self addSubview:coverBtn];
//    coverBtn.alpha = 0.3;
//    //背景
//    UIView *bgV = [[UIView alloc]initWithFrame:CGRectMake(0, screenH - 248, screenW, 248)];
    self.frame = CGRectMake(0, screenH - 248, screenW, 248);
    self.backgroundColor = [UIColor clearColor];
    UIView *bgV = [[UIView alloc]initWithFrame:self.bounds];
    bgV.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgV];
    //取消
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 18, 38, 20)];
    [cancelBtn addTarget:self action:@selector(popPickerView) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [bgV addSubview:cancelBtn];
    //确定
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenW -15 - 38, 18, 38, 20)];
    [sureBtn addTarget:self action:@selector(pickerViewBtnOK) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [bgV addSubview:sureBtn];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 36, screenW, 212)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [bgV addSubview:_pickerView];
}

-(void)popPickerView{
    NSLog(@"移除控件!");
    [self removeFromSuperview];
}

-(void)pickerViewBtnOK{
    if (self.selectBlock) {
        NSString *str = self.dataArray[selectRow];
                  self.selectBlock(str);
    }
    [self popPickerView];
}

#pragma mark - UIPickerViewDataSource

//返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

//每列对应多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

//每行显示的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataArray[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return (screenW - 60) ;
}

#pragma mark - UIPickerViewDelegate

//选中pickerView的某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectRow = row;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setTextColor:[UIColor blackColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:24]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

@end
