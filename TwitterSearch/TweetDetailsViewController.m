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
    
    
    cell.lblUsername.text = self.tweetItem.User.Name;
    cell.lblScreenName.text = self.tweetItem.User.ScreenName;
    cell.lblTweetText.text = self.tweetItem.Text;
    
    
    if (self.tweetItem.User.ProfileImageURL) {
        [cell.imgUser sd_setImageWithURL:[NSURL URLWithString:self.tweetItem.User.ProfileImageURL] placeholderImage:[UIImage imageNamed:@"twitterPlaceholder"]];
    }
    
    
    
    if (self.tweetItem.TweetImage.hasImage) {
        [cell.imgMainImage sd_setImageWithURL:[NSURL URLWithString:self.tweetItem.TweetImage.LargeImageURL] placeholderImage:[UIImage imageNamed:@"twitterPlaceholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        //we can create single instance for placeholder image by
        //dispatch_once(<#dispatch_once_t *predicate#>, <#^(void)block#>)
    }
    
    else{
        //or change design
    }
    
    
    cell.lblDateTime.text = self.tweetItem.CreatedDate;
    
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
