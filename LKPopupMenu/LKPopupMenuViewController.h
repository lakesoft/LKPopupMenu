//
//  LKPopupMenuViewController.h
//  LKPopupMenu
//
//  Created by Hashiguchi Hiroshi on 11/10/09.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKPopupMenuController.h"

@interface LKPopupMenuViewController : UIViewController <LKPopupMenuControllerDelegate> {
    UIButton *popupButton;
    UITextField *title;
}

@property (nonatomic, retain) NSArray* list;

@property (nonatomic, retain) LKPopupMenuController* popupMenu;
@property (nonatomic, retain) LKPopupMenuController* sizeMenu;
@property (nonatomic, retain) LKPopupMenuController* colorMenu;
@property (nonatomic, retain) LKPopupMenuController* animationMenu;
@property (nonatomic, retain) LKPopupMenuController* imageMenu;

@property (nonatomic, retain) IBOutlet UITextField *menuTitle;

@property (nonatomic, assign) BOOL autoresizeEnabled;
@property (nonatomic, assign) BOOL autocloseEnabled;
@property (nonatomic, assign) BOOL bounceEnabled;
@property (nonatomic, assign) BOOL multipleSelectionEnabled;
@property (nonatomic, assign) BOOL shadowEnabled;
@property (nonatomic, assign) BOOL triangleEnabled;
@property (nonatomic, assign) BOOL modalEnabled;
@property (nonatomic, assign) BOOL separatorEnabled;
@property (nonatomic, assign) BOOL outlineEnabled;
@property (nonatomic, assign) BOOL titleHilighted;
@property (nonatomic, assign) BOOL closeButtonEnabled;

@property (nonatomic, assign) LKPopupMenuControllerSize menuSize;
@property (nonatomic, assign) LKPopupMenuControllerColor menuColor;
@property (nonatomic, assign) LKPopupMenuControllerAnimationMode animationMode;

- (IBAction)popupToDown:(id)sender;
- (IBAction)popupToRight:(id)sender;
- (IBAction)popupToLeft:(id)sender;
- (IBAction)popupToUp:(id)sender;
- (IBAction)popupWithoutTriangle:(id)sender;
- (IBAction)didChangeSizeMode:(id)sender;
- (IBAction)didChangeSelectionMode:(id)sender;
- (IBAction)didChangeShadowEnabled:(id)sender;
- (IBAction)didChangeColor:(id)sender;
- (IBAction)didChangeSize:(id)sender;
- (IBAction)didChangeTriangle:(id)sender;
- (IBAction)didChangeAnimationMode:(id)sender;
- (IBAction)didChangeModal:(id)sender;
- (IBAction)didChangeSeparator:(id)sender;
- (IBAction)didChangeOutline:(id)sender;
- (IBAction)openImageMenu:(id)sender;
- (IBAction)didChangeTitleHighlighted:(id)sender;
- (IBAction)didChangeAutoclose:(id)sender;
- (IBAction)didChangeBounce:(id)sender;
- (IBAction)didChangeCloseButton:(id)sender;

@end
