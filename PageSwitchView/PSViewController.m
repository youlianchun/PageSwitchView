//
//  ViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/13.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "PSViewController.h"
#import "PSTableViewController.h"
#import "SearchView.h"
static const CGFloat firstBarHeight = 49;
static const CGFloat searchBarHeight = 44;
@interface PSViewController()<PageSwitchViewControllerProtocol,RefresBoleDataArrayDelegate>
@property (nonatomic) RefresBoleDataArray *dataArray;
@property (nonatomic) SearchView *searchView;

@end

@implementation PSViewController

-(void)viewDidAdjustRect {
     [self reload];
}

-(void)loadDataInRefresView:(RefresView *)view res:(void (^)(NSArray *, BOOL))netRes {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        netRes(nil,YES);
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [RefresBoleDataArray arrayWithRefresView:self.pageSwitchView.tableView delegate:self];
    self.dataArray.ignoredScrollViewContentInsetTop = -firstBarHeight;//第一个tatileBar不选停需要设置参数
    self.maxTitleCount = 5;
    self.adaptFull_maxTitleCount = YES;
    self.titleCellSpace = YES;
    self.titleSelectedStyle = SegmentSelectedStyleUnderline;
    self.titleCellSelectColor = [UIColor blueColor];
    self.selectedTitleColor = [UIColor blueColor];
   
    
    [self.view addSubview:self.searchView];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    lab.text = @"搜索";
    lab.backgroundColor = [UIColor lightGrayColor];
    [self.searchView.animateView addSubview:lab];
    [self addConstraint:lab inserts:UIEdgeInsetsMake(0, 0, 0, 0)];
}

-(SearchView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchView alloc]init];
        [self.view addSubview:_searchView];
        _searchView.translatesAutoresizingMaskIntoConstraints = NO;
        UIView *view = _searchView;
        UIView *superview = view.superview;
        [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1 constant:firstBarHeight]];
        [view addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:searchBarHeight]];
    }
    return _searchView;
}
-(CGFloat)topeSpace{
    return 0;
}


-(NSArray<PageSwitchItem *> *)pageSwitchItems{
    return @[];
    PageSwitchItem *item1 = [PageSwitchItem itemWithTitle:@"1" vcClsKey:@"PSTableViewController" viewKey:@"tableView"];
    PageSwitchItem *item2 = [PageSwitchItem itemWithTitle:@"2" vcClsKey:@"PSTableViewController" viewKey:@"tableView"];
    PageSwitchItem *item3 = [PageSwitchItem itemWithTitle:@"3" vcClsKey:@"PSTableViewController" viewKey:@"tableView"];
    PageSwitchItem *item4 = [PageSwitchItem itemWithTitle:@"4" vcClsKey:@"PSTableViewController" viewKey:@"tableView"];
    return @[item1,item2,item3,item4];
}

- (void)pageSwitchView:(PageSwitchView *)pageSwitchView emptyPageContentView:(UIContentView*)contentView isReuse:(BOOL)isReuse{
    UILabel *lab = [[UILabel alloc]initWithFrame:contentView.bounds];
    lab.text = @"空";
    lab.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:lab];
}

- (void)cellContentView:(UIContentView*)contentView atIndexPath:(NSIndexPath*)indexPath isReuse:(BOOL)isReuse {
    if (indexPath.row == 0) {
        contentView.backgroundColor = [UIColor redColor];
    }else{
        contentView.backgroundColor = [UIColor orangeColor];
    }
}

-(NSUInteger)numberOfSections {
    return 1;
}

-(NSUInteger)numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (void)didScrollContentOffset:(CGPoint)contentOffset velocity:(CGPoint)velocity {
    static CGFloat Y = 0;
    //        NSLog(@"%f  %f",Y,contentOffset.y);
    
    if (contentOffset.y > 200) {
        if (velocity.y != 0) {
            NSLog(@"velocity:%f", velocity.y);
            if (velocity.y > 0) {//向下
                if (velocity.y >= 800) {
                    if (contentOffset.y>240) {
                        [self.searchView doShowWithAnimate:YES];
                    }
                }
            }else {
                if (velocity.y < -800)
                {
                    [self.searchView doHideWithAnimate:YES];
                }
            }
        }
    }else {
        if (contentOffset.y <= 200) {
            [self.searchView doHideWithAnimate:NO];
        }
    }
    Y = contentOffset.y;
}

-(UIView *)viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, searchBarHeight+firstBarHeight)];//第一个tatileBar不选停需要设置参数
    view.backgroundColor = [UIColor clearColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    lab.text = @"搜索";
    lab.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lab];
    [self addConstraint:lab inserts:UIEdgeInsetsMake(firstBarHeight, 0, 0, 0)];
    return view;
}

-(CGFloat)heightForHeaderInSection:(NSInteger)section {
    return searchBarHeight+firstBarHeight;
}

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)addConstraint:(UIView*)view inserts:(UIEdgeInsets)inserts {
    UIView *superview = view.superview;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1 constant:inserts.left]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1 constant:inserts.right]];
    [superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1 constant:inserts.top]];
    [superview addConstraint: [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1 constant:inserts.bottom]];
}


@end
