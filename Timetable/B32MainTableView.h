//
//  B32MainTableView.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 09/01/17.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B32MainTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithCoder:(NSCoder *)coder;

@property (nonatomic) NSDate * date;


@end
