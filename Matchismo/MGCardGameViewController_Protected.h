//
//  MGViewController_Protected.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGCardGameViewController.h"
#import "MGDeck.h"
#import "MGGame.h"
#import "MGGameMove.h"
#import "MGCardView.h"

@interface MGCardGameViewController ()

@property (strong,nonatomic) MGGame* game;

- (void) updateUI;
- (IBAction)deal;

_abstract @property (nonatomic) NSUInteger startingCardCount;
_abstract -(void)updateCardView:(MGCardView *)cardView usingCard:(MGCard *)card;
_abstract -(BOOL)cell:(UICollectionViewCell*)cell needsUpdateFromCard:(MGCard*)card;
_abstract -(void)updateMoveDisplayUsingMove:(MGGameMove*)move;
_abstract -(void)updateSelectedDisplayUsingCards:(NSArray*)cards;

@end
