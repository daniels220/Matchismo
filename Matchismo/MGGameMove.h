//
//  MGMatchingGameMove.h
//  Matchismo
//
//  Created by Daniel Slomovits on 3/19/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGGameMove : NSObject

@property (strong,nonatomic,readonly) NSArray* cards; //of MGCard
@property (nonatomic,readonly) NSUInteger score;

-(id)initWithCards:(NSArray*)cards score:(NSUInteger)score;

@end
