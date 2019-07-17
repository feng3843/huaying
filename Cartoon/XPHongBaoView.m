//
//  XPHongBaoView.m
//  Cartoon
//
//  Created by zxh on 2019/5/28.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "XPHongBaoView.h"

#define SELF_WH 45
#define IMG_WH  30
#define BORDER_W 3
#define DURATION_PER 40

@interface XPHongBaoView()

@property (nonatomic , strong) CAShapeLayer *shapeLayer;
@property (nonatomic , assign) double end;
@property (nonatomic , strong) dispatch_source_t timer;
@property (nonatomic , assign) BOOL isSuspend;

@end


@implementation XPHongBaoView{
    
}

+(instancetype)view{
    return [[self alloc]init];
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, 0, SELF_WH , SELF_WH)]) {
        [self createHongBaoView];
    }
    return self;
}

-(void)createHongBaoView{
    self.backgroundColor = [UIColor blackColor];
    //图案
    UIImageView *hongbao = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, IMG_WH, IMG_WH)];
    hongbao.center = self.center;
    hongbao.image = [UIImage imageNamed:@"hongbao"];
    hongbao.center = self.center;
    [self addSubview:hongbao];
    
    //进度条
    CAShapeLayer *sp = [CAShapeLayer layer];
    self.shapeLayer = sp;
    sp.lineWidth = BORDER_W;
    sp.path = [UIBezierPath bezierPathWithArcCenter:self.center radius:IMG_WH * 0.5 +BORDER_W  startAngle:-M_PI_2 endAngle: (M_PI * 2 - M_PI_2) clockwise:YES].CGPath;
    sp.strokeColor = [UIColor yellowColor].CGColor;
    sp.repeatCount = 1;
    sp.strokeStart = 0;
    sp.strokeEnd = 0;
    sp.fillColor = [UIColor clearColor].CGColor;
    sp.fillRule = kCAFillRuleEvenOdd;
    [self.layer addSublayer:sp];
    
    //定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        [self changeEnd];
    });
    dispatch_resume(timer);
    self.timer = timer;
    
    self.isSuspend = NO;
    
}

- (void)changeEnd {
    float duration = DURATION_PER;
    self.end += 0.01 / duration ;
    NSLog(@"%f",self.end);
    if (self.end >= 1) {
        self.shapeLayer.strokeEnd = 1;
        //停止计时器
        [self pause];

        //移除动画 重设计数器
        
        
        sleep(1);
        
         //时间到，请求网络获取奖励
        //弹窗提示+100金币
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, (SELF_WH - 20 )*0.5, SELF_WH, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor orangeColor];
        label.font = [UIFont boldSystemFontOfSize:10];
        label.text = @"+100";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [self.shapeLayer removeFromSuperlayer];
        
        [UIView animateWithDuration:2 animations:^{
            CGRect frame = label.frame;
            frame.origin.y = -10;
            label.frame = frame;
            
            label.alpha = 0.5;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
            self.end = 0;
            self.shapeLayer.strokeStart  = 0;
            self.shapeLayer.strokeEnd = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.layer addSublayer:self.shapeLayer];
                [self resume];
            });
        }];
    }
    self.shapeLayer.strokeEnd = self.end;
}

-(void)reset{
    [self pause];
    [self.shapeLayer removeFromSuperlayer];
    [self.shapeLayer removeAllAnimations];
    self.end = 0;
    self.shapeLayer.strokeStart  = 0;
    self.shapeLayer.strokeEnd = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.layer addSublayer:self.shapeLayer];
        [self resume];
    });
}

- (void)pause{
    if (self.isSuspend == NO) {
        dispatch_suspend(_timer);
        self.isSuspend = YES;
        NSLog(@"pause");
    }
}

- (void)resume{
    if (self.isSuspend == YES) {
        dispatch_resume(_timer);
        self.isSuspend = NO;
        NSLog(@"resume");
    }
}


@end
