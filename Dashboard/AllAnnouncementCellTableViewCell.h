//
//  AllAnnouncementCellTableViewCell.h
//  Dashboard
//
//  Created by Rafay Hasan on 8/22/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllAnnouncementCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bulletinTitle;
@property (weak, nonatomic) IBOutlet UILabel *bulletinDescription;
@property (weak, nonatomic) IBOutlet UILabel *bulletinDate;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *multiScheduleImageview;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;


@end
