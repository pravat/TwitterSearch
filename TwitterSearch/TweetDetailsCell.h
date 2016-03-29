//
//  TweetDetailsCell.h
//  TwitterSearch
//
//  Created by Pravat Maskey on 3/29/16.
//  Copyright © 2016 Pravat Maskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetDetailsCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;
@property (weak, nonatomic) IBOutlet UILabel *lblTweetText;
@property (weak, nonatomic) IBOutlet UIImageView *imgMainImage;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;

@end
