//
//  DDKindController.m
//  Cartoon
//
//  Created by zxh on 2019/9/16.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "DDKindController.h"
#import "DDMovieItem.h"
#import "MovieCell.h"
#import "MJRefresh.h"
#import "DDDetailVC.h"
@interface DDKindController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) int pageNum;
@end

@implementation DDKindController

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
    DDMovieItem *model = self.dataArray[indexPath.row];
    cell.ddModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}


-(void)requestData:(id)sender{
    if (sender == nil) {
        self.dataArray = [NSMutableArray array];
        _pageNum = 1;
    }else{
        _pageNum ++;
    }
    NSString *url = [NSString stringWithFormat:@"http://kkapp.dingdang.tv:8089//ajax/data?mid=1&page=%d&limit=30&tid=%d",self.pageNum,self.tab];
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        
        NSArray *lists = [DDMovieItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        if (lists.count > 0) {
            [self.dataArray addObjectsFromArray:lists];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self->_pageNum --;
        }
    } withFailureBlock:^(NSString *errorMsg) {
        [self.tableView.mj_footer endRefreshing];
        self->_pageNum --;
    } progress:^(float progress) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDMovieItem *model = self.dataArray[indexPath.row];
    DDDetailVC *vc = [[DDDetailVC alloc]init];
    vc.vodModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
