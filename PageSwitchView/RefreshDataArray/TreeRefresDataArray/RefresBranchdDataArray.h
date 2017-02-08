//
//  RefresBranchdDataArray.h
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/8.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "NCMutableArray.h"
#import "RefresDataArray.h"

@interface RefresBranchdDataArray<ObjectType> : RefresDataArray<ObjectType>

@property (nonatomic, assign) BOOL linkedEnabled;

-(void)reloadDataWithAnimate:(BOOL)animate NS_UNAVAILABLE;
-(void)reloadData;
@end
