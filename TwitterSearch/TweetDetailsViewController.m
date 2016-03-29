//
//  TweetDetailsViewController.m
//  TwitterSearch
//
//  Created by Pravat Maskey on 3/29/16.
//  Copyright © 2016 Pravat Maskey. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "TweetDetailsCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
@interface TweetDetailsViewController ()

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tweetItem) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetDetailsCell" forIndexPath:indexPath];
    NSDictionary *user = [_tweetItem objectForKey:@"user"];
    NSString *profile_image_url_https = [user objectForKey:@"profile_image_url_https"];
    [cell.imgUser sd_setImageWithURL:[NSURL URLWithString:profile_image_url_https] placeholderImage:[UIImage imageNamed:@"twitterPlaceholder"]];
    
    NSString *userName = [user objectForKey:@"name" ];
    cell.lblUsername.text =userName;
    
    NSString *screenName = [user objectForKey:@"screen_name"];
    cell.lblScreenName.text = screenName;
    
    NSDictionary *tweetEntities = [_tweetItem objectForKey:@"entities"];
    NSArray *media = [tweetEntities objectForKey:@"media"];
    cell.lblTweetText.text = [_tweetItem objectForKey:@"text"];
    if (media != nil) {
        NSDictionary *mediaItem = [media objectAtIndex:0];
        if (mediaItem != nil) {
            NSString *media_url_https = [mediaItem objectForKey:@"media_url_https"];
            if (media_url_https != nil) {
                NSString *media_url_https_thumb = [NSString stringWithFormat:@"%@:thumb", media_url_https];
                
                [cell.imgMainImage sd_setImageWithURL:[NSURL URLWithString:media_url_https_thumb] placeholderImage:[UIImage imageNamed:@"twitterPlaceholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
                
            }
            
        }
        
    }
    else{
        //or change design
    }
    
    NSString *createdDateStr =  [_tweetItem objectForKey:@"created_at"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM d HH:mm:ss Z y"];
    NSDate *date = [dateFormatter dateFromString:createdDateStr];
    
    [dateFormatter setDateFormat:@"d/m/y, HH:MM"];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    cell.lblDateTime.text = strDate;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
