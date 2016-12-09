//
//  PageSwitchViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 2016/12/4.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "SimplePageSwitchViewController.h"
#import "PageSwitchItemViewController.h"

@interface SimplePageSwitchViewController ()<SimplePageSwitchViewDelegate, SimplePageSwitchViewDataSource>
@property (nonatomic) SimplePageSwitchView *pageSwitchView;
@end

@implementation SimplePageSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageSwitchView = [[SimplePageSwitchView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.pageSwitchView];
    self.pageSwitchView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageSwitchView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageSwitchView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.pageSwitchView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.pageSwitchView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    self.pageSwitchView.delegate = self;
    self.pageSwitchView.dataSource = self;
}

-(void)reload {
    [self.pageSwitchView reloadData];
}


- (UIView *)viewForHeaderInPageSwitchView:(SimplePageSwitchView *)pageSwitchView{
    return nil;
}

- (void)swithActon {
    
}

-(NSArray<PageSwitchItem *> *)pageSwitchItemsInPageSwitchView:(SimplePageSwitchView *)pageSwitchView {
    PageSwitchItem *item1 = [PageSwitchItemViewController pageSwitchItem];
    return @[item1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
