//
//  RefresBoleDataArray.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/8.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "NCMutableArray.h"
#import "RefresBranchdDataArray.h"
#import <UIKit/UIKit.h>

typedef UIScrollView RefresView;


@protocol RefresBoleDataArrayDelegate <NSObject>

/**
 加载完成
 
 @param view 加载页
 @param netRes arr 网络请求数组 isOK 网络状态，false时候不执行其它操作
 */
-(void)loadDataInRefresView:(RefresView*)view res:(void(^)(NSArray* arr, BOOL isOK))netRes;

@optional
-(void)didLoadDataInRefresView:(RefresView*)view ;
@end

@interface RefresBoleDataArray<ObjectType> : NCMutableArray<ObjectType>
@property (nonatomic, readonly) BOOL loading;
@property (nonatomic, readonly) BOOL willLoading;//即将开始请求网络

@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;
//@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetBottom;

+ (instancetype)arrayWithRefresView:(RefresView*)view delegate:(id<RefresBoleDataArrayDelegate>)delegate;

-(void)addBranchd:(RefresBranchdDataArray*)branchd;

-(void)removeBranchd:(RefresBranchdDataArray*)branchd;

-(void)reloadDataWithAnimate:(BOOL)animate;

@end
