//
//  MGKindViewController.m
//  Cartoon
//
//  Created by zxh on 2019/8/1.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "WMKindController.h"
#import "WMModel.h"
#import "MovieCell.h"
#import "WMMovieModel.h"
#import "MJRefresh.h"
#import "WMPlayViewController.h"

@interface WMKindController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) int pageNum;
@end

@implementation WMKindController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataArray.count == 0) {
        [self requestData:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0,0, screenW, screenH) style:UITableViewStylePlain];
    self.tableView = table;
    table.tableFooterView = [UIView new];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.estimatedRowHeight = 220;
    table.rowHeight = UITableViewAutomaticDimension;
    table.backgroundColor = [UIColor blackColor];
    [table registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    [self.view addSubview:table];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData:)];
    footer.onlyRefreshPerDrag = YES;
    footer.triggerAutomaticallyRefreshPercent = 2;
    [footer setTitle:@"没有更多" forState:MJRefreshStateNoMoreData];
    [footer setTintColor:[UIColor whiteColor]];
    footer.stateLabel.textColor = [UIColor whiteColor];
    
    self.tableView.mj_footer = footer;
    self.dataArray = [NSMutableArray array];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    WMModel *rowsModel = self.dataArray[indexPath.row];
    cell.wmModel = rowsModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(void)requestData:(id)sender{
    if (sender == nil) {
        self.pageNum = 0;
    }else{
        self.pageNum ++;
    }
    NSDictionary *params = @{
                             @"page":@(self.pageNum),
                             @"pageSize":@40
                             };
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:self.urlStr withParaments:params withSuccessBlock:^(NSDictionary *responseObject) {
        NSArray *tempArray = [WMModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (tempArray.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"没有数据！"];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.dataArray addObjectsFromArray:tempArray];
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSString *errorMsg) {
        [self.tableView.mj_footer endRefreshing];
        self.pageNum --;
    } progress:^(float progress) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WMModel *model = self.dataArray[indexPath.row];
   
    NSString *url = [NSString stringWithFormat:@"http://jrys.wy2sf.com:8056/yingshi/getVodById?d_id=%@",model.d_id];

    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        WMMovieModel *model = [WMMovieModel mj_objectWithKeyValues:responseObject[@"data"]];
        WMPlayViewController *vc = [WMPlayViewController new];
        vc.item = model;
        [self.navigationController pushViewController:vc animated:YES];

    } withFailureBlock:^(NSString *errorMsg) {

    } progress:^(float progress) {

    }];
}
@end
