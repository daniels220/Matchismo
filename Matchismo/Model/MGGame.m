//
//  MGGame.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGGame_Protected.h"
#import "MGDeck.h"
#import "MGCard.h"

@interface MGGame()

@end

@implementation MGGame

//INITIALIZERS

//Designated initializer
-(id)initWithCardCount:(NSUInteger)count usingDeck:(MGDeck *)deck {
	if (self = [super init]) {
		for (int i=0; i<count; i++)
			[self.cards addObject:[deck drawRandomCard]];
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

-(NSArray *)playableCards {
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

-(id)movesAgo:(NSInteger)movesAgo {
	if ((NSInteger)(self.pastMoves.count) - 1 - movesAgo < 0)
		return nil;
	return self.pastMoves[self.pastMoves.count-1-movesAgo];
}

@end
