//
//  TweetDetailsViewController.h
//  TwitterSearch
//
//  Created by Pravat Maskey on 3/29/16.
//  Copyright © 2016 Pravat Maskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetItem.h"
@interface TweetDetailsViewController : UITableViewController


@property (nonatomic, strong) TweetItem *tweetItem;
@end
