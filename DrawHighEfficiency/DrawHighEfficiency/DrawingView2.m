//
//  DrawingView2.m
//  DrawHighEfficiency
//
//  Created by chenshuang on 2019/10/30.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "DrawingView2.h"

#define BRUSH_SIZE 32

@interface DrawingView2()
@property (nonatomic, strong) NSMutableArray *strokes;
@end

@implementation DrawingView2

//- (void)drawRect:(CGRect)rect {
//    // redraw strokes
//    for (NSValue *value in self.strokes) {
//        // get point
//        CGPoint point = [value CGPointValue];
//
//        // get brush rect
//        CGRect brushRect = CGRectMake(point.x - BRUSH_SIZE/2, point.y - BRUSH_SIZE/2, BRUSH_SIZE, BRUSH_SIZE);
//
//        // draw brush stroke
//        [[UIImage imageNamed:@"pancil"] drawInRect:brushRect];
//    }
//}

- (void)drawRect:(CGRect)rect {
    // redraw strokes
    for (NSValue *value in self.strokes) {
        // get point
        CGPoint point = [value CGPointValue];
        
        // get brush rect
        CGRect brushRect = [self brushRectForPoint:point];
        
        // only draw brush stroke if it intersects dirty rect
        if (CGRectIntersectsRect(rect, brushRect)) {
            // draw brush stroke
            [[UIImage imageNamed:@"pancil"] drawInRect:brushRect];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    // add brush stroke
    [self addBrushStrokeAtPoint:point];
}

- (void)addBrushStrokeAtPoint:(CGPoint)point {
    //add brush stroke to array
    [self.strokes addObject:[NSValue valueWithCGPoint:point]];
    
    // needs redraw
//    [self setNeedsDisplay];
    
    // 用-setNeedsDisplayInRect:来减少不必要的绘制
    [self setNeedsDisplayInRect:[self brushRectForPoint:point]];
}

- (CGRect)brushRectForPoint:(CGPoint)point {
    return CGRectMake(point.x - BRUSH_SIZE/2, point.y - BRUSH_SIZE/2, BRUSH_SIZE, BRUSH_SIZE);
}

- (NSMutableArray *)strokes {
    if (!_strokes) {
        _strokes = [NSMutableArray array];
    }
    return _strokes;
}

@end
