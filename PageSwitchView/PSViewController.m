//
//  ViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/13.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "PSViewController.h"
#import "PSTableViewController.h"

@interface PSViewController()<PageSwitchViewDelegate, PageSwitchViewDataSource,PageViewControllerProtocol,RefresBoleDataArrayDelegate>
@property (nonatomic) RefresBoleDataArray *dataArray;

@end

@implementation PSViewController

-(void)viewDidAdjustRect {
    self.pageSwitchView.delegate = self;
    self.pageSwitchView.dataSource = self;
    [self.pageSwitchView reloadData];
    self.dataArray = [RefresBoleDataArray arrayWithRefresView:self.pageSwitchView.tableView delegate:self];
}

-(void)loadDataInRefresView:(RefresView *)view res:(void (^)(NSArray *, BOOL))netRes {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        netRes(nil,YES);
    });
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


-(CGFloat)topeSpaceInPageSwitchView:(PageSwitchView *)pageSwitchView {
    return -1;
}

-(void)swithActon {
    
}

-(NSArray<PageSwitchItem *> *)pageSwitchItemsInPageSwitchView:(PageSwitchView *)pageSwitchView {
    PageSwitchItem *item1 = [PageSwitchItem itemWithTitle:@"1" vcClsKey:@"PSTableViewController" viewKey:@"tableView"];
    PageSwitchItem *item2 = [PageSwitchItem itemWithTitle:@"2" vcClsKey:@"PSTableViewController" viewKey:@"tableView"];
    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"3" vcClsKey:@"PSTableViewController" viewKey:@"tableView"];
    PageSwitchItem *item4 = [PageSwitchItem itemWithTitle:@"4" vcClsKey:@"PSTableViewController" viewKey:@"tableView"];
    return @[item1,item2,item3,item4];
}



- (void)pageSwitchView:(PageSwitchView *)pageSwitchView cellContentView:(UIContentView*)contentView atIndexPath:(NSIndexPath*)indexPath isReuse:(BOOL)isReuse {
    if (indexPath.row == 0) {
        contentView.backgroundColor = [UIColor redColor];
    }else{
        contentView.backgroundColor = [UIColor orangeColor];
    }
}

-(NSUInteger)numberOfSectionsInTableView:(PageSwitchView *)tableView {
    return 1;
}

-(NSUInteger)pageSwitchView:(PageSwitchView *)pageSwitchView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UIView *)pageSwitchView:(PageSwitchView *)pageSwitchView viewForHeaderInSection:(NSInteger)section {
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
    lab.text = @"搜索";
    lab.backgroundColor = [UIColor lightGrayColor];
    return lab;
}

-(CGFloat)pageSwitchView:(PageSwitchView *)pageSwitchView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

-(CGFloat)pageSwitchView:(PageSwitchView *)pageSwitchView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


@end
