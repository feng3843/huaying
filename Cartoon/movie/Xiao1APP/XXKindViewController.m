//
//  XXKindViewController.m
//  Cartoon
//
//  Created by zxh on 2019/7/17.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "XXKindViewController.h"
#import "XXMovieListModel.h"
#import "XXTabModel.h"
#import "XXTabRowsModel.h"
#import "MovieCell.h"
#import "XXPlayDetailController.h"

@interface XXKindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSArray *dataArray;
@end

@implementation XXKindViewController

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
    XXTabRowsModel *model = self.dataArray[section];
    return model.vodrows.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    XXTabRowsModel *rowsModel = self.dataArray[indexPath.section];
    XXMovieListModel *model = rowsModel.vodrows[indexPath.row];
    cell.xxModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    XXTabRowsModel *rowsModel = self.dataArray[section];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 44)];
    view.backgroundColor = [UIColor blackColor];
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 44)];
    la.text = rowsModel.caption;
    la.textColor = [UIColor whiteColor];
    la.font = [UIFont boldSystemFontOfSize:22];
    [view addSubview:la];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(void)requestData{
    NSString *url = [NSString stringWithFormat:@"https://ios.xiaoxiaoimg.com/index?tab=%d",self.tab];
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        
        
        XXTabModel *model = [XXTabModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        NSMutableArray *dataArray = [NSMutableArray array];
        XXTabRowsModel *jinri = [[XXTabRowsModel alloc]init];
        jinri.caption = @"今日推荐";
        jinri.vodrows = model.dayrows;
        [dataArray addObject:jinri];
        
        XXTabRowsModel *huore = [[XXTabRowsModel alloc]init];
        huore.caption = @"火热推荐";
        huore.vodrows = model.hotrows;
        [dataArray addObject:huore];

        [dataArray addObjectsFromArray:model.nestedrows];
        
        self.dataArray = dataArray;
        [self.tableView reloadData];
    } withFailureBlock:^(NSString *errorMsg) {
        
    } progress:^(float progress) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XXTabRowsModel *rowsModel = self.dataArray[indexPath.section];
    XXMovieListModel *model = rowsModel.vodrows[indexPath.row];
    XXPlayDetailController *vc = [[XXPlayDetailController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
