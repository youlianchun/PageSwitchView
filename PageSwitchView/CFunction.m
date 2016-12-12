//
//  CFunction.m
//  ConvenientFunction
//
//  Created by YLCHUN on 16/9/15.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "CFunction.h"

#pragma mark - private function
dispatch_queue_t currentThreadQueue(){
    dispatch_queue_t currentThreadQueue;
    NSThread*currentThread = [NSThread currentThread];
    if (currentThread.isMainThread) {
        currentThreadQueue = dispatch_get_main_queue();
    }else{
        int PRIORITY = DISPATCH_QUEUE_PRIORITY_DEFAULT;
        switch (currentThread.qualityOfService) {
            case NSQualityOfServiceUserInteractive:
                PRIORITY = DISPATCH_QUEUE_PRIORITY_HIGH;
                break;
            case NSQualityOfServiceUserInitiated:
                PRIORITY = DISPATCH_QUEUE_PRIORITY_HIGH;
                break;
            case NSQualityOfServiceUtility:
                PRIORITY = DISPATCH_QUEUE_PRIORITY_LOW;
                break;
            case NSQualityOfServiceBackground:
                PRIORITY = DISPATCH_QUEUE_PRIORITY_BACKGROUND;
                break;
            case NSQualityOfServiceDefault:
                PRIORITY = DISPATCH_QUEUE_PRIORITY_DEFAULT;
                break;
            default:
                break;
        }
        currentThreadQueue = dispatch_get_global_queue(PRIORITY, 0);
    }
    return currentThreadQueue;
}

#pragma mark - public function


static dispatch_queue_t doCodeDelay_Queue;
void doCodeDelay(id obj, NSTimeInterval time,void (^doCode)(void)){
    BOOL binding = (obj != nil);
    __weak id wObj = obj;
    dispatch_queue_t doCode_Queue = currentThreadQueue();
    if (!doCodeDelay_Queue) {
        doCodeDelay_Queue = dispatch_queue_create("com.doCodeDelay.thread", DISPATCH_QUEUE_CONCURRENT);
    }
    dispatch_async(doCodeDelay_Queue, ^{
        [NSThread sleepForTimeInterval:time];
        dispatch_async(doCode_Queue, ^{
            if ((!binding || (binding && wObj)) && doCode) {
                doCode();
            }
        });
    });
}

void NDLogv(NSString *format, va_list args) {
    NSMutableString * message = [[NSMutableString alloc] initWithFormat:format arguments:args];
    NSDate *date = [NSDate date];
    NSMutableString *str = [NSMutableString string];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *time = [dateFormatter stringFromDate:date];
    [str appendString:time];
    [str appendString:@" "];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *project = [infoDictionary objectForKey:@"CFBundleExecutable"]; //获取项目名称
    [str appendString:project];
    [str appendString:@"["];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"]; //获取项目版本号
    [str appendString:version];
    [str appendString:@"_"];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"]; //获取项目构造版本号
    [str appendString:build];
    [str appendString:@"] "];
    [str appendString:message];
    printf("%s\n",  [str UTF8String]);
}

void NDLog(NSString *format, ...) {
    va_list argumentList;
    va_start(argumentList, format);
    NSMutableString * message = [[NSMutableString alloc] initWithFormat:format arguments:argumentList];
    va_end(argumentList);
    NDLogv(message, argumentList);
}

void NSLog(NSString *format, ...) {
    va_list argumentList;
    va_start(argumentList, format);
    NSMutableString * message = [[NSMutableString alloc] initWithFormat:format arguments:argumentList];
    va_end(argumentList);
    NDLogv(message, argumentList);
}

