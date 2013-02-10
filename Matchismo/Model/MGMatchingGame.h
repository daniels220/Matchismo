//
//  MGMatchingGame.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MGCard;
@class MGDeck;

@interface MGMatchingGame : NSObject

@property (nonatomic,readonly) NSUInteger numFlips;
@property (nonatomic,readonly) NSInteger score;
-(NSString*) lastMove;
-(NSInteger) numMoves;
-(NSString*) movesAgo:(NSInteger) movesAgo;

-(void) flipCardAtIndex:(NSUInteger) index;

-(MGCard*) cardAtIndex:(NSUInteger) index;

-(id) initWithCardCount:(NSUInteger)count usingDeck:(MGDeck*)deck;

@end