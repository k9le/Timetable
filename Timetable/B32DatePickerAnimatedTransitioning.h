//
//  B32DatePickerTransitioningDelegate.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 24/02/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface B32DatePickerAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL presenting;
@property (nonatomic) CGRect dateControlFrame;

@end
