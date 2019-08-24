//
//  ViewController.m
//  AnimationHightSkill_1
//
//  Created by chenshuang on 2019/8/21.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CALayerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //create sublayer
//    CALayer *blueLayer = [CALayer layer];
//    blueLayer.frame = CGRectMake(100.0f, 100.0f, 100.0f, 100.0f);
//    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
//    //add it to our view
//    [self.view.layer addSublayer:blueLayer];
    
//    [self addImgContents];
    
//    [self contentsRect];
    
//    [self contentsCenter];
    
//    [self contentsCenter1];
    
    [self caLayerDelegate];
}

- (void)addImgContents {
    UIImage *img = [UIImage imageNamed:@"cat"];
    
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    layerView.center = self.view.center;
    [self.view addSubview:layerView];
    
    // 1.图片处于中间
//    layerView.layer.contentsGravity = kCAGravityCenter;
    
    // 2.图片缩放比例
//    layerView.layer.contentsScale = img.scale;
//    layerView.layer.contentsScale = [UIScreen mainScreen].scale;
    
    // 3.masksToBounds裁剪超出边界的视图
//    layerView.layer.masksToBounds = YES;
    
    // 4.contentsRect 显示寄宿图的一个子域
    layerView.layer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);
//
    layerView.layer.contents = (__bridge id)img.CGImage;
}

- (void)contentsRect {
    UIImage *img = [UIImage imageNamed:@"cat"];
    
    // add four img
    for (int i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100 + 120 * i, 100, 100)];
        [self.view addSubview:view];
        
        CGFloat x = i % 2 == 0 ? 0 : 0.5;
        CGFloat y = i < 2 ? 0 : 0.5;
        [self addSpriteImage:img withContentRect:CGRectMake(x, y, 0.5, 0.5) ￼toLayer:view.layer];
    }
}

- (void)addSpriteImage:(UIImage *)image withContentRect:(CGRect)rect ￼toLayer:(CALayer *)layer {//set image
    layer.contents = (__bridge id)image.CGImage;
    
    //scale contents to fit
    layer.contentsGravity = kCAGravityResizeAspect;
    
    //set contentsRect
    layer.contentsRect = rect;
}

- (void)contentsCenter {
    UIImage *img = [UIImage imageNamed:@"cat"];
    
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    layerView.center = self.view.center;
    [self.view addSubview:layerView];
    
    layerView.layer.contents = (__bridge id)img.CGImage;
    layerView.layer.contentsGravity = kCAGravityResizeAspect;
    
    // contentsCenter
    layerView.layer.contentsCenter = CGRectMake(0.25, 0.25, 0.5, 0.5);
}

- (void)contentsCenter1 {
    UIImage *img = [UIImage imageNamed:@"cat"];
    
    // add four img
    for (int i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100 + 120 * i, 100, 100)];
        [self.view addSubview:view];
        
        [self addStretchableImage:img withContentCenter:CGRectMake(0.25, 0.25, 0.5, 0.5) toLayer:view.layer];
    }
}

- (void)addStretchableImage:(UIImage *)image withContentCenter:(CGRect)rect toLayer:(CALayer *)layer {
    //set image
    layer.contents = (__bridge id)image.CGImage;
    
    //set contentsCenter
    layer.contentsCenter = rect;
}

- (void)caLayerDelegate {
    // create layerView
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(50.0f, 50.0f, 100.0f, 100.0f)];
    layerView.center = self.view.center;
    [self.view addSubview:layerView];
    
    //create sublayer
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;

    //set controller as layer delegate
    blueLayer.delegate = self;
    
    // ensure that layer backing image uses correct scale
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    
    [layerView.layer addSublayer:blueLayer];
    
    [blueLayer display];
}

#pragma mark - CALayerDelegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    //draw a thick red circle
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

@end
