//
//  SubViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/2.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "SubViewController.h"


@implementation UIScrollView (gr)


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

@end


@interface SubViewController ()

@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"  返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, 300, 300)];
    scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(100, 50, 100, 100)];
    v.backgroundColor = [UIColor orangeColor];
    [scrollView addSubview:v];
    scrollView.contentSize = CGSizeMake(600, 300);
    
//    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
}
-(void)back {
    [self.navigationController popViewControllerAnimated:true];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:false animated:animated];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

