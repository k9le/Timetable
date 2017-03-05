//
//  B32StationsViewController.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 04/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B32StationsDataSource.h"

@interface B32StationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) B32StationsDataSource * stationsDataSource;

@end
