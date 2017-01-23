//
//  B32FromToTableViewCell.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 11/01/17.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32FromToTableViewCell.h"

@implementation B32FromToTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *) fromToLabelText
{
    return [[self fromToLabel] text];
}

- (void) setFromToLabelText:(NSString *)newText
{
    [[self fromToLabel] setText:newText];
}

- (NSString *) fromToValueLabelText
{
    return [[self valueLabel] text];
}


- (void) setFromToValueLabelText:(NSString *)newText
{
    [[self valueLabel] setText:newText];
}


@end
