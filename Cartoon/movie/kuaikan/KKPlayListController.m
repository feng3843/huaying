//
//  KKPlayListController.m
//  Cartoon
//
//  Created by zxh on 2019/8/28.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "KKPlayListController.h"
#import "XPGoodsTuWenController.h"
#import "TFhpple/TFHpple.h"

@interface KKPlayListController ()
@property (nonatomic , strong) UILabel *intoL;
@property (nonatomic , strong) UILabel *nameL;
@property (nonatomic , strong) UILabel *lastL;
@property (nonatomic , strong) UILabel *urlL;
@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) UIButton *selectedBtn;
@end

@implementation KKPlayListController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    //显示的播放界面
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 40)];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    //播放界面
    UIView *fview = [[UIView alloc] initWithFrame:CGRectMake(0, 40, screenW, screenW*9.0f/16.0f)];
    fview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:fview];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(fview.frame), screenW, screenH - CGRectGetMaxY(fview.frame) - 60)];
    [self.view addSubview:self.scrollView];
    
    UIButton *bottombtn = [[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.scrollView.frame), screenW - 80, 30)];
    [bottombtn setTitle:@"隐藏" forState:UIControlStateNormal];
    [bottombtn setTitle:@"显示" forState:UIControlStateSelected];
    [bottombtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [bottombtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [bottombtn addTarget:self action:@selector(bottombtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottombtn];
    
    
    self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, screenW - 150, 15)];
    self.nameL.textColor = [UIColor whiteColor];
    self.nameL.font = [UIFont systemFontOfSize:12] ;
    [self.scrollView addSubview:self.nameL];
    self.nameL.numberOfLines = 1;
    
    self.lastL = [[UILabel alloc]initWithFrame:CGRectMake(screenW - 130, 0, 130, 15)];
    self.lastL.textColor = [UIColor whiteColor];
    self.lastL.font = [UIFont systemFontOfSize:9 weight:UIFontWeightMedium];
//    NSString *mid = [NSString stringWithFormat:@"%d",self.item.vid];
//    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:mid];
//    self.lastL.text = [NSString stringWithFormat:@"上次观看:%@",str];
    [self.scrollView addSubview:self.lastL];
    
    self.urlL = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, screenW - 100, 20)];
    self.urlL.textColor = [UIColor whiteColor];
    self.urlL.font = [UIFont systemFontOfSize:8] ;
    [self.scrollView addSubview:self.urlL];
    self.urlL.numberOfLines = 2;
    
    
    self.intoL = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 0, 0)];
    self.intoL.textColor = [UIColor whiteColor];
    self.intoL.font = [UIFont systemFontOfSize:12] ;
    [self.scrollView addSubview:self.intoL];
    self.intoL.numberOfLines = 0;
    
    
//    self.intoL.text = self.item.info;
//    self.nameL.text = self.item.name;
//    CGSize size = [self.item.info boundingRectWithSize:CGSizeMake(screenW - 40, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
//    CGRect frame = self.intoL.frame;
//    frame.size = size;
//    self.intoL.frame = frame;
    
    float Margin = 20;
    float x = 0;
    float y = CGRectGetMaxY(self.intoL.frame) + 20;
    float h = 34;
    
    for (int i = 0 ; i < self.playList.count ;i++) {
        NSDictionary *dict = self.playList[i];
        
        UIButton *btn = [[UIButton alloc]init];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [self.scrollView addSubview:btn];
        UIImage *img = [[self imageWithColor:[FYColorTool colorFromHexRGB:@"4595FA" alpha:1]] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        UIImage *imgsel = [[self imageWithColor:[FYColorTool colorFromHexRGB:@"FF0000" alpha:1]] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [btn setBackgroundImage:imgsel forState:UIControlStateSelected];
        btn.selected = NO;
        btn.tag = i;
        [btn setTitle:dict[@"title"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        CGSize size = CGSizeMake(btn.bounds.size.width + 20 < 45 ? 45 : btn.bounds.size.width + 20, h);
        CGFloat btnX = 0;
        CGFloat btnY = 0;
        CGFloat btnW = size.width;
        CGFloat btnH = h;

        //每次X递增Margin
        x = Margin + x;
        //计算btn的X
        btnX = x;
        if (btnX + btnW + Margin > screenW) {//如果超长，换行 y递增 x=0
            y = y + Margin + h;
            btnX = 0 + Margin;
        }
        //计算btn的Y
        btnY = y;
        //设置btnframe
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        //累加x，用于下次计算
        x = btnX + size.width ;
    }
    UIScrollView *sc = (UIScrollView *)self.scrollView;
    sc.contentSize = CGSizeMake(0, y + 50);
    
}

-(void)btnClick:(UIButton *)btn{
    if (self.selectedBtn != btn) {
        self.selectedBtn.selected = NO;
    }else{
        return;
    }
    btn.selected = !btn.selected;
    self.selectedBtn = btn;
    
    NSDictionary *dict = self.playList[btn.tag];
    
    NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"href"]]];
    TFHpple *itemhpp = [TFHpple hppleWithHTMLData:htmlData];
    //播放地址列表
    TFHppleElement * iframeEL = [[itemhpp searchWithXPathQuery:@"//iframe"] firstObject];
    NSDictionary *dictEl = [iframeEL attributes];
    if (dictEl[@"src"]) {
        NSString *ssss = [NSString stringWithFormat:@"<iframe width='100%%' height='30%%' allowtransparency='true' allowfullscreen='true' frameborder='0' scrolling='no' src='%@'></iframe>",dictEl[@"src"]];
        XPGoodsTuWenController *vc = [XPGoodsTuWenController new];
        vc.html = ssss;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"解析错误"];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}




- (void)backClick {

    [self.navigationController popViewControllerAnimated:YES];
}

// 颜色转为图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 开启上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(ref, color.CGColor);
    // 渲染上下文
    CGContextFillRect(ref, rect);
    // 从上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}


-(void)bottombtnclick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.scrollView.hidden = YES;
    }else{
        self.scrollView.hidden = NO;
    }
}


@end
