//
//  ViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/13.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "PSViewController.h"
#import "PSTableViewController.h"
static const CGFloat firstBarHeight = 49;
@interface PSViewController()<PageSwitchViewDelegate, PageSwitchViewDataSource,PageViewControllerProtocol,RefresBoleDataArrayDelegate>
@property (nonatomic) RefresBoleDataArray *dataArray;


@end

@implementation PSViewController

-(void)viewDidAdjustRect {
    self.pageSwitchView.delegate = self;
    self.pageSwitchView.dataSource = self;
    [self.pageSwitchView reloadData];
    self.dataArray = [RefresBoleDataArray arrayWithRefresView:self.pageSwitchView.tableView delegate:self];
    self.dataArray.ignoredScrollViewContentInsetTop = -firstBarHeight;//第一个tatileBar不选停需要设置参数
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
        _pageSwitchView.titleFont = [UIFont systemFontOfSize:14];
        _pageSwitchView.maxTitleCount = 5;
        _pageSwitchView.adaptFull_maxTitleCount = YES;
//        _pageSwitchView.titleCellSpace = YES;
        _pageSwitchView.titleSelectedStyle = SegmentSelectedStyleUnderline;
        _pageSwitchView.selectedTitleColor = [UIColor blueColor];
        _pageSwitchView.titleCellSelectColor = [UIColor blueColor];

    }
    return _pageSwitchView;
}

-(CGFloat)topeSpaceInPageSwitchView:(PageSwitchView *)pageSwitchView {
    return 0;
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
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 44+firstBarHeight)];//第一个tatileBar不选停需要设置参数
    view.backgroundColor = [UIColor clearColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    lab.text = @"搜索";
    lab.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lab];
    [self addConstraint:lab inserts:UIEdgeInsetsMake(firstBarHeight, 0, 0, 0)];
    return view;
}

-(CGFloat)pageSwitchView:(PageSwitchView *)pageSwitchView heightForHeaderInSection:(NSInteger)section {
    return 44+firstBarHeight;
}

-(CGFloat)pageSwitchView:(PageSwitchView *)pageSwitchView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)addConstraint:(UIView*)view inserts:(UIEdgeInsets)inserts {
    UIView *superview = view.superview;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1 constant:inserts.left]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1 constant:inserts.right]];
    [superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1 constant:inserts.top]];
    [superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1 constant:inserts.bottom]];
}


@end
