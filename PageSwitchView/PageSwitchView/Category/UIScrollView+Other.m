//
//  UIScrollView+Other.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/6.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "UIScrollView+Other.h"
#import <objc/runtime.h>
@interface _UIScrollViewAttribute : NSObject
@property (nonatomic, weak) UIScrollView *otherScrollView;
@property (nonatomic, assign) BOOL isDescendantOfOtherScrollView;
@property (nonatomic, assign) BOOL isAncestorOfOtherScrollView;
@end
@implementation _UIScrollViewAttribute
-(instancetype)init {
    self = [super init];
    if (self) {
        self.isDescendantOfOtherScrollView = NO;
        self.isAncestorOfOtherScrollView = NO;
    }
    return self;
}
-(BOOL)isDescendantOfOtherScrollView {
    if (self.otherScrollView) {
        return _isDescendantOfOtherScrollView;
    }
    return NO;
}
-(BOOL)isAncestorOfOtherScrollView {
    if (self.otherScrollView) {
        return _isAncestorOfOtherScrollView;
    }
    return NO;
}
@end

@interface UIScrollView ()
@property (nonatomic, retain) _UIScrollViewAttribute *attribute;

@end

@implementation UIScrollView (Other)

-(_UIScrollViewAttribute *)attribute {
    _UIScrollViewAttribute *attribute = objc_getAssociatedObject(self, @selector(attribute));
    if (!attribute) {
        attribute = [[_UIScrollViewAttribute alloc]init];
        self.attribute = attribute;
    }
    return attribute;
}

-(void)setAttribute:(_UIScrollViewAttribute *)attribute {
    objc_setAssociatedObject(self, @selector(attribute), attribute, OBJC_ASSOCIATION_RETAIN);
}

-(UIScrollView *)otherScrollView {
    return self.attribute.otherScrollView;
}

-(void)setOtherScrollView:(UIScrollView *)otherScrollView {
    self.attribute.otherScrollView = otherScrollView;
    self.attribute.isDescendantOfOtherScrollView = [self isDescendantOfView:otherScrollView];
    self.attribute.isAncestorOfOtherScrollView = [otherScrollView isDescendantOfView:self];
}

-(BOOL)isDescendantOfOtherScrollView {
    return self.attribute.isDescendantOfOtherScrollView;
}

-(BOOL)isAncestorOfOtherScrollView {
    return self.attribute.isAncestorOfOtherScrollView;
}

@end
