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
#import "MGCardCollectionViewCell.h"
#import "MGSetCardView.h"

@interface MGSetGameViewController ()
//Override type of self.game
@property (strong,nonatomic) MGSetGame* game;

@property (nonatomic,readwrite) NSUInteger startingCardCount;

@property (weak, nonatomic) IBOutlet UILabel *matchMoveLabel;
@property (strong, nonatomic) IBOutletCollection(MGSetCardView) NSArray *matchMoveDisplayCards;
@property (weak, nonatomic) IBOutlet UILabel *pickMoveLabel;
@property (weak, nonatomic) IBOutlet MGSetCardView *pickMoveDisplayCard;

@end

@implementation MGSetGameViewController

@synthesize startingCardCount = _startingCardCount;
-(NSUInteger)startingCardCount {
	if (_startingCardCount == 0) _startingCardCount = 12;
	return _startingCardCount;
}

-(void)updateCardView:(MGSetCardView *)cardView usingCard:(MGSetCard *)card {
	cardView.color = card.color;
	cardView.symbol = card.symbol;
	cardView.shading = card.shading;
	cardView.number = card.number;
	cardView.selected = card.faceUp;
	cardView.hidden = card.unplayable;
}

-(BOOL)cell:(MGCardCollectionViewCell *)cell needsUpdateFromCard:(MGSetCard *)card {
	if (![card isKindOfClass:MGSetCard.class] ||
			![cell.cardView isKindOfClass:MGSetCardView.class])
		return NO;
	MGSetCardView* view = (MGSetCardView*) cell.cardView;
	return view.number != card.number || view.shading != card.shading || view.symbol != card.symbol || view.color != card.color || view.selected != card.faceUp || view.hidden != card.unplayable;
}

-(MGSetGame *)game {
	if (!super.game) super.game = [[MGSetGame alloc]
																 initWithCardCount:self.startingCardCount
																 usingDeck:[MGSetDeck new]];
	return super.game;
}

#define YES_THERE_IS_PENALTY 2
- (IBAction)theresNoSet:(UIButton *)sender {
	//If there actually *is* a set
	if (self.game.gameState == PLAYING_STATE) {
		self.game.score -= YES_THERE_IS_PENALTY;
		[[[UIAlertView alloc] initWithTitle:@"Wrong!" message:@"There's still a set here. Can you find it?" delegate:nil cancelButtonTitle:@"Maybe..." otherButtonTitles:nil] show];
		[self updateUI];
	}
	else
		for (int i=0;i<3;i++)
			[self dealCard];
}

@end
