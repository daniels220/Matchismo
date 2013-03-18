//
//  MGMatchingGame.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGMatchingGame.h"
#import "MGGame_Protected.h"
#import "MGCard.h"
#import "MGDeck.h"

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

#define WIN_BONUS 10

@implementation MGMatchingGame

-(NSString *)typeString {
	return @"Match";
}

-(void)flipCardAtIndex:(NSUInteger)index {
	MGCard* cardToFlip = self.cards[index];
	
	//Stop if we can't flip this card
	if (cardToFlip.unplayable)
		return;
	
	//If we can, we're going to
	self.numFlips++;
	
	//If we're just flipping a card down, do nothing else
	if (cardToFlip.faceUp) {
		cardToFlip.faceUp = FALSE;
		return;
	}
	
	//Find if another card is face up
	NSArray* otherCards = [self playableCards];
	MGCard* otherCard = otherCards.count ? otherCards[0] : nil;
	
	//Flip this one face up no matter what
	cardToFlip.faceUp = TRUE;
	self.score -= FLIP_COST;
	
	//If there was another up...
	if (otherCard) {
		//Try to match against it
		NSInteger score = [cardToFlip match:@[otherCard]];
		
		//Did match
		if (score) {
			//Both cards leave the game
			cardToFlip.unplayable = TRUE;
			otherCard.unplayable = TRUE;
			//Score goes up depending on how good the match was
			self.score += score * MATCH_BONUS;

			[self.pastMoves addObject:
			 [NSString stringWithFormat:@"%@ matched %@ for %d points",
				cardToFlip,otherCard,score*MATCH_BONUS]];
		//Didn't match
		} else {
			//Flip the old card down
			otherCard.faceUp = FALSE;
			//Penalty
			self.score -= MISMATCH_PENALTY;
			
			[self.pastMoves addObject:
			 [NSString stringWithFormat:@"%@ does not match %@, %d point penalty",
				cardToFlip,otherCard,MISMATCH_PENALTY]];
		}
		
		//Now check if the game is done in some form
		NSArray* faceDown = [self faceDownCards];
		//If there are no cards left, we're done (bonus score!)
		if (faceDown.count == 0) {
			self.score += WIN_BONUS;
			self.gameState = DONE_STATE;
		}
		//If there are exactly two cards face-down and they don't match, we're stuck
		else if (faceDown.count == 2 && ![faceDown[0] match:@[faceDown[1]]])
				self.gameState = STUCK_STATE;
		//If there are 4 cards face down, we just might be stuck too
		else if (faceDown.count == 4 &&
						 ![faceDown[0] match:@[faceDown[1]]] &&
						 ![faceDown[0] match:@[faceDown[2]]] &&
						 ![faceDown[0] match:@[faceDown[3]]] &&
						 ![faceDown[1] match:@[faceDown[2]]] &&
						 ![faceDown[1] match:@[faceDown[3]]] &&
						 ![faceDown[2] match:@[faceDown[3]]])
			self.gameState = STUCK_STATE;
		
		if (self.gameState == DONE_STATE || self.gameState == STUCK_STATE) {
				[self.result endGameWithScore:self.score];
				[self.result synchronize];
		}
			
	//No other card was up, nothing interesting to do
	} else {
		[self.pastMoves addObject:[NSString stringWithFormat:@"Flipped up %@",cardToFlip.contents]];
	}
}

@end
