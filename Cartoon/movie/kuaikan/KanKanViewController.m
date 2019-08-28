//
//  KanKanViewController.m
//  Cartoon
//
//  Created by zxh on 2019/8/28.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "KanKanViewController.h"
#import "TFhpple/TFHpple.h"
#import "KKModel.h"
#import "MovieCell.h"
#import "KKPlayListController.h"
#import "MJRefresh.h"

@interface KanKanViewController ()<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) NSMutableArray *items;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dicts;
@end

@implementation KanKanViewController{
    NSMutableArray * _dataList ;
    NSMutableString * _elementString;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.items.count == 0) {
        [self requestList:nil];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.items = [NSMutableArray array];
    self.dicts = [NSMutableArray array];
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0,88, screenW, screenH - 88 - 34) style:UITableViewStylePlain];
    self.tableView = table;
    table.tableFooterView = [UIView new];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.estimatedRowHeight = 220;
    table.rowHeight = UITableViewAutomaticDimension;
    table.backgroundColor = [UIColor blackColor];
    [table registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
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
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    KKModel *model = self.items[indexPath.row];
    cell.kkModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KKModel *model = self.items[indexPath.row];
    NSString *baseUrl = @"http://app123.66s.cc/";
    NSURL *itemUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,model.href]];
    NSData *htmlData = [NSData dataWithContentsOfURL:itemUrl];
    TFHpple *itemhpp = [TFHpple hppleWithHTMLData:htmlData];
    //播放地址列表
    TFHppleElement * playList = [[itemhpp searchWithXPathQuery:@"//div[@id='stab21']"] firstObject];
    TFHppleElement * playList_ul = [playList firstChildWithTagName:@"ul"];
    NSArray *li_array = [playList_ul childrenWithTagName:@"li"];
    NSMutableArray *palyLists = [NSMutableArray array];
    for (TFHppleElement *sub in li_array) {
        TFHppleElement * aEl = [sub firstChildWithTagName:@"a"];
        NSDictionary *dict = [aEl attributes];
        NSString *title = dict[@"title"];
        NSString *href = [NSString stringWithFormat:@"%@%@",baseUrl,dict[@"href"]];
        NSMutableDictionary *item = [NSMutableDictionary dictionaryWithObjectsAndKeys:title,@"title",href,@"href", nil];
        [palyLists addObject:item];
    }
    NSLog(@"%@",palyLists);
    KKPlayListController *vc = [KKPlayListController new];
    vc.playList = palyLists;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)requestList:(id)sender{

    NSURL *url = [NSURL URLWithString:@"http://app123.66s.cc"];
    NSData *htmlData = [NSData dataWithContentsOfURL:url];
    TFHpple *hpp = [TFHpple hppleWithHTMLData:htmlData];
    NSArray *array1 = [hpp searchWithXPathQuery:@"//div[@class='li-img']/a"];
    NSArray *array2 = [hpp searchWithXPathQuery:@"//div[@class='txt']/p[@class='name']/a"];
    if (array1.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    NSMutableArray *itemArray = [NSMutableArray array];
    
    for (int i = 0 ; i<array1.count;i++) {
        TFHppleElement *element1 =array1[i];
        TFHppleElement *element2 =array2[i];
        
        NSDictionary *hrefDict = [element1 attributes];
        NSString *href = hrefDict[@"href"];
        
        TFHppleElement *imgEl = [[element1 childrenWithClassName:@"lazy img"] firstObject];
        NSDictionary *dict = [imgEl attributes];
        NSString *img = dict[@"data-original"];

        
        NSString *name = [element2 text];
        
        NSMutableDictionary *item = [NSMutableDictionary dictionaryWithObjectsAndKeys:img,@"src",name,@"title",href,@"href", nil];
        [itemArray addObject:item];
    }
    NSArray *temp = [DWSJModel mj_objectArrayWithKeyValuesArray:itemArray];
    [self.dicts addObjectsFromArray:temp];
    if (temp.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer endRefreshing];
        [self.items addObjectsFromArray:temp];
        [self.tableView reloadData];
    }
}


@end
