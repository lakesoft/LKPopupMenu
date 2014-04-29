//
//  LKPopupMenuAppDelegate.h
//  LKPopupMenu
//
//  Created by Hashiguchi Hiroshi on 11/10/09.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKPopupMenuViewController;

@interface LKPopupMenuAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet LKPopupMenuViewController *viewController;

@end
