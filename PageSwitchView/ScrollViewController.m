//
//  ScrollViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/11/29.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "ScrollViewController.h"
#import "PageViewControllerProtocol.h"
@interface ScrollViewController ()<PageViewControllerProtocol>

@end

@implementation ScrollViewController

-(void)viewDidAdjustRect {
    CGSize size = self.view.bounds.size;
    size.height += size.height;
    self.scrollView.contentSize = size;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:view];
    // Do any additional setup after loading the view.
}
-(void)pageScrolling {
    NSLog(@"pageScrolling");
}
-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        CGSize size = self.view.bounds.size;
//        size.height += size.height;
        _scrollView.contentSize = size;
    }
    return _scrollView;
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
