//
//  B32StationVastTableViewCell.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 23/03/2017.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32StationVastTableViewCell.h"

@import GoogleMaps;

@interface B32StationVastTableViewCell ()

@property (weak, nonatomic) IBOutlet GMSMapView * mapView;

@property (weak, nonatomic) IBOutlet UIButton *accessoryButton;

@property (weak, nonatomic) IBOutlet UILabel *stationValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryValueLabel;

@end

@implementation B32StationVastTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [self.accessoryButton addTarget:self action:@selector(accessoryButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    
    UIImage * image = [UIImage imageNamed:@"Collapse"];
    [self.accessoryButton setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.accessoryButton.imageView setTintColor:[UIColor grayColor]];
    
    [self.accessoryButton becomeFirstResponder];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStation:(B32StationItem *)station
{
    self.stationValueLabel.text = station.stationTitle;
    self.regionValueLabel.text = station.city.regionTitle;
    self.countryValueLabel.text = station.city.countryTitle;
    
    [self.mapView clear];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(station.point.latitude, station.point.longitude);
    marker.title = station.stationTitle;
    marker.map = self.mapView;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:station.point.latitude
                                                            longitude:station.point.longitude                                                                 zoom:6];
    [self.mapView moveCamera:[GMSCameraUpdate setCamera:camera]];
    
    _station = station;
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


@end
