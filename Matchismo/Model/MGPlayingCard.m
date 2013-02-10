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

-(void)setContents:(NSString *)contents {}

-(NSUInteger)match:(NSArray *)otherCards {
	int suitMatches = 0;
	int rankMatches = 0;
	for (MGPlayingCard* otherCard in otherCards) {
		if ([otherCard.suit isEqualToString:self.suit])
			suitMatches++;
		else if (otherCard.rank == self.rank)
			rankMatches++;
		//Stop immediately if any cards don't match
		else
			return 0;
	}
	//1 suit match == 1, 1 rank match == 4
	//each additional suit match doubles
	//each additional rank match quadruples
	return pow(2,fmax(0,suitMatches-1))*pow(4,rankMatches);
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
