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

#define PYSEARCH_SEARCH_HISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MALLGOODSSearchhistories.plist"]

@interface MovieViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *arrays;
/** 搜索历史 */
@property (nonatomic, strong) NSMutableArray *searchHistories;
/** 搜索历史缓存保存路径, 默认为PYSEARCH_SEARCH_HISTORY_CACHE_PATH(PYSearchConst.h文件中的宏定义) */
@property (nonatomic, copy) NSString *searchHistoriesCachePath;
/** 搜索历史记录缓存数量，默认为20 */
@property (nonatomic, assign) NSUInteger searchHistoriesCount;
@property (nonatomic, strong) UIView *defaultSearchView;

@end

@implementation MovieViewController{
    int _pageNum;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.searchHistoriesCount = 10;
//    //默认搜索页
//    self.defaultSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, 44 + 84, screenW, screenH - 44 - 34 - 84)];
//    [self.view addSubview:self.defaultSearchView];
//    [self redrawDefaultSearchView];
//    
    
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

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length < 1) {
        return;
    }
    _pageNum = 1;
    //处理历史数据，重绘制默认视图，
    [self saveSearchCacheAndRefreshView];
    
    //展示结果页，隐藏默认页
    self.tableView.hidden = NO;
    self.defaultSearchView.hidden = YES;
    
    //请求网络搜索结果
    [self requestData:nil];
    
}

/** 进入搜索状态调用此方法 */
- (void)saveSearchCacheAndRefreshView
{
    
    // 回收键盘
    [self.textF resignFirstResponder];
    // 先移除再刷新
    [self.searchHistories removeObject:self.textF.text];
    [self.searchHistories insertObject:self.textF.text atIndex:0];
    
    // 移除多余的缓存
    if (self.searchHistories.count > self.searchHistoriesCount) {
        // 移除最后一条缓存
        [self.searchHistories removeLastObject];
    }
    // 保存搜索信息
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    
    [self redrawDefaultSearchView];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        self.tableView.hidden = YES;
        self.defaultSearchView.hidden = NO;
    }
}

-(void)redrawDefaultSearchView{
    for (UIView *subview in self.defaultSearchView.subviews){
        [subview removeFromSuperview];
    }
    //历史记录流水布局容器
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, screenW, 300)];
    [self.defaultSearchView addSubview:historyView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, screenW-148, 25)];
    titleLabel.text = @"历史搜索";
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    titleLabel.textColor = [FYColorTool colorFromHexRGB:@"#333333" alpha:1];
    [titleLabel sizeToFit];
    [historyView addSubview:titleLabel];
    
    //初始化标签
    CGFloat currentX = 24;
    CGFloat currentY = 36;
    CGFloat imageToTitle = 0;//btn内部图片和文字的间距
    CGFloat spaceX = 10;     // 左右的空隙
    CGFloat spaceY = 8;     // 上下的空隙
    CGFloat lineH = 28; //行高
    CGFloat imageLH = 0; //图片大小
    CGFloat viewMarginLR = 24;//容器左右侧间距
    if (self.searchHistories.count == 0) {
        historyView.frame = CGRectMake(0, 24, screenW, 0);
        historyView.hidden = YES;
    }else{
        UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenW-48, 3, 18, 18)];
        [delBtn setImage:[UIImage imageNamed:@"search_icon_delete"] forState:UIControlStateNormal];
        [historyView addSubview:delBtn];
        [delBtn addTarget:self action:@selector(deleteHistorySearchs) forControlEvents:UIControlEventTouchUpInside];
        
        for (int i = 0; i<self.searchHistories.count; i++) {
            NSString *keyword = self.searchHistories[i];
            CGFloat width = [keyword sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].width+ 19*2 + viewMarginLR + imageToTitle + imageLH; //文字长度+ 右侧间距+ 文字到图片间距 + 图片高度
            
            UIButton *button = [UIButton new];
            button.tag = 100 + i;
            [button setTitle:keyword forState:UIControlStateNormal];
            [button setTitleColor:[FYColorTool colorFromHexRGB:@"#333333" alpha:1] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button addTarget:self action:@selector(historyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[[UIImage imageNamed:@"search_btn_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
            // 剩余的空间 能显示下
            if (screenW - currentX - spaceX - viewMarginLR > width) {
                button.frame = CGRectMake(currentX, currentY, width, lineH);
                currentX += width+spaceX;
            }
            // 剩余的空间 显示不下 需要折行显示(但是这一行还没显示满 故不更新currentY)
            else{
                currentY += lineH + spaceY;
                currentX = 24;
                button.frame = CGRectMake(currentX, currentY, width, lineH);
                currentX += width+spaceX;
            }
            [historyView addSubview:button];
        }
        historyView.frame = CGRectMake(0, 25, screenW , currentY + 28 + 30);
    }
}

-(void)historyBtnClick:(UIButton *)btn{
    _pageNum = 1;
    NSString *str = self.searchHistories[btn.tag - 100];
    self.textF.text = str;
    //请求网络搜索结果
    [self requestData:nil];
    //处理历史数据，重绘制默认视图，
    [self saveSearchCacheAndRefreshView];
    
    //展示结果页，隐藏默认页
    self.tableView.hidden = NO;
    self.defaultSearchView.hidden = YES;
}

-(void)deleteHistorySearchs{
    [self emptySearchHistoryDidClick];
}

/** 点击清空历史按钮 */
- (void)emptySearchHistoryDidClick
{
    // 移除所有历史搜索
    [self.searchHistories removeAllObjects];
    // 移除数据缓存
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    
    [self redrawDefaultSearchView];
    
}

- (NSMutableArray *)searchHistories{
    if (!_searchHistories) {
        self.searchHistoriesCachePath = PYSEARCH_SEARCH_HISTORY_CACHE_PATH;
        _searchHistories = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath]];
        
    }
    return _searchHistories;
}

- (void)setSearchHistoriesCachePath:(NSString *)searchHistoriesCachePath
{
    _searchHistoriesCachePath = [searchHistoriesCachePath copy];
    // 刷新
    self.searchHistories = nil;
}

@end
