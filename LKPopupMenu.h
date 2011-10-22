//
//  LKPopupMenu.h
//  LKPopupMenu
//
//  Created by Hashiguchi Hiroshi on 11/10/09.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//------------------------------------------------------------------------------
// Constants
//------------------------------------------------------------------------------
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

typedef enum {
    LKPopupMenuColorDefault = 0,
    LKPopupMenuColorBlack,
    LKPopupMenuColorWhite,
    LKPopupMenuColorGray
} LKPopupMenuColor;

typedef enum {
    LKPopupMenuAnimationModeNone = 0,
    LKPopupMenuAnimationModeSlide,
    LKPopupMenuAnimationModeOpenClose,
    LKPopupMenuAnimationModeFade
} LKPopupMenuAnimationMode;

#define LKPopupMenuBlankImage   @"LKPopupMenuBlankImage"


@class LKPopupMenu;
//------------------------------------------------------------------------------
@protocol LKPopupMenuDelegate <NSObject>
//------------------------------------------------------------------------------
@optional
- (void)willAppearPopupMenu:(LKPopupMenu*)popupMenu;
- (void)willDisappearPopupMenu:(LKPopupMenu*)popupMenu;
- (void)didSelectPopupMenu:(LKPopupMenu*)popupMenu atIndex:(NSUInteger)index;

@end

//------------------------------------------------------------------------------
@interface LKPopupMenuAppearance : NSObject
//------------------------------------------------------------------------------
// color
@property (nonatomic, retain) UIColor* menuBackgroundColor;
@property (nonatomic, retain) UIColor* menuTextColor;
@property (nonatomic, retain) UIColor* menuHilightedColor;
@property (nonatomic, retain) UIColor* titleBackgroundColor;
@property (nonatomic, retain) UIColor* titleTextColor;
@property (nonatomic, retain) UIColor* checkMarkColor;
@property (nonatomic, retain) UIColor* separatorColor;
@property (nonatomic, retain) UIColor* outlineColor;
@property (nonatomic, assign) UIScrollViewIndicatorStyle indicatorStyle;

// size
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat listWidth;
@property (nonatomic, assign) CGFloat listHeight;
@property (nonatomic, assign) CGFloat outlineWith;

+ (LKPopupMenuAppearance*)defaultAppearanceWithSize:(LKPopupMenuSize)menuSize;
+ (LKPopupMenuAppearance*)defaultAppearanceWithSize:(LKPopupMenuSize)menuSize color:(LKPopupMenuColor)menuColor;

@end


//------------------------------------------------------------------------------
@interface LKPopupMenu : NSObject
//------------------------------------------------------------------------------
// Properties (data)
@property (nonatomic, retain) NSArray* textList;
@property (nonatomic, retain) NSArray* imageFilenameList;
@property (nonatomic, retain) NSIndexSet* selectedIndexSet;
@property (nonatomic, copy) NSString* title;

// Properties (delegate)
@property (nonatomic, assign) id <LKPopupMenuDelegate> delegate;

// Properties (modes)
@property (nonatomic, assign) LKPopupMenuSelectionMode selectionMode;
@property (nonatomic, assign) LKPopupMenuArrangementMode arrangementMode;
@property (nonatomic, assign) LKPopupMenuHeightSizeMode heightSizeMode;
@property (nonatomic, assign) LKPopupMenuAnimationMode animationMode;
@property (nonatomic, assign) BOOL modalEnabled;

// Properties (info)
@property (nonatomic, assign, readonly) UIView* parentView;
@property (nonatomic, assign, readonly) BOOL shown;

// Appearances
@property (nonatomic, retain) LKPopupMenuAppearance* appearance;
@property (nonatomic, assign) BOOL shadowEnabled;
@property (nonatomic, assign) BOOL triangleEnabled;
@property (nonatomic, assign) BOOL separatorEnabled;
@property (nonatomic, assign) BOOL outlineEnabled;
@property (nonatomic, assign) BOOL titleHighlighted;

// API
+ (LKPopupMenu*)popupMenuOnView:(UIView*)parentView;
+ (LKPopupMenu*)popupMenuOnView:(UIView*)parentView appearacne:(LKPopupMenuAppearance*)appearance;

- (void)showAtLocation:(CGPoint)location;
- (void)hide;

@end
