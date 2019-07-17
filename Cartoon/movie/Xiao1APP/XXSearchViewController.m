//
//  XXSearchViewController.m
//  Cartoon
//
//  Created by zxh on 2019/7/17.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "XXSearchViewController.h"
#import "XPLeftSearchBar.h"

@interface XXSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
//tableView
@property (strong, nonatomic)  UITableView *tableView;

//searchController
@property (strong, nonatomic)  XPLeftSearchBar *searchBar;

//数据源
@property (strong,nonatomic) NSMutableArray  *dataList;

@end

@implementation XXSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataList = [NSMutableArray array];
    self.title = @"搜索";
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 84,screenW ,screenH - 84)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    [_tableView registerNib:[UINib nibWithNibName:@"GoodSearchCell"  bundle:nil] forCellReuseIdentifier:@"GoodSearchCell"];
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
    
    
}

-(void)requestSearchWithKey:(NSString *)keyWord{
        NSString *url ;//= [NSString stringWithFormat:@"%@%@",urlCloud,urlMallHomeGoodsList];
    NSDictionary *params = @{
                            
                             };
    NSDictionary *headDict = nil;
    [XPNetWorkTool requestWithType:HttpRequestTypePost withHttpHeaderFieldDict:headDict withUrlString:url withParaments:params withSuccessBlock:^(NSDictionary *responseObject) {
        
        NSLog(@"%@",responseObject);
        [self.tableView reloadData];
        
    } withFailureBlock:^(NSString *errorMsg) {
        NSLog(@"%@",errorMsg);
        
    } progress:^(float progress) {
        
    }];
    
}


//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList count];
}


//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [[UITableViewCell alloc]init];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
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
    [self requestSearchWithKey:searchBar.text];
    
}

@end
