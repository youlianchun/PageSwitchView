//
//  RootViewController.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/2.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "RootViewController.h"
#import "SubViewController.h"
#import <objc/runtime.h>

//bool gestureRecognizer(id self, SEL _cmd, UIGestureRecognizer *gestureRecognizer, UIGestureRecognizer *otherGestureRecognizer){
//    if (_cmd == @selector(gestureRecognizer:shouldRequireFailureOfGestureRecognizer:)) {
//        
//    }
//    if (_cmd == @selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)) {
//        
//    }
//    return true;
//}


@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"root";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self performSelector:@selector(gestureRecognizer:shouldRequireFailureOfGestureRecognizer:) withObject:@"1" withObject:@"2"];
//    [self gestureRecognizer:nil shouldRequireFailureOfGestureRecognizer:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:true animated:animated];
//}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SubViewController *svc = [[SubViewController alloc]init];
    [self.navigationController pushViewController:svc animated:true];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



//+(BOOL)resolveInstanceMethod:(SEL)sel{
//    if (sel == @selector(gestureRecognizer:shouldRequireFailureOfGestureRecognizer:)) {
//        BOOL isSuccess = class_addMethod(self, sel, (IMP)gestureRecognizer, "B@:@:@");
//        return isSuccess;
//    }
//    if (sel == @selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)) {
//        BOOL isSuccess = class_addMethod(self, sel, (IMP)gestureRecognizer, "B@:@:@");
//        return isSuccess;
//        
//    }
//    return [super resolveInstanceMethod:sel];
//}
//

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    @"B@:@:";
    IMP imp = [self methodForSelector:_cmd];

    return NO;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    @"B@:@:";
//    SEL s = @selector(gestureRecognizer:shouldRequireFailureOfGestureRecognizer:);
//    IMP imp = [self methodForSelector:s];
//    
//
//        return NO;
//}
@end
