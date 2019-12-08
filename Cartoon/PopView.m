//
//  PopView.m
//  Cartoon
//
//  Created by zxh on 2019/11/28.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "PopView.h"
#import "StringPick.h"
#import "CodeInputView.h"

@interface PopView()<UITextFieldDelegate>

@end

@implementation PopView{
    StringPick *_pick;
    CodeInputView *_codeView;
}

+(instancetype)popView{
    return [[self alloc]init];
}

-(instancetype)init{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}

-(void)setUI{

    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    UIView *contV = [[UIView alloc]init];
    contV.backgroundColor = [UIColor whiteColor];
    [self addSubview:contV];
    [contV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 300));
        make.top.mas_equalTo(100);
        make.centerX.mas_equalTo(self);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    [btn addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 15;
    btn.layer.borderWidth = 0.5;
    [btn setTitle:@"+99299323" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [contV addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(250, 30));
    }];
    
    
    UIButton *btn2 = [[UIButton alloc]init];
    [btn2 addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
       [btn2 setTitle:@"confirm" forState:UIControlStateNormal];
       [contV addSubview:btn2];
       [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.bottom.mas_equalTo(contV.mas_bottom).offset(-10);
           make.left.mas_equalTo(25);
           make.size.mas_equalTo(CGSizeMake(250, 30));
       }];
    
    
    _codeView = [[CodeInputView alloc]initWithFrame:CGRectMake(0, 150, 300, 40) inputType:4 selectCodeBlock:^(NSString * code) {
               NSLog(@"code === %@",code);
           }];
    [contV addSubview:_codeView];
    
    
    
    
//    float left = 10;
//    float margin = 10;
//    float w = (300 - left * 2 - margin * 3)*0.25;
//    float h = 30;
//
//    for (int i = 0; i < 4; i++) {
//        UITextField *t1 = [UITextField new];
//        t1.borderStyle = UITextBorderStyleNone;
//        t1.keyboardType = UIKeyboardTypeNumberPad;
//        t1.secureTextEntry = YES;
//        t1.textAlignment = NSTextAlignmentCenter;
//
//        t1.tag = 110 + i;
//        t1.delegate = self;
//
//        UIView *lineView = [[UIView alloc]init];
//        lineView.backgroundColor = [UIColor orangeColor];
//        [t1 addSubview:lineView];
//
//        [contV addSubview:t1];
//        [t1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(10 + (i * (w + margin)));
//            make.width.mas_equalTo(w);
//            make.height.mas_equalTo(h);
//            make.top.mas_equalTo(btn.mas_bottom).offset(20);
//        }];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.width.mas_equalTo(w);
//            make.height.mas_equalTo(1);
//            make.bottom.mas_equalTo(t1);
//        }];
//
//    }
    

    
    _pick = [StringPick new];
    _pick.dataArray = @[@"+99999999999",@"+88888888888",@"+7777777777",@"+66666666",@"+5555555"];
    _pick.selectBlock = ^(NSString *str){
        if (str.length > 0) {
            [btn setTitle:str forState:UIControlStateNormal];
        }
    };
    CGRect frame = _pick.frame;
    frame.origin.y = screenH;
    _pick.frame = frame;
    [self addSubview:_pick];
    
    
    
}

-(void)dismissSelf{
    [self removeFromSuperview];
}

-(void)choose{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _pick.frame;
        frame.origin.y = screenH - 248;
        _pick.frame = frame;
    }];
    
}





@end
