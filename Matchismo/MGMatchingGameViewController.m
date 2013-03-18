//
//  MGMatchingGameViewController.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGMatchingGameViewController.h"
#import "MGCardGameViewController_Protected.h"

#import "MGThreeCardMatchingGame.h"
#import "MGPlayingCardDeck.h"
#import "MGPlayingCard.h"
#import "MGPlayingCardCollectionViewCell.h"
#import "MGPlayingCardView.h"

@interface MGMatchingGameViewController ()

//Overrides declaration in parent class to change type from MGGame* to MGMatchingGame*
@property (strong, nonatomic) MGMatchingGame* game;
@property (strong, nonatomic) Class gameMode;

@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitch;
- (IBAction)changeMode:(UISegmentedControl*)sender;

@end

@implementation MGMatchingGameViewController

//GET/SET
-(Class)gameMode {
	if (!_gameMode) _gameMode = MGMatchingGame.class;
	return _gameMode;
}

-(NSUInteger)startingCardCount {
	return 16;
}

-(void)updateCell:(MGPlayingCardCollectionViewCell *)cell usingCard:(MGPlayingCard *)card {
	if (![cell isKindOfClass:MGPlayingCardCollectionViewCell.class] ||
			![card isKindOfClass:MGPlayingCard.class])
		return;
	cell.playingCardView.suit = card.suit;
	cell.playingCardView.rank = card.rank;
	cell.playingCardView.faceUp = card.faceUp;
	cell.playingCardView.alpha = card.unplayable ? 0.5 : 1.0;
}

-(BOOL)cell:(MGPlayingCardCollectionViewCell *)cell needsUpdateFromCard:(MGPlayingCard *)card {
	if (![cell isKindOfClass:MGPlayingCardCollectionViewCell.class] ||
			![card isKindOfClass:MGPlayingCard.class])
		return NO;
	MGPlayingCardView* view = cell.playingCardView;
	return ![view.suit isEqualToString:card.suit] || view.rank != card.rank || view.faceUp != card.faceUp || (view.alpha == 1.0) == card.unplayable;
}

-(MGMatchingGame *)game {
	if (!super.game) super.game = [[self.gameMode alloc]
											 initWithCardCount:self.startingCardCount
											 usingDeck:[MGPlayingCardDeck new]];
	return super.game;
}

- (IBAction)changeMode:(UISegmentedControl *)sender {
	if ([sender selectedSegmentIndex] == 0)
		self.gameMode = MGMatchingGame.class;
	else
		self.gameMode = MGThreeCardMatchingGame.class;
	[self deal];
}

-(void)updateUI {
	[super updateUI];
	
	//Only have the mode switch enabled at the start of the game
	self.modeSwitch.enabled = self.game.numFlips == 0;
}


@end
