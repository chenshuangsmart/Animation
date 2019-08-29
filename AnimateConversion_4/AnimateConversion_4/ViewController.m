//
//  ViewController.m
//  AnimateConversion_4
//
//  Created by chenshuang on 2019/8/24.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKMatrix4.h>
#import <GLKit/GLKMatrix3.h>

#define LIGHT_DIRECTION 0,1,-0.5
#define AMBIENT_LIGHT 0.5

@interface ViewController ()
/** face */
@property(nonatomic, strong)NSMutableArray *faces;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self transform];
    
//    [self transformConcat];
    
//    [self transform3D];
    
//    [self transformM34];
    
//    [self sublayerTransform];
    
//    [self doubleSided];
    
    // 扁平化图层
//    [self innerOuter];
    
    // 绕Y轴相反的旋转变换
//    [self innerOuterY];
    
    // 创建一个立方体
    [self createCube];
}

- (void)transform {
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    catView.center = self.view.center;
    catView.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    [self.view addSubview:catView];
    
    // transform
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
    catView.layer.affineTransform = transform;
}

/// 混合变换
- (void)transformConcat {
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    catView.center = self.view.center;
    catView.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    [self.view addSubview:catView];
    
    // 混合变换
    CGAffineTransform transform = CGAffineTransformIdentity;
    // scale by 50%
    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    // rotate by 30 degrees
    transform = CGAffineTransformRotate(transform, M_PI / 180.0 * 30.0);
    // translate by 200 points
    transform = CGAffineTransformTranslate(transform, 200, 0);
    // appley transform to layer
    catView.layer.affineTransform = transform;
}

- (void)transform3D {
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    catView.center = self.view.center;
    catView.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    [self.view addSubview:catView];
    
    // rotate the layer 45 degrees along the Y axis
    CATransform3D transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    catView.layer.transform = transform;
}

- (void)transformM34 {
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    catView.center = self.view.center;
    catView.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    [self.view addSubview:catView];
    
    // create a new transform
    CATransform3D transform = CATransform3DIdentity;
    // apply perspective
    transform.m34 = -1.0 / 500.0;
    // rotate by 45 degrees along the Y axis
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    // apply to layer
    catView.layer.transform = transform;
}

- (void)sublayerTransform {
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 150, 150)];
    catView.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    [self.view addSubview:catView];
    
    UIView *catView1 = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 150, 150)];
    catView1.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    [self.view addSubview:catView1];
    
    // apply perspective transform to container
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500;

    self.view.layer.sublayerTransform = perspective;
    
    // rotate layerView1 by 45 degrees along the Y axis
    CATransform3D transform1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    catView.layer.transform = transform1;
    
    // rotate layerView2 by 45 degrees along the Y axis
    CATransform3D transform2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
    catView1.layer.transform = transform2;
}

- (void)doubleSided {
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 150, 150)];
    catView.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    [self.view addSubview:catView];
    
    // rotate layerView1 by 45 degrees along the Y axis
    CATransform3D transform1 = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    catView.layer.transform = transform1;
    
    catView.layer.doubleSided = NO;
}

- (void)innerOuter {
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    catView.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    catView.center = self.view.center;
    [self.view addSubview:catView];
    
    // rotate the outer layer 45 degrees
    CATransform3D outer = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    catView.layer.transform = outer;
    
    UIView *catView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 100, 100)];
    catView1.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    catView1.center = self.view.center;
    [self.view addSubview:catView1];
    
    // rotate the inner layer -45 degrees
    CATransform3D inner = CATransform3DMakeRotation(-M_PI_4, 0, 0, 1);
    catView1.layer.transform = inner;
}

- (void)innerOuterY {
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    catView.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    catView.center = self.view.center;
    [self.view addSubview:catView];
    
    // rotate the outer layer 45 degrees
    CATransform3D outer = CATransform3DIdentity;
    outer.m34 = -1.0 / 500.0;
    outer = CATransform3DRotate(outer, M_PI_4, 0, 1, 0);
    catView.layer.transform = outer;
    
    UIView *catView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 100, 100)];
    catView1.layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
    catView1.center = self.view.center;
    [self.view addSubview:catView1];
    
    // rotate the inner layer -45 degrees
    CATransform3D inner = CATransform3DIdentity;
    inner.m34 = -1.0 / 500.0;
    inner = CATransform3DRotate(inner, -M_PI_4, 0, 1, 0);
    catView1.layer.transform = inner;
}

/// 创建一个立方体
- (void)createCube {
    [self addCubeView];
    
    // set up the container sublayer transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    self.view.layer.sublayerTransform = perspective;
    
    // add cube face 1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 withTransform:transform];
    
    // add cube face 2
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    
    // add cube face 3
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    
    // add cube face 4
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    
    // add cube face 5
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    
    // add cube face 6
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:5 withTransform:transform];
}

- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform {
    // get the face view and add it to the container
    UIView *face = self.faces[index];
    [self.view addSubview:face];
    
    // center the face view within the container
    CGSize containerSize = self.view.bounds.size;
    face.center = CGPointMake(containerSize.width * 0.5, containerSize.height * 0.5);
    // apply the transform
    face.layer.transform = transform;
    
    // apply lighting - 光亮和阴影
    [self applyLightingToFace:face.layer];
}

- (void)addCubeView {
    self.faces = [NSMutableArray array];
    
    for (int i = 0; i < 6; i++) {
        UIView *cubeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        cubeView.layer.contents = (__bridge id)[UIImage imageNamed:[NSString stringWithFormat:@"%d",i + 1]].CGImage;
        [self.faces addObject:cubeView];
    }
}

#pragma mark - 光亮和阴影

- (void)applyLightingToFace:(CALayer *)face {
    // add lighting layer
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    
    // convert the face transform to matrix
    // GLKMatrix4 has the same structure as CATransform3D
    // 译者注：GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换，感谢[@zihuyishi](https://github.com/zihuyishi)同学~
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    
    // get face normal
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    
    // get dot product with light direction
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
    float dotProduct = GLKVector3DotProduct(light, normal);
    
    // set lighting layer opacity
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
}

@end
