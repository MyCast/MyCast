//
//  BackgroundLoader.m
//  Taschencasts
//
//  Created by Jannes Klaas on 24.10.11.
//  Copyright (c) 2011 JannesCode. All rights reserved.
//
// Registering push
//



#define PushURL @"http://www.lk-media.com/mycast/push/register.php"





#import "BackgroundLoader.h"

@implementation BackgroundLoader
@synthesize token;

-(id)initWithToken:(NSData*)deviceToken
{
	if((self=[super init])!=nil)
	{
		self.token=deviceToken;
	}
	return self;
}

-(void)main
{
	NSLog(@"Backgroundloader running...");
    
	// there is nothing to do if no token is avaible
	if(token)
	{
		[self sendProviderDeviceToken:token];
	}
}

-(BOOL)sendProviderDeviceToken:(NSData*)deviceToken
{
    if (PushURL != @"") {
        
    
    
	// check wather we have done that before, than we can save a lot of work
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	if([userDefaults objectForKey:@"AppRegistered"]==nil)
	{
		// convert token to HexString
		const char * data = [deviceToken bytes];
		NSMutableString* tokenString = [NSMutableString string];
		
		for (int i = 0; i < [deviceToken length]; i++) 
		{
			[tokenString appendFormat:@"%02.2hhX", data[i]];
		}
		
		NSLog(@"Register with Token: %@",tokenString);
		// Sending token to given URL
        NSString* urlString = [NSString stringWithFormat:@"%@?token=%@", PushURL,tokenString];
		NSURL* registerurl = [NSURL URLWithString:urlString];
                                                  NSLog(@"Register with URL: %@",registerurl);
        NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:registerurl] autorelease];
                                                   
        NSURLResponse *response=nil;
        NSError *error=nil;
                                                   
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
        NSString* returnString = [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
                                                   NSLog(@"Register Response: %@",response);
                                                   NSLog(@"Register Errror: %@",error);
                                                   NSLog(@"Register Return: %@",returnString);
                                                   if(error==nil)
                                                   {
                                                       // Didi it work?
                                                       if([[returnString substringToIndex:6] compare:@"Done"])
                                                       {
                                                           NSLog(@"Register succesful");
                                                           [userDefaults setInteger:1 forKey:@"AppRegistered"];			
                                                           [returnString release];
                                                           return YES;
                                                       }
                                                   }
                                                   [returnString release];
                                                   return NO;
                                                   }
                                                   return YES;
                                                   }
    return YES;
}
                                                   
-(void)dealloc
        {
            [token release];
            [super dealloc];
        }
                                                   
 
- (void) setToken:(NSData *)t {
    token = t;
    [token retain];
}
@end
                                                   
