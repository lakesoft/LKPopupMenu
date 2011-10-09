//
//  LKPopupMenu.h
//  LKPopupMenu
//
//  Created by Hashiguchi Hiroshi on 11/10/09.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LKPopupMenuSelectionModeSingle = 0,
    LKPopupMenuSelectionModeMultiple
} LKPopupMenuSelectionMode;

typedef enum {
    LKPopupMenuHeightSizeModeAuto = 0,
    LKPopupMenuHeightSizeModeFixed
} LKPopupMenuHeightSizeMode;

typedef enum {
    LKPopupMenuArrangementModeUp = 0,
    LKPopupMenuArrangementModeDown,
    LKPopupMenuArrangementModeLeft,
    LKPopupMenuArrangementModeRight
    
} LKPopupMenuArrangementMode;

typedef enum {
    LKPopupMenuSizeSmall = 0,
    LKPopupMenuSizeMedium,
    LKPopupMenuSizeLarge
} LKPopupMenuSize;

@class LKPopupMenu;
@protocol LKPopupMenuDelegate <NSObject>
@optional
- (void)willAppearPopupMenu:(LKPopupMenu*)popupMenu;
- (void)willDisappearPopupMenu:(LKPopupMenu*)popupMenu;
- (void)didSelectPopupMenu:(LKPopupMenu*)popupMenu atIndex:(NSUInteger)index;

@end


@interface LKPopupMenu : NSObject

// Properties (data)
@property (nonatomic, retain) NSArray* list;
@property (nonatomic, retain) NSMutableSet* selectedIndexSet;
@property (nonatomic, copy) NSString* title;

// Properties (delegate)
@property (nonatomic, assign) id <LKPopupMenuDelegate> delegate;

// Properties (modes)
@property (nonatomic, assign) LKPopupMenuSelectionMode selectionMode;
@property (nonatomic, assign) LKPopupMenuArrangementMode arrangementMode;
@property (nonatomic, assign) LKPopupMenuHeightSizeMode heightSizeMode;
@property (nonatomic, assign) CGFloat fixedWidth;
@property (nonatomic, assign) CGFloat fixedHeight;
@property (nonatomic, assign) BOOL shadowEnabled;
@property (nonatomic, assign) LKPopupMenuSize menuSize;

// Properties (info)
@property (nonatomic, assign, readonly) UIView* parentView;
@property (nonatomic, assign, readonly) BOOL shown;

// Properties (colors)
@property (nonatomic, retain) UIColor* menuBackgroundColor;
@property (nonatomic, retain) UIColor* menuTextColor;
@property (nonatomic, retain) UIColor* titleBackgroundColor;
@property (nonatomic, retain) UIColor* titleTextColor;
@property (nonatomic, retain) UIColor* menuHilightedColor;

// API
+ (LKPopupMenu*)popupMenuOnView:(UIView*)parentView;
- (void)showAtLocation:(CGPoint)location;
- (void)hide;

@end
