//
//  MGViewController.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGViewController_Protected.h"
#import "MGPlayingCardDeck.h"
#import "MGCard.h"
#import "MGGame.h"

@interface MGViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (IBAction)flipCard:(UIButton *)sender;

@end

@implementation MGViewController

//IBActions
- (IBAction)flipCard:(UIButton *)sender {
	[self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
	[self updateUI];
}

- (IBAction)deal {
	//Game will be recreated next time self.game is called
	self.game = nil;
	//Reinitialize card buttons by forcing a recall of [self setCardButtons:]
	self.cardButtons = self.cardButtons;
	//Update the rest of the UI to flip cards facedown etc.
	[self updateUI];
}

//OTHER
-(void)updateUI {
	//Update labels
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
	
	//Update state of cards
	for (UIButton* button in self.cardButtons) {
		MGCard* card = [self.game cardAtIndex:[self.cardButtons indexOfObject:button]];
		button.selected = card.faceUp;
		button.enabled = !card.unplayable;
		button.alpha = card.unplayable ? 0.5 : 1;
	}
	
}

@end
