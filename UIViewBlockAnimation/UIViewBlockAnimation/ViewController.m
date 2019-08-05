//
//  ViewController.m
//  UIViewBlockAnimation
//
//  Created by chenshuang on 2019/8/4.
//  Copyright © 2019年 wenwen. All rights reserved.
//

#import "ViewController.h"
#import "TestAnimationView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self checkAnimation];
    
    // block动画原理
    [self checkAnimation4];
}

- (void)animation {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    // 这样写没有动画
    view.center = CGPointMake(80, 80);
    
    // 写在block里面就有动画
    [UIView animateWithDuration:2.0 animations:^{
        view.center = CGPointMake(80, 80);
    }];
}

- (void)checkAnimation {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    NSLog(@"%@",[view.layer.delegate actionForLayer:view.layer forKey:@"position"]);
    
    [UIView animateWithDuration:1.25 animations:^{
        NSLog(@"%@",[view.layer.delegate actionForLayer:view.layer forKey:@"position"]);
    }];
}

- (void)checkAnimation2 {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    view.center = CGPointMake(80, 80);
    
    [UIView animateWithDuration:1.25 animations:^{
        view.center = CGPointMake(80, 80);
    } completion:^(BOOL finished) {
        NSLog(@"aaa");
    }];
}

- (void)checkAnimation3 {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    [UIView animateWithDuration:1.25 animations:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            view.center = CGPointMake(80, 80);
        });
    } completion:^(BOOL finished) {
        NSLog(@"aaa");
    }];
}

- (void)checkAnimation4 {
    TestAnimationView * view = [[TestAnimationView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:view];
    
    [UIView animateWithDuration:1.25 animations:^{
        view.center = CGPointMake(80, 80);
    } completion:^(BOOL finished) {
        NSLog(@"aaa");
    }];
}
@end
