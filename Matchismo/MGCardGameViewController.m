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
#import "MGCardCollectionViewCell.h"
#import "MGMatchCollectionViewCell.h"

@interface MGCardGameViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollection;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
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

@end

@implementation MGCardGameViewController

- (void)viewDidLoad {
	[self setupUI];
	[self updateUI];
}

-(void)setupUI {
//	for (NSLayoutConstraint* constraint in self.view.constraints) {
//		if (constraint.)
//	}
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

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 2;
}

#define CARDS_SECTION 0
#define MATCHES_SECTION 1
-(NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
	if (section == CARDS_SECTION)
		return self.game.numCards;
	else if (section == MATCHES_SECTION)
		return self.game.pastMatches.count;
	else
		return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
		
	if (indexPath.section == CARDS_SECTION) {
		MGCardCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell" forIndexPath:indexPath];
		
		[self updateCell:cell usingCard:[self.game cardAtIndex:indexPath.item]];
		return cell;
	}
	else if (indexPath.section == MATCHES_SECTION) {
		MGMatchCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"matchCell" forIndexPath:indexPath];
		NSArray* match = self.game.pastMatches[indexPath.item];
		
		[self updateCardView:cell.twoCardViews[0] usingCard:match[0]];
		[self updateCardView:cell.twoCardViews[1] usingCard:match[1]];
		if (match.count == 3)
			[self updateCardView:cell.thirdCardView usingCard:match[2]];
		else {
			cell.thirdCardView.hidden = YES;
			CGRect bounds = cell.bounds;
#pragma message("Magic number...")
			bounds.size.width = 84;
			cell.bounds = bounds;
		}
		
		return cell;
	}
	return nil;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	if (kind == UICollectionElementKindSectionHeader && indexPath.section == MATCHES_SECTION) {
		return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"matchesHeader" forIndexPath:indexPath];
	}
	return nil;
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
	
	[self updateAllCards];

	[self.cardCollection reloadData];
//	[self.cardCollection reloadSections:[[NSIndexSet alloc] initWithIndex:MATCHES_SECTION]];
	
	//Check if the game is done and pop up an alert view
	if (self.game.gameState == DONE_STATE || (self.game.gameState == STUCK_STATE && !self.game.canDealCard)) {
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
		self.matchMoveCard1.hidden = YES;
		self.matchMoveCard2.hidden = YES;
	}
	//"Pick"-type moves
	else if (move.cards.count < self.game.maxCardsUp) {
		//Update the card display
		[self updateCardView:self.pickMoveDisplayCard usingCard:[move.cards lastObject]];
		[self updateCardViewForStaticDisplay:self.pickMoveDisplayCard];
		//Hide the stuff that's only used for match-type moves
		self.matchMoveLabel.hidden = YES;
		self.matchMoveCard1.hidden = YES;
		self.matchMoveCard2.hidden = YES;
		//Show the stuff that's used for pick-type moves
		self.pickMoveLabel.hidden = NO;
	}
	//Moves where a match was made
	else {
		[self updateCardView:self.matchMoveCard1 usingCard:move.cards[0]];
		[self updateCardViewForStaticDisplay:self.matchMoveCard1];
		[self updateCardView:self.matchMoveCard2 usingCard:move.cards[1]];
		[self updateCardViewForStaticDisplay:self.matchMoveCard2];
		if (move.cards.count == 3) {
			[self updateCardView:self.pickMoveDisplayCard usingCard:move.cards[2]];
			[self updateCardViewForStaticDisplay:self.pickMoveDisplayCard];
		}
		else
			self.pickMoveDisplayCard.hidden = YES;
				
		self.matchMoveLabel.text = move.score > 0 ?
		[NSString stringWithFormat:@"Match! %d point%c",move.score,move.score == 1 ? ' ':'s'] :
		[NSString stringWithFormat:@"Don't match! -%d point%c",self.game.mismatchPenalty,move.score == 1 ? ' ':'s'];
		
		self.pickMoveLabel.hidden = YES;
		self.matchMoveLabel.hidden = NO;
	}
}

-(void)updateCell:(MGCardCollectionViewCell *)cell usingCard:(MGCard *)card {
	[self updateCardView:cell.cardView usingCard:card];
}

-(void)updateCardViewForStaticDisplay:(MGCardView*)cardView {
	cardView.hidden = NO;
	cardView.faceUp = YES;
	cardView.selected = NO;
}

-(void)updateSelectedDisplayUsingCards:(NSArray *)cards {
	if (cards.count == 1) {
		[self updateCardView:self.firstSelectedCard usingCard:cards[0]];
		[self updateCardViewForStaticDisplay:self.firstSelectedCard];
		self.secondSelectedCard.hidden = YES;
	}
	else if (cards.count == 2) {
		[self updateCardView:self.firstSelectedCard usingCard:cards[0]];
		[self updateCardViewForStaticDisplay:self.firstSelectedCard];
		[self updateCardView:self.secondSelectedCard usingCard:cards[1]];
		[self updateCardViewForStaticDisplay:self.secondSelectedCard];
	}
	else {
		self.firstSelectedCard.hidden = YES;
		self.secondSelectedCard.hidden = YES;
	}
}

-(void)updateAllCards {
	//Update state of cards
	for (UICollectionViewCell* cell in self.cardCollection.visibleCells) {
		MGCard* card = [self.game cardAtIndex:[self.cardCollection indexPathForCell:cell].item];
		if (card.unplayable) {
			[self.game removeCard:card];
			[self.cardCollection deleteItemsAtIndexPaths:@[[self.cardCollection indexPathForCell:cell]]];
			
			if (self.game.canDealCard)
				[self dealCard];
		}
		else if ([self cell:cell needsUpdateFromCard:card])
			[UIView transitionWithView:cell
												duration:0.25
												 options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionLayoutSubviews
											animations:^{ [self updateCell:cell usingCard:card]; }
											completion:nil];
	}
}

-(void)dealCard {
	[self.game dealCard];
	NSUInteger indices[] = {0 , self.game.numCards-1};
	[self.cardCollection insertItemsAtIndexPaths:@[[[NSIndexPath alloc] initWithIndexes:indices length:2]]];
}

@end
