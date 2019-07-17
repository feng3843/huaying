//
//  XXKindViewController.m
//  Cartoon
//
//  Created by zxh on 2019/7/17.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "XXKindViewController.h"

@interface XXKindViewController ()<UITableViewDelegate,UITableViewDataSource>

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
//    [table registerNib:[UINib nibWithNibName:@"LongVideoCell" bundle:nil] forCellReuseIdentifier:@"LongVideoCell"];
    [self.view addSubview:table];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

@end
