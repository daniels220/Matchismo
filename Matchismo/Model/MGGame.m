//
//  MGGame.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGGame_Protected.h"

@interface MGGame()
@end

@implementation MGGame

//INITIALIZERS

//Designated initializer
-(id)init {
	if (self = [super init]) {
		for (int i=0; i<self.cardsToDeal; i++)
			[self.cards addObject:[self.deck drawRandomCard]];
		self.result = [[MGGameResult alloc] initWithGameType:self.typeString];
	}
	return self;
}

//GET/SET

-(NSMutableArray *)cards {
	if (!_cards) _cards = [NSMutableArray new];
	return _cards;
}

-(NSArray *)faceDownCards {
	NSMutableArray* faceDownCards = [NSMutableArray new];
	for (MGCard* card in self.cards)
		if (!card.faceUp)
			[faceDownCards addObject:card];
	return faceDownCards;
}

-(NSArray *)playableFaceUpCards {
	NSMutableArray* playableCards = [NSMutableArray new];
	for (MGCard* card in self.cards)
		if (card.faceUp && !card.unplayable)
			[playableCards addObject:card];
	return playableCards;
}

-(NSUInteger)numCards {
	return self.cards.count;
}

-(MGCard *)cardAtIndex:(NSUInteger)index {
	return self.cards[index];
}

-(void)removeCard:(MGCard*)card {
	[self.cards removeObject:card];
}

-(BOOL)canDealCard {
	return self.deck.cardsRemaining > 0;
}

-(void)dealCard {
	if ([self canDealCard])
		[self.cards addObject:[self.deck drawRandomCard]];
	self.gameState = [self canContinue] ? PLAYING_STATE : STUCK_STATE;
}

-(NSMutableArray *)pastMoves {
	if (!_pastMoves) _pastMoves = [NSMutableArray new];
	return _pastMoves;
}

-(id)lastMove {
	return [self.pastMoves lastObject];
}

-(NSInteger)numMoves {
	return self.pastMoves.count;
}

-(MGGameMove *)moveNumber:(NSInteger)moveNumber {
	if (moveNumber > self.numMoves)
		return nil;
	return self.pastMoves[moveNumber];
}

-(NSMutableArray *)pastMatches {
	if (!_pastMatches) _pastMatches = [NSMutableArray new];
	return _pastMatches;
}

-(void)flipCardAtIndex:(NSUInteger)index {
	MGCard* cardToFlip = self.cards[index];
	//Every *flip*, whether it's up or down, resets this flag
	self.lastFlipWasMatch = NO;
	
	//This check is no longer needed given the current controller implementation
	//but it seems like a good idea
	if (cardToFlip.unplayable)
		return;
	
	self.numFlips++;
	
	if (cardToFlip.faceUp) {
		cardToFlip.faceUp = NO;
		return;
	}
	
	NSArray* otherCards = [self playableFaceUpCards];
	
	cardToFlip.faceUp = YES;
	self.score -= self.flipCost;
	
	MGGameMove* pastMove;
	NSArray* allCards = [otherCards arrayByAddingObject:cardToFlip];
	
	if (otherCards.count == self.maxCardsUp - 1) {
		NSInteger score = [cardToFlip match:otherCards];
		if (score) {
			//Matched, need to expose that to our controller
			self.lastFlipWasMatch = YES;
			cardToFlip.unplayable = YES;
			for (MGCard* card in otherCards)
				card.unplayable = YES;
			
			self.score += score * self.matchBonus;
			//Add this move to the past-matches array
			[self.pastMatches addObject:[otherCards arrayByAddingObject:cardToFlip]];
		} //end if matched
		else {
			for (MGCard* card in otherCards)
				card.faceUp = NO;
			self.score -= self.mismatchPenalty;
		} //end else did not match
		pastMove = [[MGGameMove alloc] initWithCards:allCards score:score*self.matchBonus];
	} // end if should match
	else {
		pastMove = [[MGGameMove alloc] initWithCards:@[cardToFlip] score:0];
	}

	//There's always a move to record
	[self.pastMoves addObject:pastMove];
	
	//Now check if the game is done in some form
	NSArray* faceDown = [self faceDownCards];
	//If there are no cards left, we're done (bonus score!)
	if (faceDown.count == 0) {
		self.score += self.winBonus;
		self.gameState = DONE_STATE;
	}
	//If there aren't enough cards left, or they can't possibly match, we're stuck
	else if (faceDown.count < self.maxCardsUp || ![self canContinue])
		self.gameState = STUCK_STATE;
	
	if (self.gameState == DONE_STATE || self.gameState == STUCK_STATE) {
		[self.result endGameWithScore:self.score];
		[self.result synchronize];
	}
	
}

//Just check all possible combinations of cards to see if they match
-(BOOL)canContinue {
	NSArray* playable = [[self faceDownCards] arrayByAddingObjectsFromArray:[self playableFaceUpCards]];
	if (self.maxCardsUp == 2) {
		for (MGCard* card0 in playable)
			for (MGCard* card1 in playable) {
				if (card0 == card1) continue;
				if ([card0 match:@[card1]])
					return YES;
			}
	}
	else if (self.maxCardsUp == 3) {
		for (MGCard* card0 in playable)
			for (MGCard* card1 in playable)
				for (MGCard* card2 in playable) {
					if (card0 == card1 || card1 == card2 || card0 == card2)
						continue;
					if ([card0 match:@[card1,card2]])
						return YES;
				}
	}
	return NO;
}

@end
