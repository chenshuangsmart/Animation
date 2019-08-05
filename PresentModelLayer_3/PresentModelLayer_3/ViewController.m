//
//  ViewController.m
//  PresentModelLayer_3
//
//  Created by chenshuang on 2019/8/5.
//  Copyright © 2019年 wenwen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.add animation
//    [self addAnimation];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self addAnimation2];
}

/** 动画结束后回到起始位置 */
- (void)addAnimation {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 2;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(80, 80)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 300)];
    [view.layer addAnimation:animation forKey:nil];
}

/** 动画结束后停留在当前位置 */
- (void)addAnimation1 {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 2;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(80, 80)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 300)];
    animation.removedOnCompletion = NO; // 动画结束后停留在当前位置
    animation.fillMode = kCAFillModeForwards;   // 动画结束后停留在当前位置
    [view.layer addAnimation:animation forKey:nil];
}

/** 设置M的值到动画结束的状态来保持P和M的同步 */
- (void)addAnimation2 {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    view.center = CGPointMake(200, 300);
    [self.view addSubview:view];
    
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 2;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(80, 80)];
    [view.layer addAnimation:animation forKey:nil];
}


@end
