//
//  DDOffsearchViewController.m
//  Cartoon
//
//  Created by zxh on 2019/10/9.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "DDOffsearchViewController.h"
#import "XPLeftSearchBar.h"
#import "DDListModel.h"
#import "MovieCell.h"
#import "DDOffLinePlayVC.h"
#import "MJRefresh.h"
#define historePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/dingdanghistory.plist"]

//docment路径
#define DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#import "FMDB.h"

@interface DDOffsearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
//tableView
@property (strong, nonatomic)  UITableView *tableView;

//searchController
@property (strong, nonatomic)  XPLeftSearchBar *searchBar;

//数据源
@property (strong,nonatomic) NSMutableArray  *dataList;

@property (nonatomic , strong) NSMutableArray *historyList;

@property (nonatomic , strong) UITableView *historyView;

@end

@implementation DDOffsearchViewController{
    int _page;
    FMDatabase * _db;//消息数据库对象
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [path objectAtIndex:0];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dingdang.sqlite" ofType:nil];
    NSString *dstPath = [docDirectory stringByAppendingPathComponent:@"dingdang.sqlite"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dstPath] == false) {
        [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:dstPath error:nil];
    }

    //设置消息的数据库名称
    _db = [FMDatabase databaseWithPath:dstPath];
    
    _dataList = [NSMutableArray array];
    self.title = @"搜索";
    
    //创建UISearchController
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 84, screenW, 54)];
    _searchBar = [[XPLeftSearchBar alloc] initWithFrame:CGRectMake(10, 5, screenW - 20, 44)];
    _searchBar.placeholder = @"搜索内容";
    _searchBar.delegate = self;
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDefault;
    [view addSubview:_searchBar];
    [self.view addSubview:view];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 84 + 54,screenW ,screenH - 84 - 54)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    [_tableView registerNib:[UINib nibWithNibName:@"MovieCell"  bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    if (@available(iOS 11, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    
    _historyList = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:historePath]];
    _historyView = [[UITableView alloc]initWithFrame:_tableView.frame];
    _historyView.delegate = self;
    _historyView.dataSource = self;
    _historyView.separatorStyle = UITableViewCellSelectionStyleNone;
    _historyView.backgroundColor = [UIColor blackColor];
    [_historyView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    [self.view addSubview:_tableView];
    [self.view addSubview:_historyView];
    self.dataList = [NSMutableArray array];
    
//    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestSearchWithKey:)];
//    footer.onlyRefreshPerDrag = YES;
//    footer.triggerAutomaticallyRefreshPercent = 2;
//    [footer setTitle:@"没有更多" forState:MJRefreshStateNoMoreData];
//    self.tableView.mj_footer = footer;
//    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    
}

-(void)requestSearchWithKey:(id)sender{
    NSString *keyWord = self.searchBar.text;
    

       if ([_db open]) {
           //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
           NSString *selectSQL = [NSString stringWithFormat:@"select * from t_DINGDANG_VIDEO where vodname like '%%%@%%'",keyWord];
           FMResultSet *result = [_db executeQuery:selectSQL];
           NSMutableArray *array = @[].mutableCopy;
           while ([result next]) {
               NSMutableDictionary *videoDict = [NSMutableDictionary dictionary];
               videoDict[@"vod_id"] = [result stringForColumn:@"vodId"];
               videoDict[@"vod_content"] = [result stringForColumn:@"vodContent"];
               videoDict[@"vod_pic"] = [result stringForColumn:@"vodpic"];
               videoDict[@"vod_actor"] = [result stringForColumn:@"vodactor"];
               videoDict[@"vod_director"] = [result stringForColumn:@"voddirector"];
               videoDict[@"vod_remarks"] = [result stringForColumn:@"vodremarks"];
               videoDict[@"vod_name"] = [result stringForColumn:@"vodname"];
               videoDict[@"urlStr"] = [result stringForColumn:@"vodurl"];
               videoDict[@"vod_year"] = [result stringForColumn:@"vodYear"];
               videoDict[@"vod_time"] = [result stringForColumn:@"vodtimeadd"];
               videoDict[@"vod_down_url"] = [result stringForColumn:@"vodDownUrl"];
               videoDict[@"vod_class"] = [result stringForColumn:@"vodClass"];
               [array addObject:videoDict];
           }
           
           self.dataList = [DDListModel mj_objectArrayWithKeyValuesArray:array];
           [self.tableView reloadData];
           [_db close];
       }
}


//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _historyView) {
        return self.historyList.count;
    }
    return [self.dataList count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _historyView) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = self.historyList[indexPath.row];
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    }
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    DDListModel *model = self.dataList[indexPath.row];
    cell.ddOffLineModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _historyView) {
        return 44;
    }
    return 150;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _historyView) {
        self.searchBar.text = _historyList[indexPath.row];
        [self searchBarSearchButtonClicked:self.searchBar];
        return;
    }
    DDListModel *model = self.dataList[indexPath.row];
    DDOffLinePlayVC *vc = [[DDOffLinePlayVC alloc]init];
    vc.vodModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _historyView) {
        UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 44)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 44)];
        label.text = @"历史记录";
        view.backgroundColor = [UIColor blackColor];
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(screenW - 80 - 24, 0, 80,44)];
        [btn setTitle:@"清除" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        [view addSubview:btn];
        
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _historyView) {
        return 44;
    }
    return 0;
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
    [self.view bringSubviewToFront:_tableView];
    [self.searchBar resignFirstResponder];
    _page = 1;
    self.dataList = [NSMutableArray array];
    [_tableView reloadData];
    [self updateHistoryList];
    [self requestSearchWithKey:nil];
    
}

-(void)updateHistoryList{
    if ([_historyList containsObject:self.searchBar.text]) {
        [_historyList removeObject:self.searchBar.text];
    }
    if (_historyList.count >= 20) {
        [_historyList removeLastObject];
    }
    [_historyList insertObject:self.searchBar.text atIndex:0];
    
    [_historyList writeToFile:historePath atomically:YES];
    [_historyView reloadData];
}

-(void)clearAll{
    _historyList = [NSMutableArray array];
    [_historyList writeToFile:historePath atomically:YES];
    [_historyView reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view bringSubviewToFront:_historyView];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [self.view bringSubviewToFront:_historyView];
    }
}



@end
