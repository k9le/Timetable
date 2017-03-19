//
//  B32StationsViewController.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 04/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B32StationsDataSource.h"

@interface B32StationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic) B32StationsDataSource * stationsDataSource;
@property (nonatomic, readonly) BOOL showFrom;

@end
