//
//  MovieViewController.m
//  Cartoon
//
//  Created by zxh on 2019/6/21.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "MovieItem.h"
#import "XPNetWorkTool.h"
#import "MJRefresh.h"
#import "PlayModel.h"
#import "LVPlayVodDetailVC.h"

@interface MovieViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *arrays;

@end

@implementation MovieViewController{
    int _pageNum;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.textF.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData:)];
    footer.onlyRefreshPerDrag = YES;
    footer.triggerAutomaticallyRefreshPercent = 2;
    [footer setTitle:@"没有更多" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    _pageNum = 1;
    self.arrays = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    [self requestRecomand];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrays.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    MovieItem *item = self.arrays[indexPath.row];
    cell.item = item;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieItem *item = self.arrays[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"https://v.kan321.com/api/info?id=%d&app-version=1.0.11",item.vid];
    
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

- (IBAction)search:(id)sender {
     [self.textF resignFirstResponder];
    if (self.textF.text.length > 0) {
        [self requestData:nil];
    }else{
        [self  requestRecomand];
    } 
}

-(void)requestRecomand{
    NSString *url = [NSString stringWithFormat:@"https://v.kan321.com/api/hot"];
    
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject[@"data"][@"list"]);
        NSArray *list = responseObject[@"data"][@"list"];
        self.arrays = [NSMutableArray array];
        for (int i = 0 ; i < list.count; i++) {
            NSDictionary *dict = list[i];
            NSArray *arry = [MovieItem mj_objectArrayWithKeyValuesArray:dict[@"videos"]];
            [self.arrays addObjectsFromArray:arry];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSString *errorMsg) {

    } progress:^(float progress) {
        
    }];
}


-(void)requestData:(id)sender{
    if (sender == nil) {
        _pageNum = 1;
    }else{
        _pageNum ++;
    }
    NSString *url = [[NSString stringWithFormat:@"https://v.kan321.com/api/search?query=%@&page=%d&app-version=1.0.11",self.textF.text,_pageNum] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject[@"data"][@"data"]);
        NSArray *temArray = [MovieItem mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        if (self->_pageNum == 1) {
            self.arrays = [temArray mutableCopy];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.arrays addObjectsFromArray: temArray];
            [self.tableView.mj_footer endRefreshing];
        }
        if (temArray.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSString *errorMsg) {
        self->_pageNum --;
    } progress:^(float progress) {
        
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.textF resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
        [self search:nil];
        return YES;
    }
    return NO;
}

@end
