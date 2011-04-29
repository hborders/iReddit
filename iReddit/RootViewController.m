//
//  RootViewController.m
//  iReddit
//
//  Created by Bryce Penberthy on 4/28/11.
//  Copyright 2011 Servo Labs, LLC. All rights reserved.
//

#import "RootViewController.h"
#import "JSON.h"
#import "CommentsViewController.h"

@interface RootViewController() 

@property(nonatomic, retain) NSArray *redditLinks;

@end

@implementation RootViewController

@synthesize redditLinks = _redditLinks;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSData *redditData = 
        [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.reddit.com/.json" ]]
                          returningResponse:nil 
                                      error:nil];
    NSString *redditJson = [[[NSString alloc] initWithData:redditData encoding:NSUTF8StringEncoding] autorelease];
    
    NSDictionary *redditDataDict = [redditJson JSONValue];
        
    self.redditLinks = [[redditDataDict objectForKey:@"data"] objectForKey:@"children"];
//    NSLog(@"Our Reddit Dictionary %@", self.redditLinks);
    
    self.navigationItem.title = @"Reddit";
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.redditLinks count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    NSString *title = [[[self.redditLinks objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"title"];
    CGFloat cellHeight = [title sizeWithFont:[UIFont systemFontOfSize:15.0] 
                           constrainedToSize:CGSizeMake(self.tableView.bounds.size.width, CGFLOAT_MAX) 
                               lineBreakMode:UILineBreakModeWordWrap].height;
    NSLog(@"Cell height: %f  %@", cellHeight, title);
    return cellHeight;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell
    NSString *title = [[[self.redditLinks objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"title"];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.text = title;    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = [[[self.redditLinks objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"title"];
    NSString *path = [[[self.redditLinks objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"permalink"];
    
    NSURL *storyUrl = [NSURL URLWithString:[@"http://www.reddit.com" stringByAppendingFormat:@"%@.json", path]];
    NSData *storyData = 
        [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:storyUrl]
                              returningResponse:nil
                                          error:nil];
    NSArray *storyAndComments = [[[[NSString alloc] initWithData:storyData
                                                        encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    NSDictionary *commentsDict = [storyAndComments objectAtIndex:1];
    NSArray *comments = [[commentsDict objectForKey:@"data"] objectForKey:@"children"];
    
    CommentsViewController *commentsViewController = [[[CommentsViewController alloc] init] autorelease];   
    commentsViewController.comments = comments;
    commentsViewController.navigationItem.title = title;
    
    [self.navigationController pushViewController:commentsViewController
                                         animated:YES];
}

- (void)viewDidUnload
{
    self.redditLinks = nil;
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    self.redditLinks = nil;
    [super dealloc];
}

@end
