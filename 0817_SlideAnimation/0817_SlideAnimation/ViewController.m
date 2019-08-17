//
//  ViewController.m
//  0817_SlideAnimation
//
//  Created by chenshuang on 2019/8/17.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
/** view */
@property(nonatomic, strong)CALayer *myLayer;
/** slide */
@property(nonatomic, strong)UISlider *slide;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self drawUI];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CALayer * layer = [CALayer layer];
    layer.frame = CGRectMake(100, 100, 200, 200);
    layer.opacity = 0.5;
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"opacity";
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 1;
    animation.beginTime = CACurrentMediaTime() + 1;
    animation.removedOnCompletion = false;
    [layer addAnimation:animation forKey:@"opacity"];
}

- (void)drawUI {
    // white view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    whiteView.backgroundColor = [UIColor orangeColor];
    whiteView.center = self.view.center;
    [self.view addSubview:whiteView];
    
    // layer
    self.myLayer = [CALayer layer];
    self.myLayer.frame = whiteView.bounds;
    [whiteView.layer addSublayer:self.myLayer];
    
    // animation
    CABasicAnimation *changeColor = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    changeColor.fromValue = (id)[UIColor orangeColor].CGColor;
    changeColor.toValue = (id)[UIColor blueColor].CGColor;
    changeColor.duration = 1.0; // for convenience
    [self.myLayer addAnimation:changeColor forKey:@"changeColor"];
    self.myLayer.speed = 0.0;   // pause the animation
    
    // slide
    UISlider *slideView = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    slideView.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5 + 100);
    [slideView addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slideView];
}

- (void)sliderChanged:(UISlider *)sender {
    self.myLayer.timeOffset = sender.value; // Update "current time"
}

@end
