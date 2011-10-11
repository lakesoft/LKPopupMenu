//
//  LKPopupMenuViewController.h
//  LKPopupMenu
//
//  Created by Hashiguchi Hiroshi on 11/10/09.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKPopupMenu.h"

@interface LKPopupMenuViewController : UIViewController <LKPopupMenuDelegate> {
    UIButton *popupButton;
    UITextField *title;
}

@property (nonatomic, retain) NSArray* list;

@property (nonatomic, retain) LKPopupMenu* popupMenu;
@property (nonatomic, retain) LKPopupMenu* sizeMenu;
@property (nonatomic, retain) LKPopupMenu* colorMenu;
@property (nonatomic, retain) IBOutlet UITextField *menuTitle;

@property (nonatomic, assign) LKPopupMenuHeightSizeMode sizeMode;
@property (nonatomic, assign) LKPopupMenuSelectionMode selectionMode;
@property (nonatomic, assign) BOOL shadowEnabled;
@property (nonatomic, assign) BOOL triangleEnabled;

@property (nonatomic, assign) LKPopupMenuSize menuSize;
@property (nonatomic, assign) LKPopupMenuColor menuColor;

- (IBAction)popupToDown:(id)sender;
- (IBAction)popupToRight:(id)sender;
- (IBAction)popupToLeft:(id)sender;
- (IBAction)popupToUp:(id)sender;
- (IBAction)didChangeSizeMode:(id)sender;
- (IBAction)didChangeSelectionMode:(id)sender;
- (IBAction)didChangeShadowEnabled:(id)sender;
- (IBAction)didChangeColor:(id)sender;
- (IBAction)didChangeSize:(id)sender;
- (IBAction)didChangeTriangle:(id)sender;

@end
