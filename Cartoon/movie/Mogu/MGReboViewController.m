//
//  MGReboViewController.m
//  Cartoon
//
//  Created by zxh on 2019/8/1.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "MGReboViewController.h"
#import "MovieItem.h"
#import "MovieCell.h"
#import "LVPlayVodDetailVC.h"
#import "MoiveSectionModel.h"
#import "PlayModel.h"
#import "MJRefresh.h"

@interface MGReboViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) int page;
@end

@implementation MGReboViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataArray.count == 0) {
        [self requestData:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.dataArray = [NSMutableArray array];
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
    
    MJRefreshBackNormalFooter * footer =  [MJRefreshBackNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(requestData:)];
    [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    [footer setTintColor:[UIColor whiteColor]];
    footer.stateLabel.textColor = [UIColor whiteColor];
    
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self requestData:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    MovieItem *model = self.dataArray[indexPath.row];
    cell.item = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(void)requestData:(id)sender{
    if (sender == nil) {
        self.page = 1;
    }else{
        self.page ++;
    }
    NSString *url = [NSString stringWithFormat:@"%@&page=%d",self.urlStr,self.page];
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSArray *array = [MovieItem mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        [self.dataArray addObjectsFromArray: array];
        if (array.count < [responseObject[@"data"][@"page_size"] integerValue] || self.page >= [responseObject[@"data"][@"page_total"] integerValue]) {
            [SVProgressHUD showInfoWithStatus:@"没有更多数据了！"];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSString *errorMsg) {
        [self.tableView.mj_footer endRefreshing];
        self.page --;
    } progress:^(float progress) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieItem *item = self.dataArray[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"https://v.kan321.com/api/info?id=%d",item.vid];
    
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject[@"data"][@"play"]);
        NSArray *model = [PlayModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"play"]];
        item.info = responseObject[@"data"][@"info"];
        item.play = model;
        LVPlayVodDetailVC *vc = [LVPlayVodDetailVC new];
        vc.item = item;
        [self.navigationController pushViewController:vc animated:YES];
        
    } withFailureBlock:^(NSString *errorMsg) {
        
    } progress:^(float progress) {
        
    }];
}
@end
