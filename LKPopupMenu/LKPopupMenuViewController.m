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
@synthesize imageMenu = imageMenu_;
@synthesize menuTitle;
@synthesize list;
@synthesize sizeMode;
@synthesize selectionMode;
@synthesize shadowEnabled;
@synthesize triangleEnabled;
@synthesize menuSize;
@synthesize menuColor;
@synthesize animationMode;
@synthesize modalEnabled;
@synthesize separatorEnabled;

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
    self.modalEnabled = YES;
    self.separatorEnabled = YES;
}

- (void)dealloc {
    self.popupMenu = nil;
    self.sizeMenu = nil;
    self.colorMenu = nil;
    self.animationMenu = nil;
    self.imageMenu = nil;
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
    self.imageMenu = nil;
    self.menuTitle = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
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
            self.popupMenu.textList = self.list;
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
        self.popupMenu.modalEnabled = self.modalEnabled;
        self.popupMenu.separatorEnabled = self.separatorEnabled;
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
            self.colorMenu.textList = [NSArray arrayWithObjects:
                                  @"Default", @"Black", @"White", @"Gray", nil];
            self.colorMenu.delegate = self;
        }
        self.colorMenu.title = @"Menu Color";
        self.colorMenu.arrangementMode = LKPopupMenuArrangementModeUp;
        self.colorMenu.triangleEnabled = YES;    
        self.colorMenu.selectedIndexSet = [NSIndexSet indexSetWithIndex:0];
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
            self.sizeMenu.textList = [NSArray arrayWithObjects:
                                    @"Small", @"Medium", @"Large", nil];
            self.sizeMenu.delegate = self;
            self.sizeMenu.selectedIndexSet = [NSIndexSet indexSetWithIndex:LKPopupMenuSizeMedium];
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
            self.animationMenu.textList = [NSArray arrayWithObjects:
                                   @"None", @"Slide", @"OpenClose", @"Fade", nil];
            self.animationMenu.delegate = self;
            self.animationMenu.selectedIndexSet = [NSIndexSet indexSetWithIndex:LKPopupMenuAnimationModeSlide];
        }
        self.animationMenu.title = @"Animation Mode";
        self.animationMenu.arrangementMode = LKPopupMenuArrangementModeUp;
        self.animationMenu.triangleEnabled = YES;        
        [self.animationMenu showAtLocation:location];
    }
}

- (IBAction)didChangeModal:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    self.modalEnabled = sw.on;
}

- (IBAction)didChangeSeparator:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    self.separatorEnabled = sw.on;
}

- (IBAction)openImageMenu:(id)sender {
    CGSize size = ((UIButton*)sender).frame.size;
    CGPoint origin = ((UIButton*)sender).frame.origin;
    CGPoint location = CGPointMake(origin.x + size.width/2.0,
                                   origin.y - 2.0);
    if (self.animationMenu.shown) {
        [self.animationMenu hide];
    } else {
        if (self.imageMenu == nil) {
            self.imageMenu = [LKPopupMenu popupMenuOnView:self.view appearacne:[LKPopupMenuAppearance defaultAppearanceWithSize:LKPopupMenuSizeMedium color:LKPopupMenuColorWhite]];
            self.imageMenu.textList = [NSArray arrayWithObjects:
                                       @"Cloud",
                                       @"Clouds",
                                       @"Cloudy",
                                       @"Rain",
                                       @"Snow",
                                       @"Sunny",
                                       @"Thunder",
                                       @"(not image)",
                                       nil];
            self.imageMenu.imageFilenameList = [NSArray arrayWithObjects:
                                                @"Weather Cloud",
                                                @"Weather Clouds",
                                                @"Weather Cloudy",
                                                @"Weather Rain",
                                                @"Weather Snow",
                                                @"Weather Sunny",
                                                @"Weather Thunder",
                                                LKPopupMenuBlankImage,
                                       nil];
            self.imageMenu.delegate = self;
            self.imageMenu.title = @"Weather Menu";
            self.imageMenu.arrangementMode = LKPopupMenuArrangementModeUp;
        }
        self.imageMenu.heightSizeMode = self.sizeMode;
        self.imageMenu.selectionMode = self.selectionMode;
        self.imageMenu.animationMode = self.animationMode;
        self.imageMenu.shadowEnabled = self.shadowEnabled;
        self.imageMenu.triangleEnabled = self.triangleEnabled;
        self.imageMenu.modalEnabled = self.modalEnabled;
        self.imageMenu.separatorEnabled = self.separatorEnabled;

        [self.imageMenu showAtLocation:location];
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
