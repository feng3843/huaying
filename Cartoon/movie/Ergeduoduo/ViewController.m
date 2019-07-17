//
//  ViewController.m
//  Cartoon
//
//  Created by hanyong on 2019/4/22.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "ViewController.h"
#import "VideoListModel.h"
#import "VideoListCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIDocumentPickerDelegate,NSURLSessionDownloadDelegate>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *listArray;

@end

@implementation ViewController{
    BOOL _flag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //http://cartoon.ergeduoduo.com/baby/cartoon.php?act=gethotlist&ps=100
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"VideoListCell" bundle:nil] forCellReuseIdentifier:@"VideoListCell"];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [FYColorTool colorFromHexRGB:@"#91A9CE" alpha:1];

    [self getVideoList];
    

}


-(void)getVideoList{
    NSString *requestUrl = @"http://cartoon.ergeduoduo.com/baby/cartoon.php";
    NSDictionary *params = @{
                             @"act":@"gethotlist",
                             @"ps":@100
                             };
    [XPNetWorkTool requestWithType:HttpRequestTypeGet withHttpHeaderFieldDict:nil withUrlString:requestUrl withParaments:params withSuccessBlock:^(NSDictionary *responseObject) {
        self.listArray = [VideoListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.tableView reloadData];
    } withFailureBlock:^(NSString *errorMsg) {

    } progress:^(float progress) {

    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoListCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"VideoListCell"];
    cell.model = _listArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 15 + (screenW - 30) * 0.625 + 24 + 15;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoListModel *model = self.listArray[indexPath.row];
    NSLog(@"%@",model.vid);

}


@end
