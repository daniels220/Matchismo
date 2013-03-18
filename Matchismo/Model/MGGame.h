//
//  MGGame.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGGameResult.h"
@class MGCard;
@class MGDeck;

typedef enum {
	PLAYING_STATE,
	DONE_STATE,
	STUCK_STATE
} GameState;

@interface MGGame : NSObject

@property (nonatomic,readonly) NSInteger score;
@property (nonatomic,readonly) NSUInteger numFlips;
@property (strong,nonatomic,readonly) MGGameResult* result;
@property (nonatomic,readonly) GameState gameState;

-(NSUInteger) numCards;
-(void) flipCardAtIndex:(NSUInteger) index;
-(MGCard*) cardAtIndex:(NSUInteger) index;

-(id) lastMove;
-(NSInteger) numMoves;
-(id) movesAgo:(NSInteger) movesAgo;

-(id) initWithCardCount:(NSUInteger)count usingDeck:(MGDeck*)deck;
-(NSString*) typeString;

@end
