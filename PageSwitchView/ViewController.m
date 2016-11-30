//
//  ViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/13.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "ViewController.h"
#import "PageSwitchView.h"
#import "TableViewController.h"
#import "TwoScrollViewController.h"
#import "SimpleViewController.h"
#import "ScrollViewController.h"
@interface ViewController()<PageSwitchViewDelegate, PageSwitchViewDataSource, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) PageSwitchView *pageSwitchView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageSwitchView = [[PageSwitchView alloc]initWithFrame:self.view.bounds];
    self.pageSwitchView.clipsToBounds = true;
    [self.view addSubview:self.pageSwitchView];
    
    
    self.pageSwitchView.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageSwitchView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageSwitchView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.pageSwitchView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.pageSwitchView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    self.pageSwitchView.delegate = self;
    self.pageSwitchView.dataSource = self;
    [self.pageSwitchView reloadData];
    
//    __weak typeof(self) wself = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [wself.pageSwitchView switchNewPageWithNewIndex:2];
//    });
}


- (UIView *)viewForHeaderInPageSwitchView:(PageSwitchView *)pageSwitchView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 150)];
    view.backgroundColor = [UIColor redColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 100, 100)];
    lab.text = @"labsss";
    lab.textColor = [UIColor yellowColor];
    [view addSubview:lab];
    
    UISwitch *swith =[ [UISwitch alloc]init];
    swith.frame = CGRectMake(0, 120, 100, 40);
    [swith addTarget:self action:@selector(swithActon) forControlEvents:UIControlEventValueChanged];
    [view addSubview:swith];
    
    return view;
}
-(void)swithActon {
    
}

- (UIView *)pageSwitchView:(PageSwitchView *)pageSwitchView pageAtIndex:(NSUInteger)index{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.tag = 1001101;
    tableView.dataSource = self;
    [tableView reloadData];
    return tableView;

}

-(NSArray<PageSwitchItem *> *)pageSwitchItemsInPageSwitchView:(PageSwitchView *)pageSwitchView {
    PageSwitchItem *item1 = [PageSwitchItem itemWithTitle:@"1" page:^(DoReturn doReturn) {
        TwoScrollViewController *vc = [[TwoScrollViewController alloc]init];
        vc.title = @"1";
        doReturn(vc, vc.twoScrollView);
    }];
    PageSwitchItem *item2 = [PageSwitchItem itemWithTitle:@"2" page:^(DoReturn doReturn) {
        TableViewController *vc = [[TableViewController alloc]init];
        vc.title = @"2";
        doReturn(vc, vc.tableView);
    }];
    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"3" page:^(DoReturn doReturn) {
        SimpleViewController *vc = [[SimpleViewController alloc]init];
        vc.title = @"3";
        doReturn(vc, vc.view);
    }];
    PageSwitchItem *item4 = [PageSwitchItem itemWithTitle:@"4" page:^(DoReturn doReturn) {
        ScrollViewController *vc = [[ScrollViewController alloc]init];
        vc.title = @"4";
        doReturn(vc, vc.scrollView);
    }];
    PageSwitchItem *item5 = [PageSwitchItem itemWithTitle:@"5" page:^(DoReturn doReturn) {
        TableViewController *vc = [[TableViewController alloc]init];
        vc.title = @"5";
        doReturn(vc, vc.tableView);
    }];
    PageSwitchItem *item6 = [PageSwitchItem itemWithTitle:@"6" page:^(DoReturn doReturn) {
        TableViewController *vc = [[TableViewController alloc]init];
        vc.title = @"6";
        doReturn(vc, vc.tableView);
    }];
    PageSwitchItem *item7 = [PageSwitchItem itemWithTitle:@"7" page:^(DoReturn doReturn) {
        TableViewController *vc = [[TableViewController alloc]init];
        vc.title = @"7";
        doReturn(vc, vc.tableView);
    }];
    return @[item1,item2,item3,item4,item5,item6,item7];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}


//-(NSInteger)numberOfSectionsInPageSwitchView:(PageSwitchView *)pageSwitchView{
//    return 10;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

@end
