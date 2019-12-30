//
//  ZRFXViewController.m
//  Cartoon
//
//  Created by zxh on 2019/8/27.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "ZRFXViewController.h"
#import "TFHpple.h"
#import "DWSJModel.h"
#import "MovieCell.h"
#import "DSPlayViewController.h"
#import "MJRefresh.h"

@interface ZRFXViewController ()<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) NSMutableArray *items;
@property (nonatomic , assign) int pageNum;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dicts;
@end

@implementation ZRFXViewController{
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
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestList:)];
    footer.onlyRefreshPerDrag = YES;
    footer.triggerAutomaticallyRefreshPercent = 2;
    [footer setTitle:@"没有更多" forState:MJRefreshStateNoMoreData];
    [footer setTintColor:[UIColor whiteColor]];
    footer.stateLabel.textColor = [UIColor whiteColor];
    
    self.tableView.mj_footer = footer;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    DWSJModel *model = self.items[indexPath.row];
    cell.dwsjModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DWSJModel *model = self.items[indexPath.row];
    NSString *baseUrl = @"http://www.cctv1zhibo.com/";
    NSURL *itemUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,model.href]];
    NSStringEncoding gbEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *htmlData = [NSData dataWithContentsOfURL:itemUrl];
    NSString *htmlStr = [[NSString alloc] initWithData:htmlData encoding:gbEncoding] ;
    NSString *utf8HtmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">"
                                                               withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
    NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *itemhpp = [TFHpple hppleWithHTMLData:htmlDataUTF8];
    NSArray *array2 = [itemhpp searchWithXPathQuery:@"//iframe"];
    if (array2.count != 0 ) {
        TFHppleElement *iframeElement = array2[0];
        NSString *idstr = [iframeElement attributes][@"src"];
        NSRange range = [idstr rangeOfString:@"?pid="];
        idstr = [idstr substringFromIndex:(range.location + range.length)];
        NSRange range2 = [idstr rangeOfString:@"&time"];
        idstr = [idstr substringToIndex:range2.location];
        NSString *playUrl = [NSString stringWithFormat:@"http://newcntv.qcloudcdn.com/asp/hls/1200/0303000a/3/default/%@/1200.m3u8",idstr];
        DSPlayViewController *vc = [DSPlayViewController new];
        vc.playUrl = playUrl;
        vc.name = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)requestList:(id)sender{
    if (sender == nil) {
        self.pageNum = 1;
    }else{
        self.pageNum ++;
    }
    
    NSStringEncoding gbEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.cctv1zhibo.com/tags/ziranfaxian/%d/",self.pageNum]];
    NSData *htmlData = [NSData dataWithContentsOfURL:url];
    NSString *htmlStr = [[NSString alloc] initWithData:htmlData encoding:gbEncoding] ;
    NSString *utf8HtmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">"
                                                               withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
    NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *hpp = [TFHpple hppleWithHTMLData:htmlDataUTF8];
    NSArray *array = [hpp searchWithXPathQuery:@"//div[@class='list_lm_news']/ul//li/a"];
    if (array.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    NSMutableArray *itemArray = [NSMutableArray array];
    for (TFHppleElement *element in array) {
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionaryWithDictionary:[element attributes]];
        if ([element hasChildren]) {
            TFHppleElement *subElement = [element children][0];
            itemDict[@"src"] = [subElement attributes][@"src"];
        }
        [itemArray addObject:itemDict];
    }
    NSArray *temp = [DWSJModel mj_objectArrayWithKeyValuesArray:itemArray];
    [self.dicts addObjectsFromArray:itemArray];
    if (temp.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer endRefreshing];
        [self.items addObjectsFromArray:temp];
        [self.tableView reloadData];
    }
}


@end
