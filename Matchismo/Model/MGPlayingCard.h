//
//  MGPlayingCard.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGCard.h"

@interface MGPlayingCard : MGCard

@property (strong,nonatomic)	NSString* suit;
@property (nonatomic)					NSUInteger rank;

-(id) initWithSuit:(NSString*)suit rank:(NSUInteger)rank;

-(NSString*) rankString;
+(NSArray*) validSuits;
+(NSArray*) rankStrings;
+(NSUInteger) maxRank;

@end
