//
//  TwoScrollViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/21.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "TwoScrollViewController.h"
@interface TwoScrollViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TwoScrollViewController

-(TwoScrollView *)twoScrollView {
    if (!_twoScrollView) {
        UITableView *lTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        lTableView.dataSource = self;
        lTableView.delegate = self;
        UITableView *rTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        rTableView.dataSource = self;
        rTableView.delegate = self;
        _twoScrollView = [[TwoScrollView alloc]initWithFrame:self.view.bounds scrollView_l:lTableView scrollView_r:rTableView];
    }
    return _twoScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = @"";
    if (tableView == self.twoScrollView.scrollView_l) {
        title = [NSString stringWithFormat:@"l_page: %@      %ld",self.title,(long)indexPath.row];
    }
    if (tableView == self.twoScrollView.scrollView_r) {
        title = [NSString stringWithFormat:@"r_page: %@      %ld",self.title,(long)indexPath.row];
    }
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text=title;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s",__func__);
}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}
//
///*删除用到的函数*/
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // 删除
//        NSLog(@"侧滑菜单事件");
//
//    }
//}

@end
