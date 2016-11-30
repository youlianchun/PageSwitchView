//
//  DelegateInterceptor.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/10/13.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DelegateInterceptor<ReceiverDelegateType> : NSObject
@property (nonatomic, readwrite, weak) ReceiverDelegateType receiver;
@property (nonatomic, readwrite, weak) id middleMan;

@property (nonatomic, readonly) ReceiverDelegateType mySelf;

@end
