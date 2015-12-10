//
//  CHMagnifierView.m
//  Magnifier
//
//  Created by Chenhao on 14-2-25.
//  Copyright (c) 2014年 Chenhao. All rights reserved.
//

#import "CHMagnifierView.h"

@interface CHMagnifierView ()

@property (strong, nonatomic) CALayer *contentLayer;

@end

@implementation CHMagnifierView


- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 200, 50);
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.windowLevel = UIWindowLevelAlert;

        self.contentLayer = [CALayer layer];
        self.contentLayer.frame = self.bounds;
        
        self.contentLayer.delegate = self;
        self.contentLayer.contentsScale = [[UIScreen mainScreen] scale];
        [self.layer addSublayer:self.contentLayer];
    }
    
    return self;
}

- (void)setPointToMagnify:(CGPoint)pointToMagnify
{
    _pointToMagnify = pointToMagnify;
    
    CGPoint center = CGPointMake(pointToMagnify.x, self.center.y);
    if (pointToMagnify.y > CGRectGetHeight(self.bounds) * 0.5) {
        center.y = pointToMagnify.y -  CGRectGetHeight(self.bounds) / 2;
    }
    self.center = center;
    [self.contentLayer setNeedsDisplay];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextTranslateCTM(ctx, self.frame.size.width * 0.5, self.frame.size.height * 0.5);
	CGContextScaleCTM(ctx, 1.5, 1.5);
	CGContextTranslateCTM(ctx, -1 * self.pointToMagnify.x, -1 * self.pointToMagnify.y - 30);
    [self.viewToMagnify.layer renderInContext:ctx];
}


@end
