//
//  UIGestureRecognizer+Group.m
//  PageView
//
//  Created by YLCHUN on 16/10/13.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "UIGestureRecognizer+Group.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (Group)
-(NSString *)groupTag {
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setGroupTag:(NSString *)groupTag {
    objc_setAssociatedObject(self, @selector(groupTag), groupTag, OBJC_ASSOCIATION_COPY);
}
@end
