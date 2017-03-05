//
//  B32FromToTableViewCell.h
//  Timetable
//
//  Created by Vasiliy Fedotov on 11/01/17.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    B32FromToTableViewCellTypeFrom,
    B32FromToTableViewCellTypeTo
} B32FromToTableViewCellType;

@interface B32FromToTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fromToLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (nonatomic) NSString * fromToLabelText;
@property (nonatomic) NSString * fromToValueLabelText;

@property (nonatomic) B32FromToTableViewCellType type;

@end
