//
//  MGViewController.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGDeck.h"

@interface MGCardGameViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

_abstract @property (nonatomic) NSUInteger startingCardCount;
_abstract -(void)updateCell:(UICollectionViewCell*)cell usingCard:(MGCard*)card;
_abstract -(BOOL)cell:(UICollectionViewCell*)cell needsUpdateFromCard:(MGCard*)card;

@end
