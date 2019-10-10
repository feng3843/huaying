//
//  UIViewController+BackItem.m
//  VRFrog
//
//  Created by chenfeiyang on 2018/6/22.
//  Copyright © 2018年 陈飞洋. All rights reserved.
//

#import "UIViewController+BackItem.h"

@implementation UIViewController (BackItem)

+(void)load{
    //使用runtime交换原来的viewDidLoad对象方法
    Method viewDidloadMethod=class_getInstanceMethod([self class], @selector(viewDidLoad));
    //使用runtime交换新加的viewDidLoadBackItem对象方法
    Method viewDidloadMethodHideBackItem=class_getInstanceMethod([self class], @selector(viewDidLoadBackItem));
    //交换两个方法的实现
    method_exchangeImplementations(viewDidloadMethod, viewDidloadMethodHideBackItem);
    
    
}

//因为交换了原来的viewDidLoad和新添加的viewDidLoadBackItem方法的实现 所以在工程里调用viewDidLoad方法的地方都会被替换成viewDidLoadBackItem的实现
- (void)viewDidLoadBackItem
{
    //因为已经交换了原来的viewDidLoad和新添加的viewDidLoadBackItem方法的实现 现在调用viewDidLoadBackItem就是调用原来的viewDidLoad
    [self viewDidLoadBackItem];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:nil];
}

@end
