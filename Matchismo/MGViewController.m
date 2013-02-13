//
//  MGViewController.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGViewController.h"
#import "MGThreeCardMatchingGame.h"
#import "MGPlayingCardDeck.h"
#import "MGCard.h"

@interface MGViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitch;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@property (strong, nonatomic) Class gameMode;

- (IBAction)flipCard:(UIButton *)sender;
- (IBAction)deal;
- (IBAction)changeMode:(UISegmentedControl*)sender;
- (IBAction)moveInHistory:(UISlider *)sender;

- (void) updateUI;

@property (strong,nonatomic) MGMatchingGame* game;

@end

@implementation MGViewController

//GET/SET

-(void)setCardButtons:(NSArray *)cardButtons {
	_cardButtons = cardButtons;
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
	if (!_game) _game = [[self.gameMode alloc]
											 initWithCardCount:self.cardButtons.count
											 usingDeck:[MGPlayingCardDeck new]];
	return _game;
}

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

//OTHER
-(void)updateUI {
	//Update labels
	self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.game.numFlips];
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
	self.logLabel.text = self.game.lastMove;
	
	//Update state of cards
	for (UIButton* button in self.cardButtons) {
		MGCard* card = [self.game cardAtIndex:[self.cardButtons indexOfObject:button]];
		button.selected = card.faceUp;
		button.enabled = !card.unplayable;
		button.alpha = card.unplayable ? 0.5 : 1;
	}
	
	//Only have the mode switch enabled at the start of the game
	self.modeSwitch.enabled = self.game.numFlips == 0;
	
	//Set the range for the history slider
	self.historySlider.enabled = self.game.numFlips != 0;
	self.historySlider.maximumValue = self.game.numMoves;
	self.historySlider.value = self.game.numMoves;
}

@end
