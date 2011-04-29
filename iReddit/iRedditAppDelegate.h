//
//  iRedditAppDelegate.h
//  iReddit
//
//  Created by Bryce Penberthy on 4/28/11.
//  Copyright 2011 Servo Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iRedditAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
