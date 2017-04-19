//
//  PageSwitchViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 2016/12/4.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "SimplePageSwitchViewController.h"
#import "PageSwitchItemViewController.h"

@implementation SimplePageSwitchViewController(Protocol)
-(UIView*)viewForPageTitleViewAtPageIndex:(NSUInteger)index{return nil;}
-(NSArray<PageSwitchItem *> *)pageSwitchItems {
    PageSwitchItem *item1 = [PageSwitchItemViewController pageSwitchItemWithTitle:@"item"];
    return @[item1];
}
- (CGFloat)titleHeight  {return 49;}
- (void)movedToPageIndex:(NSUInteger)index{}
- (void)movingAtPageIndex:(NSUInteger)inde{}

@end

@interface SimplePageSwitchViewController ()<SimplePageSwitchViewDelegate, SimplePageSwitchViewDataSource>
@property (nonatomic) SimplePageSwitchView *pageSwitchView;
@property (nonatomic) void(^switchBlock)();
@property (nonatomic) void(^setNumberBlock)();

@end

@implementation SimplePageSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageSwitchView = [[SimplePageSwitchView alloc]initWithFrame:self.view.bounds];
    self.pageSwitchView.delegate = self;
    self.pageSwitchView.dataSource = self;
    self.pageSwitchView.titleFont = [UIFont systemFontOfSize:14];
    self.pageSwitchView.normalTitleColor = [UIColor colorWithHexString:@"#323232"];
    [self.view addSubview:self.pageSwitchView];
    [self layoutPageSwitchViewWithinserts:UIEdgeInsetsMake(0, 0, 0, 0)];
}
-(void)layoutPageSwitchViewWithinserts:(UIEdgeInsets)inserts{
    [self.pageSwitchView layoutWithinserts:inserts];
}

#pragma mark - delegate dataSource
-(UIView*)viewForPageTitleViewInPageSwitchView:(SimplePageSwitchView *)pageSwitchView atPageIndex:(NSUInteger)index {
    return [self viewForPageTitleViewAtPageIndex:index];
}
-(NSArray<PageSwitchItem *> *)pageSwitchItemsInPageSwitchView:(SimplePageSwitchView *)pageSwitchView {
    return [self pageSwitchItems];
}

- (CGFloat)titleHeightInPageSwitchView:(SimplePageSwitchView *)pageSwitchView {
    return [self titleHeight];
}

- (void)pageSwitchView:(SimplePageSwitchView *)pageSwitchView movedToPageIndex:(NSUInteger)index {
    [self movedToPageIndex:index];
}

- (void)pageSwitchView:(SimplePageSwitchView *)pageSwitchView movingAtPageIndex:(NSUInteger)index {
    [self movingAtPageIndex:index];
}

#pragma mark -

-(void)reload {
    [self.pageSwitchView reloadData];
}

-(void)switchNewPageWithNewIndex:(NSUInteger)newIndex {
    __weak typeof(self) wself = self;
    self.switchBlock = ^(){
        [wself.pageSwitchView switchNewPageWithNewIndex:newIndex];
        wself.switchBlock = nil;
    };
    if (self.pageSwitchView) {
        self.switchBlock();
    }
}

-(void)switchNewPageWithTitle:(NSString*)title {
    __weak typeof(self) wself = self;
    self.switchBlock = ^(){
        [wself.pageSwitchView switchNewPageWithTitle:title];
        wself.switchBlock = nil;
    };
    if (self.pageSwitchView) {
        self.switchBlock();
    }
}

-(void)setNumber:(NSInteger)number atIndex:(NSUInteger)index {
    __weak typeof(self) wself = self;
    self.setNumberBlock = ^(){
        [wself.pageSwitchView setNumber:number atIndex:index];
        wself.switchBlock = nil;
    };
    if (self.pageSwitchView) {
        self.setNumberBlock();
    }
}

-(void)setNumber:(NSInteger)number atTitle:(NSString*)title {
    __weak typeof(self) wself = self;
    self.setNumberBlock = ^(){
        [wself.pageSwitchView setNumber:number atTitle:title];
        wself.switchBlock = nil;
    };
    if (self.pageSwitchView) {
        self.setNumberBlock();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.switchBlock) {
        self.switchBlock();
        self.switchBlock = nil;
    }
    if (self.setNumberBlock) {
        self.setNumberBlock();
        self.setNumberBlock = nil;
    }
}

#pragma mark -
-(void)setHoverTitleBar:(BOOL)hoverTitleBar {
    self.pageSwitchView.hoverTitleBar = hoverTitleBar;
}
-(BOOL)hoverTitleBar {
    return self.pageSwitchView.hoverTitleBar;
}
-(void)setNormalTitleColor:(UIColor *)normalTitleColor {
    self.pageSwitchView.normalTitleColor = normalTitleColor;
}
-(UIColor *)normalTitleColor {
    return self.pageSwitchView.normalTitleColor;
}
-(void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    self.pageSwitchView.selectedTitleColor = selectedTitleColor;
}
-(UIColor *)selectedTitleColor {
    return self.pageSwitchView.selectedTitleColor;
}
-(void)setTitleSelectedStyle:(SegmentSelectedStyle)titleSelectedStyle {
    self.pageSwitchView.titleSelectedStyle = titleSelectedStyle;
}
-(SegmentSelectedStyle)titleSelectedStyle {
    return self.pageSwitchView.titleSelectedStyle;
}
-(void)setTitleCellSpace:(BOOL)titleCellSpace {
    self.pageSwitchView.titleCellSpace = titleCellSpace;
}
-(BOOL)titleCellSpace {
    return self.pageSwitchView.titleCellSpace;
}
-(void)setMaxTitleCount:(NSUInteger)maxTitleCount {
    self.pageSwitchView.maxTitleCount = maxTitleCount;
}
-(NSUInteger)maxTitleCount {
    return self.pageSwitchView.maxTitleCount;
}
-(void)setAdaptFull_maxTitleCount:(BOOL)adaptFull_maxTitleCount {
    self.pageSwitchView.adaptFull_maxTitleCount = adaptFull_maxTitleCount;
}
-(BOOL)adaptFull_maxTitleCount {
    return self.pageSwitchView.adaptFull_maxTitleCount;
}
-(void)setTitleCellSelectColor:(UIColor *)titleCellSelectColor {
    self.pageSwitchView.titleCellSelectColor = titleCellSelectColor;
}
-(UIColor *)titleCellSelectColor {
    return self.pageSwitchView.titleCellSelectColor;
}
@end
