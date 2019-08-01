//
//  MGKindViewController.m
//  Cartoon
//
//  Created by zxh on 2019/8/1.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "MGKindViewController.h"
#import "MovieItem.h"
#import "MovieCell.h"
#import "LVPlayVodDetailVC.h"
#import "MoiveSectionModel.h"
#import "PlayModel.h"

@interface MGKindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *dataArray;
@end

@implementation MGKindViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataArray.count == 0) {
        [self requestData];
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
    [self requestData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MoiveSectionModel *model = self.dataArray[section];
    return model.videos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    MoiveSectionModel *rowsModel = self.dataArray[indexPath.section];
    MovieItem *model = rowsModel.videos[indexPath.row];
    cell.item = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MoiveSectionModel *rowsModel = self.dataArray[section];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 44)];
    view.backgroundColor = [UIColor blackColor];
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 44)];
    la.text = rowsModel.title;
    la.textColor = [UIColor whiteColor];
    la.font = [UIFont boldSystemFontOfSize:22];
    [view addSubview:la];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(void)requestData{
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:self.urlStr withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        self.dataArray = [MoiveSectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        if (self.dataArray.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"没有数据！"];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSString *errorMsg) {
        
    } progress:^(float progress) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MoiveSectionModel *rowsModel = self.dataArray[indexPath.section];
    MovieItem *item = rowsModel.videos[indexPath.row];
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
