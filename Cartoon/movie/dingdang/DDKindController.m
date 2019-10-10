//
//  DDKindController.m
//  Cartoon
//
//  Created by zxh on 2019/9/16.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "DDKindController.h"
#import "DDMovieItem.h"
#import "MovieCell.h"
#import "MJRefresh.h"
#import "DDDetailVC.h"
#import "FMDB.h"
//docment路径
#define DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
@interface DDKindController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) int pageNum;
@end

@implementation DDKindController    {
    FMDatabase * _db;//消息数据库对象
}

-(void)insertDbWithDict:(NSDictionary *)videoDict{
    NSString *vodId = videoDict[@"vodId"];
    NSString *vodContent = videoDict[@"vodContent"];
    NSString * vodpic = videoDict[@"vodpic"];
    NSString *vodactor = videoDict[@"vodactor"];
    NSString *voddirector = videoDict[@"voddirector"];
    NSString *vodremarks = videoDict[@"vodremarks"];
    NSString *vodname = videoDict[@"vodname"];
    NSString *vodurl = videoDict[@"vodurl"];
    NSString *vodYear = videoDict[@"vodYear"];
    NSString *vodtimeadd = videoDict[@"vodtimeadd"];
    //设置消息的数据库名称
    NSString *fileName = [DOCUMENT_PATH stringByAppendingPathComponent:@"dingdang.sqlite"];
    //2.获取数据库
    _db = [FMDatabase databaseWithPath:fileName];
    if ([_db open]) {
        //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
        BOOL result = [_db executeUpdate:@"INSERT OR REPLACE INTO t_DINGDANG_VIDEO (vodId,vodContent, vodpic, vodactor, voddirector, vodremarks, vodname, vodurl,vodYear,vodtimeadd) VALUES (?,?,?,?,?,?,?,?,?,?)",vodId,vodContent, vodpic, vodactor, voddirector, vodremarks, vodname, vodurl,vodYear,vodtimeadd];
        if (result) {
            NSLog(@"---插入成功");
        } else {
            NSLog(@"---插入失败");
        }
        [_db close];
    }
}

-(void)saveUrl{
    if (self.dataArray.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"无数据"];
        return;
    }

    // 创建队列组，可以使多个网络请求异步执行，执行完之后再进行操作
    dispatch_group_t group = dispatch_group_create();
    //创建全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, queue, ^{
        // 循环上传数据
        for (int i = 0; i < self.dataArray.count; i++) {
            //创建dispatch_semaphore_t对象
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            DDMovieItem *model = self.dataArray[i];
            NSString *url = [NSString stringWithFormat:@"http://kkapp.dingdang.tv:8089//ajax/getDetail?mid=1&id=%@",model.vod_id];
            [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
                NSDictionary *info = responseObject[@"info"];
                if (info) {
                    NSDictionary *playlist = info[@"vod_play_list"];
                    NSDictionary *child = [[playlist allValues] firstObject];
                    if (child) {
                        NSString *urlstr = child[@"url"];
                        NSMutableDictionary *videoDict = [NSMutableDictionary dictionary];
                        videoDict[@"vodId"] = model.vod_id;
                        videoDict[@"vodContent"] = model.vod_content;
                        videoDict[@"vodpic"] = model.vod_pic;
                        videoDict[@"vodactor"] = model.vod_actor;
                        videoDict[@"voddirector"] = model.vod_director;
                        videoDict[@"vodremarks"] = model.vod_remarks;
                        videoDict[@"vodname"] = model.vod_name;
                        videoDict[@"vodurl"] = urlstr;
                        videoDict[@"vodYear"] = model.vod_year;
                        videoDict[@"vodtimeadd"] = model.vod_time;
                        [self insertDbWithDict:videoDict];
                    }
                }else{
                    [SVProgressHUD showInfoWithStatus:@"获取详情失败！！！！"];
                }
                // 请求成功发送信号量(+1)
                NSLog(@"发送请求  %d",i);
               dispatch_semaphore_signal(semaphore);
            } withFailureBlock:^(NSString *errorMsg) {
            // 请求成功发送信号量(+1)
              dispatch_semaphore_signal(semaphore);
            } progress:^(float progress) {

            }];
            //信号量减1，如果>0，则向下执行，否则等待
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    });

                   


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0,0, screenW, screenH) style:UITableViewStylePlain];
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
    

    UIButton *right = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [right addTarget:self action:@selector(saveUrl) forControlEvents:UIControlEventTouchUpInside];
    right.backgroundColor = [UIColor redColor];
//    [self.view addSubview:right];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData:)];
    footer.onlyRefreshPerDrag = YES;
    footer.triggerAutomaticallyRefreshPercent = 2;
    [footer setTitle:@"没有更多" forState:MJRefreshStateNoMoreData];
    [footer setTintColor:[UIColor whiteColor]];
    footer.stateLabel.textColor = [UIColor whiteColor];
    
    self.tableView.mj_footer = footer;
    
    [self requestData:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    DDMovieItem *model = self.dataArray[indexPath.row];
    cell.ddModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}


-(void)requestData:(id)sender{
    if (sender == nil) {
        self.dataArray = [NSMutableArray array];
        _pageNum = 1;
    }else{
        _pageNum ++;
    }
    NSString *url = [NSString stringWithFormat:@"http://kkapp.dingdang.tv:8089//ajax/data?mid=1&page=%d&limit=100&tid=%d",self.pageNum,self.tab];
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
        
        NSArray *lists = [DDMovieItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        if (lists.count > 0) {
            [self.dataArray addObjectsFromArray:lists];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self->_pageNum --;
        }
    } withFailureBlock:^(NSString *errorMsg) {
        [self.tableView.mj_footer endRefreshing];
        self->_pageNum --;
    } progress:^(float progress) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDMovieItem *model = self.dataArray[indexPath.row];
    DDDetailVC *vc = [[DDDetailVC alloc]init];
    vc.vodModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
