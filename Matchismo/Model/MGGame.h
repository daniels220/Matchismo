//
//  MGGame.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MGCard;
@class MGDeck;

@interface MGGame : NSObject

@property (nonatomic,readonly) NSInteger score;

-(void) flipCardAtIndex:(NSUInteger) index;

-(MGCard*) cardAtIndex:(NSUInteger) index;

-(id) initWithCardCount:(NSUInteger)count usingDeck:(MGDeck*)deck;

@end
