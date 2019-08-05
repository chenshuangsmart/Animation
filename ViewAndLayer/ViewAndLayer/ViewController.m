//
//  ViewController.m
//  ViewAndLayer
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
    
    TestAnimationView *view = [[TestAnimationView alloc] init];
    
    // 1.test
//    [self.view addSubview:view];
    
    // 2.test
    view.layer.position = CGPointMake(80, 80);
    NSLog(@"%@",NSStringFromCGPoint(view.center));
    
    [self.view addSubview:view];
}

@end
