//
//  LKPopupMenu.m
//  LKPopupMenu
//
//  Created by Hashiguchi Hiroshi on 11/10/09.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "LKPopupMenu.h"

//------------------------------------------------------------------------------
@interface LKPopupMenuSizeModel : NSObject
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGSize defaultSize;

+ (LKPopupMenuSizeModel*)modelForMenuSize:(LKPopupMenuSize)menuSize;
@end

@implementation LKPopupMenuSizeModel
@synthesize titleHeight, cellHeight, fontSize, defaultSize;

static NSDictionary* models_ = nil;
+ (LKPopupMenuSizeModel*)modelForMenuSize:(LKPopupMenuSize)menuSize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        LKPopupMenuSizeModel* model = nil;
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        
        model = [[[LKPopupMenuSizeModel alloc] init] autorelease];
        model.titleHeight = 25.0;
        model.cellHeight = 30.0;
        model.fontSize = 12.0;
        model.defaultSize = CGSizeMake(120.0, 150.0);
        [dict setObject:model forKey:[NSNumber numberWithInt:LKPopupMenuSizeSmall]];
        
        model = [[[LKPopupMenuSizeModel alloc] init] autorelease];
        model.titleHeight = 30.0;
        model.cellHeight = 35.0;
        model.fontSize = 14.0;
        model.defaultSize = CGSizeMake(160.0, 190.0);
        [dict setObject:model forKey:[NSNumber numberWithInt:LKPopupMenuSizeMedium]];
        
        model = [[[LKPopupMenuSizeModel alloc] init] autorelease];
        model.titleHeight = 35.0;
        model.cellHeight = 40.0;
        model.fontSize = 17.0;
        model.defaultSize = CGSizeMake(200.0, 230.0);
        [dict setObject:model forKey:[NSNumber numberWithInt:LKPopupMenuSizeLarge]];
        
        models_ = dict;
    });
    
    return [models_ objectForKey:[NSNumber numberWithInt:menuSize]];
}
            
@end

//------------------------------------------------------------------------------
@class LKPopupMenuView;
@interface LKPopupMenu() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) UIView* parentView;
@property (nonatomic, retain) LKPopupMenuView* popupMenuView;

@end

//------------------------------------------------------------------------------
#define LK_POPUP_MENU_PADDING   2.0
#define LK_POPUP_MENU_MARGIN    2.0
#define LK_POPUP_MENU_PROJECTION_LONG          16.0
#define LK_POPUP_MENU_PROJECTION_SHORT         10.0

#define LK_POPUP_MENU_SHADOW_OFFSET 5.0

@interface LKPopupMenuView : UIView
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) LKPopupMenu* popupMenu;
@property (nonatomic, assign) UITableView* tableView;
@property (nonatomic, assign) CGRect tableFrame;
@property (nonatomic, assign) CGFloat shadowOffset;
@property (nonatomic, assign) CGFloat titleHeight;

- (void)reloadData;

@end

@implementation LKPopupMenuView
@synthesize location = location_;
@synthesize popupMenu = popupMenu_;
@synthesize tableView = tableView_;
@synthesize tableFrame = tableFrame_;
@synthesize shadowOffset = shadowOffset_;
@synthesize titleHeight = titleHeight_;

- (id)initWithPopupMenu:(LKPopupMenu*)popupMenu Location:(CGPoint)location title:(NSString*)title
{
    LKPopupMenuSizeModel* sizeModel = [LKPopupMenuSizeModel modelForMenuSize:popupMenu.menuSize];
    
    self.popupMenu = popupMenu;
    self.location = location;
    self.shadowOffset = self.popupMenu.shadowEnabled ? LK_POPUP_MENU_SHADOW_OFFSET : 0;
    if (title && [[title stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceCharacterSet]] length] > 0) {
        self.titleHeight = sizeModel.titleHeight;
    } else {
        self.titleHeight = 0.0;
    }

    // setup list size
    CGFloat listWidth, listHeight;
    listWidth = self.popupMenu.fixedWidth;
    if (self.popupMenu.heightSizeMode == LKPopupMenuHeightSizeModeAuto) {
        listHeight = sizeModel.cellHeight * [self.popupMenu.list count] + self.titleHeight;
    } else {
        listHeight = self.popupMenu.fixedHeight;
    }
    
    // setup menu size
    CGFloat menuWidth, menuHeight;
    menuWidth = listWidth + LK_POPUP_MENU_PADDING*2 + self.shadowOffset;
    menuHeight = listHeight + LK_POPUP_MENU_PADDING*2 + self.shadowOffset;

    switch (self.popupMenu.arrangementMode) {
        case LKPopupMenuArrangementModeUp:
            menuHeight += LK_POPUP_MENU_PROJECTION_SHORT;
            break;
            
        case LKPopupMenuArrangementModeDown:
            menuHeight += LK_POPUP_MENU_PROJECTION_SHORT;
            break;
            
        case LKPopupMenuArrangementModeRight:
            menuWidth += LK_POPUP_MENU_PROJECTION_SHORT;
            break;
            
        case LKPopupMenuArrangementModeLeft:
            menuWidth += LK_POPUP_MENU_PROJECTION_SHORT;
            break;
    }

    // adjust origin and size
    CGFloat menuX, menuY;    
    switch (self.popupMenu.arrangementMode) {
        case LKPopupMenuArrangementModeUp:
            menuX = self.location.x - menuWidth/2.0;
            menuY = self.location.y - menuHeight;
            break;
            
        case LKPopupMenuArrangementModeDown:
            menuX = self.location.x - menuWidth/2.0;
            menuY = self.location.y;
            break;
            
        case LKPopupMenuArrangementModeRight:
            menuX = self.location.x;
            menuY = self.location.y - menuHeight/2.0;
            break;
            
        case LKPopupMenuArrangementModeLeft:
            menuX = self.location.x - menuWidth;
            menuY = self.location.y - menuHeight/2.0;
            break;
    }

    CGSize parentViewSize = self.popupMenu.parentView.frame.size;

    if (menuX < 0) {
        menuX = LK_POPUP_MENU_MARGIN;
        if ((menuX + menuWidth) > parentViewSize.width) {
            CGFloat deltaW = (parentViewSize.width - menuX - LK_POPUP_MENU_MARGIN) - menuWidth;
            menuWidth += deltaW;
            listWidth += deltaW;
        }
    }
    CGFloat deltaX = parentViewSize.width - (menuX + menuWidth);
    if (deltaX < 0 && fabs(deltaX) < menuX) {
        menuX += deltaX;
    }

    if (menuY < 0) {
        menuY = LK_POPUP_MENU_MARGIN;
        if ((menuY + menuHeight) > parentViewSize.height) {
            CGFloat deltaH = (parentViewSize.height - menuY - LK_POPUP_MENU_MARGIN) - menuHeight;
            menuHeight += deltaH;
            listHeight += deltaH;
        }
    }
    CGFloat deltaY = parentViewSize.height - (menuY + menuHeight);
    if (deltaY < 0 && fabs(deltaY) < menuY) {
        menuY += deltaY;
    }
    
    
    menuX = floor(menuX + 0.5);
    menuY = floor(menuY + 0.5);

    CGRect frame = CGRectMake(menuX, menuY, menuWidth, menuHeight);

    self = [super initWithFrame:frame];
    if (self) {
        // setup table view
        CGFloat tableX = LK_POPUP_MENU_PADDING;
        CGFloat tableY = LK_POPUP_MENU_PADDING;
        switch (self.popupMenu.arrangementMode) {
            case LKPopupMenuArrangementModeUp:
                break;
                
            case LKPopupMenuArrangementModeDown:
                tableY += LK_POPUP_MENU_PROJECTION_SHORT;
                break;
                
            case LKPopupMenuArrangementModeRight:
                tableX += LK_POPUP_MENU_PROJECTION_SHORT;
                break;
                
            case LKPopupMenuArrangementModeLeft:
                break;
        }

        self.tableFrame = CGRectMake(tableX, tableY, listWidth, listHeight);
        self.tableView = [[[UITableView alloc] initWithFrame:self.tableFrame
                                                       style:UITableViewStylePlain] autorelease];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = YES;
        self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.tableView.bounces = NO;
        
        self.tableView.backgroundColor = [UIColor clearColor];
        CALayer* layer = self.tableView.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 5.0;
        
        if (title && [[title stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceCharacterSet]] length] > 0) {
            UILabel* titleLabel = [[[UILabel alloc] initWithFrame:
                                    CGRectMake(0, 0, self.tableView.frame.size.width, self.titleHeight)] autorelease];
            titleLabel.adjustsFontSizeToFitWidth = YES;
            titleLabel.font = [UIFont boldSystemFontOfSize:sizeModel.fontSize];
            titleLabel.textColor = self.popupMenu.titleTextColor;
            titleLabel.backgroundColor = self.popupMenu.titleBackgroundColor;   
            titleLabel.minimumFontSize = sizeModel.fontSize;
            
            titleLabel.text = title;
            self.tableView.tableHeaderView = titleLabel;
        }

        self.tableView.dataSource = popupMenu;
        self.tableView.delegate = popupMenu;

        [self addSubview:self.tableView];

        // setup basics
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc {
    self.popupMenu = nil;
    if (self.tableView) {
        [self.tableView removeFromSuperview];
    }
    self.tableView = nil;
    [super dealloc];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (UIBezierPath*)_projectionBezierPath
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGPoint p = [self convertPoint:self.location fromView:self.superview];
    
    switch (self.popupMenu.arrangementMode) {
        case LKPopupMenuArrangementModeUp:
            p.y -= self.shadowOffset;
            [path moveToPoint:p];
            p.x -= LK_POPUP_MENU_PROJECTION_LONG/2.0;
            p.y -= LK_POPUP_MENU_PROJECTION_SHORT + LK_POPUP_MENU_PADDING;
            [path addLineToPoint:p];
            p.x += LK_POPUP_MENU_PROJECTION_LONG;
            [path addLineToPoint:p];
            break;
            
        case LKPopupMenuArrangementModeDown:
            [path moveToPoint:p];
            p.x -= LK_POPUP_MENU_PROJECTION_LONG/2.0;
            p.y += LK_POPUP_MENU_PROJECTION_SHORT + LK_POPUP_MENU_PADDING;
            [path addLineToPoint:p];
            p.x += LK_POPUP_MENU_PROJECTION_LONG;
            [path addLineToPoint:p];
            break;
            
        case LKPopupMenuArrangementModeRight:
            [path moveToPoint:p];
            p.x += LK_POPUP_MENU_PROJECTION_SHORT + LK_POPUP_MENU_PADDING;
            p.y -= LK_POPUP_MENU_PROJECTION_LONG/2.0;
            [path addLineToPoint:p];
            p.y += LK_POPUP_MENU_PROJECTION_LONG;
            [path addLineToPoint:p];
            break;
            
        case LKPopupMenuArrangementModeLeft:
            p.x -= self.shadowOffset;
            [path moveToPoint:p];
            p.x -= LK_POPUP_MENU_PROJECTION_SHORT + LK_POPUP_MENU_PADDING;
            p.y -= LK_POPUP_MENU_PROJECTION_LONG/2.0;
            [path addLineToPoint:p];
            p.y += LK_POPUP_MENU_PROJECTION_LONG;
            [path addLineToPoint:p];
            break;
    }
    [path closePath];
    
    return path;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:self.tableFrame cornerRadius:5.0];
    UIBezierPath* projectionPath = [self _projectionBezierPath];

    CGContextRef context = UIGraphicsGetCurrentContext();

    if (self.popupMenu.arrangementMode == LKPopupMenuArrangementModeDown && self.titleHeight) {
        [self.popupMenu.titleBackgroundColor setFill];
        
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context,CGSizeMake(self.shadowOffset, self.shadowOffset), self.shadowOffset, [[UIColor colorWithWhite:0.0 alpha:1.0] CGColor]);
        [projectionPath fill];
        CGContextRestoreGState(context);

    } else {
        [path appendPath:projectionPath];
    }

    [self.popupMenu.menuBackgroundColor setFill];

    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context,CGSizeMake(self.shadowOffset, self.shadowOffset), self.shadowOffset, [[UIColor colorWithWhite:0.0 alpha:1.0] CGColor]);
    [path fill];
    CGContextRestoreGState(context);


}

@end

//------------------------------------------------------------------------------
@interface LKPopupMenuCell : UITableViewCell

+ (LKPopupMenuCell*)cellForTableView:(UITableView*)tableView popupMenu:(LKPopupMenu*)popupMenu;
@property (nonatomic, assign) UIColor* hilightedColor;

@end

@implementation LKPopupMenuCell
@synthesize hilightedColor = hilightedColor_;

+ (LKPopupMenuCell*)cellForTableView:(UITableView*)tableView popupMenu:(LKPopupMenu*)popupMenu
{
    static NSString *cellIdentifier = @"LKPopupMenuCell";
    
    LKPopupMenuCell *cell = (LKPopupMenuCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        LKPopupMenuSizeModel* sizeModel = [LKPopupMenuSizeModel modelForMenuSize:popupMenu.menuSize];

        cell = [[[LKPopupMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:sizeModel.fontSize];
        cell.textLabel.textColor = popupMenu.menuTextColor;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.hilightedColor = popupMenu.menuHilightedColor;
    }
    return cell;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.contentView.backgroundColor = self.hilightedColor;
    } else {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

- (void)dealloc {
    self.hilightedColor = nil;
    [super dealloc];
}
@end

//------------------------------------------------------------------------------
@implementation LKPopupMenu
//------------------------------------------------------------------------------
@synthesize list = list_;
@synthesize selectedIndexSet = selectedIndexSet_;
@synthesize delegate = delegate_;
@synthesize selectionMode = selectionMode_;
@synthesize arrangementMode = arrangementMode_;
@synthesize parentView = parentView_;
@synthesize title = title_;
@synthesize shown = shown_;
@synthesize shadowEnabled = shadowEnabled_;

@synthesize heightSizeMode = heightSizeMode_;
@synthesize fixedWidth = fixedWidth_;
@synthesize fixedHeight = fixedHeight_;

@synthesize menuSize = menuSize_;

@synthesize popupMenuView = popupMenuView_;

// colors
@synthesize menuBackgroundColor;
@synthesize menuTextColor;
@synthesize titleBackgroundColor;
@synthesize titleTextColor;
@synthesize menuHilightedColor;

#pragma mark -
#pragma mark Basics

- (void)_resetColors
{
    self.menuBackgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
    self.menuTextColor = [UIColor whiteColor];
    self.titleBackgroundColor = [UIColor colorWithWhite:0.0 alpha:0.85];
    self.titleTextColor = [UIColor whiteColor];
    self.menuHilightedColor = [UIColor colorWithWhite:0.5 alpha:0.5];    
}

- (id)initWithView:(UIView*)parentView
{
    self = [super init];
    if (self) {
        self.parentView = parentView;
        self.heightSizeMode = LKPopupMenuHeightSizeModeAuto;
        self.selectionMode = LKPopupMenuSelectionModeSingle;
        self.arrangementMode = LKPopupMenuArrangementModeDown;
        self.shadowEnabled = YES;
        self.selectedIndexSet = [NSMutableSet set];
        self.menuSize = LKPopupMenuSizeMedium;

        [self _resetColors];
    }
    return self;
}

- (void)dealloc {
    self.list = nil;
    self.delegate = nil;
    if (self.popupMenuView) {
        [self.popupMenuView removeFromSuperview];
    }
    self.popupMenuView = nil;
    self.parentView = nil;
    self.title = nil;

    self.selectedIndexSet = nil;

    self.menuBackgroundColor = nil;
    self.menuTextColor = nil;
    self.titleBackgroundColor = nil;
    self.titleTextColor = nil;
    self.menuHilightedColor = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark API
+ (LKPopupMenu*)popupMenuOnView:(UIView*)parentView
{
    return [[[self alloc] initWithView:parentView] autorelease];
}

- (void)showAtLocation:(CGPoint)location
{
    if ([self.delegate respondsToSelector:@selector(willAppearPopupMenu:)]) {
        [self.delegate willAppearPopupMenu:self];
    }

    if (self.popupMenuView) {
        [self.popupMenuView removeFromSuperview];
        self.popupMenuView = nil;
    }

    // create new popup mewnu view
    NSString* title = self.title ? [@" " stringByAppendingString:self.title] : nil;
    self.popupMenuView = [[[LKPopupMenuView alloc] initWithPopupMenu:self
                                                            Location:location
                                                               title:title
                           ] autorelease];
    self.popupMenuView.alpha = 0.0;
    [self.parentView addSubview:self.popupMenuView];
    if (self.popupMenuView.alpha == 0.0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.popupMenuView.alpha = 1.0;            
        }];
    }
}

- (void)hide
{
    if (self.popupMenuView && self.popupMenuView.alpha) {
        if ([self.delegate respondsToSelector:@selector(willDisappearPopupMenu:)]) {
            [self.delegate willDisappearPopupMenu:self];
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.popupMenuView.alpha = 0.0;            
        }];
    }
}


#pragma mark -
#pragma mark Properties

- (BOOL)shown
{
    return (self.popupMenuView.alpha);
}

- (void)setMenuSize:(LKPopupMenuSize)menuSize
{
    menuSize_ = menuSize;

    LKPopupMenuSizeModel* sizeModel = [LKPopupMenuSizeModel modelForMenuSize:self.menuSize];
    self.fixedWidth = sizeModel.defaultSize.width;
    self.fixedHeight = sizeModel.defaultSize.height;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKPopupMenuCell* cell = [LKPopupMenuCell cellForTableView:tableView popupMenu:self];
    if ([self.selectedIndexSet containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [self.list objectAtIndex:indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LKPopupMenuSizeModel* sizeModel = [LKPopupMenuSizeModel modelForMenuSize:self.menuSize];
    return sizeModel.cellHeight;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.selectionMode == LKPopupMenuSelectionModeSingle) {
        [self.selectedIndexSet removeAllObjects];
        [self.selectedIndexSet addObject:indexPath];
        if ([self.delegate respondsToSelector:@selector(didSelectPopupMenu:atIndex:)]) {
            [self.delegate didSelectPopupMenu:self atIndex:indexPath.row];
        }
        [self hide];
    } else {
        if ([self.selectedIndexSet containsObject:indexPath]) {
            [self.selectedIndexSet removeObject:indexPath];
        } else {
            [self.selectedIndexSet addObject:indexPath];            
        }
        if ([self.delegate respondsToSelector:@selector(didSelectPopupMenu:atIndex:)]) {
            [self.delegate didSelectPopupMenu:self atIndex:indexPath.row];
        }
        [self.popupMenuView reloadData];
    }
}

@end
