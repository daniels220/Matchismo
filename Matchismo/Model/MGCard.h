//
//  MGCard.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGCard : NSObject

@property (strong,nonatomic) NSString* contents;

@property (nonatomic) BOOL faceUp;
@property (nonatomic) BOOL unplayable;

-(NSUInteger) match:(NSArray*) otherCards;

@end
 