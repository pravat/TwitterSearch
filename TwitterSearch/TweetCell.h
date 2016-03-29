//
//  TweetCell.h
//  TwitterSearch
//
//  Created by Pravat Maskey on 3/28/16.
//  Copyright © 2016 Pravat Maskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgTweet;
@property (weak, nonatomic) IBOutlet UILabel *lblTweet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageWidth;

@end
