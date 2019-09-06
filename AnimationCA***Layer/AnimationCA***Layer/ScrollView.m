//
//  ScrollView.m
//  AnimationCA***Layer
//
//  Created by chenshuang on 2019/8/31.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

+ (Class)layerClass {
    return [CAScrollLayer class];
}

- (void)setup {
    // enable clipping
    self.layer.masksToBounds = YES;
    
    // attach pan gesture recongnizer
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:recognizer];
    
    UIImage *image = [UIImage imageNamed:@"cat"];
    
    CALayer *imageLayer = [CALayer layer];
    [imageLayer setContentsScale:[[UIScreen mainScreen] scale]];
    [imageLayer setContents:(__bridge id)[image CGImage]];
    [imageLayer setBounds:CGRectMake(0.0, 0.0, [image size].width, [image size].height)];
    [imageLayer setAnchorPoint:CGPointMake(0.0, 0.0)];
    
    [(CAScrollLayer *)self.layer addSublayer:imageLayer];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    //get the offset by subtracting the pan gesture
    //translation from the current bounds origin
    CGPoint offset = self.bounds.origin;
    offset.x -= [recognizer translationInView:self].x;
    offset.y -= [recognizer translationInView:self].y;
    
    // scroll the layer
    [(CAScrollLayer *)self.layer scrollToPoint:offset];
    
    // reset the pan gesture translation
    [recognizer setTranslation:CGPointZero inView:self];
}

@end
