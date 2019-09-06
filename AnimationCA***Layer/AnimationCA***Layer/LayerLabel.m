//
//  LayerLabel.m
//  AnimationCA***Layer
//
//  Created by chenshuang on 2019/8/31.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "LayerLabel.h"

@implementation LayerLabel

+ (Class)layerClass {
    // this makes our label create a catextlayer
    // instead of a regular CALayer for its backing layer
    return [CATextLayer class];
}

- (CATextLayer *)textLayer {
    return (CATextLayer *)self.layer;
}

- (void)setup {
    // set defaults from uilabel settings
    self.text = self.text;
    self.textColor = self.textColor;
    self.font = self.font;
    
    // we should really derive these from the UILabel settings too
    // but that's complicated, so for now we'll just hard-code them
    [self textLayer].alignmentMode = kCAAlignmentJustified;
    
    [self textLayer].wrapped = YES;
    [self.layer display];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    // called when creating label using Interface Builder
    [self setup];
}

- (void)setText:(NSString *)text {
    super.text = text;
    // set layer text
    [self textLayer].string = text;
}

- (void)setFont:(UIFont *)font {
    super.font = font;
    // set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    [self textLayer].font = fontRef;
    [self textLayer].fontSize = font.pointSize;
    
    CGFontRelease(fontRef);
}

@end

