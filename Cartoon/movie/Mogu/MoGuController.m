//
//  MoGuController.m
//  Cartoon
//
//  Created by zxh on 2019/8/1.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "MoGuController.h"
#import "YNPageViewController.h"
#import "MGKindViewController.h"
#import "MGReboViewController.h"
#import "MGSearchController.h"

@interface MoGuController ()<YNPageViewControllerDelegate,YNPageViewControllerDataSource>
@property (nonatomic , strong) NSMutableArray *titleItemArray;
@end

@implementation MoGuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self navPageVCWithTitles:@[@"推荐",@"电影",@"电视剧",@"最热",@"最新",@"评分最高",@"伦理最热",@"伦理最新"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"sousuo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
}

-(void)searchClick{
    NSLog(@"searchClick");
    [self.navigationController pushViewController:[MGSearchController new] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
}

- (void)navPageVCWithTitles:(NSArray *)titles{
    NSMutableArray *controllers = [NSMutableArray array];
    MGKindViewController *vc1 = [MGKindViewController new];
    vc1.urlStr = @"https://v.kan321.com/api/hot/?app-version=1.0.11";
    [controllers addObject:vc1];
    MGKindViewController *vc2 = [MGKindViewController new];
    vc2.urlStr = @"https://v.kan321.com/api/dianying/?app-version=1.0.11";
    [controllers addObject:vc2];
    MGKindViewController *vc3 = [MGKindViewController new];
    vc3.urlStr = @"https://v.kan321.com/api/dianshiju/?app-version=1.0.11";
    [controllers addObject:vc3];
    MGReboViewController*vc4 = [MGReboViewController new];
    vc4.urlStr = @"https://v.kan321.com/api/filter?order=hit&app-version=1.0.11";
    [controllers addObject:vc4];
    MGReboViewController*vc5 = [MGReboViewController new];
    vc5.urlStr = @"https://v.kan321.com/api/filter?order=time&app-version=1.0.11";
    [controllers addObject:vc5];
    MGReboViewController*vc6 = [MGReboViewController new];
    vc6.urlStr = @"https://v.kan321.com/api/filter?order=score&app-version=1.0.11";
    [controllers addObject:vc6];
    MGReboViewController*vc7 = [MGReboViewController new];
    vc7.urlStr = @"https://v.kan321.com/api/filter?order=hit&pwd=369369&tid=17&app-version=1.0.11";
    [controllers addObject:vc7];
    MGReboViewController*vc8 = [MGReboViewController new];
    vc8.urlStr = @"https://v.kan321.com/api/filter?order=time&pwd=369369&tid=17&app-version=1.0.11";
    [controllers addObject:vc8];
    
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
    if ([vc isKindOfClass:[MGKindViewController class]]) {
        return [(MGKindViewController *)vc tableView];
    }
    
    return [(MGReboViewController *)vc tableView];
}
@end
