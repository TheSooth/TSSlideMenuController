//
//  TSSlideMenuController.h
//  SlideMenu
//
//  Created by TheSooth on 9/26/13.
//  Copyright (c) 2013 TheSooth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSSlideMenuController : UIViewController

@property (nonatomic, strong, readwrite) UINavigationController *navigationController;

@property (nonatomic, strong, readonly) UIView *contentView;

@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat hiddingTreshold;

- (void)presentSlideMenu;

- (void)dismissSlideMenu;

@end
