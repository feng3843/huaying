//
//  XXYSViewController.m
//  Cartoon
//
//  Created by zxh on 2019/7/17.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "XXYSViewController.h"
#import "YNPageViewController.h"
#import "XXKindViewController.h"
#import "XXSearchViewController.h"

@interface XXYSViewController ()<YNPageViewControllerDelegate,YNPageViewControllerDataSource>
@property (nonatomic , strong) NSMutableArray *titleItemArray;
@end

@implementation XXYSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self navPageVCWithTitles:@[@"推荐",@"电影",@"电视",@"动漫",@"综艺"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"sousuo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
}

-(void)searchClick{
    NSLog(@"searchClick");
    [self.navigationController pushViewController:[XXSearchViewController new] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)navPageVCWithTitles:(NSArray *)titles{
    NSMutableArray *controllers = [NSMutableArray array];
    for (int i = 0 ; i < titles.count ; i ++) {
        XXKindViewController *other = [[XXKindViewController alloc]init];
        other.tab = i;
        [controllers addObject:other];
    }
   
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleNavigation;
    configration.showTabbar = NO;
    configration.showNavigation = NO;
    configration.scrollMenu = YES;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = NO;
    configration.scrollViewBackgroundColor = [UIColor clearColor];
    configration.cutOutHeight = 84;
    
    configration.itemFont = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    configration.normalItemColor = [FYColorTool colorFromHexRGB:@"#666666" alpha:1];
    configration.selectedItemFont = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    configration.selectedItemColor = [FYColorTool colorFromHexRGB:@"#333333" alpha:1];
    configration.itemMargin = 20;
    configration.showScrollLine = NO;
    configration.menuWidth = screenW - 80;
    
    /// 设置菜单栏宽度
    configration.menuWidth = screenW;
    
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:controllers
                                                                                titles:titles
                                                                                config:configration];
    vc.dataSource = self;
    vc.delegate = self;
    
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
}



#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];

    return [(XXKindViewController *)vc tableView];
    
}


@end

