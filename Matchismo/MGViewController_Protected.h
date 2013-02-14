//
//  MGViewController_Protected.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGViewController.h"
@class MGGame;

@interface MGViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

- (IBAction)deal;


@property (strong,nonatomic) MGGame* game;

- (void) updateUI;

@end
