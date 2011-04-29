//
//  CommentsViewController.m
//  iReddit
//
//  Created by Bryce Penberthy on 4/28/11.
//  Copyright 2011 Servo Labs, LLC. All rights reserved.
//

#import "CommentsViewController.h"


@implementation CommentsViewController

@synthesize comments;


- (void)dealloc
{
    self.comments = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comments count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    NSString *comment = [[[self.comments objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"body"];
    CGFloat cellHeight = [comment sizeWithFont:[UIFont systemFontOfSize:15.0] 
                             constrainedToSize:CGSizeMake(self.tableView.bounds.size.width, CGFLOAT_MAX) 
                                 lineBreakMode:UILineBreakModeWordWrap].height;
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
    NSString *comment = [[[self.comments objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"body"];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.text = comment;    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id replies = [[[self.comments objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"replies"];
    if ([replies isKindOfClass:[NSDictionary class]] && [replies count]) {
        NSString *comment = [[[self.comments objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"body"];
        
        CommentsViewController *commentsViewController = [[[CommentsViewController alloc] init] autorelease];   
        commentsViewController.comments = [[replies objectForKey:@"data"] objectForKey:@"children"];
        commentsViewController.navigationItem.title = comment;
        
        [self.navigationController pushViewController:commentsViewController
                                             animated:YES];
    }
}

@end
