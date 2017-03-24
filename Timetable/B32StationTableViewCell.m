//
//  B32StationTableViewCell.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 04/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32StationTableViewCell.h"

@interface B32StationTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton * accessoryButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

- (void)accessoryButtonTapped:(id)sender event:(id)event;

@end


@implementation B32StationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.accessoryButton addTarget:self action:@selector(accessoryButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    
    UIImage * image = [UIImage imageNamed:@"Expand"];
    [self.accessoryButton setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.accessoryButton.imageView setTintColor:[UIColor grayColor]];
    
    [self.accessoryButton becomeFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)accessoryButtonTapped:(id)sender event:(id)event
{
    id view = [self superview];
    
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    
    UITableView *tableView = view;
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint: currentTouchPosition];

    if (indexPath != nil)
    {
        [tableView.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}

- (void)setStation:(B32StationItem *)station
{
    self.titleLabel.text = station.stationTitle;
    if(0 == [station.regionTitle length])
    {
        self.detailLabel.text = [NSString stringWithFormat:@"%@, %@", station.city.cityTitle, station.city.countryTitle];
    } else {
        self.detailLabel.text = [NSString stringWithFormat:@"%@, %@, %@", station.city.cityTitle, station.city.regionTitle, station.city.countryTitle];
    }
    
    _station = station;
}


@end
