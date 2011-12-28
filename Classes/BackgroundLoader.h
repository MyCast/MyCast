//
//  BackgroundLoader.h
//  Taschencasts
//
//  Created by Jannes Klaas on 24.10.11.
//  Copyright (c) 2011 JannesCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundLoader : NSOperation 

{
	NSData *token; // for notification registration
}

@property (nonatomic, retain) NSData *token;

-(id)initWithToken:(NSData*)deviceToken;
-(BOOL)sendProviderDeviceToken:(NSData*)deviceToken;
-(void) setToken:(NSData *)t;

@end
