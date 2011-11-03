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
@implementation LKPopupMenuAppearance
//------------------------------------------------------------------------------
// colors
@synthesize menuBackgroundColor;
@synthesize menuTextColor;
@synthesize titleBackgroundColor;
@synthesize titleTextColor;
@synthesize menuHilightedColor;
@synthesize checkMarkColor;
@synthesize separatorColor;
@synthesize outlineColor;
@synthesize indicatorStyle;

// size
@synthesize titleHeight;
@synthesize cellHeight;
@synthesize fontSize;
@synthesize listWidth, listHeight;
@synthesize outlineWith;

+ (LKPopupMenuAppearance*)defaultAppearanceWithSize:(LKPopupMenuSize)menuSize color:(LKPopupMenuColor)menuColor
{
    LKPopupMenuAppearance* appearance = [[[LKPopupMenuAppearance alloc] init] autorelease];

    // setup sizes
    switch (menuSize) {
        case LKPopupMenuSizeSmall:
            appearance.titleHeight = 25.0;
            appearance.cellHeight = 30.0;
            appearance.fontSize = 12.0;
            appearance.listWidth = 120.0;
            appearance.listHeight = 150.0;
            appearance.outlineWith = 1.0;
            break;
            
        case LKPopupMenuSizeMedium:
            appearance.titleHeight = 30.0;
            appearance.cellHeight = 35.0;
            appearance.fontSize = 14.0;
            appearance.listWidth = 160.0;
            appearance.listHeight = 190.0;
            appearance.outlineWith = 2.0;
            break;
            
        case LKPopupMenuSizeLarge:
            appearance.titleHeight = 35.0;
            appearance.cellHeight = 40.0;
            appearance.fontSize = 17.0;
            appearance.listWidth = 200.0;
            appearance.listHeight = 230.0;
            appearance.outlineWith = 3.0;
            break;
            
        default:
            break;
    }

    // setup colors
    switch (menuColor) {
        case LKPopupMenuColorDefault:
        case LKPopupMenuColorBlack:
            appearance.menuBackgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
            appearance.menuTextColor = [UIColor whiteColor];
            appearance.menuHilightedColor = [UIColor colorWithWhite:0.5 alpha:0.5];    
            appearance.titleBackgroundColor = [UIColor colorWithWhite:0.0 alpha:0.85];
            appearance.titleTextColor = [UIColor whiteColor];
            appearance.checkMarkColor = [UIColor whiteColor];
            appearance.separatorColor = [UIColor colorWithWhite:0.5 alpha:0.9];
            appearance.outlineColor   = [UIColor whiteColor];
            appearance.indicatorStyle = UIScrollViewIndicatorStyleWhite;            
            break;

        case LKPopupMenuColorWhite:
            appearance.menuBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.85];
            appearance.menuTextColor = [UIColor colorWithWhite:0.25 alpha:1.0];
            appearance.menuHilightedColor = [UIColor colorWithWhite:0.75 alpha:1.0];
            appearance.titleBackgroundColor = [UIColor colorWithWhite:0.85 alpha:0.95];
            appearance.titleTextColor = [UIColor colorWithWhite:0.35 alpha:1.0];
            appearance.checkMarkColor = [UIColor darkGrayColor];
            appearance.separatorColor = [UIColor colorWithWhite:1.0 alpha:1.0];
            appearance.outlineColor   = [UIColor whiteColor];
            appearance.indicatorStyle = UIScrollViewIndicatorStyleBlack;
            break;

        case LKPopupMenuColorGray:
            appearance.menuBackgroundColor = [UIColor colorWithWhite:0.75 alpha:0.9];
            appearance.menuTextColor = [UIColor whiteColor];
            appearance.menuHilightedColor = [UIColor colorWithWhite:0.6 alpha:0.9];
            appearance.titleBackgroundColor = [UIColor colorWithWhite:0.5 alpha:0.9];
            appearance.titleTextColor = [UIColor whiteColor];
            appearance.checkMarkColor = [UIColor whiteColor];
            appearance.separatorColor = [UIColor colorWithWhite:0.85 alpha:0.9];
            appearance.outlineColor   = [UIColor whiteColor];
            appearance.indicatorStyle = UIScrollViewIndicatorStyleBlack;
            break;
            
        default:
            break;
    }


    return appearance;
}

+ (LKPopupMenuAppearance*)defaultAppearanceWithSize:(LKPopupMenuSize)menuSize
{
    return [self defaultAppearanceWithSize:menuSize color:LKPopupMenuColorDefault];
}

- (void)dealloc
{
    self.menuBackgroundColor = nil;
    self.menuTextColor = nil;
    self.menuHilightedColor = nil;
    self.titleBackgroundColor = nil;
    self.titleTextColor = nil;
    self.checkMarkColor = nil;
    self.separatorColor = nil;
    self.outlineColor = nil;
    [super dealloc];
}
            
@end


@class LKPopupMenuView;
@class LKPopupBackgroundView;
//==============================================================================
@interface LKPopupMenu() <UITableViewDelegate, UITableViewDataSource>
//==============================================================================

@property (nonatomic, assign) UIView* parentView;
@property (nonatomic, retain) LKPopupMenuView* popupMenuBaseView;
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, retain) LKPopupBackgroundView* backgroundView;
@property (nonatomic, retain) NSMutableIndexSet* indexSet;

@end

//------------------------------------------------------------------------------
@interface LKPopupBackgroundView : UIView
//------------------------------------------------------------------------------
@property (nonatomic, assign) LKPopupMenu* popupMenu;
@end
@implementation LKPopupBackgroundView
@synthesize popupMenu;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.popupMenu hide];
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
@end


//==============================================================================
@interface LKPopupMenuTitleView : UIView
//==============================================================================
@property (nonatomic, assign) CATextLayer* textLayer;
@property (nonatomic, assign) CAGradientLayer* gradientLayer;
- (id)initWithFrame:(CGRect)frame popupMenu:(LKPopupMenu*)popupMenu;
@end

//------------------------------------------------------------------------------
@implementation LKPopupMenuTitleView
//------------------------------------------------------------------------------
#define LK_POPUP_MENU_PADDING_X     10.0

@synthesize textLayer = textLayer_;
@synthesize gradientLayer = gradientLayer_;

- (id)initWithFrame:(CGRect)frame popupMenu:(LKPopupMenu*)popupMenu
{
    self = [super initWithFrame:frame];
    if (self) {
        // setup basics
        self.backgroundColor = popupMenu.appearance.titleBackgroundColor;
                
        // setup gradient layer
        if (popupMenu.titleHighlighted) {
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = self.bounds;
            self.gradientLayer.locations = [NSArray arrayWithObjects:
                                            [NSNumber numberWithFloat:0.0],
                                            [NSNumber numberWithFloat:0.5],
                                            [NSNumber numberWithFloat:0.5],
                                            [NSNumber numberWithFloat:1.0],
                                            nil];
            self.gradientLayer.colors =
                [NSArray arrayWithObjects:
                 (id)[UIColor colorWithWhite:1.0 alpha:0.6].CGColor,
                 (id)[UIColor colorWithWhite:1.0 alpha:0.4].CGColor,
                 (id)[UIColor colorWithWhite:1.0 alpha:0.3].CGColor,
                 (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
                 nil];

            [self.layer addSublayer:self.gradientLayer];
        }
        
        // setup text layer
        self.textLayer = [CATextLayer layer];
        
        self.textLayer.string = popupMenu.title;
        UIFont* font = [UIFont boldSystemFontOfSize:popupMenu.appearance.fontSize];
        CGSize textSize = [popupMenu.title sizeWithFont:font];
        self.textLayer.frame = CGRectMake(LK_POPUP_MENU_PADDING_X,
                                          (self.frame.size.height - textSize.height)/2.0 + 3,
                                          self.frame.size.width - LK_POPUP_MENU_PADDING_X*2,
                                          textSize.height);
        self.textLayer.font = CGFontCreateWithFontName((CFStringRef)font.fontName);
        self.textLayer.fontSize = popupMenu.appearance.fontSize;
        self.textLayer.foregroundColor = popupMenu.appearance.titleTextColor.CGColor;
        self.textLayer.truncationMode = kCATruncationEnd;
        self.textLayer.alignmentMode = kCAAlignmentLeft;
        [self.layer addSublayer:self.textLayer];
        
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}
@end



//==============================================================================
@interface LKPopupMenuView : UIView
//==============================================================================
#define LK_POPUP_MENU_PADDING   2.0
#define LK_POPUP_MENU_MARGIN    2.0
#define LK_POPUP_MENU_TRIANGLE_LONG          22.0
#define LK_POPUP_MENU_TRIANGLE_SHORT         14.0

#define LK_POPUP_MENU_SHADOW_OFFSET 2.5
#define LK_POPUP_MENU_CORNER_RADIUS    5.0

typedef enum {
    LKPopupMenuViewTypeBase,
    LKPopupMenuViewTypeFrame
} LKPopupMenuViewType;

@property (nonatomic, assign) LKPopupMenu* popupMenu;
@property (nonatomic, assign) UITableView* tableView;
@property (nonatomic, assign) CGRect tableFrame;
@property (nonatomic, assign) CGFloat shadowOffset;
@property (nonatomic, assign) CGSize triangleSize;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, retain) UIBezierPath* path;
@property (nonatomic, assign) LKPopupMenuViewType type;

- (id)initAsBaseWithPopupMenu:(LKPopupMenu*)popupMenu location:(CGPoint)location title:(NSString*)title;
- (id)initAsFrameWithPopupMenu:(LKPopupMenu*)popupMenu location:(CGPoint)location title:(NSString*)title;
- (void)setupPathAtLocation:(CGPoint)location;
- (void)reloadData;

@end


//------------------------------------------------------------------------------
@implementation LKPopupMenuView
//------------------------------------------------------------------------------
@synthesize popupMenu = popupMenu_;
@synthesize tableView = tableView_;
@synthesize tableFrame = tableFrame_;
@synthesize shadowOffset = shadowOffset_;
@synthesize triangleSize = triangleSize_;
@synthesize titleHeight = titleHeight_;
@synthesize path = path_;
@synthesize type = type_;

- (void)setupPathAtLocation:(CGPoint)location
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    path.lineJoinStyle = kCGLineJoinRound;
    
    CGPoint p = self.tableFrame.origin;
    CGPoint tp = location;
    
    p.x += LK_POPUP_MENU_CORNER_RADIUS;
    [path moveToPoint:p];
    
    // upper
    if (self.popupMenu.triangleEnabled &&
        self.popupMenu.arrangementMode == LKPopupMenuArrangementModeDown) {
        p.x = tp.x - self.triangleSize.width/2.0;
        [path addLineToPoint:p];
        p.x += self.triangleSize.width/2.0;
        p.y -= self.triangleSize.height;
        [path addLineToPoint:p];
        p.x += self.triangleSize.width/2.0;
        p.y += self.triangleSize.height;
        [path addLineToPoint:p];
        p.x = self.tableFrame.origin.x + self.tableFrame.size.width - LK_POPUP_MENU_CORNER_RADIUS;
        [path addLineToPoint:p];
    } else {
        p.x += self.tableFrame.size.width - LK_POPUP_MENU_CORNER_RADIUS*2;
        [path addLineToPoint:p];
    }
    
    // upper right
    p.y += LK_POPUP_MENU_CORNER_RADIUS;
    [path addArcWithCenter:p
                    radius:LK_POPUP_MENU_CORNER_RADIUS
                startAngle:-1.0*M_PI/2.0
                  endAngle:0.0*M_PI/2.0
                 clockwise:YES];
    
    // right
    p.x += LK_POPUP_MENU_CORNER_RADIUS;
    if (self.popupMenu.triangleEnabled &&
        self.popupMenu.arrangementMode == LKPopupMenuArrangementModeLeft) {
        p.y = tp.y - self.triangleSize.width/2.0;
        [path addLineToPoint:p];
        p.x += self.triangleSize.height;
        p.y += self.triangleSize.width/2.0;
        [path addLineToPoint:p];
        p.x -= self.triangleSize.height;
        p.y += self.triangleSize.width/2.0;
        [path addLineToPoint:p];
        p.y = self.tableFrame.origin.y + self.tableFrame.size.height - LK_POPUP_MENU_CORNER_RADIUS;
        [path addLineToPoint:p];
    } else {
        p.y += self.tableFrame.size.height - LK_POPUP_MENU_CORNER_RADIUS*2;
        [path addLineToPoint:p];
    }
    
    // lower right
    p.x -= LK_POPUP_MENU_CORNER_RADIUS;    
    [path addArcWithCenter:p
                    radius:LK_POPUP_MENU_CORNER_RADIUS
                startAngle:0.0*M_PI/2.0
                  endAngle:1.0*M_PI/2.0
                 clockwise:YES];
    
    // lower
    p.y += LK_POPUP_MENU_CORNER_RADIUS;
    if (self.popupMenu.triangleEnabled &&
        self.popupMenu.arrangementMode == LKPopupMenuArrangementModeUp) {
        p.x = tp.x + self.triangleSize.width/2.0;
        [path addLineToPoint:p];
        p.x -= self.triangleSize.width/2.0;
        p.y += self.triangleSize.height;
        [path addLineToPoint:p];
        p.x -= self.triangleSize.width/2.0;
        p.y -= self.triangleSize.height;
        [path addLineToPoint:p];
        p.x = self.tableFrame.origin.x + LK_POPUP_MENU_CORNER_RADIUS;
        [path addLineToPoint:p];
    } else {
        p.x -= self.tableFrame.size.width - LK_POPUP_MENU_CORNER_RADIUS*2;
        [path addLineToPoint:p];
    }
    
    // lower left
    p.y -= LK_POPUP_MENU_CORNER_RADIUS;
    [path addArcWithCenter:p
                    radius:LK_POPUP_MENU_CORNER_RADIUS
                startAngle:1.0*M_PI/2.0
                  endAngle:2.0*M_PI/2.0
                 clockwise:YES];
    
    // left
    p.x -= LK_POPUP_MENU_CORNER_RADIUS;
    if (self.popupMenu.triangleEnabled &&
        self.popupMenu.arrangementMode == LKPopupMenuArrangementModeRight) {
        p.y = tp.y + self.triangleSize.width/2.0;
        [path addLineToPoint:p];
        p.x -= self.triangleSize.height;
        p.y -= self.triangleSize.width/2.0;
        [path addLineToPoint:p];
        p.x += self.triangleSize.height;
        p.y -= self.triangleSize.width/2.0;
        [path addLineToPoint:p];
        p.y = self.tableFrame.origin.y + LK_POPUP_MENU_CORNER_RADIUS;
        [path addLineToPoint:p];
    } else {
        p.y -= self.tableFrame.size.height - LK_POPUP_MENU_CORNER_RADIUS*2;
        [path addLineToPoint:p];
    }
    
    // upper left
    p.x += LK_POPUP_MENU_CORNER_RADIUS;
    [path addArcWithCenter:p
                    radius:LK_POPUP_MENU_CORNER_RADIUS
                startAngle:2.0*M_PI/2.0
                  endAngle:3.0*M_PI/2.0
                 clockwise:YES];
    [path closePath];

    self.path = path;
}

 - (id)_initAsType:(LKPopupMenuViewType)type WithPopupMenu:(LKPopupMenu*)popupMenu location:(CGPoint)location title:(NSString*)title
{
    self.type = type;
    self.popupMenu = popupMenu;
    LKPopupMenuAppearance* appearance = popupMenu.appearance;
    
    self.shadowOffset = self.popupMenu.shadowEnabled ? LK_POPUP_MENU_SHADOW_OFFSET : 0;
    self.triangleSize = CGSizeMake(LK_POPUP_MENU_TRIANGLE_LONG, LK_POPUP_MENU_TRIANGLE_SHORT);

    if (title && [[title stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceCharacterSet]] length] > 0) {
        self.titleHeight = appearance.titleHeight;
    } else {
        self.titleHeight = 0.0;
    }

    // setup list size
    CGFloat listWidth, listHeight;
    listWidth = appearance.listWidth;
    if (self.popupMenu.heightSizeMode == LKPopupMenuHeightSizeModeAuto) {
        listHeight = appearance.cellHeight * [self.popupMenu.textList count] + self.titleHeight;
    } else {
        listHeight = appearance.listHeight;
    }
    
    // setup menu size
    CGFloat menuWidth, menuHeight;
    menuWidth = listWidth + LK_POPUP_MENU_PADDING*2 + self.shadowOffset;
    menuHeight = listHeight + LK_POPUP_MENU_PADDING*2 + self.shadowOffset;

    switch (self.popupMenu.arrangementMode) {
        case LKPopupMenuArrangementModeUp:
            menuHeight += self.triangleSize.height;
            break;
            
        case LKPopupMenuArrangementModeDown:
            menuHeight += self.triangleSize.height;
            break;
            
        case LKPopupMenuArrangementModeRight:
            menuWidth += self.triangleSize.height;
            break;
            
        case LKPopupMenuArrangementModeLeft:
            menuWidth += self.triangleSize.height;
            break;
    }

    // adjust origin and size
    CGFloat menuX, menuY;    
    switch (self.popupMenu.arrangementMode) {
        case LKPopupMenuArrangementModeUp:
            menuX = location.x - menuWidth/2.0;
            menuY = location.y - menuHeight;
            break;
            
        case LKPopupMenuArrangementModeDown:
            menuX = location.x - menuWidth/2.0;
            menuY = location.y;
            break;
            
        case LKPopupMenuArrangementModeRight:
            menuX = location.x;
            menuY = location.y - menuHeight/2.0;
            break;
            
        case LKPopupMenuArrangementModeLeft:
            menuX = location.x - menuWidth;
            menuY = location.y - menuHeight/2.0;
            break;
    }

    CGSize parentViewSize = self.popupMenu.parentView.frame.size;
    CGFloat delta;

    if (menuX < 0) {
        if (self.popupMenu.arrangementMode == LKPopupMenuArrangementModeLeft ||
            self.popupMenu.arrangementMode == LKPopupMenuArrangementModeRight) {
            menuWidth += menuX - LK_POPUP_MENU_MARGIN;
            listWidth += menuX - LK_POPUP_MENU_MARGIN;
        }
        menuX = LK_POPUP_MENU_MARGIN;
    }

    delta = parentViewSize.width - (menuX + menuWidth + LK_POPUP_MENU_MARGIN);
    if (delta < 0) {
        if (-delta < menuX) {
            menuX += delta;
        } else {
            if (self.popupMenu.arrangementMode == LKPopupMenuArrangementModeUp ||
                self.popupMenu.arrangementMode == LKPopupMenuArrangementModeDown) {
                if (LK_POPUP_MENU_MARGIN < menuX) {
                    delta += menuX - LK_POPUP_MENU_MARGIN;
                    if (delta > 0) {
                        delta = 0;
                    }
                    menuX = LK_POPUP_MENU_MARGIN;
                }
            }
            menuWidth += delta;
            listWidth+= delta;
        }
    }

    if (menuY < 0) {
        if (self.popupMenu.arrangementMode == LKPopupMenuArrangementModeUp ||
            self.popupMenu.arrangementMode == LKPopupMenuArrangementModeDown) {
            menuHeight += menuY - LK_POPUP_MENU_MARGIN;
            listHeight += menuY - LK_POPUP_MENU_MARGIN;
        }
        menuY = LK_POPUP_MENU_MARGIN;
    }
    
    delta = parentViewSize.height - (menuY + menuHeight + LK_POPUP_MENU_MARGIN);
    //        fabs(deltaY) < menuY) {    menuY += deltaY

    if (delta < 0) {
        if (-delta < menuY) {
            menuY += delta;
        } else {
            if (self.popupMenu.arrangementMode == LKPopupMenuArrangementModeLeft ||
                self.popupMenu.arrangementMode == LKPopupMenuArrangementModeRight) {
                if (LK_POPUP_MENU_MARGIN < menuY) {
                    delta += menuY - LK_POPUP_MENU_MARGIN;
                    if (delta > 0) {
                        delta = 0;
                    }
                    menuY = LK_POPUP_MENU_MARGIN;
                }
            }
            menuHeight += delta;
            listHeight += delta;
        }
    }
    
    menuX = floor(menuX + 0.5);
    menuY = floor(menuY + 0.5);

    CGRect frame;
    
    if (type == LKPopupMenuViewTypeBase) {
        frame = CGRectMake(menuX, menuY, menuWidth, menuHeight);
    } else if (type == LKPopupMenuViewTypeFrame) {
        frame = CGRectMake(0, 0, menuWidth, menuHeight);
    }

    self = [super initWithFrame:frame];
    if (self) {
        // setup table view
        CGFloat tableX = LK_POPUP_MENU_PADDING;
        CGFloat tableY = LK_POPUP_MENU_PADDING;
        switch (self.popupMenu.arrangementMode) {
            case LKPopupMenuArrangementModeUp:
                break;
                
            case LKPopupMenuArrangementModeDown:
                tableY += self.triangleSize.height;
                break;
                
            case LKPopupMenuArrangementModeRight:
                tableX += self.triangleSize.height;
                break;
                
            case LKPopupMenuArrangementModeLeft:
                break;
        }

        self.tableFrame = CGRectMake(tableX, tableY, listWidth, listHeight);

        if (type == LKPopupMenuViewTypeBase) {
            // setup table        
            self.tableView = [[[UITableView alloc] initWithFrame:self.tableFrame
                                                           style:UITableViewStylePlain] autorelease];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.tableView.showsVerticalScrollIndicator = YES;
            self.tableView.indicatorStyle = appearance.indicatorStyle;
            self.tableView.bounces = NO;
            
            self.tableView.backgroundColor = [UIColor clearColor];
            CALayer* layer = self.tableView.layer;
            layer.masksToBounds = YES;
            layer.cornerRadius = 5.0;
            
            // setup header
            if (title && [[title stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]] length] > 0) {
                LKPopupMenuTitleView* view = [[[LKPopupMenuTitleView alloc] initWithFrame:
                                 CGRectMake(0, 0, self.tableView.frame.size.width, self.titleHeight)
                                               popupMenu:popupMenu] autorelease];
                self.tableView.tableHeaderView = view;
            }

            self.tableView.dataSource = popupMenu;
            self.tableView.delegate = popupMenu;

            [self addSubview:self.tableView];

        } else if (type ==LKPopupMenuViewTypeFrame) {
            self.userInteractionEnabled = NO;
        }

        // setup basics
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initAsFrameWithPopupMenu:(LKPopupMenu*)popupMenu location:(CGPoint)location title:(NSString*)title
{
    return [self _initAsType:LKPopupMenuViewTypeFrame
               WithPopupMenu:popupMenu
                    location:location
                       title:title];
}

- (id)initAsBaseWithPopupMenu:(LKPopupMenu*)popupMenu location:(CGPoint)location title:(NSString*)title
{
    return [self _initAsType:LKPopupMenuViewTypeBase
               WithPopupMenu:popupMenu
                    location:location
                       title:title];
}

- (void)dealloc {
    self.popupMenu = nil;
    if (self.tableView) {
        [self.tableView removeFromSuperview];
    }
    self.tableView = nil;
    self.path = nil;
    [super dealloc];
}

- (void)reloadData
{
    [self.tableView reloadData];
}


- (void)drawRect:(CGRect)rect
{
    if (self.type == LKPopupMenuViewTypeBase) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGColorRef shadowColor = [[UIColor colorWithWhite:0.0 alpha:0.5] CGColor];
        CGContextSetShadowWithColor(context,CGSizeMake(0, 0), self.shadowOffset, shadowColor);
        [self.popupMenu.appearance.menuBackgroundColor setFill];
        [self.path fill];
        
    } else if (self.type == LKPopupMenuViewTypeFrame) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGColorRef shadowColor = [[UIColor colorWithWhite:0.0 alpha:0.35] CGColor];
        CGContextSetShadowWithColor(context,CGSizeMake(1, 1), 2, shadowColor);
        [self.popupMenu.appearance.outlineColor setStroke];
        [self.path setLineWidth:self.popupMenu.appearance.outlineWith];
        [self.path stroke];
    }
}

@end

//------------------------------------------------------------------------------
@interface LKPopupMenuCheckMarkView : UIView
//------------------------------------------------------------------------------
@property (nonatomic, retain) UIColor* color;
+ (LKPopupMenuCheckMarkView*)checkMarkViewAtPoint:(CGPoint)p color:(UIColor*)color;
@end

//------------------------------------------------------------------------------
@implementation LKPopupMenuCheckMarkView
//------------------------------------------------------------------------------
#define LK_POPUP_MENU_CHECK_MARK_SIZE   16

@synthesize color = color_;

+ (LKPopupMenuCheckMarkView*)checkMarkViewAtPoint:(CGPoint)p color:(UIColor*)color
{
    CGRect frame = CGRectMake(p.x, p.y, LK_POPUP_MENU_CHECK_MARK_SIZE, LK_POPUP_MENU_CHECK_MARK_SIZE);
    LKPopupMenuCheckMarkView* view = [[[LKPopupMenuCheckMarkView alloc]
                                       initWithFrame:frame] autorelease];
    view.color = color;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath* path = [UIBezierPath bezierPath];

    CGPoint p = CGPointMake(3, 9);
    [path moveToPoint:p];
    
    p.x += 4;
    p.y += 4;
    [path addLineToPoint:p];

    p.x += 6;
    p.y -= 10;
    [path addLineToPoint:p];
    
    [path setLineWidth:2.0];
    [self.color setStroke];
    [path stroke];
}

- (void)dealloc {
    self.color = nil;
    [super dealloc];
}

@end


//------------------------------------------------------------------------------
@interface LKPopupMenuCell : UITableViewCell
//------------------------------------------------------------------------------
+ (LKPopupMenuCell*)cellForTableView:(UITableView*)tableView popupMenu:(LKPopupMenu*)popupMenu;
@property (nonatomic, retain) LKPopupMenuCheckMarkView* checkMarkView;
@property (nonatomic, assign) LKPopupMenuAppearance* appearance;
@property (nonatomic, assign) BOOL separatorEnabled;
@end

@implementation LKPopupMenuCell
@synthesize checkMarkView = checkMarkView_;
@synthesize appearance = appearance_;
@synthesize separatorEnabled = separatorEnabled_;

+ (LKPopupMenuCell*)cellForTableView:(UITableView*)tableView popupMenu:(LKPopupMenu*)popupMenu
{
    static NSString *cellIdentifier = @"LKPopupMenuCell";
    
    LKPopupMenuCell *cell = (LKPopupMenuCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[LKPopupMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.appearance = popupMenu.appearance;
        cell.textLabel.font = [UIFont systemFontOfSize:cell.appearance.fontSize];
        cell.textLabel.textColor = cell.appearance.menuTextColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGPoint p = CGPointMake(tableView.frame.size.width - LK_POPUP_MENU_CHECK_MARK_SIZE - 8.0,
                                (cell.appearance.cellHeight - LK_POPUP_MENU_CHECK_MARK_SIZE)/2.0);
        cell.checkMarkView = [LKPopupMenuCheckMarkView checkMarkViewAtPoint:p color:cell.appearance.checkMarkColor];
        cell.separatorEnabled = popupMenu.separatorEnabled;
        [cell.contentView addSubview:cell.checkMarkView];
    }
    return cell;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.contentView.backgroundColor = self.appearance.menuHilightedColor;
    } else {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.separatorEnabled) {
        UIBezierPath* path = [UIBezierPath bezierPath];
        CGPoint p = CGPointMake(0, 0);
        [path moveToPoint:p];
        p.x += self.bounds.size.width - 1.0;
        [path addLineToPoint:p];
        [path setLineWidth:0.5];
        [[UIColor blackColor] setStroke];
        [path stroke];
        
        path = [UIBezierPath bezierPath];
        p = CGPointMake(0, 0.5);
        [path moveToPoint:p];
        p.x += self.bounds.size.width - 1.0;
        [path addLineToPoint:p];
        [path setLineWidth:0.5];
        [self.appearance.separatorColor setStroke];
        [path stroke];
    }    
}

- (void)dealloc {
    self.checkMarkView = nil;
    self.appearance = nil;
    [super dealloc];
}
@end

//------------------------------------------------------------------------------
@implementation LKPopupMenu
//------------------------------------------------------------------------------
@synthesize indexSet = indexSet_;

@synthesize textList = textList_;
@synthesize imageFilenameList = imageFilenameList;
@synthesize delegate = delegate_;
@synthesize selectionMode = selectionMode_;
@synthesize arrangementMode = arrangementMode_;
@synthesize animationMode = animationMode_;
@synthesize modalEnabled = modalEnabled_;

@synthesize parentView = parentView_;
@synthesize title = title_;
@synthesize shown = shown_;

@synthesize heightSizeMode = heightSizeMode_;

@synthesize appearance = appearance_;
@synthesize shadowEnabled = shadowEnabled_;
@synthesize triangleEnabled = triangleEnabled_;
@synthesize separatorEnabled = separatorEnabled_;
@synthesize outlineEnabled = outlineEnabled_;
@synthesize titleHighlighted = titleHighlighted_;

@synthesize popupMenuBaseView = popupMenuBaseView_;
@synthesize backgroundView = backgroundView_;


#pragma mark -
#pragma mark Basics

- (id)initWithView:(UIView*)parentView appearance:(LKPopupMenuAppearance*)appearance
{
    self = [super init];
    if (self) {
        self.parentView = parentView;
        self.heightSizeMode = LKPopupMenuHeightSizeModeAuto;
        self.selectionMode = LKPopupMenuSelectionModeSingle;
        self.arrangementMode = LKPopupMenuArrangementModeDown;
        self.animationMode = LKPopupMenuAnimationModeSlide;
        self.shadowEnabled = YES;
        self.triangleEnabled = YES;
        self.separatorEnabled = YES;
        self.outlineEnabled = YES;
        self.titleHighlighted = YES;
        self.selectedIndexSet = [NSMutableIndexSet indexSet];
        self.modalEnabled = YES;
        self.separatorEnabled = YES;
        self.indexSet = [NSMutableIndexSet indexSet];

        self.appearance = appearance;
    }
    return self;
}

- (void)dealloc {
    self.textList = nil;
    self.imageFilenameList = nil;
    self.delegate = nil;
    if (self.popupMenuBaseView) {
        [self.popupMenuBaseView removeFromSuperview];
    }
    self.popupMenuBaseView = nil;
    self.parentView = nil;
    self.title = nil;

    self.indexSet = nil;

    self.appearance = nil;
    
    if (self.backgroundView) {
        [self.backgroundView removeFromSuperview];
    }
    self.backgroundView = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark Properties
- (void)setSelectedIndexSet:(NSIndexSet *)selectedIndexSet
{
    self.indexSet = [[[NSMutableIndexSet alloc] initWithIndexSet:selectedIndexSet] autorelease];
}

- (NSIndexSet*)selectedIndexSet
{
    return self.indexSet;
}

#pragma mark -
#pragma mark API
+ (LKPopupMenu*)popupMenuOnView:(UIView*)parentView
{
    return [[[self alloc] initWithView:parentView
                            appearance:[LKPopupMenuAppearance defaultAppearanceWithSize:LKPopupMenuSizeMedium]] autorelease];
}

+ (LKPopupMenu*)popupMenuOnView:(UIView*)parentView appearacne:(LKPopupMenuAppearance*)appearance
{
    return [[[self alloc] initWithView:parentView
                            appearance:appearance] autorelease];
}

- (void)showAtLocation:(CGPoint)location
{
    self.shown = YES;

    if ([self.delegate respondsToSelector:@selector(willAppearPopupMenu:)]) {
        [self.delegate willAppearPopupMenu:self];
    }

    if (self.popupMenuBaseView) {
        [self.popupMenuBaseView removeFromSuperview];
        self.popupMenuBaseView = nil;
    }
    
    // create new popup mewnu view
    NSString* title = self.title ? [@"  " stringByAppendingString:self.title] : nil;
    self.popupMenuBaseView = [[[LKPopupMenuView alloc] initAsBaseWithPopupMenu:self
                                                                      location:location
                                                                         title:title] autorelease];

    if (self.modalEnabled) {
        self.backgroundView = [[[LKPopupBackgroundView alloc] initWithFrame:self.parentView.bounds] autorelease];
        self.backgroundView.popupMenu = self;
        [self.parentView addSubview:self.backgroundView];
    }
    
    [self.parentView addSubview:self.popupMenuBaseView];
    CGPoint p = [self.popupMenuBaseView convertPoint:location fromView:self.parentView];
    [self.popupMenuBaseView setupPathAtLocation:p];
    
    if (self.outlineEnabled) {
        LKPopupMenuView* frameView = [[[LKPopupMenuView alloc] initAsFrameWithPopupMenu:self
                                                                               location:location
                                                                                  title:title] autorelease];
        [self.popupMenuBaseView addSubview:frameView];
        [frameView setupPathAtLocation:p];
    }

    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];

    if (self.animationMode != LKPopupMenuAnimationModeNone) {

        CGAffineTransform t1 = self.popupMenuBaseView.transform;
        CGAffineTransform t2 = self.popupMenuBaseView.transform;
        CGSize viewSize = self.popupMenuBaseView.frame.size;
        
        if (self.animationMode == LKPopupMenuAnimationModeSlide) {
            switch (self.arrangementMode) {
                case LKPopupMenuArrangementModeUp:
                    t1 = CGAffineTransformTranslate(t1, 0, viewSize.height/2.0);
                    self.popupMenuBaseView.transform = CGAffineTransformScale(t1, 1.0, 0.001);
                    break;

                case LKPopupMenuArrangementModeDown:
                    t1 = CGAffineTransformTranslate(t1, 0, -viewSize.height/2.0);
                    self.popupMenuBaseView.transform = CGAffineTransformScale(t1, 1.0, 0.001);
                    break;
                    
                case LKPopupMenuArrangementModeRight:
                    t1 = CGAffineTransformTranslate(t1, -viewSize.width/2.0, 0);
                    self.popupMenuBaseView.transform = CGAffineTransformScale(t1, 0.001, 1.0);
                    break;

                case LKPopupMenuArrangementModeLeft:
                    t1 = CGAffineTransformTranslate(t1, viewSize.width/2.0, 0);
                    self.popupMenuBaseView.transform = CGAffineTransformScale(t1, 0.001, 1.0);
                    break;
            }
            self.popupMenuBaseView.alpha = 0.5;
            self.popupMenuBaseView.tableView.alpha = 0.0;
            [UIView animateWithDuration:0.15
                             animations:^{
                                 self.popupMenuBaseView.transform = t2;
                                 self.popupMenuBaseView.alpha = 1.0;
                             }
                             completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.1
                                                  animations:^{
                                                      self.popupMenuBaseView.tableView.alpha = 1.0;
                                                  }];
                             }];

        } else if (self.animationMode == LKPopupMenuAnimationModeOpenClose) {
            switch (self.arrangementMode) {
                case LKPopupMenuArrangementModeUp:
                case LKPopupMenuArrangementModeDown:
                    self.popupMenuBaseView.transform = CGAffineTransformScale(t1, 0.001, 1.0);
                    break;
                    
                case LKPopupMenuArrangementModeRight:
                case LKPopupMenuArrangementModeLeft:
                    self.popupMenuBaseView.transform = CGAffineTransformScale(t1, 1.0, 0.001);
                    break;
            }
            self.popupMenuBaseView.alpha = 0.5;
            self.popupMenuBaseView.tableView.alpha = 0.0;
            [UIView animateWithDuration:0.15
                             animations:^{
                                 self.popupMenuBaseView.transform = t2;
                                 self.popupMenuBaseView.alpha = 1.0;
                             }
                             completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.1
                                                  animations:^{
                                                      self.popupMenuBaseView.tableView.alpha = 1.0;
                                                  }];
            }];

        } else if (self.animationMode == LKPopupMenuAnimationModeFade) {
            self.popupMenuBaseView.alpha = 0.0;
            [UIView animateWithDuration:0.2 animations:^{
                self.popupMenuBaseView.alpha = 1.0;
            }];            
        }
    }    
}

- (void)hide
{
    if (!self.shown) {
        return;
    }
    self.shown = NO;
    
    if (self.backgroundView) {
        [self.backgroundView removeFromSuperview];
    }
    self.backgroundView = nil;

    if ([self.delegate respondsToSelector:@selector(willDisappearPopupMenu:)]) {
        [self.delegate willDisappearPopupMenu:self];
    }

    CGAffineTransform t = self.popupMenuBaseView.transform;
    CGSize viewSize = self.popupMenuBaseView.frame.size;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];

    if (self.animationMode == LKPopupMenuAnimationModeNone) {
        self.popupMenuBaseView.hidden = YES;

    } else if (self.animationMode == LKPopupMenuAnimationModeFade) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.popupMenuBaseView.alpha = 0.0;
                         }];

    } else if (self.animationMode == LKPopupMenuAnimationModeSlide) {
        switch (self.arrangementMode) {
            case LKPopupMenuArrangementModeUp:
                t = CGAffineTransformTranslate(t, 0, viewSize.height/2.0);
                t = CGAffineTransformScale(t, 1.0, 0.001);
                break;
                
            case LKPopupMenuArrangementModeDown:
                t = CGAffineTransformTranslate(t, 0, -viewSize.height/2.0);
                t = CGAffineTransformScale(t, 1.0, 0.001);
                break;
                
            case LKPopupMenuArrangementModeRight:
                t = CGAffineTransformTranslate(t, -viewSize.width/2.0, 0);
                t = CGAffineTransformScale(t, 0.001, 1.0);
                break;
                
            case LKPopupMenuArrangementModeLeft:
                t = CGAffineTransformTranslate(t, viewSize.width/2.0, 0);
                t = CGAffineTransformScale(t, 0.001, 1.0);
                break;
        }
        
        self.popupMenuBaseView.tableView.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.popupMenuBaseView.transform = t;
            self.popupMenuBaseView.alpha = 0.25;
        } completion:^(BOOL finished){
            self.popupMenuBaseView.hidden = YES;
        }];
        
    } else if (self.animationMode == LKPopupMenuAnimationModeOpenClose) {
        switch (self.arrangementMode) {
            case LKPopupMenuArrangementModeUp:
            case LKPopupMenuArrangementModeDown:
                t = CGAffineTransformScale(t, 0.001, 1.0);
                break;
                
            case LKPopupMenuArrangementModeRight:
            case LKPopupMenuArrangementModeLeft:
                t = CGAffineTransformScale(t, 1.0, 0.001);
                break;
        }
        
        self.popupMenuBaseView.tableView.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.popupMenuBaseView.transform = t;
            self.popupMenuBaseView.alpha = 0.25;
        } completion:^(BOOL finished){
            self.popupMenuBaseView.hidden = YES;
        }];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.textList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKPopupMenuCell* cell = [LKPopupMenuCell cellForTableView:tableView popupMenu:self];

    cell.checkMarkView.hidden = ![self.selectedIndexSet containsIndex:indexPath.row];
    cell.textLabel.text = [self.textList objectAtIndex:indexPath.row];
    
    if (self.imageFilenameList && indexPath.row < [self.imageFilenameList count]) {
        NSString* imageFilename = [self.imageFilenameList objectAtIndex:indexPath.row];
        if ([imageFilename isEqualToString:LKPopupMenuBlankImage]) {
            UIGraphicsBeginImageContext(CGSizeMake(32, 32));
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        } else {
            cell.imageView.image = [UIImage imageNamed:imageFilename];
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.appearance.cellHeight;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.selectionMode == LKPopupMenuSelectionModeSingle) {
        [self.indexSet removeAllIndexes];
        [self.indexSet addIndex:indexPath.row];
        if ([self.delegate respondsToSelector:@selector(didSelectPopupMenu:atIndex:)]) {
            [self.delegate didSelectPopupMenu:self atIndex:indexPath.row];
        }
        [self hide];
    } else {
        if ([self.indexSet containsIndex:indexPath.row]) {
            [self.indexSet removeIndex:indexPath.row];
        } else {
            [self.indexSet addIndex:indexPath.row];        
        }
        if ([self.delegate respondsToSelector:@selector(didSelectPopupMenu:atIndex:)]) {
            [self.delegate didSelectPopupMenu:self atIndex:indexPath.row];
        }
        [self.popupMenuBaseView reloadData];
    }
}

@end
