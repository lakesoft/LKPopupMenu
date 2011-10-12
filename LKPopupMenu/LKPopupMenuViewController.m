//
//  LKPopupMenuViewController.m
//  LKPopupMenu
//
//  Created by Hashiguchi Hiroshi on 11/10/09.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LKPopupMenuViewController.h"
#import "LKPopupMenu.h"

@implementation LKPopupMenuViewController
@synthesize popupMenu = popupMenu_;
@synthesize sizeMenu = sizeMenu_;
@synthesize colorMenu = colorMenu_;
@synthesize animationMenu = animationMenu_;
@synthesize menuTitle;
@synthesize list;
@synthesize sizeMode;
@synthesize selectionMode;
@synthesize shadowEnabled;
@synthesize triangleEnabled;
@synthesize menuSize;
@synthesize menuColor;
@synthesize animationMode;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray* array = [NSMutableArray array];
    for (int i=0; i < 6; i++) {
        [array addObject:[NSString stringWithFormat:@"Menu Item %d", i+1]];
    }
    self.list = array;
    self.sizeMode = LKPopupMenuHeightSizeModeAuto;
    self.selectionMode = LKPopupMenuSelectionModeSingle;
    self.shadowEnabled = YES;
    self.menuSize = LKPopupMenuSizeMedium;
    self.triangleEnabled = YES;
    self.animationMode = LKPopupMenuAnimationModeSlide;
}

- (void)dealloc {
    self.popupMenu = nil;
    self.sizeMenu = nil;
    self.colorMenu = nil;
    self.animationMenu = nil;
    [popupButton release];
    [title release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.popupMenu = nil;
    self.sizeMenu = nil;
    self.colorMenu = nil;
    self.animationMenu = nil;
    self.menuTitle = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.popupMenu.shown) {
        [self.popupMenu hide];
        [self.sizeMenu hide];
        [self.colorMenu hide];
        [self.animationMenu hide];
    }
    [self.menuTitle resignFirstResponder];
}

#pragma mark -
#pragma mark LKPopupMenuDelegate

- (void)willAppearPopupMenu:(LKPopupMenu*)popupMenu
{
    NSLog(@"%s|%@", __PRETTY_FUNCTION__, popupMenu);
}
- (void)willDisappearPopupMenu:(LKPopupMenu*)popupMenu
{
    NSLog(@"%s|%@", __PRETTY_FUNCTION__, popupMenu);
}
- (void)didSelectPopupMenu:(LKPopupMenu*)popupMenu atIndex:(NSUInteger)index
{
    NSLog(@"%s|index=%d, %@", __PRETTY_FUNCTION__, index, popupMenu.selectedIndexSet);
    
    if (popupMenu == self.sizeMenu) {
        self.menuSize = index;
    } else if (popupMenu == self.colorMenu) {
        self.menuColor = index;
    } else if (popupMenu == self.animationMenu) {
        self.animationMode = index;
    }
}


#pragma mark -
#pragma mark Actions
- (void)_popupAt:(CGPoint)location arrangementMode:(LKPopupMenuArrangementMode)arrangementMode
{
    if (self.popupMenu.shown) {
        [self.popupMenu hide];
    } else {
        if (self.popupMenu == nil) {
            self.popupMenu = [LKPopupMenu popupMenuOnView:self.view];
            self.popupMenu.list = self.list;
            self.popupMenu.delegate = self;
//            self.popupMenu.fixedHeight = 140.0;
        }
        self.popupMenu.title = self.menuTitle.text;
        self.popupMenu.heightSizeMode = self.sizeMode;
        self.popupMenu.selectionMode = self.selectionMode;
        self.popupMenu.arrangementMode = arrangementMode;
        self.popupMenu.animationMode = self.animationMode;
        self.popupMenu.shadowEnabled = self.shadowEnabled;
        self.popupMenu.triangleEnabled = self.triangleEnabled;
        self.popupMenu.appearance = [LKPopupMenuAppearance defaultAppearanceWithSize:self.menuSize
                                                                               color:self.menuColor];

        // TODO
//        self.popupMenu.appearance.tableSize = CGSizeMake(500, 500);;

        [self.popupMenu showAtLocation:location];
    }
}

- (IBAction)popupToUp:(id)sender {
    CGSize size = ((UIButton*)sender).frame.size;
    CGPoint origin = ((UIButton*)sender).frame.origin;
    CGPoint location = CGPointMake(origin.x + size.width/2.0,
                                   origin.y - 2.0);
    [self _popupAt:location arrangementMode:LKPopupMenuArrangementModeUp];
}

- (IBAction)didChangeSizeMode:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    self.sizeMode = sw.on ? LKPopupMenuHeightSizeModeAuto : LKPopupMenuHeightSizeModeFixed;

}

- (IBAction)didChangeSelectionMode:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    self.selectionMode = sw.on ? LKPopupMenuSelectionModeMultiple : LKPopupMenuSelectionModeSingle;
}

- (IBAction)didChangeShadowEnabled:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    self.shadowEnabled = sw.on;
}

- (IBAction)didChangeColor:(id)sender {
    CGSize size = ((UIButton*)sender).frame.size;
    CGPoint origin = ((UIButton*)sender).frame.origin;
    CGPoint location = CGPointMake(origin.x + size.width/2.0,
                                   origin.y - 2.0);
    if (self.colorMenu.shown) {
        [self.colorMenu hide];
    } else {
        if (self.colorMenu == nil) {
            self.colorMenu = [LKPopupMenu popupMenuOnView:self.view];
            self.colorMenu.list = [NSArray arrayWithObjects:
                                  @"Default", @"Black", @"White", @"Gray", nil];
            self.colorMenu.delegate = self;
        }
        self.colorMenu.title = @"Menu Color";
        self.colorMenu.arrangementMode = LKPopupMenuArrangementModeUp;
        self.colorMenu.triangleEnabled = YES;        
        [self.colorMenu showAtLocation:location];
    }
}

- (IBAction)didChangeSize:(id)sender {
    CGSize size = ((UIButton*)sender).frame.size;
    CGPoint origin = ((UIButton*)sender).frame.origin;
    CGPoint location = CGPointMake(origin.x + size.width/2.0,
                                   origin.y - 2.0);
    if (self.sizeMenu.shown) {
        [self.sizeMenu hide];
    } else {
        if (self.sizeMenu == nil) {
            self.sizeMenu = [LKPopupMenu popupMenuOnView:self.view];
            self.sizeMenu.list = [NSArray arrayWithObjects:
                                    @"Small", @"Medium", @"Large", nil];
            self.sizeMenu.delegate = self;
        }
        self.sizeMenu.title = @"Menu Size";
        self.sizeMenu.arrangementMode = LKPopupMenuArrangementModeUp;
        self.sizeMenu.triangleEnabled = YES;
        [self.sizeMenu showAtLocation:location];
    }
}

- (IBAction)didChangeTriangle:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    self.triangleEnabled = sw.on;

}

- (IBAction)didChangeAnimationMode:(id)sender {
    CGSize size = ((UIButton*)sender).frame.size;
    CGPoint origin = ((UIButton*)sender).frame.origin;
    CGPoint location = CGPointMake(origin.x + size.width/2.0,
                                   origin.y - 2.0);
    if (self.animationMenu.shown) {
        [self.animationMenu hide];
    } else {
        if (self.animationMenu == nil) {
            self.animationMenu = [LKPopupMenu popupMenuOnView:self.view];
            self.animationMenu.list = [NSArray arrayWithObjects:
                                   @"None", @"Slide", @"OpenClose", @"Fade", nil];
            self.animationMenu.delegate = self;
            self.animationMenu.selectedIndexSet = [NSMutableSet setWithObject:
                                                [NSIndexPath indexPathForRow:LKPopupMenuAnimationModeSlide inSection:0]];
        }
        self.animationMenu.title = @"Animation Mode";
        self.animationMenu.arrangementMode = LKPopupMenuArrangementModeUp;
        self.animationMenu.triangleEnabled = YES;        
        [self.animationMenu showAtLocation:location];
    }
}

- (IBAction)popupToDown:(id)sender {
    CGSize size = ((UIButton*)sender).frame.size;
    CGPoint origin = ((UIButton*)sender).frame.origin;
    CGPoint location = CGPointMake(origin.x + size.width/2.0,
                                   origin.y + size.height + 2.0);
    [self _popupAt:location arrangementMode:LKPopupMenuArrangementModeDown];
}

- (IBAction)popupToRight:(id)sender {
    CGSize size = ((UIButton*)sender).frame.size;
    CGPoint origin = ((UIButton*)sender).frame.origin;
    CGPoint location = CGPointMake(origin.x + size.width + 2.0,
                                   origin.y + size.height/2.0);
    [self _popupAt:location arrangementMode:LKPopupMenuArrangementModeRight];
}

- (IBAction)popupToLeft:(id)sender {
    CGSize size = ((UIButton*)sender).frame.size;
    CGPoint origin = ((UIButton*)sender).frame.origin;
    CGPoint location = CGPointMake(origin.x - 2.0,
                                   origin.y + size.height/2.0);
    [self _popupAt:location arrangementMode:LKPopupMenuArrangementModeLeft];
}

@end
