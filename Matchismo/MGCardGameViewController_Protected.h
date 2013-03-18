//
//  MGViewController_Protected.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGCardGameViewController.h"
@class MGGame;

@interface MGCardGameViewController ()

@property (strong,nonatomic) MGGame* game;
- (void) updateUI;
- (IBAction)deal;

@end
