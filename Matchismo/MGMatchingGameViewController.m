//
//  MGMatchingGameViewController.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGMatchingGameViewController.h"
#import "MGCardGameViewController_Protected.h"

#import "MGMatchingGame.h"
#import "MGPlayingCardDeck.h"
#import "MGPlayingCard.h"
#import "MGCardCollectionViewCell.h"
#import "MGPlayingCardView.h"

@interface MGMatchingGameViewController ()

//Overrides declaration in parent class to change type from MGGame* to MGMatchingGame*
@property (strong, nonatomic) MGMatchingGame* game;

@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitch;
- (IBAction)changeMode:(UISegmentedControl*)sender;

@end

@implementation MGMatchingGameViewController

//GET/SET

-(void)updateCardView:(MGPlayingCardView *)cardView usingCard:(MGPlayingCard *)card {
	if (![card isKindOfClass:MGPlayingCard.class]) return;
	cardView.suit = card.suit;
	cardView.rank = card.rank;
	cardView.faceUp = card.faceUp;
	cardView.alpha = card.unplayable ? 0.5 : 1.0;
}

-(BOOL)cell:(MGCardCollectionViewCell *)cell needsUpdateFromCard:(MGPlayingCard *)card {
	if (![cell.cardView isKindOfClass:MGPlayingCardView.class] ||
			![card isKindOfClass:MGPlayingCard.class])
		return NO;
	MGPlayingCardView* view = (MGPlayingCardView*) cell.cardView;
	return ![view.suit isEqualToString:card.suit] || view.rank != card.rank || view.faceUp != card.faceUp || (view.alpha == 1.0) == card.unplayable;
}

-(CGSize)sizeForCardCell {
	return CGSizeMake(60,80);
}

-(CGSize)sizeForMatchCellWithCards:(NSUInteger)numCards {
	return CGSizeMake(numCards*30+(numCards-1)*4, 40);
}

-(MGMatchingGame *)game {
	if (!super.game) super.game = [MGMatchingGame new];
	super.game.maxCardsUp = self.modeSwitch.selectedSegmentIndex == 0 ? 2 : 3;
	return super.game;
}

- (IBAction)changeMode:(UISegmentedControl *)sender {
	if ([sender selectedSegmentIndex] == 0)
		self.game.maxCardsUp = 2;
	else
		self.game.maxCardsUp = 3;
	[self deal];
}

-(void)updateUI {
	[super updateUI];
	
	//Only have the mode switch enabled at the start of the game
	self.modeSwitch.enabled = self.game.numMoves == 0;
}


@end
