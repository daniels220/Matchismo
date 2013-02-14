//
//  MGMatchingGame.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGGame.h"
@class MGCard;
@class MGDeck;

@interface MGMatchingGame : MGGame

@property (nonatomic,readonly) NSUInteger numFlips;
-(NSString*) lastMove;
-(NSInteger) numMoves;
-(NSString*) movesAgo:(NSInteger) movesAgo;


@end