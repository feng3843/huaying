//
//  MGSearchController.m
//  Cartoon
//
//  Created by zxh on 2019/8/1.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "MGSearchController.h"
#import "XPLeftSearchBar.h"
#import "MovieItem.h"
#import "MovieCell.h"
#import "LVPlayVodDetailVC.h"
#import "PlayModel.h"
#import "MJRefresh.h"

@interface MGSearchController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
//tableView
@property (strong, nonatomic)  UITableView *tableView;

//searchController
@property (strong, nonatomic)  XPLeftSearchBar *searchBar;

//数据源
@property (strong,nonatomic) NSMutableArray  *dataList;

@end

@implementation MGSearchController{
    int _page;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    
    _dataList = [NSMutableArray array];
    self.title = @"搜索";
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 84,screenW ,screenH - 84)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    [_tableView registerNib:[UINib nibWithNibName:@"MovieCell"  bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    if (@available(iOS 11, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //创建UISearchController
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 54)];
    _searchBar = [[XPLeftSearchBar alloc] initWithFrame:CGRectMake(10, 5, screenW - 20, 44)];
    _searchBar.placeholder = @"搜索内容";
    _searchBar.delegate = self;
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDefault;
    [view addSubview:_searchBar];
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = view;
    
    [self.view addSubview:_tableView];
    self.dataList = [NSMutableArray array];
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestSearchWithKey:)];
    footer.onlyRefreshPerDrag = YES;
    footer.triggerAutomaticallyRefreshPercent = 2;
    [footer setTitle:@"没有更多" forState:MJRefreshStateNoMoreData];
    [footer setTintColor:[UIColor whiteColor]];
    footer.stateLabel.textColor = [UIColor whiteColor];
   
    self.tableView.mj_footer = footer;
    
}

-(void)requestSearchWithKey:(id)sender{
    if (sender == nil) {
        _page = 1;
    }else{
        _page++;
    }
    NSString *keyWord = self.searchBar.text;
    NSString *url = [[NSString stringWithFormat:@"https://v.kan321.com/api/search?query=%@&page=%d",keyWord,_page] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSMutableArray *array = [MovieItem mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        [self.dataList addObjectsFromArray: array];
        if (array.count < [responseObject[@"data"][@"page_size"] integerValue] || _page >= [responseObject[@"data"][@"page_total"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [SVProgressHUD showInfoWithStatus:@"没有更多数据了～！"];
        }else{
            
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSString *errorMsg) {
        self->_page --;
        [self.tableView.mj_footer endRefreshing];
    } progress:^(float progress) {
        
    }];
    
}


//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    MovieItem *model = self.dataList[indexPath.row];
    cell.item = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieItem *item = self.dataList[indexPath.row];
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length < 1) {
        return;
    }
    [self.searchBar resignFirstResponder];
    _page = 1;
    self.dataList = [NSMutableArray array];
    [self requestSearchWithKey:nil];
    
}
@end
