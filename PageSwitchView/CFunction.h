//
//  CFunction.h
//  ConvenientFunction
//
//  Created by YLCHUN on 16/9/15.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 *  代码块延迟执行（代码块执行的所在线程类型取决于函数调用时的线程类型）
 *
 *  @param obj     绑定对象，nil为不绑定（绑定对象一旦释放将不执行代码块）
 *  @param time    延迟时间（秒）
 *  @param doCode 延迟执行代码块
 */
void doCodeDelay(id obj, double time,void (^doCode)(void));



/*!
 *  DEVELOP_FLG 时候打印
 */
void NDLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2) NS_NO_TAIL_CALL;

