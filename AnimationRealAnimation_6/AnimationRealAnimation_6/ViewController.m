//
//  ViewController.m
//  AnimationRealAnimation_6
//
//  Created by chenshuang on 2019/9/14.
//  Copyright © 2019年 wenwen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CAAnimationDelegate>
/** img view*/
@property(nonatomic,strong)UIImageView *imgView;
/** imgs*/
@property(nonatomic,strong)NSMutableArray *imgs;
@property (nonatomic, strong) CALayer *shipLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 使用CATransition对图像平滑淡入淡出
//    [self createImgView];
    
    // 使用UIKit提供的方法来做过渡动画
//    [self createImgView2];
    
    /// 5开始和停止一个动画
    [self creatStartStopAnimation];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self createImgView];
    
//    [self createImgView2];
    
    //  用renderInContext:创建自定义过渡效果
    [self performTransition];
}

- (void)createImgView {
    // set up crossfade transition
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    // apply transition to imageview backing layer
    [self.imgView.layer addAnimation:transition forKey:nil];
    
    // cycle to next image
    UIImage *currentImg = self.imgView.image;
    NSUInteger index = [self.imgs indexOfObject:currentImg];
    index = (index + 1) % [self.imgs count];
    self.imgView.image = self.imgs[index];
}

/// 使用UIKit提供的方法来做过渡动画
- (void)createImgView2 {
    [UIView transitionWithView:self.imgView
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                           //cycle to next image
                           UIImage *currentImage = self.imgView.image;
                           NSUInteger index = [self.imgs indexOfObject:currentImage];
                           index = (index + 1) % [self.imgs count];
                           self.imgView.image = self.imgs[index];
    } completion:^(BOOL finished) {
        
    }];
}

/// 4.用renderInContext:创建自定义过渡效果
- (void)performTransition {
    // preserve the current view snapshot
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // insert snapshot view in front of this one
    UIImageView *coverView = [[UIImageView alloc] initWithImage:coverImage];
    coverView.frame = self.view.bounds;
    [self.view addSubview:coverView];
    
    // update the view (we'll simply randomize the layer background color)
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    // perform animation(anything you like)
    [UIView animateWithDuration:1.0 animations:^{
        // scale rotate and fade the view
        CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.001);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        coverView.transform = transform;
        coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        // remove the cover view now we're finished with it
        [coverView removeFromSuperview];
    }];
}

/// 5开始和停止一个动画
- (void)creatStartStopAnimation {
    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 128, 128);
    self.shipLayer.position = self.view.center;
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed: @"plane"].CGImage;
    [self.view.layer addSublayer:self.shipLayer];
    
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    startBtn.center = CGPointMake(self.view.bounds.size.width * 0.25, self.view.bounds.size.height * 0.75);
    [self.view addSubview:startBtn];
    
    UIButton *stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    [stopBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stopBtn setTitle:@"结束" forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    stopBtn.center = CGPointMake(self.view.bounds.size.width * 0.75, self.view.bounds.size.height * 0.75);
    [self.view addSubview:stopBtn];
}

- (void)start {
    //animate the ship rotation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 2.0;
    animation.byValue = @(M_PI * 2);
    animation.delegate = self;
    [self.shipLayer addAnimation:animation forKey:@"rotateAnimation"];
}

- (void)stop {
    [self.shipLayer removeAnimationForKey:@"rotateAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //log that the animation stopped
    NSLog(@"The animation stopped (finished: %@)", flag? @"YES": @"NO");
}

#pragma mark - lazy

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _imgView.center = self.view.center;
        _imgView.image = [UIImage imageNamed:@"0"];
        [self.view addSubview:_imgView];
    }
    return _imgView;
}

- (NSMutableArray *)imgs {
    if (_imgs == nil) {
        _imgs = [NSMutableArray array];
        [_imgs addObject:[UIImage imageNamed:@"0"]];
        [_imgs addObject:[UIImage imageNamed:@"1"]];
        [_imgs addObject:[UIImage imageNamed:@"2"]];
        [_imgs addObject:[UIImage imageNamed:@"3"]];
    }
    return _imgs;
}
@end
