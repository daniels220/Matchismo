//
//  MGMatchingGame.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGMatchingGame_Protected.h"
#import "MGCard.h"
#import "MGDeck.h"

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

@implementation MGMatchingGame

#pragma mark OVERRIDES

#pragma mark GET/SET

-(NSMutableArray *)pastMoves {
	if (!_pastMoves) _pastMoves = [NSMutableArray new];
	return _pastMoves;
}

-(NSString *)lastMove {
	return [self.pastMoves lastObject];
}

-(NSInteger)numMoves {
	return self.pastMoves.count;
}

-(NSString *)movesAgo:(NSInteger)movesAgo {
	if ((NSInteger)(self.pastMoves.count) - 1 - movesAgo < 0)
		return nil;
	return self.pastMoves[self.pastMoves.count-1-movesAgo];
}

#pragma mark OTHER

-(void)flipCardAtIndex:(NSUInteger)index {
	MGCard* cardToFlip = self.cards[index];
	//Definitely going to flip a card somehow
	self.numFlips++;
	
	//If we're just flipping a card down, do nothing else
	if (cardToFlip.faceUp) {
		cardToFlip.faceUp = FALSE;
		return;
	}
	
	//Find if another card is face up
	MGCard* otherCard;
	for (MGCard* card in self.cards)
		if (card.faceUp  && !card.unplayable) {
			otherCard = card;
			break;
		}
	
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
	//No other card was up, nothing interesting to do
	} else {
		[self.pastMoves addObject:[NSString stringWithFormat:@"Flipped up %@",cardToFlip.contents]];
	}
}

@end
