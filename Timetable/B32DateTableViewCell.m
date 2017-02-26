//
//  B32DateTableViewCell.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 11/01/17.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32DateTableViewCell.h"

@interface B32DateTableViewCell ()

{
    NSDateFormatter * _dateFormatter;
}

@end



@implementation B32DateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [_dateFormatter setLocale: [NSLocale localeWithLocaleIdentifier:@"ru_RU"]];
        [_dateFormatter setLocalizedDateFormatFromTemplate:@"dMMMMEEEE"];
        
        self.actualDate = [NSDate date];
        
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(dateLabel)) options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(dateValueLabel)) options:NSKeyValueObservingOptionNew context:nil];

    }
    
    return self;
}

- (void) setActualDate: (NSDate *) date
{
    _actualDate = date;
    
    NSString * dateText = [_dateFormatter stringFromDate: self.actualDate];
    
    [[self dateValueLabel] setText:dateText];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(dateLabel))]) {
        [[self dateLabel] setText:@"Дата"];
        return;
    }
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(dateValueLabel))]) {
        if ( nil != change[NSKeyValueChangeNewKey] && nil == change[NSKeyValueChangeOldKey])
        {
            [self setActualDate:[NSDate date]];
        }
        return;
    }
}

@end
