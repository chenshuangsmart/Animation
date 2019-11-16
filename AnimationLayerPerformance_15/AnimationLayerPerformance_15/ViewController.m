//
//  ViewController.m
//  AnimationLayerPerformance_15
//
//  Created by chenshuang on 2019/11/12.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ViewController.h"

#define WIDTH 10
#define HEIGHT 10
#define DEPTH 10
#define SIZE 100
#define SPACING 150
#define CAMERA_DISTANCE 500
#define PERSPECTIVE(z) (float)CAMERA_DISTANCE/(z + CAMERA_DISTANCE)

/// 图层性能
@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *layerView;
/** scrollView */
@property(nonatomic, strong)UIScrollView *scrollView;
/** recycle pool */
@property(nonatomic, strong)NSMutableSet *recyclePool;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.layerView.center = self.view.center;
    [self.view addSubview:self.layerView];
    
    // create recycle pool
    self.recyclePool = [NSMutableSet set];
    
    // 1.用CAShapeLayer画一个圆角矩形
//    [self drawRectangle];
    
    /// 2.用可伸缩图片绘制圆角矩形
//    [self drawRectangle2];
    
    /// 绘制3D图层矩阵
//    [self draw3DMatrix];
    
    /// 排除可视区域之外的图层
    [self draw3DMatrixInside];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    [self updateLayers];
    [self updateLayers2];
}

/// 1.用CAShapeLayer画一个圆角矩形
- (void)drawRectangle {
    // create shape layer
    CAShapeLayer *blueLayer = [CAShapeLayer layer];
    blueLayer.frame = CGRectMake(0, 0, 100, 100);
    blueLayer.fillColor = [UIColor blueColor].CGColor;
    blueLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 100, 100) cornerRadius:20].CGPath;
    
    // add it to our view
    [self.layerView.layer addSublayer:blueLayer];
}

/// 2.用可伸缩图片绘制圆角矩形
- (void)drawRectangle2 {
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(0, 0, 100, 100);
    blueLayer.contentsCenter = CGRectMake(0.5, 0.5, 0, 0);
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    blueLayer.contents = (__bridge id)[UIImage imageNamed:@"circle"].CGImage;
    
    // add it to our view
    [self.layerView.layer addSublayer:blueLayer];
}

/// 绘制3D图层矩阵
- (void)draw3DMatrix {
    // set content size
    self.scrollView.contentSize = CGSizeMake((WIDTH - 1)*SPACING, (HEIGHT - 1)*SPACING);
    
    // setup perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / CAMERA_DISTANCE;
    self.scrollView.layer.sublayerTransform = transform;
    
    // create layers
    for (int z = DEPTH - 1; z >= 0; z--) {
        for (int y = 0; y < HEIGHT; y++) {
            for (int x = 0; x < WIDTH; x++) {
                // create layer
                CALayer *layer = [CALayer layer];
                layer.frame = CGRectMake(0, 0, SIZE, SIZE);
                layer.position = CGPointMake(x * SPACING, y * SPACING);
                layer.zPosition = -z * SPACING;
                
                // set background color
                layer.backgroundColor = [UIColor colorWithWhite:1-z*(1.0/DEPTH) alpha:1].CGColor;
                
                // attach to scroll view
                [self.scrollView.layer addSublayer:layer];
            }
        }
    }
}

/// 排除可视区域之外的图层
- (void)draw3DMatrixInside {
    // set contenty size
    self.scrollView.contentSize = CGSizeMake((WIDTH - 1) * SPACING, (HEIGHT - 1) * SPACING);
    
    // set up perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / CAMERA_DISTANCE;
    self.scrollView.layer.sublayerTransform = transform;
}

- (void)updateLayers {
    // calculate clipping bounds
    CGRect bounds = self.scrollView.bounds;
    bounds.origin = self.scrollView.contentOffset;
    bounds = CGRectInset(bounds, -SIZE * 0.5, -SIZE * 0.5);
    
    // create layers
    NSMutableArray *visibleLayers = [NSMutableArray array];
    for (int z = DEPTH - 1; z >= 0; z--) {
        // increase bounds size to compensate for perspective
        CGRect adjusted = bounds;
        adjusted.size.width /= PERSPECTIVE(z * SPACING);
        adjusted.size.height /= PERSPECTIVE(z * SPACING);
        adjusted.origin.x -=  (adjusted.size.width - bounds.size.width) * 0.5;
        adjusted.origin.y -= (adjusted.size.height - bounds.size.height) * 0.5;
        
        for (int y = 0; y < HEIGHT; y++) {
            // check if vertically outside visible rect
            if (y * SPACING < adjusted.origin.y || y * SPACING >= adjusted.origin.y + adjusted.size.height) {
                continue;
            }
            
            for (int x = 0; x < WIDTH; x++) {
                // check if horionzally outside visible rect
                if (x * SPACING < adjusted.origin.x || x * SPACING >= adjusted.origin.x + adjusted.size.width) {
                    continue;
                }
                
                // create layer
                CALayer *layer = [CALayer layer];
                layer.frame = CGRectMake(0, 0, SIZE, SIZE);
                layer.position = CGPointMake(x * SPACING, y * SPACING);
                layer.zPosition = -z * SPACING;
                
                // set background color
                layer.backgroundColor = [UIColor colorWithWhite:1 - z * (1.0 / DEPTH) alpha:1].CGColor;
                
                // attach to scroll view
                [visibleLayers addObject:layer];
            }
        }
    }
    // update layers
    self.scrollView.layer.sublayers = visibleLayers;
}

- (void)updateLayers2 {
    // calculate clipping bounds
    CGRect bounds = self.scrollView.bounds;
    bounds.origin = self.scrollView.contentOffset;
    bounds = CGRectInset(bounds, -SIZE * 0.5, -SIZE * 0.5);
    
    // add existing layers to pool
    [self.recyclePool addObjectsFromArray:self.scrollView.layer.sublayers];
    // disable animation
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    // create layers
    NSInteger recycled = 0;
    NSMutableArray *visibleLayers = [NSMutableArray array];
    for (int z = DEPTH - 1; z >= 0; z--) {
        // increase bounds size to compensate for perspective
        CGRect adjusted = bounds;
        adjusted.size.width /= PERSPECTIVE(z * SPACING);
        adjusted.size.height /= PERSPECTIVE(z * SPACING);
        adjusted.origin.x -=  (adjusted.size.width - bounds.size.width) * 0.5;
        adjusted.origin.y -= (adjusted.size.height - bounds.size.height) * 0.5;
        
        for (int y = 0; y < HEIGHT; y++) {
            // check if vertically outside visible rect
            if (y * SPACING < adjusted.origin.y || y * SPACING >= adjusted.origin.y + adjusted.size.height) {
                continue;
            }
            
            for (int x = 0; x < WIDTH; x++) {
                // check if horionzally outside visible rect
                if (x * SPACING < adjusted.origin.x || x * SPACING >= adjusted.origin.x + adjusted.size.width) {
                    continue;
                }
                
                // recycle layer if available
                CALayer *layer = [self.recyclePool anyObject];
                if (layer) {
                    recycled++;
                    [self.recyclePool removeObject:layer];
                } else {
                    // create layer
                    CALayer *layer = [CALayer layer];
                    layer.frame = CGRectMake(0, 0, SIZE, SIZE);
                    layer.position = CGPointMake(x * SPACING, y * SPACING);
                    layer.zPosition = -z * SPACING;
                    
                    // set background color
                    layer.backgroundColor = [UIColor colorWithWhite:1 - z * (1.0 / DEPTH) alpha:1].CGColor;
                    
                    // attach to scroll view
                    [visibleLayers addObject:layer];
                }
            }
        }
    }
    [CATransaction commit]; // update layers
    // update layers
    self.scrollView.layer.sublayers = visibleLayers;
    [self.recyclePool removeAllObjects];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self updateLayers];
    [self updateLayers2];
}

#pragma mark - lazy

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

@end
