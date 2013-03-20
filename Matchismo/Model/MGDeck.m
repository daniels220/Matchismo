//
//  MGDeck.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGDeck.h"
#import "MGCard.h"

@interface MGDeck()

@property (strong,nonatomic) NSMutableArray* cards; //of MGCard

@end

@implementation MGDeck

-(NSMutableArray *)cards {
	if (!_cards)
		_cards = [NSMutableArray new];
	return _cards;
}

-(void)addCard:(MGCard *)card {
	if (card)
		[self.cards addObject:card];
}

-(MGCard *)drawRandomCard {
	if (self.cards.count == 0) return nil;
	
	int randPos = arc4random_uniform(self.cards.count);
	
	MGCard* randCard = self.cards[randPos];
	[self.cards removeObjectAtIndex:randPos];
	
	return randCard;
}

-(NSUInteger)cardsRemaining {
	return self.cards.count;
}

@end
