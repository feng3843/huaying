//
//  DDZJViewController.m
//  Cartoon
//
//  Created by zxh on 2019/9/16.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "DDZJViewController.h"
#import "DDTopicModel.h"
#import "MovieCell.h"
#import "DDZJDetailController.h"
@interface DDZJViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *dataArray;
@end

@implementation DDZJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 84,screenW ,screenH - 84)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    if (@available(iOS 11, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    }
    [self.view addSubview:_tableView];
    [self getList];
}

-(void)getList{
    NSString *url = [NSString stringWithFormat:@"http://kkapp.dingdang.tv:8089//ajax/topicViewWithVodDetail?mid=1&page=1&limit=30"];
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSDictionary *dict = responseObject[@"list"];
       self.dataArray = [DDTopicModel mj_objectArrayWithKeyValuesArray:[dict allValues]];
      [self.tableView reloadData];
    } withFailureBlock:^(NSString *errorMsg) {
       
    } progress:^(float progress) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenW, 150 - 10)];
    [cell addSubview:imgV];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, screenW - 40, 20)];
    [cell addSubview:label];
    
    DDTopicModel *model = self.dataArray[indexPath.row];
    [imgV sd_setImageWithURL:[NSURL URLWithString:model.topic_pic]];
    label.text = model.topic_name;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [label sizeToFit];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDZJDetailController *vc = [DDZJDetailController new];
    DDTopicModel *model = self.dataArray[indexPath.row];
    vc.model = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
