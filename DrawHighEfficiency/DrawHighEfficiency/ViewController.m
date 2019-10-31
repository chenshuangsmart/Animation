//
//  ViewController.m
//  DrawHighEfficiency
//
//  Created by chenshuang on 2019/10/25.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ViewController.h"
#import "DrawingView.h"
#import "DrawingView2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
//    DrawingView *view = [[DrawingView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:view];
    
    // 简单的类似黑板的应用
    DrawingView2 *view =  [[DrawingView2 alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
}


@end
