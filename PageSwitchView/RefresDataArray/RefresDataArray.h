//
//  RefresDataArray.h
//  RefreshDataArray
//
//  Created by YLCHUN on 2016/9/30.
//  Copyright © 2016年 YLCHUN. All rights reserved.
//

#import "NCMutableArray.h"
#import <UIKit/UIKit.h>

typedef struct RefreshSet{
    NSUInteger startPage;//起始页码
    NSUInteger pageSize;//分页大小，pageSize < 1 时候只有一页（footer为false时候会默认置0）
    BOOL header; //是否有下拉刷新
    BOOL footer; //是否有上拉加载 （pageSize < 1 时候会默认置false）
} RefreshSet;
extern RefreshSet RefreshSetMake(BOOL header, BOOL footer, NSUInteger startPage, NSUInteger pageSize);

typedef UIScrollView RefresView;

@protocol RefresDataArrayDelegate <NSObject>

/**
 加载完成
 
 @param view 加载页
 @param page 加载结果
 @param firstPage 是否第一页
 @param netRes arr 网络请求数组 isOK 网络状态，false时候不执行其它操作
 */
-(void)loadDataInRefresView:(RefresView*)view page:(NSUInteger)page firstPage:(BOOL)firstPage res:(void(^)(NSArray* arr, BOOL isOK))netRes;

/**
 *  设置刷新项
 *
 *  @return <#return value description#>
 */
-(RefreshSet)refreshSetWithRefresView:(RefresView*)view;

@optional
/**
 加载完成
 
 @param view 加载页
 @param page 加载结果
 @param firstPage 是否第一页
 */
-(void)didLoadDataInRefresView:(RefresView*)view page:(NSUInteger)page firstPage:(BOOL)firstPage;

/**
 *  没有数据
 *
 *  @param isEmpty true时候没有数据
 */
-(void)emptyDataArrayInRefresView:(RefresView*)view isEmpty:(BOOL)isEmpty;


/**
 是否隐藏第一页footer，当分页为1的时候

 @param view 加载页
 @return 是否隐藏
 */
//-(BOOL)hidenFooterAtFirstPageWhen1PageSizeInRefresView:(RefresView*)view;

@end

@interface RefresDataArray<ObjectType> : NCMutableArray<ObjectType>


/**
 数组0元素时候请求Page始终是StartPage，默认false
 */
@property (nonatomic, assign) BOOL pageIsStartPageWhenEmpty;

@property (nonatomic, copy) BOOL(^hidenFooterAtFirstPageWhen1PageSize)(RefresDataArray<ObjectType> *wArr);

/**
 *  请求下一页数据，没有分页时候且第一页已经请求完成后不执行
 */
-(void)loadNextPageData;
/**
 *  下拉刷新,第一次请求数据时候若不需要动画时候使用 nextPage
 *
 *  @param animate true 时候有下拉效果
 */
-(void)reloadDataWithAnimate:(BOOL)animate;

+ (instancetype)arrayWithRefresView:(RefresView*)view delegate:(id<RefresDataArrayDelegate>)delegate;

+ (instancetype)array NS_UNAVAILABLE;
+ (instancetype)arrayWithObject:(ObjectType)anObject NS_UNAVAILABLE;
+ (instancetype)arrayWithObjects:(ObjectType)firstObj, ... NS_REQUIRES_NIL_TERMINATION  NS_UNAVAILABLE;
+ (instancetype)arrayWithArray:(NSArray<ObjectType> *)array  NS_UNAVAILABLE;
- (instancetype)initWithCapacity:(NSUInteger)numItems  NS_UNAVAILABLE;
-(instancetype)init  NS_UNAVAILABLE;

@end


