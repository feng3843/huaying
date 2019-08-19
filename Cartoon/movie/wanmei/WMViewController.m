//
//  MoGuController.m
//  Cartoon
//
//  Created by zxh on 2019/8/1.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "WMViewController.h"
#import "YNPageViewController.h"
#import "WMHotVCViewController.h"
#import "WMKindController.h"
#import "WMSearchViewController.h"
#import "WMModel.h"


@interface WMViewController ()<YNPageViewControllerDelegate,YNPageViewControllerDataSource>
@property (nonatomic , strong) NSMutableArray *titleItemArray;
@property (nonatomic , strong) NSMutableArray *hotVods;
@end

@implementation WMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor lightGrayColor];
    NSString *urlStr = @"http://jrys.wy2sf.com:8056/yingshi/getHome";
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *data = responseObject[@"data"];
        NSArray *titles = data[@"types"];
        self.hotVods = [WMModel mj_objectArrayWithKeyValuesArray:data[@"hotVods"]];
        
        [self navPageVCWithTitles:titles];
    } withFailureBlock:^(NSString *errorMsg) {
        
    } progress:^(float progress) {
        
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"sousuo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
}

-(void)searchClick{
    NSLog(@"searchClick");
    [self.navigationController pushViewController:[WMSearchViewController new] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
}

- (void)navPageVCWithTitles:(NSArray *)titleItems{
    NSMutableArray *controllers = [NSMutableArray array];
    NSMutableArray *idArrays = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    
    WMHotVCViewController *hot = [WMHotVCViewController new];
    hot.dataArray = self.hotVods;
    [controllers addObject:hot];
    [idArrays addObject:@"0"];
    [titles addObject:@"热门"];
    
    for (NSDictionary *dict in titleItems) {
        NSString *idstr = [NSString stringWithFormat:@"%d",[dict[@"t_id"] intValue] ];
        NSString *name = dict[@"t_name"];
        if ([idstr isEqualToString:@"1"] || [idstr isEqualToString:@"2"] || [idstr isEqualToString:@"3"] || [idstr isEqualToString:@"4"]) {
            continue;
        }
        [idArrays addObject:idstr];
        [titles addObject:name];
        WMKindController *vc = [WMKindController new];
        vc.urlStr = [NSString stringWithFormat:@"http://jrys.wy2sf.com:8056/yingshi/getVodWithPage?d_type=%@",idstr];
        [controllers addObject:vc];
    }

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
    if ([vc isKindOfClass:[WMKindController class]]) {
        return [(WMKindController *)vc tableView];
    }
    
    return [(WMHotVCViewController *)vc tableView];
}
@end
