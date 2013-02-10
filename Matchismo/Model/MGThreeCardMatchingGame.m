//
//  MGThreeCardMatchingGame.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/10/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGThreeCardMatchingGame.h"
#import "MGMatchingGame_Protected.h"
#import "MGCard.h"

@interface MGThreeCardMatchingGame ()

@end

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

@implementation MGThreeCardMatchingGame

-(void)flipCardAtIndex:(NSUInteger)index {

	MGCard* cardToFlip = self.cards[index];
	//Definitely going to flip a card somehow
	self.numFlips++;
	
	//If we're just flipping a card down, do nothing else
	if (cardToFlip.faceUp) {
		cardToFlip.faceUp = FALSE;
		return;
	}
	
	//Find if other cards are face up
	NSMutableArray* otherCards = [NSMutableArray new];
	for (MGCard* card in self.cards)
		if (card.faceUp  && !card.unplayable)
			[otherCards addObject:card];
	
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
		//No other card was up, nothing interesting to do
	} else {
		[self.pastMoves addObject:[NSString stringWithFormat:@"Flipped up %@",cardToFlip.contents]];
	}
}

@end
