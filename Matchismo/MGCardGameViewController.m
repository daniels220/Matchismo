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
#import "MGCardView.h"

@interface MGCardGameViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollection;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
- (IBAction)moveInHistory:(UISlider *)sender;
- (IBAction)flipCard:(UITapGestureRecognizer*)sender;

@property (weak, nonatomic) IBOutlet MGCardView *firstSelectedCard;
@property (weak, nonatomic) IBOutlet MGCardView *secondSelectedCard;

@property (weak, nonatomic) IBOutlet UILabel *pickMoveLabel;
@property (weak, nonatomic) IBOutlet MGCardView *pickMoveDisplayCard;
@property (weak, nonatomic) IBOutlet UILabel *matchMoveLabel;
@property (weak, nonatomic) IBOutlet MGCardView *matchMoveCard1;
@property (weak, nonatomic) IBOutlet MGCardView *matchMoveCard2;
@property (strong, nonatomic) NSArray *matchMoveDisplayCards;

@end

@implementation MGCardGameViewController

- (void)viewDidLoad {
	[self updateUI];
}

-(NSArray *)matchMoveDisplayCards {
	return @[self.matchMoveCard1,self.matchMoveCard2,self.pickMoveDisplayCard];
}

#pragma mark IBActions

- (IBAction)moveInHistory:(UISlider *)sender {
	[self updateMoveDisplayUsingMove:[self.game moveNumber:(NSInteger)sender.value]];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)sender {
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

#pragma mark CollectionViewDelegate/DataSource

-(NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.game.numCards;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell" forIndexPath:indexPath];
	
	[self updateCell:cell usingCard:[self.game cardAtIndex:indexPath.item]];
		
	return cell;
}

#pragma mark updateUI

-(void)updateUI {
	//Update labels
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
	
	//Update the log display
	[self updateMoveDisplayUsingMove:self.game.lastMove];
	
	//Update the selected display
	[self updateSelectedDisplayUsingCards:self.game.playableFaceUpCards];
	
	//Set the range for the history slider
	self.historySlider.enabled = self.game.numMoves > 1;
	self.historySlider.maximumValue = self.game.numMoves - 0.01;
	self.historySlider.value = self.game.numMoves - 0.01;
	
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
		else
			title = @"You Can Go No Further...";
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
																												message:[NSString stringWithFormat:@"Game completed in %.0f seconds",self.game.result.duration]
																											 delegate:nil
																							cancelButtonTitle:@"OK"
																							otherButtonTitles:nil];
		[alertView show];
	}
	
}

-(void)updateMoveDisplayUsingMove:(MGGameMove *)move {
	//Start of game
	if (!move) {
		self.pickMoveLabel.hidden = YES;
		self.pickMoveDisplayCard.hidden = YES;
		self.matchMoveLabel.hidden = YES;
		for (MGCardView* cardView in self.matchMoveDisplayCards)
			cardView.hidden = YES;
	}
	//"Pick"-type moves
	else if (move.cards.count < self.game.maxCardsUp) {
		//Update the card display
		[self updateCardView:self.pickMoveDisplayCard usingCard:[move.cards lastObject]];
		self.pickMoveDisplayCard.selected = NO;
		self.pickMoveDisplayCard.faceUp	= YES;
		//Hide the stuff that's only used for match-type moves
		self.matchMoveLabel.hidden = YES;
		for (MGCardView* cardView in self.matchMoveDisplayCards)
			cardView.hidden = YES;
		//Show the stuff that's used for pick-type moves
		self.pickMoveLabel.hidden = NO;
		self.pickMoveDisplayCard.hidden = NO;
	}
	//Moves where a match was made
	else {
		for (NSInteger i=0; i<self.game.maxCardsUp; i++) {
			[self updateCardView:self.matchMoveDisplayCards[i] usingCard:move.cards[i]];
			[self.matchMoveDisplayCards[i] setFaceUp:YES];
			[self.matchMoveDisplayCards[i] setSelected:NO];
			[self.matchMoveDisplayCards[i] setHidden:NO];
		}
		for (NSInteger i=self.game.maxCardsUp; i<self.matchMoveDisplayCards.count; i++)
			[self.matchMoveDisplayCards[i] setHidden:YES];
		
		self.matchMoveLabel.text = move.score > 0 ?
		[NSString stringWithFormat:@"Match! %d point%c",move.score,move.score == 1 ? ' ':'s'] :
		[NSString stringWithFormat:@"Don't match! -%d point%c",self.game.mismatchPenalty,move.score == 1 ? ' ':'s'];
		
		self.pickMoveLabel.hidden = YES;
		self.matchMoveLabel.hidden = NO;
	}
}

-(void)updateSelectedDisplayUsingCards:(NSArray *)cards {
	if (cards.count == 1) {
		[self updateCardView:self.firstSelectedCard usingCard:cards[0]];
		self.firstSelectedCard.selected = NO;
		self.firstSelectedCard.faceUp = YES;
		self.secondSelectedCard.hidden = YES;
		self.firstSelectedCard.hidden = NO;
	}
	else if (cards.count == 2) {
		[self updateCardView:self.firstSelectedCard usingCard:cards[0]];
		self.firstSelectedCard.selected = NO;
		self.firstSelectedCard.faceUp = YES;
		[self updateCardView:self.secondSelectedCard usingCard:cards[1]];
		self.secondSelectedCard.selected = NO;
		self.secondSelectedCard.faceUp = YES;
		self.firstSelectedCard.hidden = NO;
		self.secondSelectedCard.hidden = NO;
	}
	else {
		self.firstSelectedCard.hidden = YES;
		self.secondSelectedCard.hidden = YES;
	}
}

@end
