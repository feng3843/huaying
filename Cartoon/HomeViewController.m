//
//  HomeViewController.m
//  Cartoon
//
//  Created by zxh on 2019/7/17.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "HomeViewController.h"
#import "MoGuController.h"
#import "movie/Xiao1APP/XXYSViewController.h"
#import "movie/kuaikan/KKViewController.h"
#import "WMViewController.h"
#import "movie/dianshi/DianshiViewController.h"
#import "movie/dianshi/DianyingViewController.h"
#import "DWSJViewController.h"
#import "RYZRViewController.h"
#import "ZRFXViewController.h"
#import "HomeCell.h"
#import "XPGoodsTuWenController.h"
#import "KanKanViewController.h"
#import "CCTVViewController.h"
#import "DDViewController.h"
#import "DDOffsearchViewController.h"
#import "DDOfflineViewController.h"
#import "XPGameVC.h"

#import "PopView.h"
#import "TestViewController.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSArray *titleArray;
@property (nonatomic , strong) UITableView *tableView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = @[@"叮当影视",@"今日影视",@"电影频道",@"电视台",@"CCTV-动物世界",@"离线电影",@"闲泡数据"];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:{
            cell.imgV.image = [UIImage imageNamed:@"叮当"];
            break;
        }
//        case 1:{
//            cell.imgV.image = [UIImage imageNamed:@"mogu"];
//            break;
//        }
//        case 2:{
//            cell.imgV.image = [UIImage imageNamed:@"xiaoxiao"];
//            break;
//        }
//        case 3:{
//            cell.imgV.image = [UIImage imageNamed:@"快看漫画"];
//            break;
//        }
        case 1:{
           cell.imgV.image = [UIImage imageNamed:@"简直完美"];
            break;
        }
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
    switch (indexPath.row) {
        case 0:{
            DDViewController *vc = [[DDViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
//        case 1:{
//            MoGuController *vc = [[MoGuController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 2:{
//            XXYSViewController *vc = [[XXYSViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 3:{
//            KKViewController *vc = [[KKViewController alloc]init];
//            vc.url = @"http://app123.66s.cc";
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
        case 1:{
            WMViewController *vc = [[WMViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];

            break;
        }
        case 2:{
            DianyingViewController *vc = [DianyingViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 3:{
            DianshiViewController *vc = [DianshiViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 4:{
            CCTVViewController *vc = [CCTVViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
            
        case 5:{
            DDOfflineViewController *vc = [DDOfflineViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
    
    
            
        default:{
            TestViewController *vc = [TestViewController new];
            [self.navigationController pushViewController:vc animated:YES];
                       
                       break;
            
            
            
//            PopView *pop = [PopView popView];
//            [[UIApplication sharedApplication].keyWindow addSubview:pop];
//                    break;
                }
    }
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


@end
