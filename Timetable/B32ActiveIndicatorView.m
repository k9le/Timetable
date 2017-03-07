//
//  B32ActiveIndicatorView.m
//  BouncesAnimation
//
//  Created by Vasiliy Fedotov on 07/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32ActiveIndicatorView.h"


@interface B32ActiveIndicatorView ()

- (void) createBounces;

@end

@implementation B32ActiveIndicatorView

-(void) drawRect:(CGRect)rect
{
    [self createBounces];
}

- (void) createBounces
{
    UIColor * bounceColor = self.bounceColor;
    
    CGRect frame = self.frame;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    CGFloat distanceDiameterRatio = self.distanceDiameterRatio;
    
    NSInteger bouncePairNumber = self.bouncePairNumber;
    
    CGFloat diameter = width/(bouncePairNumber * 2 + (bouncePairNumber + 1) * 2 * distanceDiameterRatio);
    CGFloat distance = distanceDiameterRatio * diameter;
    
    CGFloat delayAnimationRatio = self.delayAnimationRatio;
    CGFloat animationTimeR = 1.f / (2.f * bouncePairNumber * (1 + delayAnimationRatio) );
    CGFloat delayTimeR = delayAnimationRatio * animationTimeR;
    CGFloat delayBetweenBounceR = ((bouncePairNumber - 1) * animationTimeR + bouncePairNumber * delayTimeR);
    
    for(NSInteger i = 0; i < bouncePairNumber; ++i)
    {
        CALayer * layer = [CALayer layer];
        layer.backgroundColor = [[UIColor clearColor] CGColor];
        layer.frame = self.bounds;
        
        CGRect circleFrame1 = (1 == i % 2) ?
        CGRectMake(width/2.f - diameter/2.f, distance + i*(diameter + distance), diameter, diameter) :
        CGRectMake(distance + i*(diameter + distance), height/2.f - diameter/2.f, diameter, diameter);
        
        CGRect circleRect = CGRectMake(0.f, 0.f, diameter, diameter);
        
        UIBezierPath * circlePath1 = [UIBezierPath bezierPathWithOvalInRect:circleRect];
        
        CAShapeLayer * bounceLayer1 = [CAShapeLayer layer];
        bounceLayer1.frame = circleFrame1;
        bounceLayer1.backgroundColor = [[UIColor clearColor] CGColor];
        bounceLayer1.path = [circlePath1 CGPath];
        bounceLayer1.opacity = 1.f;
        bounceLayer1.fillColor = [bounceColor CGColor];
        [layer addSublayer:bounceLayer1];
        
        CGRect circleFrame2 = (1 == i % 2) ?
        CGRectMake(width/2.f - diameter/2.f, height - (i+1)*(diameter + distance), diameter, diameter) :
        CGRectMake(width - (i+1)*(diameter + distance), height/2.f - diameter/2.f, diameter, diameter);
        
        CAShapeLayer * bounceLayer2 = [CAShapeLayer layer];
        bounceLayer2.frame = circleFrame2;
        bounceLayer2.backgroundColor = [[UIColor clearColor] CGColor];
        bounceLayer2.path = [circlePath1 CGPath];
        bounceLayer2.opacity = 1.f;
        bounceLayer2.fillColor = [bounceColor CGColor];
        [layer addSublayer:bounceLayer2];
        
        CGFloat rotateValue = i*M_PI/4.f;
        layer.transform = CATransform3DMakeRotation(rotateValue, 0.0, 0.0, 1.0);
        
        float supple = (1 == i % 2) ? 1 : -1;
        
        NSArray * animationValues = @[@(rotateValue), @(rotateValue), @(rotateValue + M_PI / 2.f * supple), @(rotateValue + M_PI / 2.f * supple), @(rotateValue + M_PI * supple), @(rotateValue + M_PI * supple)];
        
        CGFloat startPos = (bouncePairNumber - 1 - i) * (animationTimeR + delayTimeR);
        NSArray * keyTimesValues = @[@(0.f), @(startPos), @(startPos + animationTimeR), @(startPos + animationTimeR + delayBetweenBounceR), @(startPos + animationTimeR + delayBetweenBounceR + animationTimeR), @(1.f)];
        
        
        CAKeyframeAnimation * keyframe = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        keyframe.values = animationValues;
        keyframe.keyTimes = keyTimesValues;
        keyframe.duration = self.animationDuration;
        keyframe.repeatCount = INFINITY;
        
        [layer addAnimation:keyframe forKey:@"rotationZ"];
        
        [[self layer] addSublayer:layer];
    }
}

@end
