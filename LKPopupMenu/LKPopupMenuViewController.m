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
@synthesize popupMenu2 = popupMenu2_;
@synthesize menuTitle;
@synthesize list;
@synthesize sizeMode;
@synthesize selectionMode;
@synthesize shadowEnabled;
@synthesize whiteColor;
@synthesize menuSize;

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
}

- (void)dealloc {
    self.popupMenu = nil;
    self.popupMenu2 = nil;
    [popupButton release];
    [title release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.popupMenu = nil;
    self.popupMenu2 = nil;
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
        [self.popupMenu2 hide];
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
    
    if (popupMenu == self.popupMenu2) {
        self.menuSize = index;
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
        self.popupMenu.shadowEnabled = self.shadowEnabled;
        self.popupMenu.menuSize = self.menuSize;
        
        if (self.whiteColor) {
            self.popupMenu.menuBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.85];
            self.popupMenu.menuTextColor = [UIColor colorWithWhite:0.25 alpha:1.0];
            self.popupMenu.titleBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
            self.popupMenu.titleTextColor = [UIColor colorWithWhite:0.25 alpha:1.0];
            self.popupMenu.menuHilightedColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.85 alpha:0.75];
        } else {
            [self.popupMenu performSelector:@selector(_resetColors)];   // calling private selector
        }
        
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
    UISwitch* sw = (UISwitch*)sender;
    self.whiteColor = sw.on;
}

- (IBAction)didChangeSize:(id)sender {
    CGSize size = ((UIButton*)sender).frame.size;
    CGPoint origin = ((UIButton*)sender).frame.origin;
    CGPoint location = CGPointMake(origin.x + size.width/2.0,
                                   origin.y + size.height + 2.0);
    if (self.popupMenu2.shown) {
        [self.popupMenu2 hide];
    } else {
        if (self.popupMenu2 == nil) {
            self.popupMenu2 = [LKPopupMenu popupMenuOnView:self.view];
            self.popupMenu2.list = [NSArray arrayWithObjects:
                                    @"Small", @"Medium", @"Large", nil];
            self.popupMenu2.delegate = self;
        }
        self.popupMenu2.title = @"Menu Size";
        self.popupMenu2.heightSizeMode = self.sizeMode;
        self.popupMenu2.arrangementMode = LKPopupMenuArrangementModeUp;
        self.popupMenu.menuSize = self.menuSize;
        
        if (self.whiteColor) {
            self.popupMenu2.menuBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.75];
            self.popupMenu2.menuTextColor = [UIColor colorWithWhite:0.25 alpha:1.0];
            self.popupMenu2.titleBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.85];
            self.popupMenu2.titleTextColor = [UIColor colorWithWhite:0.25 alpha:1.0];
            self.popupMenu2.menuHilightedColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.75 alpha:0.75];
        } else {
            [self.popupMenu2 performSelector:@selector(_resetColors)];   // calling private selector
        }
        
        [self.popupMenu2 showAtLocation:location];
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
