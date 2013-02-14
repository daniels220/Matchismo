//
//  MGMatchingGameViewController.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGMatchingGameViewController.h"
#import "MGViewController_Protected.h"

#import "MGCard.h"
#import "MGPlayingCardDeck.h"
#import "MGThreeCardMatchingGame.h"

@interface MGMatchingGameViewController ()

//Overrides declaration in parent class to change type from MGGame* to MGMatchingGame*
@property (strong, nonatomic) MGMatchingGame* game;
@property (strong, nonatomic) Class gameMode;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;

@property (weak, nonatomic) IBOutlet UILabel *logLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
- (IBAction)moveInHistory:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitch;
- (IBAction)changeMode:(UISegmentedControl*)sender;

@end

@implementation MGMatchingGameViewController

//GET/SET

-(void)setCardButtons:(NSArray *)cardButtons {
	[super setCardButtons:cardButtons];
	for (UIButton* button in self.cardButtons) {
		MGCard* card = [self.game cardAtIndex:[self.cardButtons indexOfObject:button]];
		[button setImage:[UIImage new] forState:UIControlStateSelected];
		[button setImage:[UIImage new] forState:UIControlStateSelected|UIControlStateDisabled];
		[button setTitle:card.contents forState:UIControlStateSelected];
		[button setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
	}
}

-(Class)gameMode {
	if (!_gameMode) _gameMode = MGMatchingGame.class;
	return _gameMode;
}

-(MGMatchingGame *)game {
	if (!super.game) super.game = [[self.gameMode alloc]
											 initWithCardCount:self.cardButtons.count
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

- (IBAction)moveInHistory:(UISlider *)sender {
	self.logLabel.text = [self.game movesAgo:(NSInteger)(self.game.numMoves - sender.value)];
}

-(void)updateUI {
	[super updateUI];
	
	self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.game.numFlips];
	
	//Update the log label
	self.logLabel.text = self.game.lastMove;
	
	//Only have the mode switch enabled at the start of the game
	self.modeSwitch.enabled = self.game.numFlips == 0;
	
	//Set the range for the history slider
	self.historySlider.enabled = self.game.numFlips != 0;
	self.historySlider.maximumValue = self.game.numMoves;
	self.historySlider.value = self.game.numMoves;

}


@end
