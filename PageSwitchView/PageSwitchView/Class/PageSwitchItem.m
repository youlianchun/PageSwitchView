//
//  PageSwitchItem.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/9/23.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "_PageSwitchItem.h"
#import "_TwoScrollView.h"
#import "DelegateInterceptor.h"
//#import "NCTimer.h"

static const CGFloat waitTimer = 0.05;

@interface PageSwitchItem()
@property (nonatomic, copy) NSString *title;
@property (nonatomic) UIView* contentView;
@property (nonatomic) UIViewController<PageViewControllerProtocol> *contentViewController;
@property (nonatomic, copy) void(^newPage)(DoReturn doReturn);
@property (nonatomic, retain) DelegateInterceptor<id<UIScrollViewDelegate>> *delegateInterceptor;
@property (nonatomic) BOOL didLoad;
//@property (nonatomic) NCTimer *timer;

-(instancetype)initSelf;


@end
@implementation PageSwitchItem

-(instancetype)initSelf{
    self = [super init];
    if (self) {
    }
    return self;
}


-(UIView*)contentView{
    if (!_contentView) {//懒加载调用控制器创建，获取分页滑动视图
        DoReturn doReturn = ^(UIViewController<PageViewControllerProtocol>*viewController, id view){
            _contentView = view;
            _contentViewController = viewController;
        };
        self.newPage(doReturn);
        self.didConfig = NO;
        [_contentView removeFromSuperview];
    }
    return _contentView;
}

-(BOOL)isScroll {
    _isScroll = [self.contentView isKindOfClass:[UIScrollView class]];
    return  _isScroll;
}

-(BOOL)is2Scroll {
    _is2Scroll = [self.contentView isKindOfClass:[TwoScrollView class]];
    return _is2Scroll;
}

-(UIViewController<PageViewControllerProtocol> *)contentViewController{
    if (!_contentViewController) {
        __weak typeof(self) wself = self;
        DoReturn doReturn = ^(UIViewController<PageViewControllerProtocol>*viewController, id view){
            _contentView = view;
            _contentViewController = viewController;
            wself.isScroll = [view isKindOfClass:[UIScrollView class]];
            wself.is2Scroll = [view isKindOfClass:[TwoScrollView class]];
        };
        self.newPage(doReturn);
        self.didConfig = NO;
    }
    return _contentViewController;
}

-(void)setScrollDelegate:(id<UIScrollViewDelegate>)scrollDelegate {
    if (self.isScroll) {
        _scrollDelegate = scrollDelegate;
        self.delegateInterceptor = [[DelegateInterceptor alloc]init];
        self.delegateInterceptor.receiver = ((UIScrollView *)self.contentView).delegate;
        self.delegateInterceptor.middleMan = self;
        [((UIScrollView *)self.contentView) setDelegate:self.delegateInterceptor.mySelf];
    }
    if (self.is2Scroll) {
        _scrollDelegate = scrollDelegate;
        ((TwoScrollView *)self.contentView).delegate = (id<UIScrollViewDelegate>)self;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.isScroll) {
        if ([self.delegateInterceptor.receiver respondsToSelector:_cmd]) {
            [self.delegateInterceptor.receiver scrollViewDidScroll:scrollView];
        }
    }
    if ([self.scrollDelegate respondsToSelector:_cmd]) {
        [self.scrollDelegate scrollViewDidScroll:scrollView];
    }
}

-(void)setIsVisible:(BOOL)isVisible {
    _isVisible = isVisible;
}

-(void)setIsCurrent:(BOOL)isCurrent {
    if (_isCurrent == isCurrent) {
        return;
    }
    _isCurrent = isCurrent;
    if (!self.didLoad) {
        if (waitTimer>0.005) {
            if (isCurrent) {
//                [self.timer resume];
                [self performSelector:@selector(loadFunction) withObject:nil afterDelay:waitTimer];//停留waitTimer后加载，否则取消加载
            }else{
//                [self.timer cancel];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadFunction) object:nil];
            }
        }else {
            [self loadFunction];
        }
    }
}

//-(NCTimer *)timer {
//    if (!_timer) {
//        _timer = [NCTimer timerWithCount:1 interval:waitTimer target:self selector:@selector(loadFunction)];
//    }
//    return _timer;
//}

-(void)loadFunction {
    self.didLoad = YES;
    if (self.didLoadBock) {
        self.didLoadBock();
    }
}

+(PageSwitchItem*)itemWithTitle:(NSString*)title page:(void(^)(DoReturn doReturn))newPage {
    PageSwitchItem *item = [[PageSwitchItem alloc]initSelf];
    item.newPage = newPage;
    item.title = title;
    return item;
}

+(PageSwitchItem*)itemWithTitle:(NSString*)title vcCls:(Class)vcCls viewKey:(NSString*)key {
    BOOL b = [vcCls isSubclassOfClass:[UIViewController class]];
    NSAssert(b, @"％@不是UIViewController", vcCls);
    PageSwitchItem *item = [[PageSwitchItem alloc]initSelf];
    item.title = title;
    item.newPage = ^(DoReturn doReturn){
        id vc = [[vcCls alloc]init];
        id view = [vc valueForKey:key];
        BOOL b = view != nil && ![view isMemberOfClass:[UIView class]];
        NSAssert(b, @"%@ 属性: %@不正确", key, vcCls);
        doReturn (vc, view);
    };
    return item;
}

+(PageSwitchItem*)itemWithTitle:(NSString*)title vcClsKey:(NSString*)clsKey viewKey:(NSString*)key {
    Class vcCls = NSClassFromString(clsKey);
    return [PageSwitchItem itemWithTitle:title vcCls:vcCls viewKey:key];
}


@end
