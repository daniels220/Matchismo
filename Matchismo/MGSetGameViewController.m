//
//  MGSetGameViewController.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MGSetGameViewController.h"
#import "MGCardGameViewController_Protected.h"

#import "MGSetCard.h"
#import "MGSetDeck.h"
#import "MGSetGame.h"
#import "MGSetCardCollectionViewCell.h"
#import "MGSetCardView.h"

@interface MGSetGameViewController ()

@property (strong,nonatomic) MGSetGame* game;

@end

@implementation MGSetGameViewController

-(NSUInteger)startingCardCount {
	return 24;
}

-(void)updateCell:(MGSetCardCollectionViewCell *)cell usingCard:(MGSetCard *)card {
	if (![cell isKindOfClass:[MGSetCardCollectionViewCell class]] || ![card isKindOfClass:[MGSetCard class]])
		return;
	cell.setCardView.color = card.color;
	cell.setCardView.symbol = card.symbol;
	cell.setCardView.shading = card.shading;
	cell.setCardView.number = card.number;
	cell.setCardView.selected = card.faceUp;
	cell.hidden = card.unplayable;
}

-(BOOL)cell:(MGSetCardCollectionViewCell *)cell needsUpdateFromCard:(MGSetCard *)card {
	if (![cell isKindOfClass:MGSetCardCollectionViewCell.class] || ![card isKindOfClass:MGSetCard.class])
		return NO;
	MGSetCardView* view = cell.setCardView;
	return view.number != card.number || view.shading != card.shading || ![view.symbol isEqualToString:card.symbol] || ![view.color isEqual:card.color] || view.selected != card.faceUp || view.hidden != card.unplayable;
}

-(MGSetGame *)game {
	if (!super.game) super.game = [[MGSetGame alloc]
																 initWithCardCount:self.startingCardCount
																 usingDeck:[MGSetDeck new]];
	return super.game;
}


@end
