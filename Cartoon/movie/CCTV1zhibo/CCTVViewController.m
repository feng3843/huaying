//
//  CCTVViewController.m
//  Cartoon
//
//  Created by zxh on 2019/8/29.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "CCTVViewController.h"
#import "HomeCell.h"
#import "CCTVListVC.h"
#import "ZRFXViewController.h"

@interface CCTVViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSArray *titleArray;
@property (nonatomic , strong) UITableView *tableView;
@end

@implementation CCTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = @[@"动物世界",@"人与自然",@"自然发现",@"朝闻天下"];
    self.view.backgroundColor = [UIColor blackColor];
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0,88, screenW, screenH - 88 - 34) style:UITableViewStylePlain];
    self.tableView = table;
    table.tableFooterView = [UIView new];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.estimatedRowHeight = 220;
    table.rowHeight = UITableViewAutomaticDimension;
    table.backgroundColor = [UIColor blackColor];
    table.tableFooterView = [UIView new];
    [table registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:@"HomeCell"];
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
    return self.titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    cell.textL.text = self.titleArray[indexPath.row];
    cell.backgroundColor = [UIColor blackColor];
    cell.textL.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    switch (indexPath.row) {
        default:
            cell.imgV.image = [UIImage imageNamed:@"电台"];
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *href = @"zhaowentianxia";
    switch (indexPath.row) {
        case 0:{
            href = @"dongwushijie";
            break;
        }
        case 1:{
          href = @"renyuziran";
            break;
        }
        case 2:{
            ZRFXViewController *vc = [ZRFXViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            return;
            break;
        }
        case 3:{
            href = @"zhaowentianxia";
            break;
        }
        default:
            break;
    }
    CCTVListVC *vc = [CCTVListVC new];
    vc.href = href;
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
@end
