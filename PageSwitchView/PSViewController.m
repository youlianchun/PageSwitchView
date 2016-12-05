//
//  ViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/13.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "PSViewController.h"
#import "TableViewController.h"
#import "TwoScrollViewController.h"
#import "SimpleViewController.h"
#import "ScrollViewController.h"
#import "NavigationBarTitleView.h"

@interface PSViewController()<PageSwitchViewDelegate, PageSwitchViewDataSource,PageViewControllerProtocol>

@property (nonatomic) NavigationBarTitleView *titleView;
@end

@implementation PSViewController

-(void)viewDidAdjustRect {
    self.pageSwitchView.delegate = self;
    self.pageSwitchView.dataSource = self;
    [self.pageSwitchView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    

}
-(PageSwitchView *)pageSwitchView {
    if (!_pageSwitchView) {
        _pageSwitchView = [[PageSwitchView alloc]initWithFrame:self.view.bounds];
    }
    return _pageSwitchView;
}

-(NavigationBarTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[NavigationBarTitleView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    }
    return _titleView;
}

- (void)pageSwitchView:(PageSwitchView *)pageSwitchView headerDisplayProgress:(CGFloat)progress {
    self.titleView.labelShowRatio = progress;
}

- (UIView *)viewForHeaderInPageSwitchView:(PageSwitchView *)pageSwitchView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 150)];
    view.backgroundColor = [UIColor redColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 100, 100)];
    lab.text = @"labsss";
    lab.textColor = [UIColor yellowColor];
    [view addSubview:lab];
    
    UISwitch *swith =[ [UISwitch alloc]init];
    swith.frame = CGRectMake(0, 110, 100, 40);
    [swith addTarget:self action:@selector(swithActon) forControlEvents:UIControlEventValueChanged];
    [view addSubview:swith];
    
    return view;
}

-(void)swithActon {
    
}

-(NSArray<PageSwitchItem *> *)pageSwitchItemsInPageSwitchView:(PageSwitchView *)pageSwitchView {
    //    PageSwitchItem *item1 = [PageSwitchItem itemWithTitle:@"1" page:^(DoReturn doReturn) {
    //        TwoScrollViewController *vc = [[TwoScrollViewController alloc]init];
    //        vc.title = @"1";
    //        doReturn(vc, vc.twoScrollView);
    //    }];
    //    PageSwitchItem *item2 = [PageSwitchItem itemWithTitle:@"2" page:^(DoReturn doReturn) {
    //        TableViewController *vc = [[TableViewController alloc]init];
    //        vc.title = @"2";
    //        doReturn(vc, vc.tableView);
    //    }];
    //    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"3" page:^(DoReturn doReturn) {
    //        SimpleViewController *vc = [[SimpleViewController alloc]init];
    //        vc.title = @"3";
    //        doReturn(vc, vc.view);
    //    }];
    //    PageSwitchItem *item4 = [PageSwitchItem itemWithTitle:@"4" page:^(DoReturn doReturn) {
    //        ScrollViewController *vc = [[ScrollViewController alloc]init];
    //        vc.title = @"4";
    //        doReturn(vc, vc.scrollView);
    //    }];
    //    PageSwitchItem *item5 = [PageSwitchItem itemWithTitle:@"5" page:^(DoReturn doReturn) {
    //        TableViewController *vc = [[TableViewController alloc]init];
    //        vc.title = @"5";
    //        doReturn(vc, vc.tableView);
    //    }];
    //    PageSwitchItem *item6 = [PageSwitchItem itemWithTitle:@"6" page:^(DoReturn doReturn) {
    //        TableViewController *vc = [[TableViewController alloc]init];
    //        vc.title = @"6";
    //        doReturn(vc, vc.tableView);
    //    }];
    //    PageSwitchItem *item7 = [PageSwitchItem itemWithTitle:@"7" page:^(DoReturn doReturn) {
    //        TableViewController *vc = [[TableViewController alloc]init];
    //        vc.title = @"7";
    //        doReturn(vc, vc.tableView);
    //    }];
    
    
    PageSwitchItem *item1 = [PageSwitchItem itemWithTitle:@"1" key:@"TwoScrollViewController.twoScrollView"];
    PageSwitchItem *item2 = [PageSwitchItem itemWithTitle:@"2" vcClsKey:@"TableViewController" viewKey:@"tableView"];
    //    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"3" vcClsKey:@"SimpleViewController" viewKey:@"view"];
    //    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"1" key:@"SimpleViewController."];
    //    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"1" key:@"SimpleViewController.view"];
    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"1" key:@"SimpleViewController"];
    PageSwitchItem *item4 = [PageSwitchItem itemWithTitle:@"4" vcClsKey:@"ScrollViewController" viewKey:@"scrollView"];
    PageSwitchItem *item5 = [PageSwitchItem itemWithTitle:@"5" vcClsKey:@"ViewController" viewKey:@"pageSwitchView"];
    PageSwitchItem *item6 = [PageSwitchItem itemWithTitle:@"6" vcClsKey:@"TableViewController" viewKey:@"tableView"];
    PageSwitchItem *item7 = [PageSwitchItem itemWithTitle:@"7" vcClsKey:@"TableViewController" viewKey:@"tableView"];
    return @[item1,item2,item3,item4,item5,item6,item7];
}




@end
