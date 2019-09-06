//
//  ReflectionView.m
//  AnimationCA***Layer
//
//  Created by chenshuang on 2019/8/31.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ReflectionView.h"

@implementation ReflectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

+ (Class)layerClass {
    return [CAReplicatorLayer class];
}

- (void)setup {
    //configure replicator
    CAReplicatorLayer *replicatorLayer = (CAReplicatorLayer *)self.layer;
    replicatorLayer.instanceCount = 2;
    
    //move reflection instance below original and flip vertically
    CATransform3D transform = CATransform3DIdentity;
    CGFloat verticalOffset = self.bounds.size.height + 2;
    transform = CATransform3DTranslate(transform, 0, verticalOffset, 0);
    transform = CATransform3DScale(transform, 1, -1, 0);
    replicatorLayer.instanceTransform = transform;
    
    //reduce alpha of reflection layer
    replicatorLayer.instanceAlphaOffset = -0.6;
    
    UIImage *image = [UIImage imageNamed:@"cat"];
    
    CALayer *imageLayer = [CALayer layer];
    [imageLayer setContentsScale:[[UIScreen mainScreen] scale]];
    [imageLayer setContents:(__bridge id)[image CGImage]];
    [imageLayer setBounds:CGRectMake(0.0, 0.0, [image size].width, [image size].height)];
    [imageLayer setAnchorPoint:CGPointMake(0.0, 0.0)];
    
    [replicatorLayer addSublayer:imageLayer];
}

@end
