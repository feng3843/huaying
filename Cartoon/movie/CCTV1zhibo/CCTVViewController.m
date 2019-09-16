//
//  CCTVViewController.m
//  Cartoon
//
//  Created by zxh on 2019/8/29.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "CCTVViewController.h"
#import "HomeCell.h"
#import "CCTVListVC.h"
#import "ZRFXViewController.h"
#import "TFhpple/TFHpple.h"

@interface CCTVViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSArray *titleArray;
@property (nonatomic , strong) UITableView *tableView;
@end

@implementation CCTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = @[@"动物世界",@"人与自然",@"自然发现",@"朝闻天下"];
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
    [table registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:@"HomeCell"];
    [self.view addSubview:table];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//    [self getZMZVideoBaiduPanInfo];
//    [self get720DownLoadInfo];
//    [self get1080DownLoadInfo];
}





//-(void)getallZMZ{
//    NSMutableArray *results = [NSMutableArray array];
//    NSString *baseUrl = @"https://www.newzmz.com/index.html";
//    NSURL *itemUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",baseUrl]];
//    NSData *htmlData = [NSData dataWithContentsOfURL:itemUrl];
//    TFHpple *itemhpp = [TFHpple hppleWithHTMLData:htmlData];
//    NSArray *array = [itemhpp searchWithXPathQuery:@"//div[@class='rowMod']"];
//    for (TFHppleElement *el in array) {
//        NSMutableArray *items = [NSMutableArray array];
//        TFHppleElement *titleEl = [el firstChildWithClassName:@"rowTitle"];
//        NSString *sectionT = [[titleEl firstChildWithClassName:@"row-header-title"] text];
//        sectionT =  sectionT.length > 0 ? sectionT : @"";
//
//        NSArray *array2 = [el searchWithXPathQuery:@"//li"];
//
//        for (TFHppleElement *el in array2) {
//
//            NSString *name = @"";
//            NSString *imgUrl = @"";
//            NSString *pageHref = @"";
//            //li第一个a标签
//            TFHppleElement *a_EL = [el firstChildWithTagName:@"a"];
//            NSDictionary *a_dict = [a_EL attributes];
//            pageHref = a_dict[@"href"];
//            //a_EL内第一个div容器
//
//            TFHppleElement *name_EL = [[el searchWithXPathQuery:@"//div[@class='caption-name']"] firstObject];
//            name = [name_EL text];
//            TFHppleElement *name_ENG_EL = [[el searchWithXPathQuery:@"//div[@class='caption-eng']"] firstObject];
//            NSString *name_en = [name_ENG_EL text];
//            //tupian
//            TFHppleElement *img_EL = [a_EL firstChildWithTagName:@"img"];
//            NSDictionary *img_EL_dict = [img_EL attributes];
//            imgUrl = img_EL_dict[@"src"];
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            dict[@"name"] = name;
//            dict[@"imgUrl"] = imgUrl;
//            dict[@"pageHref"] = pageHref?[NSString stringWithFormat:@"https://www.newzmz.com/%@",pageHref]:@"";
//            dict[@"name_en"] = name_en;
//            dict[@"playerList"] = [self getVidUrl:dict[@"pageHref"]];
//            [items addObject:dict];
//        }
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[@"title"] = sectionT?sectionT:@"";
//        dict[@"list"] = items;
//        [results addObject:dict];
//    }
//
//    NSString *jsonString = nil;
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:results
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&error];
//    if (!jsonData) {
//        NSLog(@"Got an error: %@", error);
//    } else {
//        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    }
//
//    [jsonString writeToFile: @"/Users/mac/Desktop/zmz/1.json" atomically:YES encoding:NSUTF8StringEncoding error:nil];
//
//
//}
//
//
//
//-(NSArray *)getVidUrl:(NSString *)href{
//    NSMutableArray *results = [NSMutableArray array];
//    NSURL *itemUrl = [NSURL URLWithString:href];
//    NSData *htmlData = [NSData dataWithContentsOfURL:itemUrl];
//    TFHpple *itemhpp = [TFHpple hppleWithHTMLData:htmlData];
//    NSArray *array = [itemhpp searchWithXPathQuery:@"//div[@class='epmetas']//li//button[@class='btn btn-default epd-btn']"];
//    if (array.count > 0) {
//        for (TFHppleElement *el in array) {
//            NSString *pid = [el objectForKey:@"data-pid"];
//            NSString *version = [el objectForKey:@"data-vers"];
//            NSString *baidupan = [el objectForKey:@"data-link1"];
//            NSString *baidupwd = [el objectForKey:@"data-link2"];
//            NSString *magnet_720 = [el objectForKey:@"data-link3"];
//            NSString *magnet_1080 = [el objectForKey:@"data-link4"];
//            NSMutableDictionary *item = [NSMutableDictionary dictionary];
//            item[@"name"] = pid;
//            item[@"type"] = version;
//            item[@"pan"] = baidupan?baidupan:@"无";
//            item[@"pwd"] = baidupwd?baidupwd:@"无";
//            item[@"720P"] = magnet_720?magnet_720:@"无";
//            item[@"1080P"] = magnet_1080?magnet_1080:@"无";
//            [results addObject:item];
//        }
//    }else{
//        TFHppleElement *ul = [[itemhpp searchWithXPathQuery:@"//div[@class='epmetas']//ul[@class='epslist']"] firstObject];
//        NSArray *array = [ul searchWithXPathQuery:@"//a[@class='btn btn-default epd-btn']"];
//        if (array.count > 0) {
//            NSMutableDictionary *item = [NSMutableDictionary dictionary];
//            for (TFHppleElement *el in array) {
//                NSString *name = [el content];
//                NSString *href = [el objectForKey:@"href"];
//                if (name) {
//                    item[name] = href;
//                }
//            }
//            TFHppleElement *pwd = [[ul searchWithXPathQuery:@"/button[@class='btn btn-default epd-btn cbact']"] firstObject];
//            item[@"pwd"] = [pwd content]?[pwd content]:@"无";
//            [results addObject:item];
//        }else{
//            NSLog(@"%@ 无内容",href);
//        }
//
//    }
//
//    return results;
//}
//





-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    cell.textL.text = self.titleArray[indexPath.row];
    cell.backgroundColor = [UIColor blackColor];
    cell.textL.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    switch (indexPath.row) {
        default:
            cell.imgV.image = [UIImage imageNamed:@"电台"];
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *href = @"zhaowentianxia";
    switch (indexPath.row) {
        case 0:{
            href = @"dongwushijie";
            break;
        }
        case 1:{
            href = @"renyuziran";
            break;
        }
        case 2:{
            ZRFXViewController *vc = [ZRFXViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            return;
            break;
        }
        case 3:{
            href = @"zhaowentianxia";
            break;
        }
        default:
            break;
    }
    CCTVListVC *vc = [CCTVListVC new];
    vc.href = href;
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


-(void)getZMZVideoBaiduPanInfo{
    NSMutableArray *results = [NSMutableArray array];
    NSString *baseUrl = @"https://www.newzmz.com/index.html";
    NSURL *itemUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",baseUrl]];
    NSData *htmlData = [NSData dataWithContentsOfURL:itemUrl];
    TFHpple *itemhpp = [TFHpple hppleWithHTMLData:htmlData];
    NSArray *array = [itemhpp searchWithXPathQuery:@"//div[@class='rowMod']"];
    for (TFHppleElement *el in array) {
        NSMutableArray *items = [NSMutableArray array];
        TFHppleElement *titleEl = [el firstChildWithClassName:@"rowTitle"];
        NSString *sectionT = [[titleEl firstChildWithClassName:@"row-header-title"] text];
        sectionT =  sectionT.length > 0 ? sectionT : @"";
        
        NSArray *array2 = [el searchWithXPathQuery:@"//li"];
        
        for (TFHppleElement *el in array2) {
            
            NSString *name = @"";
            NSString *imgUrl = @"";
            NSString *pageHref = @"";
            //li第一个a标签
            TFHppleElement *a_EL = [el firstChildWithTagName:@"a"];
            NSDictionary *a_dict = [a_EL attributes];
            pageHref = a_dict[@"href"];
            //a_EL内第一个div容器
            
            TFHppleElement *name_EL = [[el searchWithXPathQuery:@"//div[@class='caption-name']"] firstObject];
            name = [name_EL text];
            TFHppleElement *name_ENG_EL = [[el searchWithXPathQuery:@"//div[@class='caption-eng']"] firstObject];
            NSString *name_en = [name_ENG_EL text];
            //tupian
            TFHppleElement *img_EL = [a_EL firstChildWithTagName:@"img"];
            NSDictionary *img_EL_dict = [img_EL attributes];
            imgUrl = img_EL_dict[@"src"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"name"] = name;
            //            dict[@"imgUrl"] = imgUrl;
            //            dict[@"pageHref"] = pageHref?[NSString stringWithFormat:@"https://www.newzmz.com/%@",pageHref]:@"";
            //            dict[@"name_en"] = name_en;
            dict[@"playerList"] = [self getVidBaiduPanUrl:[NSString stringWithFormat:@"https://www.newzmz.com/%@",pageHref]];
            [items addObject:dict];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"title"] = sectionT?sectionT:@"";
        dict[@"list"] = items;
        [results addObject:dict];
    }
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:results
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    [jsonString writeToFile: @"/Users/mac/Desktop/zmz/1.json" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
}



-(NSArray *)getVidBaiduPanUrl:(NSString *)href{
    NSMutableArray *results = [NSMutableArray array];
    NSURL *itemUrl = [NSURL URLWithString:href];
    NSData *htmlData = [NSData dataWithContentsOfURL:itemUrl];
    TFHpple *itemhpp = [TFHpple hppleWithHTMLData:htmlData];
    NSArray *array = [itemhpp searchWithXPathQuery:@"//div[@class='epmetas']//li//button[@class='btn btn-default epd-btn']"];
    if (array.count > 0) {
        for (TFHppleElement *el in array) {
            NSString *pid = [el objectForKey:@"data-pid"];
            //            NSString *version = [el objectForKey:@"data-vers"];
            NSString *baidupan = [el objectForKey:@"data-link1"];
            NSString *baidupwd = [el objectForKey:@"data-link2"];
            //            NSString *magnet_720 = [el objectForKey:@"data-link3"];
            //            NSString *magnet_1080 = [el objectForKey:@"data-link4"];
            NSMutableDictionary *item = [NSMutableDictionary dictionary];
            item[@"name"] = pid;
            //            item[@"type"] = version;
            item[@"pan"] = baidupan?baidupan:@"无";
            item[@"pwd"] = baidupwd?baidupwd:@"无";
            //            item[@"720P"] = magnet_720?magnet_720:@"无";
            //            item[@"1080P"] = magnet_1080?magnet_1080:@"无";
            [results addObject:item];
        }
    }else{
        TFHppleElement *ul = [[itemhpp searchWithXPathQuery:@"//div[@class='epmetas']//ul[@class='epslist']"] firstObject];
        NSArray *array = [ul searchWithXPathQuery:@"//a[@class='btn btn-default epd-btn']"];
        if (array.count > 0) {
            NSMutableDictionary *item = [NSMutableDictionary dictionary];
            TFHppleElement *el = [array firstObject];
            NSString *name = [el content];
            NSString *href = [el objectForKey:@"href"];
            if (name) {
                item[name] = href;
            }
            TFHppleElement *pwd = [[ul searchWithXPathQuery:@"//button[@class='btn btn-default epd-btn cbact']"] firstObject];
            item[@"pwd"] = [pwd objectForKey:@"data-clipboard-text"];
            [results addObject:item];
        }else{
            NSLog(@"%@ 无内容",href);
        }
        
    }
    
    return results;
}

-(void)get720DownLoadInfo{
    NSMutableArray *results = [NSMutableArray array];
    NSString *baseUrl = @"https://www.newzmz.com/index.html";
    NSURL *itemUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",baseUrl]];
    NSData *htmlData = [NSData dataWithContentsOfURL:itemUrl];
    TFHpple *itemhpp = [TFHpple hppleWithHTMLData:htmlData];
    NSArray *array = [itemhpp searchWithXPathQuery:@"//div[@class='rowMod']"];
    for (TFHppleElement *el in array) {
        NSMutableArray *items = [NSMutableArray array];
        TFHppleElement *titleEl = [el firstChildWithClassName:@"rowTitle"];
        NSString *sectionT = [[titleEl firstChildWithClassName:@"row-header-title"] text];
        sectionT =  sectionT.length > 0 ? sectionT : @"";
        
        NSArray *array2 = [el searchWithXPathQuery:@"//li"];
        
        for (TFHppleElement *el in array2) {
            
            NSString *name = @"";
            NSString *imgUrl = @"";
            NSString *pageHref = @"";
            //li第一个a标签
            TFHppleElement *a_EL = [el firstChildWithTagName:@"a"];
            NSDictionary *a_dict = [a_EL attributes];
            pageHref = a_dict[@"href"];
            //a_EL内第一个div容器
            
            TFHppleElement *name_EL = [[el searchWithXPathQuery:@"//div[@class='caption-name']"] firstObject];
            name = [name_EL text];
            TFHppleElement *name_ENG_EL = [[el searchWithXPathQuery:@"//div[@class='caption-eng']"] firstObject];
            NSString *name_en = [name_ENG_EL text];
            //tupian
            TFHppleElement *img_EL = [a_EL firstChildWithTagName:@"img"];
            NSDictionary *img_EL_dict = [img_EL attributes];
            imgUrl = img_EL_dict[@"src"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"name"] = name;
            dict[@"playerList"] = [self getVid720Url:[NSString stringWithFormat:@"https://www.newzmz.com/%@",pageHref]];
            [items addObject:dict];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"title"] = sectionT?sectionT:@"";
        dict[@"list"] = items;
        [results addObject:dict];
    }
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:results
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    [jsonString writeToFile: @"/Users/mac/Desktop/zmz/720.json" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
}



-(NSArray *)getVid720Url:(NSString *)href{
    NSMutableArray *results = [NSMutableArray array];
    NSURL *itemUrl = [NSURL URLWithString:href];
    NSData *htmlData = [NSData dataWithContentsOfURL:itemUrl];
    TFHpple *itemhpp = [TFHpple hppleWithHTMLData:htmlData];
    NSArray *array = [itemhpp searchWithXPathQuery:@"//div[@class='epmetas']//li//button[@class='btn btn-default epd-btn']"];
    if (array.count > 0) {
        for (TFHppleElement *el in array) {
            NSString *pid = [el objectForKey:@"data-pid"];
            //            NSString *version = [el objectForKey:@"data-vers"];
            //            NSString *baidupan = [el objectForKey:@"data-link1"];
            //            NSString *baidupwd = [el objectForKey:@"data-link2"];
            NSString *magnet_720 = [el objectForKey:@"data-link3"];
            //            NSString *magnet_1080 = [el objectForKey:@"data-link4"];
            NSMutableDictionary *item = [NSMutableDictionary dictionary];
            item[@"name"] = pid;
            //            item[@"type"] = version;
            //            item[@"pan"] = baidupan?baidupan:@"无";
            //            item[@"pwd"] = baidupwd?baidupwd:@"无";
            item[@"720P"] = magnet_720?magnet_720:@"无";
            //            item[@"1080P"] = magnet_1080?magnet_1080:@"无";
            [results addObject:item];
        }
    }else{
        TFHppleElement *ul = [[itemhpp searchWithXPathQuery:@"//div[@class='epmetas']//ul[@class='epslist']"] firstObject];
        NSArray *array = [ul searchWithXPathQuery:@"//a[@class='btn btn-default epd-btn']"];
        if (array.count >= 3) {
            NSMutableDictionary *item = [NSMutableDictionary dictionary];
            TFHppleElement *el = array[2];
            NSString *name = [el content];
            NSString *href = [el objectForKey:@"href"];
            if (name) {
                item[name] = href;
            }
            TFHppleElement *pwd = [[ul searchWithXPathQuery:@"//button[@class='btn btn-default epd-btn cbact']"] firstObject];
            item[@"pwd"] = [pwd objectForKey:@"data-clipboard-text"];
            [results addObject:item];
        }else{
            NSLog(@"%@ 无内容",href);
        }
        
    }
    
    return results;
}


-(void)get1080DownLoadInfo{
    NSMutableArray *results = [NSMutableArray array];
    NSString *baseUrl = @"https://www.newzmz.com/index.html";
    NSURL *itemUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",baseUrl]];
    NSData *htmlData = [NSData dataWithContentsOfURL:itemUrl];
    TFHpple *itemhpp = [TFHpple hppleWithHTMLData:htmlData];
    NSArray *array = [itemhpp searchWithXPathQuery:@"//div[@class='rowMod']"];
    for (TFHppleElement *el in array) {
        NSMutableArray *items = [NSMutableArray array];
        TFHppleElement *titleEl = [el firstChildWithClassName:@"rowTitle"];
        NSString *sectionT = [[titleEl firstChildWithClassName:@"row-header-title"] text];
        sectionT =  sectionT.length > 0 ? sectionT : @"";
        
        NSArray *array2 = [el searchWithXPathQuery:@"//li"];
        
        for (TFHppleElement *el in array2) {
            
            NSString *name = @"";
            NSString *imgUrl = @"";
            NSString *pageHref = @"";
            //li第一个a标签
            TFHppleElement *a_EL = [el firstChildWithTagName:@"a"];
            NSDictionary *a_dict = [a_EL attributes];
            pageHref = a_dict[@"href"];
            //a_EL内第一个div容器
            
            TFHppleElement *name_EL = [[el searchWithXPathQuery:@"//div[@class='caption-name']"] firstObject];
            name = [name_EL text];
            TFHppleElement *name_ENG_EL = [[el searchWithXPathQuery:@"//div[@class='caption-eng']"] firstObject];
            NSString *name_en = [name_ENG_EL text];
            //tupian
            TFHppleElement *img_EL = [a_EL firstChildWithTagName:@"img"];
            NSDictionary *img_EL_dict = [img_EL attributes];
            imgUrl = img_EL_dict[@"src"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"name"] = name;
            dict[@"playerList"] = [self getVid1080Url:[NSString stringWithFormat:@"https://www.newzmz.com/%@",pageHref]];
            [items addObject:dict];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"title"] = sectionT?sectionT:@"";
        dict[@"list"] = items;
        [results addObject:dict];
    }
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:results
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    [jsonString writeToFile: @"/Users/mac/Desktop/zmz/1080.json" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
}



-(NSArray *)getVid1080Url:(NSString *)href{
    NSMutableArray *results = [NSMutableArray array];
    NSURL *itemUrl = [NSURL URLWithString:href];
    NSData *htmlData = [NSData dataWithContentsOfURL:itemUrl];
    TFHpple *itemhpp = [TFHpple hppleWithHTMLData:htmlData];
    NSArray *array = [itemhpp searchWithXPathQuery:@"//div[@class='epmetas']//li//button[@class='btn btn-default epd-btn']"];
    if (array.count > 0) {
        for (TFHppleElement *el in array) {
            NSString *pid = [el objectForKey:@"data-pid"];
            //            NSString *version = [el objectForKey:@"data-vers"];
            //            NSString *baidupan = [el objectForKey:@"data-link1"];
            //            NSString *baidupwd = [el objectForKey:@"data-link2"];
            NSString *magnet_720 = [el objectForKey:@"data-link3"];
            NSString *magnet_1080 = [el objectForKey:@"data-link4"];
            NSMutableDictionary *item = [NSMutableDictionary dictionary];
            item[@"name"] = pid;
            //            item[@"type"] = version;
            //            item[@"pan"] = baidupan?baidupan:@"无";
            //            item[@"pwd"] = baidupwd?baidupwd:@"无";
            item[@"1080P"] = magnet_1080.length > 3?magnet_1080:(magnet_720?magnet_720:@"无");
            //            item[@"720P"] = magnet_720?magnet_720:@"无";
            [results addObject:item];
        }
    }else{
        TFHppleElement *ul = [[itemhpp searchWithXPathQuery:@"//div[@class='epmetas']//ul[@class='epslist']"] firstObject];
        NSArray *array = [ul searchWithXPathQuery:@"//a[@class='btn btn-default epd-btn']"];
        if (array.count >= 3) {
            NSMutableDictionary *item = [NSMutableDictionary dictionary];
            TFHppleElement *el = [array lastObject];
            NSString *name = [el content];
            NSString *href = [el objectForKey:@"href"];
            if (name) {
                item[name] = href;
            }
            TFHppleElement *pwd = [[ul searchWithXPathQuery:@"//button[@class='btn btn-default epd-btn cbact']"] firstObject];
            item[@"pwd"] = [pwd objectForKey:@"data-clipboard-text"];
            [results addObject:item];
        }else{
            NSLog(@"%@ 无内容",href);
        }
        
    }
    
    return results;
}



@end
