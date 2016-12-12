//
//  TableViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 2016/10/3.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "TableViewController.h"
#import "RefresDataArray.h"
#import "PageViewControllerProtocol.h"
#import "MJRefresh.h"
//#import "PagingSwitchEmptyView.h"
@interface TableViewController ()<UITableViewDelegate,UITableViewDataSource,PageViewControllerProtocol,RefresDataArrayDelegate>
@property (nonatomic) RefresDataArray *dataArray;
@end

@implementation TableViewController

-(void)viewDidAdjustRect {
    self.dataArray = [RefresDataArray arrayWithRefresView:self.tableView delegate:self];
    [self.dataArray reloadDataWithAnimate:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
//    [PagingSwitchEmptyView showInPagingSwitchContentView:self.tableView];
//    [PagingSwitchEmptyView hideInPagingSwitchContentView:self.tableView];
    // Do any additional setup after loading the view.
}

-(void)loadDataInRefresView:(RefresView *)view page:(NSUInteger)page firstPage:(BOOL)firstPage res:(void (^)(NSArray *, BOOL))netRes {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *arr = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        netRes(arr,YES);
    });
}

-(RefreshSet)refreshSetWithRefresView:(RefresView *)view {
    return RefreshSetMake(NO, YES, 1, 10);
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text=[NSString stringWithFormat:@"page: %@      %ld, %ld",self.title,(long)indexPath.section,(long)indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s",__func__);
}
-(void)viewDidDisplayWhenSwitch {
    NSLog(@"shaow");
}
-(void)viewDidEndDisplayWhenSwitch {
    NSLog(@"hide");
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
