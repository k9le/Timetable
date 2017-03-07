//
//  B32ActiveIndicatorView.h
//  BouncesAnimation
//
//  Created by Vasiliy Fedotov on 07/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface B32ActiveIndicatorView : UIView

@property (nonatomic) IBInspectable UIColor * bounceColor;
@property (nonatomic) IBInspectable NSInteger bouncePairNumber;
@property (nonatomic) IBInspectable CGFloat distanceDiameterRatio;
@property (nonatomic) IBInspectable CGFloat delayAnimationRatio;
@property (nonatomic) IBInspectable CGFloat animationDuration;

@end
