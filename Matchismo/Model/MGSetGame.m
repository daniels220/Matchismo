//
//  MGSetGame.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGSetGame.h"
#import "MGGame_Protected.h"
#import "MGSetCard.h"

//The player can see all the cards, so they have no excuse for picking ones that don't match
#define MATCH_BONUS 2
#define MISMATCH_PENALTY 4

#define WIN_BONUS 10

@implementation MGSetGame

-(NSString *)typeString {
	return @"Set";
}

-(void)flipCardAtIndex:(NSUInteger)index {
	
	MGSetCard* cardToFlip = self.cards[index];
	//Definitely going to flip a card somehow
	self.numFlips++;
	
	//If we're just flipping a card down, do nothing else
	if (cardToFlip.faceUp) {
		cardToFlip.faceUp = FALSE;
		return;
	}
	
	//Find if other cards are face up
	NSArray* otherCards = [self playableCards];
	
	//Flip this one face up no matter what
	cardToFlip.faceUp = TRUE;
	
	//If there were two other cards up, so we need to match
	if (otherCards.count == 2) {
		MGSetCard* other1 = otherCards[0];
		MGSetCard* other2 = otherCards[1];
		//Try to match
		NSInteger score = [cardToFlip match:otherCards];
		
		//Start constructing the past-move string
		NSMutableAttributedString* pastMove = [[NSMutableAttributedString alloc] init];
		[pastMove appendAttributedString:cardToFlip.attributedString];
		[pastMove appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
		[pastMove appendAttributedString:other1.attributedString];
		[pastMove appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
		[pastMove appendAttributedString:other2.attributedString];
		
		//Did match
		if (score) {
			//All cards involved leave the game
			cardToFlip.unplayable = TRUE;
			other1.unplayable = TRUE;
			other2.unplayable = TRUE;

			//Score goes up depending on how good the match was
			self.score += score * MATCH_BONUS;
			
			[pastMove appendAttributedString:
			 [[NSAttributedString alloc] initWithString:
				[NSString stringWithFormat:@" is a Set! %d points.",score*MATCH_BONUS]]];
			[self.pastMoves addObject:pastMove];

			//Didn't match
		} else {
			//Flip the old card down
			other1.faceUp = FALSE;
			other2.faceUp = FALSE;
			//Penalty
			self.score -= MISMATCH_PENALTY;
			
			[pastMove appendAttributedString:
			 [[NSAttributedString alloc] initWithString:
				[NSString stringWithFormat:@" is not a Set! %d point penalty.",MISMATCH_PENALTY]]];
			[self.pastMoves addObject:pastMove];
		}
		
		//Now check if the game is done in some form
		NSArray* faceDown = [self faceDownCards];
		//If there are no cards left, we're done (bonus score!)
		if (faceDown.count == 0) {
			self.score += WIN_BONUS;
			self.gameState = DONE_STATE;
		}
		//If there are no sets on the board, we're stuck
		else if (![self haveSets])
			self.gameState = STUCK_STATE;

		if (self.gameState == DONE_STATE || self.gameState == STUCK_STATE) {
			[self.result endGameWithScore:self.score];
			[self.result synchronize];
		}
		
		//No other card was up, nothing interesting to do
	} else {
		NSMutableAttributedString* pastMove = [[NSMutableAttributedString alloc] initWithString:@"Chose "];
		[pastMove appendAttributedString:cardToFlip.attributedString];
		[pastMove appendAttributedString:[[NSAttributedString alloc] initWithString:@"."]];
		[self.pastMoves addObject:pastMove];
	}
	
}

-(BOOL)haveSets {
	NSArray* playableCards = [self faceDownCards];
	for (MGCard* card0 in playableCards) {
		for (MGCard* card1 in playableCards) {
			for (MGCard* card2 in playableCards) {
				if (card0 == card1 || card1 == card2 || card0 == card2)
					continue;
				if ([card0 match:@[card1,card2]])
					return YES;
			}
		}
	}
	return NO;
}

@end
