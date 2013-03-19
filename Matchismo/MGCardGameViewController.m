//
//  MGViewController.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGCardGameViewController_Protected.h"
#import "MGDeck.h"
#import "MGCard.h"
#import "MGGame.h"
#import "MGGameResult.h"

@interface MGCardGameViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollection;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
- (IBAction)moveInHistory:(UISlider *)sender;
- (IBAction)flipCard:(UITapGestureRecognizer*)sender;

@end

@implementation MGCardGameViewController

-(void)viewDidLoad {
	[self updateUI];
}

- (IBAction)moveInHistory:(UISlider *)sender {
	self.logLabel.text = [self.game movesAgo:(NSInteger)(self.game.numMoves - sender.value)];
}

-(void)flipCard:(UITapGestureRecognizer *)sender {
	NSIndexPath* path = [self.cardCollection indexPathForItemAtPoint:[sender locationInView:self.cardCollection]];
	if (path) {
		[self.game flipCardAtIndex:path.item];
		[self updateUI];
	}
}

- (IBAction)deal {
	//Game will be recreated next time self.game is called
	self.game = nil;
	//Tell our collection view to reload its data (self.game will be reinitialized here)
	[self.cardCollection reloadData];
	//Update the rest of the UI to reset score, numFlips, etc.--card flipping is already done
	[self updateUI];
}

-(NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.game.numCards;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell" forIndexPath:indexPath];
	
	[self updateCell:cell usingCard:[self.game cardAtIndex:indexPath.item]];
		
	return cell;
}

//OTHER
-(void)updateUI {
	//Update labels
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
	self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.game.numFlips];
	
	//Update the log label
	if ([self.game.lastMove isKindOfClass:UILabel.class])
		self.logLabel.attributedText = [self.game.lastMove attributedText];
	else
		self.logLabel.text = self.game.lastMove;
	
	//Set the range for the history slider
	self.historySlider.enabled = self.game.numFlips != 0;
	self.historySlider.maximumValue = self.game.numMoves;
	self.historySlider.value = self.game.numMoves;
	
	//Update state of cards
	for (UICollectionViewCell* cell in self.cardCollection.visibleCells) {
		MGCard* card = [self.game cardAtIndex:[self.cardCollection indexPathForCell:cell].item];
		if ([self cell:cell needsUpdateFromCard:card])
			[UIView transitionWithView:cell
												duration:0.25
												 options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionLayoutSubviews
											animations:^{ [self updateCell:cell usingCard:card]; }
											completion:nil];
	}
	
	//Check if the game is done and pop up an alert view
	if (self.game.gameState == DONE_STATE || self.game.gameState == STUCK_STATE) {
		NSString* title;
		if (self.game.gameState == DONE_STATE)
			title = @"You Win!";
		else {
			title = @"You Can Go No Further...";
		}
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
																												message:[NSString stringWithFormat:@"Game completed in %.0f seconds",self.game.result.duration]
																											 delegate:nil
																							cancelButtonTitle:@"OK"
																							otherButtonTitles:nil];
		[alertView show];
	}
	
}

@end
