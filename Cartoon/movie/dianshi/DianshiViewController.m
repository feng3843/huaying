//
//  DianshiViewController.m
//  Cartoon
//
//  Created by zxh on 2019/8/20.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "DianshiViewController.h"
#import "DSPlayViewController.h"
#import "TestMp3ViewController.h"

@interface DianshiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *playList;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *nameList;
@end

@implementation DianshiViewController

-(void)copyNewPlayList{
    
       NSString *path = [[NSBundle mainBundle] pathForResource:@"tv2.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *array = [str componentsSeparatedByString:@"\n"];
        self.playList = [NSMutableArray array];
        self.nameList = [NSMutableArray array];
        for (NSString *str in array) {
           NSArray *mods = [str componentsSeparatedByString:@","];
           [self.nameList addObject: [mods firstObject]];
    //       [self.playList addObject:[mods lastObject]];
        }
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"beiyong.json" ofType:nil];
          NSData *data1 = [NSData dataWithContentsOfFile:path1];
          NSString *str1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
          NSArray *array1 = [str1 componentsSeparatedByString:@"\n"];

          NSMutableDictionary *dict = @{}.mutableCopy;
          for (NSString *str in array1) {
             NSArray *mods = [str componentsSeparatedByString:@","];
              [dict setValue:[mods lastObject] forKey:[mods firstObject]];
          }
       
       
       for (NSString *str in self.nameList) {
           NSString *play = dict[str] ? dict[str] : @"..." ;
           [self.playList addObject:play];
       }
       
       NSMutableString *lastStr = [NSMutableString string];
       for (int i = 0 ; i < self.nameList.count ; i ++) {
           NSString *name = self.nameList[i];
           [lastStr appendString:[NSString stringWithFormat:@"%@,%@\n",name,self.playList[i] ]];
       }
       [lastStr writeToFile:@"/Users/mac/Desktop/1111/1.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
       
}

-(void)initPlayList{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tv2.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    self.playList = [NSMutableArray array];
    self.nameList = [NSMutableArray array];
    for (NSString *str in array) {
       NSArray *mods = [str componentsSeparatedByString:@","];
       [self.nameList addObject: [mods firstObject]];
       [self.playList addObject:[mods lastObject]];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPlayList];
    //从beifen.json替换新源
//    [self copyNewPlayList];

    
    self.view.backgroundColor = [UIColor blackColor];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0,88, screenW, screenH - 88 - 34) style:UITableViewStylePlain];
    self.tableView = table;
    table.tableFooterView = [UIView new];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.estimatedRowHeight = 220;
    table.rowHeight = UITableViewAutomaticDimension;
    table.backgroundColor = [UIColor blackColor];
    table.tableFooterView = [UIView new];
    [self.view addSubview:table];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nameList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = self.nameList[indexPath.row];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *url = self.playList[indexPath.row];
    NSString *name = self.nameList[indexPath.row];
    if ([url isEqualToString:name]) {
        return 30;
    }
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *url = self.playList[indexPath.row];
    NSString *name = self.nameList[indexPath.row];
    if ([url isEqualToString:name]) {
        return;
    }
    DSPlayViewController *vc = [DSPlayViewController new];
    vc.playUrl = url;
    vc.name = name;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
