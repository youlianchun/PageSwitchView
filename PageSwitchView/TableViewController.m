//
//  TableViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 2016/10/3.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "TableViewController.h"
//#import "PagingSwitchEmptyView.h"
@interface TableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
//    [PagingSwitchEmptyView showInPagingSwitchContentView:self.tableView];
//    [PagingSwitchEmptyView hideInPagingSwitchContentView:self.tableView];
    // Do any additional setup after loading the view.
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
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
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text=[NSString stringWithFormat:@"page: %@      %ld",self.title,(long)indexPath.row];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
