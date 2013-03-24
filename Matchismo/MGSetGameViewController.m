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

typedef enum HintState {
	HintStateNoHint,
	HintStateHint,
	HintStateShowMe,
	HintStateNoSet
} HintState;

@interface MGSetGameViewController ()
//Override type of self.game
@property (strong,nonatomic) MGSetGame* game;

@property (weak, nonatomic) IBOutlet UIButton *hintButton;
@property (nonatomic) HintState	hintState;
@property (strong, nonatomic) NSArray* hintedCards;

@end

@implementation MGSetGameViewController

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

-(CGSize)sizeForCardCell {
	return CGSizeMake(80,60);
}

-(CGSize)sizeForMatchCellWithCards:(NSUInteger)numCards {
	return CGSizeMake(numCards*40+(numCards-1)*4, 30);
}

-(MGSetGame *)game {
	if (!super.game) super.game = [MGSetGame new];
	return super.game;
}

#define YES_THERE_IS_PENALTY 2
- (IBAction)theresNoSet {
	self.game.lastFlipWasMatch = NO;
	self.hintState = HintStateNoHint;
	[self updateHintedCards];
	[self updateHintButton];
	//If there actually *is* a set
	if (self.game.canContinue) {
		self.game.score -= YES_THERE_IS_PENALTY;
		[[[UIAlertView alloc] initWithTitle:@"Wrong!" message:@"There's still a set here. Can you find it?" delegate:nil cancelButtonTitle:@"Maybe..." otherButtonTitles:nil] show];
		self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
	}
	else
		for (int i=0;i<3;i++)
			[self dealCard];
}

#define HINT_PENALTY 2
- (IBAction)giveHint {
	//We haven't given any hint at all, this is the first time the user is clicking the button
	switch (self.hintState) {
		case HintStateNoHint:
			self.hintState = HintStateHint;
			self.game.score -= HINT_PENALTY;
			self.hintedCards = [self.game findSet];
			if (!self.hintedCards) {
				[[[UIAlertView alloc] initWithTitle:@"There's no Set!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
				self.hintState = HintStateNoSet;
			}
			break;
		case HintStateHint:
			self.game.score -= HINT_PENALTY;
			self.hintState = HintStateShowMe;
			break;
		case HintStateShowMe:
			self.hintState = HintStateNoHint;
			break;
		case HintStateNoSet:
			//Can't happen, button will be disabled
			break;
	}
	[self updateHintedCards];
	[self updateHintButton];
}

-(void)updateUI {
	[super updateUI];
	if (self.game.lastFlipWasMatch)
		self.hintState = HintStateNoHint;
	[self updateHintedCards];
	[self updateHintButton];
}

-(void)updateHintedCards {
	for (MGCardCollectionViewCell* cell in self.cardCollection.visibleCells) {
		MGCard* card = [self.game cardAtIndex:[self.cardCollection indexPathForCell:cell].item];
		cell.cardView.starred = [self shouldStarCard:card];
	}
}

-(BOOL)shouldStarCard:(MGCard*)card {
	if (self.hintState == HintStateNoHint || self.hintState == HintStateNoSet)
		return NO;
	if (self.hintState == HintStateHint)
		return [card isEqual:self.hintedCards[0]];
	return [self.hintedCards containsObject:card];
}

#define CARDS_SECTION 0
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	MGCardCollectionViewCell* cell = (MGCardCollectionViewCell*) [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
	if (indexPath.section == CARDS_SECTION) {
		cell.cardView.starred = [self shouldStarCard:[self.game cardAtIndex:indexPath.item]];
	}
	return cell;
}

-(void)updateHintButton {
	switch (self.hintState) {
		case HintStateNoHint:
			[self.hintButton setTitle:@"Hint" forState:UIControlStateNormal];
			self.hintButton.hidden = NO;
			self.hintButton.enabled = YES;
			break;
		case HintStateHint:
			[self.hintButton setTitle:@"Show" forState:UIControlStateNormal];
			self.hintButton.hidden = NO;
			break;
		case HintStateShowMe:
			self.hintButton.hidden = YES;
			break;
		case HintStateNoSet:
			self.hintButton.enabled = NO;
	}
}

-(void)deal {
	self.hintState = HintStateNoHint;
	[super deal];
}

@end
