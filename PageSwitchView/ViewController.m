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
#import "NavigationBarTitleView.h"
#import "PSViewController.h"

@interface ViewController()<PageSwitchViewControllerProtocol>
@property (nonatomic) NavigationBarTitleView *titleView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"detail";
    self.navigationItem.titleView = self.titleView;
    self.titleView.titleLabel.text = self.title;
    self.titleView.titleView.backgroundColor = [UIColor orangeColor];
    
    self.maxTitleCount = 5;
    self.adaptFull_maxTitleCount = YES;
    self.titleCellSpace = YES;
    self.titleSelectedStyle = SegmentSelectedStyleBackground;
    self.titleCellSelectColor = [UIColor blueColor];
    self.selectedTitleColor = [UIColor whiteColor];
    self.headerView = [self viewForHeader];
    self.stretchingHeaderIf = YES;

    [self reload];
    
//    __weak typeof(self) wself = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [wself.pageSwitchView switchNewPageWithNewIndex:2];
//        [wself.pageSwitchView switchNewPageWithTitle:@"4"];
//    });
}

-(NavigationBarTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[NavigationBarTitleView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    }
    return _titleView;
}

- (BOOL)stretchingHeader {
    return YES;
}

//
//-(CGFloat)topeSpace {
//    return -1;
//}

- (void)headerDisplayProgress:(CGFloat)progress {
    self.titleView.labelShowRatio = progress;
}

- (UIView *)viewForHeader {
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

-(NSArray<PageSwitchItem *> *)pageSwitchItems {
    PageSwitchItem *item1 = [PageSwitchItem itemWithTitle:@"11" key:@"TwoScrollViewController.twoScrollView"];
    PageSwitchItem *item2 = [PageSwitchItem itemWithTitle:@"2" vcClsKey:@"TableViewController" viewKey:@"tableView"];
//    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"3" vcClsKey:@"SimpleViewController" viewKey:@"view"];
//    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"3" key:@"SimpleViewController."];
//    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"3" key:@"SimpleViewController.view"];
    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"333333" key:@"SimpleViewController"];
    PageSwitchItem *item4 = [PageSwitchItem itemWithTitle:@"4" vcClsKey:@"ScrollViewController" viewKey:@"scrollView"];
    PageSwitchItem *item5 = [PageSwitchItem itemWithTitle:@"55" vcClsKey:@"TableViewController" viewKey:@"tableView"];
    PageSwitchItem *item6 = [PageSwitchItem itemWithTitle:@"666" vcClsKey:@"TableViewController" viewKey:@"tableView"];
    PageSwitchItem *item7 = [PageSwitchItem itemWithTitle:@"7" page:^(DoReturn doReturn) {
        TableViewController *vc = [[TableViewController alloc]init];
        vc.title = @"7";
        doReturn(vc, vc.tableView);
    }];
    return @[item1,item2,item3,item4,item5,item6,item7];
}




@end
