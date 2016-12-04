//
//  PageSwitchViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 2016/12/4.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "PageSwitchViewController.h"
#import "PageSwitchView.h"
#import "PageSwitchItemViewController.h"

@interface PageSwitchViewController ()<PageSwitchViewDelegate, PageSwitchViewDataSource>
@property (nonatomic) PageSwitchView *pageSwitchView;
@end

@implementation PageSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageSwitchView = [[PageSwitchView alloc]initWithFrame:self.view.bounds];
    self.pageSwitchView.clipsToBounds = YES;
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


- (UIView *)viewForHeaderInPageSwitchView:(PageSwitchView *)pageSwitchView{
    return nil;
}

- (void)swithActon {
    
}

-(NSArray<PageSwitchItem *> *)pageSwitchItemsInPageSwitchView:(PageSwitchView *)pageSwitchView {
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
