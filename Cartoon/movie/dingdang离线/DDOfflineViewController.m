//
//  DDOfflineViewController.m
//  Cartoon
//
//  Created by zxh on 2019/10/10.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "DDOfflineViewController.h"
#import "DDListModel.h"
#import "MovieCell.h"
#import "FMDB.h"
#import "DDOffLinePlayVC.h"
#import "DDOffsearchViewController.h"

@interface DDOfflineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *dataList;
@property (nonatomic , strong) UITableView *tableView;
@end

@implementation DDOfflineViewController{
    FMDatabase *_db;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
       NSString *docDirectory = [path objectAtIndex:0];
       NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dingdang.sqlite" ofType:nil];
       NSString *dstPath = [docDirectory stringByAppendingPathComponent:@"dingdang.sqlite"];
       if ([[NSFileManager defaultManager] fileExistsAtPath:dstPath] == false) {
           [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:dstPath error:nil];
       }

       //设置消息的数据库名称
       _db = [FMDatabase databaseWithPath:dstPath];
        
       UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"获取最新" style:UIBarButtonItemStylePlain target:self action:@selector(saveUrl)];
       self.navigationItem.rightBarButtonItem = right;
    
       UIBarButtonItem *search = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"sousuo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
    self.navigationItem.rightBarButtonItems = @[search,right];
    
    
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

       [self.view addSubview:_tableView];
       self.dataList = [NSMutableArray array];
    
    [self requestSearchWithKey:nil];
}

-(void)searchClick{
       NSLog(@"searchClick");
       [self.navigationController pushViewController:[DDOffsearchViewController new] animated:YES];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请输入需要拉取的数据个数" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = @"100";
        textField.placeholder = @"请输入需要拉取的数据个数";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UITextField *  textField = alert.textFields[0];
        int num = [textField.text intValue];
        if (num > 0) {
            [self getNewDataListWithNum:num];
        }else{
            [self getNewDataListWithNum:100];
        }
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:yes];
    
    [self presentViewController:alert animated:yes completion:nil];
    
    
}

-(void)getNewDataListWithNum:(int)num{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
       [SVProgressHUD showProgress:0];
       //1.查询最新数据
       NSString *url = [NSString stringWithFormat:@"http://kkapp.dingdang.tv:8089//ajax/data?mid=1&page=1&limit=%d&tid=0",num];
       [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:url withParaments:nil withSuccessBlock:^(NSDictionary *responseObject) {
           
           NSArray *lists = [DDMovieItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];

               if (lists.count == 0) {
                   [SVProgressHUD showInfoWithStatus:@"无数据"];
                   return;
               }

               // 创建队列组，可以使多个网络请求异步执行，执行完之后再进行操作
               dispatch_group_t group = dispatch_group_create();
               //创建全局队列
               dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
               
               dispatch_group_async(group, queue, ^{
                   // 循环上传数据
                   for (int i = 0; i <lists.count; i++) {
                       //创建dispatch_semaphore_t对象
                       dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                       DDMovieItem *model = lists[i];
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
                       [SVProgressHUD showProgress:i*1.0/num status:[NSString stringWithFormat:@"%.1f%%",i*100.0/num]];
                   }
                   [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                   [SVProgressHUD dismiss];
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       [self requestSearchWithKey:nil];
                   });
               });
       } withFailureBlock:^(NSString *errorMsg) {
           [SVProgressHUD showInfoWithStatus:@"网络错误"];
       } progress:^(float progress) {
           
       }];
}


-(void)requestSearchWithKey:(id)sender{
       if ([_db open]) {
           //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
           NSString *selectSQL = [NSString stringWithFormat:@"select * from t_dingdang_video  order by vodtimeadd DESC limit 400"];
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
               [array addObject:videoDict];
           }
           
           self.dataList = [DDListModel mj_objectArrayWithKeyValuesArray:array];
           [self.tableView reloadData];
           [_db close];
       }
}


//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    DDListModel *model = self.dataList[indexPath.row];
    cell.ddOffLineModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDListModel *model = self.dataList[indexPath.row];
    DDOffLinePlayVC *vc = [[DDOffLinePlayVC alloc]init];
    vc.vodModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
