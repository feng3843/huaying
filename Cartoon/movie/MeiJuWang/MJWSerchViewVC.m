//
//  MJWSerchViewVC.m
//  Cartoon
//
//  Created by zxh on 2020/2/20.
//  Copyright © 2020 hanyong. All rights reserved.
//

#import "MJWSerchViewVC.h"
#import "XPLeftSearchBar.h"
#import "MJWMovieItemModel.h"
#import "MJWMovieItemCell.h"
#import "MJRefresh.h"
#import "MJWPlayerVC.h"
#define historePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/dingdanghistory.plist"]

//docment路径
#define DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#import "FMDB.h"

@interface MJWSerchViewVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
//tableView
@property (strong, nonatomic)  UITableView *tableView;

//searchController
@property (strong, nonatomic)  XPLeftSearchBar *searchBar;

//数据源
@property (strong,nonatomic) NSMutableArray  *dataList;

@property (nonatomic , strong) NSMutableArray *historyList;

@property (nonatomic , strong) UITableView *historyView;

@end

@implementation MJWSerchViewVC{
    int _page;
    FMDatabase * _db;//消息数据库对象
}

-(void)saveUrl{
    
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
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [path objectAtIndex:0];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dingdang.sqlite" ofType:nil];
    NSString *dstPath = [docDirectory stringByAppendingPathComponent:@"dingdang.sqlite"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dstPath] == false) {
        [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:dstPath error:nil];
    }

    //设置消息的数据库名称
    _db = [FMDatabase databaseWithPath:dstPath];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveUrl)];
    self.navigationItem.rightBarButtonItem = right;
    
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
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 84, screenW, 54)];
    _searchBar = [[XPLeftSearchBar alloc] initWithFrame:CGRectMake(10, 5, screenW - 20, 44)];
    _searchBar.placeholder = @"搜索内容";
    _searchBar.delegate = self;
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDefault;
    [view addSubview:_searchBar];
    [self.view addSubview:view];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 84 + 54,screenW ,screenH - 84)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    [_tableView registerNib:[UINib nibWithNibName:@"MJWMovieItemCell"  bundle:nil] forCellReuseIdentifier:@"MJWMovieItemCell"];
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
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestSearchWithKey:)];
    footer.onlyRefreshPerDrag = YES;
    footer.triggerAutomaticallyRefreshPercent = 2;
    [footer setTitle:@"没有更多" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    
}

-(void)requestSearchWithKey:(id)sender{
    if (sender == nil) {
        _page = 1;
    }else{
        _page++;
    }
    NSString *keyWord = self.searchBar.text;

    NSString *url = [[NSString stringWithFormat:@"https://api.bjxkhc.com/index.php/app/ios/vod/index?key=%@&page=%d&size=50",keyWord,_page] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *array = [MJWMovieItemModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        if (array.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [SVProgressHUD showInfoWithStatus:@"没有更多数据了～！"];
        }else{
            if (sender == nil) {
                self.dataList  = [array mutableCopy];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.dataList addObjectsFromArray:array];
                [self.tableView.mj_footer endRefreshing];
            }
        }
        
        [self.tableView reloadData];
        [self.view bringSubviewToFront:self.tableView];
    } withFailureBlock:^(NSString *errorMsg) {
        self->_page --;
        [self.tableView.mj_footer endRefreshing];
    } progress:^(float progress) {
        
    }];
    
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
    MJWMovieItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MJWMovieItemCell" forIndexPath:indexPath];
    MJWMovieItemModel *model = self.dataList[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _historyView) {
        return 44;
    }
    return 110;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _historyView) {
        self.searchBar.text = _historyList[indexPath.row];
        [self searchBarSearchButtonClicked:self.searchBar];
        return;
    }
     MJWMovieItemModel *model = self.dataList[indexPath.row];
    MJWPlayerVC *vc = [[MJWPlayerVC alloc]init];
    vc.itemModel = model;
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
    [self.tableView reloadData];
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
