//
//  WMHotVCViewController.m
//  Cartoon
//
//  Created by zxh on 2019/8/19.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "WMHotVCViewController.h"
#import "WMModel.h"
#import "MovieCell.h"
#import "WMPlayViewController.h"
#import "PlayModel.h"
#import "WMMovieModel.h"


@interface WMHotVCViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WMHotVCViewController

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
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    WMModel *model = self.dataArray[indexPath.row];
    cell.wmModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
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
