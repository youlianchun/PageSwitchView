//
//  PageSwitchViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 2016/12/4.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "PageSwitchViewController.h"
#import "PageSwitchView.h"
#import "PageSwitchItemViewController.h"

@implementation PageSwitchViewController(Protocol)
-(UIView*)viewForPageTitleViewAtPageIndex:(NSUInteger)index{return nil;}

-(NSArray<PageSwitchItem *> *)pageSwitchItems {
    PageSwitchItem *item1 = [PageSwitchItemViewController pageSwitchItemWithTitle:@"item"];
    return @[item1];
}
- (CGFloat)topeSpace {return 0;}
- (CGFloat)titleHeight  {return 49;}
- (void)movedToPageIndex:(NSUInteger)index{}
- (void)movingAtPageIndex:(NSUInteger)inde{}
- (void)cellContentView:(UIContentView*)contentView atIndexPath:(NSIndexPath*)indexPath isReuse:(BOOL)isReuse {}
-(NSUInteger)numberOfSections {return 0;}
-(NSUInteger)numberOfRowsInSection:(NSInteger)section {return 0;}
-(UIView *)viewForHeaderInSection:(NSInteger)section {return nil;}
-(CGFloat)heightForHeaderInSection:(NSInteger)section {return 0;}
-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {return 0;}
- (void)didScrollContentOffset:(CGPoint)contentOffset velocity:(CGPoint)velocity {}
-(NSArray*)selectedImageInTitle {return  @[];}
-(UIColor*)bgColorInTitle{return [UIColor whiteColor];}
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{}
- (void)emptyPageContentView:(UIContentView*)contentView isReuse:(BOOL)isReuse{}
@end

@interface PageSwitchViewController ()<PageSwitchViewDelegate, PageSwitchViewDataSource>
@property (nonatomic, retain) PageSwitchView *pageSwitchView;
@end

@implementation PageSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.pageSwitchView];
    self.pageSwitchView.delegate = self;
    self.pageSwitchView.dataSource = self;
    self.pageSwitchView.normalTitleColor = [UIColor colorWithHexString:@"#787878"];

    [self layoutPageSwitchViewWithinserts:UIEdgeInsetsMake(0, 0, 0, 0)];
}
-(void)layoutPageSwitchViewWithinserts:(UIEdgeInsets)inserts{
    [self.pageSwitchView layoutWithinserts:inserts];
}
-(PageSwitchView *)pageSwitchView {
    if (!_pageSwitchView) {
        _pageSwitchView = [[PageSwitchView alloc] initWithFrame:self.view.bounds];
        _pageSwitchView.titleFont = [UIFont systemFontOfSize:14];
        _pageSwitchView.maxTitleCount = self.maxTitleCount;
        _pageSwitchView.adaptFull_maxTitleCount = self.adaptFull_maxTitleCount;
        _pageSwitchView.titleCellSpace = self.titleCellSpace;
        _pageSwitchView.titleSelectedStyle = self.titleSelectedStyle;
        _pageSwitchView.selectedTitleColor = self.selectedTitleColor;
        _pageSwitchView.titleCellSelectColor = self.titleCellSelectColor;
        _pageSwitchView.horizontalScrollEnabled = YES;
    }
    return _pageSwitchView;
}
#pragma mark - delegate dataSource
-(UIView*)viewForPageTitleViewInPageSwitchView:(PageSwitchView *)pageSwitchView atPageIndex:(NSUInteger)index {
    return [self viewForPageTitleViewAtPageIndex:index];
}
- (CGFloat)titleHeightInPageSwitchView:(PageSwitchView *)pageSwitchView {
    return [self titleHeight];
}
-(CGFloat)topeSpaceInPageSwitchView:(PageSwitchView *)pageSwitchView {
    return [self topeSpace];
}
- (UIView *)viewForHeaderInPageSwitchView:(PageSwitchView *)pageSwitchView{
    return self.headerView;
}

- (BOOL)stretchingHeaderInPageSwitchView:(PageSwitchView *)pageSwitchView {
    return self.stretchingHeaderIf;
}

-(NSArray<PageSwitchItem *> *)pageSwitchItemsInPageSwitchView:(PageSwitchView *)pageSwitchView {
    return [self pageSwitchItems];
}

- (void)pageSwitchView:(PageSwitchView *)pageSwitchView cellContentView:(UIContentView*)contentView atIndexPath:(NSIndexPath*)indexPath isReuse:(BOOL)isReuse {
    [self cellContentView:contentView atIndexPath:indexPath isReuse:isReuse];
}
- (void)pageSwitchView:(PageSwitchView *)pageSwitchView emptyPageContentView:(UIContentView*)contentView isReuse:(BOOL)isReuse {
    [self emptyPageContentView:contentView isReuse:isReuse];
}

-(NSUInteger)numberOfSectionsInTableView:(PageSwitchView *)tableView {
    return [self numberOfSections];
}

-(NSUInteger)pageSwitchView:(PageSwitchView *)pageSwitchView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsInSection:section];
}

-(UIView *)pageSwitchView:(PageSwitchView *)pageSwitchView viewForHeaderInSection:(NSInteger)section {
    return [self viewForHeaderInSection:section];
}

-(CGFloat)pageSwitchView:(PageSwitchView *)pageSwitchView heightForHeaderInSection:(NSInteger)section {
    return [self heightForHeaderInSection:section];
}

-(CGFloat)pageSwitchView:(PageSwitchView *)pageSwitchView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForRowAtIndexPath:indexPath];
}

-(void)pageSwitchViewDidScroll:(PageSwitchView *)pageSwitchView contentOffset:(CGPoint)contentOffset velocity:(CGPoint)velocity {
    [self didScrollContentOffset:contentOffset velocity:velocity];
}

-(NSArray*)selectedImageInTitleAtPageSwitchView:(PageSwitchView *)pageSwitchView {
    return [self selectedImageInTitle];
}

-(UIColor*)bgColorInTitleAtPageSwitchView:(PageSwitchView *)pageSwitchView {
    return [self bgColorInTitle];
}
-(void)pageSwitchView:(PageSwitchView *)pageSwitchView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self didSelectRowAtIndexPath:indexPath];
}

- (void)pageSwitchView:(PageSwitchView *)pageSwitchView movedToPageIndex:(NSUInteger)index {
    [self movedToPageIndex:index];
}

- (void)pageSwitchView:(PageSwitchView *)pageSwitchView movingAtPageIndex:(NSUInteger)index {
    [self movingAtPageIndex:index];
}
#pragma mark -

-(void)reload {
    [self.pageSwitchView reloadData];
}

-(void)switchNewPageWithNewIndex:(NSUInteger)newIndex {
    [self.pageSwitchView switchNewPageWithNewIndex:newIndex];
}

-(void)switchNewPageWithTitle:(NSString*)title {
    [self.pageSwitchView switchNewPageWithTitle:title];
}

-(void)setNumber:(NSInteger)number atIndex:(NSUInteger)index {
    [self.pageSwitchView setNumber:number atIndex:index];
}

-(void)setNumber:(NSInteger)number atTitle:(NSString*)title {
    [self.pageSwitchView setNumber:number atTitle:title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
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
-(void)setHorizontalScrollEnabled:(BOOL)horizontalScrollEnabled {
    self.pageSwitchView.horizontalScrollEnabled = horizontalScrollEnabled;
}
-(BOOL)horizontalScrollEnabled {
    return self.pageSwitchView.horizontalScrollEnabled;
}
@end
