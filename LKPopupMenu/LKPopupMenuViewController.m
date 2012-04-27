//
//  LKPopupMenuViewController.m
//  LKPopupMenu
//
//  Created by Hashiguchi Hiroshi on 11/10/09.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LKPopupMenuViewController.h"
#import "LKPopupMenuController.h"

#define MENU_NUM    6

@implementation LKPopupMenuViewController
@synthesize popupMenu = popupMenu_;
@synthesize sizeMenu = sizeMenu_;
@synthesize colorMenu = colorMenu_;
@synthesize animationMenu = animationMenu_;
@synthesize imageMenu = imageMenu_;
@synthesize menuTitle;
@synthesize list;
@synthesize autoresizeEnabled;
@synthesize autocloseEnabled;
@synthesize bounceEnabled;
@synthesize multipleSelectionEnabled;
@synthesize shadowEnabled;
@synthesize triangleEnabled;
@synthesize menuSize;
@synthesize menuColor;
@synthesize animationMode;
@synthesize modalEnabled;
@synthesize separatorEnabled;
@synthesize outlineEnabled;
@synthesize titleHilighted;

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
    for (int i=0; i < MENU_NUM; i++) {
        [array addObject:[NSString stringWithFormat:@"Menu Item %d", i+1]];
    }
    self.list = array;
    self.autoresizeEnabled = YES;
    self.autocloseEnabled = YES;
    self.bounceEnabled = NO;
    self.multipleSelectionEnabled = NO;
    self.shadowEnabled = YES;
    self.menuSize = LKPopupMenuControllerSizeMedium;
    self.triangleEnabled = YES;
    self.animationMode = LKPopupMenuControllerAnimationModeSlide;
    self.modalEnabled = YES;
    self.separatorEnabled = YES;
    self.outlineEnabled = YES;
    self.titleHilighted = YES;
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

- (void)willAppearPopupMenuController:(LKPopupMenuController*)popupMenuController
{
    NSLog(@"%s|%@", __PRETTY_FUNCTION__, popupMenuController);
}
- (void)willDisappearPopupMenuController:(LKPopupMenuController*)popupMenuController
{
    NSLog(@"%s|%@", __PRETTY_FUNCTION__, popupMenuController);
}
- (void)popupMenuController:(LKPopupMenuController*)popupMenuController didSelectRowAtIndex:(NSUInteger)index
{
    NSLog(@"%s|index=%d, %@", __PRETTY_FUNCTION__, index, popupMenuController.selectedIndexSet);
    
    if (popupMenuController == self.sizeMenu) {
        self.menuSize = index;
    } else if (popupMenuController == self.colorMenu) {
        self.menuColor = index;
    } else if (popupMenuController == self.animationMenu) {
        self.animationMode = index;
    }
}


#pragma mark -
#pragma mark Actions
- (void)_popupAt:(CGPoint)location arrangementMode:(LKPopupMenuControllerArrangementMode)arrangementMode
{
    if (self.popupMenu.popupmenuVisible) {
        [self.popupMenu dismiss];
    } else {
        if (self.popupMenu == nil) {
            self.popupMenu = [LKPopupMenuController popupMenuControllerOnView:self.view];
            self.popupMenu.textList = self.list;
            self.popupMenu.delegate = self;
        }
        self.popupMenu.title = self.menuTitle.text;
        self.popupMenu.autoresizeEnabled = self.autoresizeEnabled;
        self.popupMenu.autocloseEnabled = self.autocloseEnabled;
        self.popupMenu.bounceEnabled = self.bounceEnabled;
        self.popupMenu.multipleSelectionEnabled = self.multipleSelectionEnabled;
        self.popupMenu.arrangementMode = arrangementMode;
        self.popupMenu.animationMode = self.animationMode;
        self.popupMenu.modalEnabled = self.modalEnabled;
        
        LKPopupMenuAppearance* appearance = [LKPopupMenuAppearance defaultAppearanceWithSize:self.menuSize
                                                                                       color:self.menuColor];
        appearance.shadowEnabled = self.shadowEnabled;
        appearance.triangleEnabled = self.triangleEnabled;
        appearance.separatorEnabled = self.separatorEnabled;
        appearance.outlineEnabled = self.outlineEnabled;
        appearance.titleHighlighted = self.titleHilighted;
        self.popupMenu.appearance = appearance;
// test auto resizing
//        self.popupMenu.appearance.listWidth = 1000.0;
//        self.popupMenu.appearance.listHeight = 1000.0;

        [self.popupMenu presentPopupMenuFromLocation:location];
    }
}

- (IBAction)popupToUp:(id)sender {
    CGSize size = ((UIButton*)sender).frame.size;
    CGPoint origin = ((UIButton*)sender).frame.origin;
    CGPoint location = CGPointMake(origin.x + size.width/2.0,
                                   origin.y - 2.0);
    [self _popupAt:location arrangementMode:LKPopupMenuControllerArrangementModeUp];
}

- (IBAction)didChangeSizeMode:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    self.autoresizeEnabled = sw.on;

}

- (IBAction)didChangeSelectionMode:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    self.multipleSelectionEnabled = sw.on;
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
    if (self.colorMenu.popupmenuVisible) {
        [self.colorMenu dismiss];
    } else {
        if (self.colorMenu == nil) {
            self.colorMenu = [LKPopupMenuController popupMenuControllerOnView:self.view];
            self.colorMenu.textList = [NSArray arrayWithObjects:
                                  @"Default", @"Black", @"White", @"Gray", nil];
            self.colorMenu.delegate = self;
        }
        self.colorMenu.title = @"Menu Color";
        self.colorMenu.arrangementMode = LKPopupMenuControllerArrangementModeUp;
        self.colorMenu.appearance.triangleEnabled = YES;    
        self.colorMenu.selectedIndexSet = [NSIndexSet indexSetWithIndex:self.menuColor];
        [self.colorMenu presentPopupMenuFromLocation:location];
    }
}

- (IBAction)didChangeSize:(id)sender {
    CGSize size = ((UIButton*)sender).frame.size;
    CGPoint origin = ((UIButton*)sender).frame.origin;
    CGPoint location = CGPointMake(origin.x + size.width/2.0,
                                   origin.y - 2.0);
    if (self.sizeMenu.popupmenuVisible) {
        [self.sizeMenu dismiss];
    } else {
        if (self.sizeMenu == nil) {
            self.sizeMenu = [LKPopupMenuController popupMenuControllerOnView:self.view];
            self.sizeMenu.textList = [NSArray arrayWithObjects:
                                    @"Small", @"Medium", @"Large", nil];
            self.sizeMenu.delegate = self;
            self.sizeMenu.selectedIndexSet = [NSIndexSet indexSetWithIndex:LKPopupMenuControllerSizeMedium];
        }
        self.sizeMenu.title = @"Menu Size";
        self.sizeMenu.arrangementMode = LKPopupMenuControllerArrangementModeUp;
        self.sizeMenu.appearance.triangleEnabled = YES;
        [self.sizeMenu presentPopupMenuFromLocation:location];
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
    if (self.animationMenu.popupmenuVisible) {
        [self.animationMenu dismiss];
    } else {
        if (self.animationMenu == nil) {
            self.animationMenu = [LKPopupMenuController popupMenuControllerOnView:self.view];
            self.animationMenu.textList = [NSArray arrayWithObjects:
                                   @"None", @"Slide", @"Slide with bounce", @"OpenClose", @"Fade", nil];
            self.animationMenu.delegate = self;
            self.animationMenu.selectedIndexSet = [NSIndexSet indexSetWithIndex:LKPopupMenuControllerAnimationModeSlide];
        }
        self.animationMenu.title = @"Animation Mode";
        self.animationMenu.arrangementMode = LKPopupMenuControllerArrangementModeUp;
        self.animationMenu.appearance.triangleEnabled = YES;        
        [self.animationMenu presentPopupMenuFromLocation:location];
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
    if (self.animationMenu.popupmenuVisible) {
        [self.animationMenu dismiss];
    } else {
        if (self.imageMenu == nil) {
            self.imageMenu = [LKPopupMenuController popupMenuControllerOnView:self.view appearacne:[LKPopupMenuAppearance defaultAppearanceWithSize:LKPopupMenuControllerSizeMedium color:LKPopupMenuControllerColorWhite]];
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
                                                LKPopupMenuControllerBlankImage,
                                       nil];
            self.imageMenu.delegate = self;
            self.imageMenu.title = @"Weather Menu";
            self.imageMenu.arrangementMode = LKPopupMenuControllerArrangementModeUp;
        }
        self.imageMenu.autoresizeEnabled = self.autoresizeEnabled;
        self.imageMenu.autocloseEnabled = self.autocloseEnabled;
        self.imageMenu.bounceEnabled = self.bounceEnabled;
        self.imageMenu.multipleSelectionEnabled = self.multipleSelectionEnabled;
        self.imageMenu.animationMode = self.animationMode;
        self.imageMenu.modalEnabled = self.modalEnabled;
        self.imageMenu.appearance.shadowEnabled = self.shadowEnabled;
        self.imageMenu.appearance.triangleEnabled = self.triangleEnabled;
        self.imageMenu.appearance.separatorEnabled = self.separatorEnabled;
        self.imageMenu.appearance.outlineEnabled = self.outlineEnabled;
        self.imageMenu.appearance.titleHighlighted = self.titleHilighted;

        [self.imageMenu presentPopupMenuFromLocation:location];
    }
}

- (IBAction)didChangeTitleHighlighted:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    self.titleHilighted = sw.on;
}

- (IBAction)didChangeAutoclose:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    self.autocloseEnabled = sw.on;
}

- (IBAction)didChangeOutline:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    self.outlineEnabled = sw.on;
}

- (IBAction)didChangeBounce:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    self.bounceEnabled = sw.on;
}

- (IBAction)popupToDown:(id)sender {
    CGSize size = ((UIButton*)sender).frame.size;
    CGPoint origin = ((UIButton*)sender).frame.origin;
    CGPoint location = CGPointMake(origin.x + size.width/2.0,
                                   origin.y + size.height + 2.0);
    [self _popupAt:location arrangementMode:LKPopupMenuControllerArrangementModeDown];
}

- (IBAction)popupToRight:(id)sender {
    CGSize size = ((UIButton*)sender).frame.size;
    CGPoint origin = ((UIButton*)sender).frame.origin;
    CGPoint location = CGPointMake(origin.x + size.width + 2.0,
                                   origin.y + size.height/2.0);
    [self _popupAt:location arrangementMode:LKPopupMenuControllerArrangementModeRight];
}

- (IBAction)popupToLeft:(id)sender {
    CGSize size = ((UIButton*)sender).frame.size;
    CGPoint origin = ((UIButton*)sender).frame.origin;
    CGPoint location = CGPointMake(origin.x - 2.0,
                                   origin.y + size.height/2.0);
    [self _popupAt:location arrangementMode:LKPopupMenuControllerArrangementModeLeft];
}

@end
