//
//  DDViewController.m
//  Cartoon
//
//  Created by zxh on 2019/9/16.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "DDViewController.h"
#import "YNPageViewController.h"
#import "DDKindController.h"
#import "DDSearchViewController.h"
#import "DDZJViewController.h"
@interface DDViewController ()<YNPageViewControllerDelegate,YNPageViewControllerDataSource>
@property (nonatomic , strong) NSMutableArray *titleItemArray;
@end

@implementation DDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self navPageVCWithTitles:@[@"推荐",@"电影",@"电视",@"综艺",@"动漫",@"专题"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"sousuo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
}

-(void)searchClick{
    NSLog(@"searchClick");
    [self.navigationController pushViewController:[DDSearchViewController new] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
}

- (void)navPageVCWithTitles:(NSArray *)titles{
    NSMutableArray *controllers = [NSMutableArray array];
    for (int i = 0 ; i < titles.count -1 ; i ++) {
        DDKindController *other = [[DDKindController alloc]init];
        other.tab = i;
        [controllers addObject:other];
    }
    DDZJViewController *zj= [DDZJViewController new];
    [controllers addObject:zj];
    
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleNavigation;
    configration.showTabbar = NO;
    configration.showNavigation = NO;
    configration.scrollMenu = YES;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = NO;
    configration.scrollViewBackgroundColor = [UIColor blackColor];
    configration.cutOutHeight = 84;
    
    configration.itemFont = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    configration.normalItemColor = [FYColorTool colorFromHexRGB:@"#999999" alpha:1];
    configration.selectedItemFont = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    configration.selectedItemColor = [FYColorTool colorFromHexRGB:@"#FFFFFF" alpha:1];
    configration.itemMargin = 20;
    configration.showScrollLine = NO;
    
    /// 设置菜单栏宽度
    configration.menuWidth = screenW - 100;
    
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
    if ([vc isKindOfClass:[DDZJViewController class]]) {
        return [(DDZJViewController *)vc tableView];
    }
    return [(DDKindController *)vc tableView];
}

@end
