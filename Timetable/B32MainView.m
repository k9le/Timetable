//
//  B32MainView.m
//  Timetable
//
//  Created by Vasiliy Fedotov on 19/01/17.
//  Copyright © 2017 Vasiliy Fedotov. All rights reserved.
//

#import "B32MainView.h"
#import "B32MainTableView.h"
#import "B32DateTableViewCell.h"

@interface B32MainView ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomConstraint;

//

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingsViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingsViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingsViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;
- (void)layoutSubviews;

@property (weak, nonatomic) IBOutlet B32MainTableView *mainTableView;

@end


@implementation B32MainView

- (void)layoutSubviews
{
    // bottom indent
    CGRect viewSize = [self bounds];

    CGFloat height = viewSize.size.height;
    
    [[self settingsViewBottomConstraint] setConstant:height/6.f];
    
    // settingsView height
    UIView * sView = self.subviews[1];
    
    UITableView * tView = sView.subviews[0];
    CGFloat tableViewHeight = tView.contentSize.height;
    CGFloat tableViewWidth = tView.contentSize.width - tView.separatorInset.left - tView.separatorInset.right;
    CGFloat tableViewRowHeight = tView.rowHeight;
    
    self.buttonWidthConstraint.constant = tableViewWidth;
    self.buttonHeightConstraint.constant = tableViewRowHeight;
    
    CGFloat settingsViewHeight = tableViewHeight + tableViewRowHeight + self.tableViewTopConstraint.constant +
    self.tableViewBottomConstraint.constant + self.buttonBottomConstraint.constant;
    
    self.settingsViewHeightConstraint.constant = settingsViewHeight;
}

- (CGRect)dateControlFrame
{
    for ( UITableViewCell * cell in self.mainTableView.visibleCells)
    {
        if(NO == [cell isKindOfClass:[B32DateTableViewCell class]]) continue;
        B32DateTableViewCell * dateCell = cell;
        
        return [self convertRect:dateCell.frame fromView:self.mainTableView];
    }
    
    return CGRectZero;
}

@end
