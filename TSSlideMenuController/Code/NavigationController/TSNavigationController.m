//
//  TSNavigationController.m
//  SlideMenu
//
//  Created by TheSooth on 10/4/13.
//  Copyright (c) 2013 TheSooth. All rights reserved.
//

#import "TSNavigationController.h"
#import "TSSlideMenuController.h"

@interface TSNavigationController ()

@property (nonatomic, strong) TSSlideMenuController *menuController;

@end

@implementation TSNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuController = [TSSlideMenuController new];
    self.menuController.navigationController = self;
    
    [self.view addSubview:self.menuController.view];
}

- (void)presetSlideMenu
{
    [self.menuController presentSlideMenu];
}

- (void)dismisslideMenu
{
    [self.menuController dismissSlideMenu];
}

@end
