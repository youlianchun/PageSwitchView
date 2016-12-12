//
//  PageSwitchItemViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 2016/12/4.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "PageSwitchItemViewController.h"


@interface PageSwitchItemViewController ()

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

+ (PageSwitchItem*)pageSwitchItemWithTitle:(NSString*)title{
    PageSwitchItem *item = [PageSwitchItem itemWithTitle:title page:^(DoReturn doReturn) {
        PageSwitchItemViewController *vc = [[self alloc]init];
        vc.title = title;
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
