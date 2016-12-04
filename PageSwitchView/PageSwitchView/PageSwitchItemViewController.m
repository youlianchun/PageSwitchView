//
//  PageSwitchItemViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 2016/12/4.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "PageSwitchItemViewController.h"
#import "PageViewControllerProtocol.h"

@interface PageSwitchItemViewController ()<PageViewControllerProtocol>

@end

@implementation PageSwitchItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (PageSwitchItem*)pageSwitchItem {
    PageSwitchItem *item = [PageSwitchItem itemWithTitle:@"item" page:^(DoReturn doReturn) {
        PageSwitchItemViewController *vc = [[PageSwitchItemViewController alloc]init];
        vc.title = @"item";
        doReturn(vc, vc.view);
    }];
    return item;
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
