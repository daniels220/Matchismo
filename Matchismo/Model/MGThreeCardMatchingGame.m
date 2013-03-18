//
//  MGThreeCardMatchingGame.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/10/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGThreeCardMatchingGame.h"
#import "MGGame_Protected.h"
#import "MGCard.h"

@interface MGThreeCardMatchingGame ()

@end

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

#define WIN_BONUS 10

@implementation MGThreeCardMatchingGame

-(NSString *)typeString {
	return @"Three-Card Match";
}

-(void)flipCardAtIndex:(NSUInteger)index {

	MGCard* cardToFlip = self.cards[index];
	
	if (cardToFlip.unplayable)
		return;
	
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
	self.score -= FLIP_COST;
	
	//If there were two other cards up, so we need to match
	if (otherCards.count == 2) {
		//Try to match
		NSInteger score = [cardToFlip match:otherCards];
		
		//Did match
		if (score) {
			//All cards involved leave the game
			cardToFlip.unplayable = TRUE;
			for (MGCard* otherCard in otherCards)
				otherCard.unplayable = TRUE;
			//Score goes up depending on how good the match was
			self.score += score * MATCH_BONUS;
			
			[self.pastMoves addObject:
			 [NSString stringWithFormat:@"%@, %@, %@ matched for %d points",
				cardToFlip,otherCards[0],otherCards[1],score*MATCH_BONUS]];
			//Didn't match
		} else {
			//Flip the old card down
			for (MGCard* otherCard in otherCards)
				otherCard.faceUp = FALSE;
			//Penalty
			self.score -= MISMATCH_PENALTY;
			
			[self.pastMoves addObject:
			 [NSString stringWithFormat:@"%@, %@, %@ do not match, %d point penalty",
				cardToFlip,otherCards[0],otherCards[1],MISMATCH_PENALTY]];
		}
		
		//Now check if the game is done in some form
		NSArray* faceDown = [self faceDownCards];
		//If there are no cards left, we're done (bonus score!)
		if (faceDown.count == 0) {
			self.score += WIN_BONUS;
			self.gameState = DONE_STATE;
		}
		//If there are exactly three cards face-down and they don't match, we're stuck
		else if (faceDown.count == 3 && ![faceDown[0] match:@[faceDown[1],faceDown[2]]])
			self.gameState = STUCK_STATE;
		//If there are 6 cards face down, we could be stuck, but it's hell to check for
#pragma message("TODO check for stuck games with 6 cards left")
		//If there are too few cards left, stuck too
		else if (faceDown.count == 1 || faceDown.count == 2)
			self.gameState = STUCK_STATE;
		
		if (self.gameState == DONE_STATE || self.gameState == STUCK_STATE) {
			[self.result endGameWithScore:self.score];
			[self.result synchronize];
		}
		
		//Not enough other cards were up, nothing interesting to do
	} else {
		[self.pastMoves addObject:[NSString stringWithFormat:@"Flipped up %@",cardToFlip.contents]];
	}
}

@end
