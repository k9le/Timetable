//
//  B32DatePickerTransitioningDelegate.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 24/02/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32DatePickerAnimatedTransitioning.h"
#import "B32MainView.h"

@interface B32DatePickerAnimatedTransitioning ()

@property (nonatomic) float duration;

@end


@implementation B32DatePickerAnimatedTransitioning

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _duration = 0.25f;
    }
    
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView * containerView = [transitionContext containerView];
    
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    CGRect initialRect = self.presenting ? self.dateControlFrame : [transitionContext initialFrameForViewController:fromVC];
    CGRect resultRect = self.presenting ? [transitionContext finalFrameForViewController:toVC] : self.dateControlFrame;
    
    CGFloat sX = self.presenting ?
                    initialRect.size.width / resultRect.size.width :
                    resultRect.size.width/ initialRect.size.width;
    CGFloat sY = self.presenting ?
                    initialRect.size.height / resultRect.size.height :
                    resultRect.size.height / initialRect.size.height;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(sX, sY);
    
    if(self.presenting)
    {
        toView.transform = transform;
        toView.alpha = 0.1f;
        toView.center = CGPointMake(CGRectGetMidX(initialRect), CGRectGetMidY(initialRect));
        
        [containerView addSubview:toView];
        
        [UIView animateKeyframesWithDuration:self.duration delay:0.f options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            [UIView addKeyframeWithRelativeStartTime:0.f relativeDuration:0.5f animations:^{
                float mainViewTransformRate = 3.5f;
                fromView.transform = CGAffineTransformMakeScale(mainViewTransformRate, mainViewTransformRate);
            }];
            [UIView addKeyframeWithRelativeStartTime:0.25f relativeDuration:0.75f animations:^{
                toView.transform = CGAffineTransformIdentity;
                toView.alpha = 1.f;
                toView.center = CGPointMake(CGRectGetMidX(resultRect), CGRectGetMidY(resultRect));
            }];
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        
    } else {
        [containerView addSubview:toView];
        [containerView bringSubviewToFront:fromView];
        
        [UIView animateKeyframesWithDuration:self.duration delay:0.f options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.85f animations:^{
                fromView.transform = transform;
                fromView.alpha = 0.f;
                fromView.center = CGPointMake(CGRectGetMidX(resultRect), CGRectGetMidY(resultRect));
            }];

            [UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:0.5f animations:^{
                toView.transform = CGAffineTransformIdentity;
            }];
            
        } completion:^(BOOL finished) {
            [fromView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

@end
