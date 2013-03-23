//
//  MGPlayingCard.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGPlayingCard.h"
#import <math.h>

@implementation MGPlayingCard

//OVERRIDES
-(NSString *)contents {
	return [NSString stringWithFormat:@"%@%@",self.rankString,self.suit];
}

-(NSUInteger)match:(NSArray *)otherCards {
	BOOL allRanksMatch = YES;
	BOOL allSuitsMatch = YES;
	for (MGPlayingCard* otherCard in otherCards) {
		if (![otherCard.suit isEqualToString:self.suit])
			allSuitsMatch = NO;
		if (otherCard.rank != self.rank)
			allRanksMatch = NO;
	}
	//All ranks match, for 2 cards is worth 4 points, for 3 cards is worth 16 points, etc
	if (allRanksMatch)
		return pow(4,otherCards.count);
	//All suits match is worth 1 point for 2 cards, 2 for 3, 4 for 4, etc.
	else if (allSuitsMatch)
		return pow(2,otherCards.count-1);
	//No complete match
	else
		return 0;
}

//INITIALIZERS

//Designated initializer
-(id)initWithSuit:(NSString *)suit rank:(NSUInteger)rank {
	if (self = [super init]) {
		self.suit = suit;
		self.rank = rank;
	}
	return self;
}

//GET/SET
@synthesize suit = _suit;

-(NSString *)suit {
	if (!_suit) return @"?";
	return _suit;
}

-(void)setSuit:(NSString*)suit {
	if ([self.class.validSuits containsObject:suit])
		_suit = suit;
}

-(void)setRank:(NSUInteger)rank {
	if (rank <= self.class.maxRank)
		_rank = rank;
}

//OTHER
-(NSString*)rankString {
	return self.class.rankStrings[self.rank];
}

//CLASS METHODS
+(NSArray *)validSuits {
	static NSArray* suits;
	if (!suits) suits = @[@"♠",@"♣",@"♥",@"♦"];
	return suits;
}

+(NSArray*) rankStrings {
	static NSArray* ranks;
	if (!ranks) ranks = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
	return ranks;
}

+(NSUInteger) maxRank {
	return self.rankStrings.count-1;
}

@end
