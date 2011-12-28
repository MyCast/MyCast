

#define CastURL @"www.lk-media.com"

#define AdviceMessage @"Dieser Podcast ist toll. Also erzähl doch bitte allen Leuten davon. Denn wenn ganz viele Leute zuhören macht es gleich noch viel mehr Spaß!"


#define MessageContend @"Ich habe einen super tollen Podcast enddeckt www.lk.media.de"


#define Subject @"Podcast"



/*
     File: MailComposerViewController.m
 Abstract: 
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "MailComposerViewController.h"
#import "MKInfoPanel.h"
#import "MyCastAppDelegate.h"
#import "MyCastAppDelegate.h"

@implementation MailComposerViewController
@synthesize message;



- (void) viewWillAppear:(BOOL)animated {
    sendingAdvice.text = AdviceMessage; 
    MyCastAppDelegate* delegate = (MyCastAppDelegate*)[[UIApplication sharedApplication] delegate];

    navigationBar.tintColor = delegate.navigationBarColor;
    
    sendingAdvice.textColor = delegate.textColor;
    
    UIImage* backroundImage = [[[UIImage alloc] initWithContentsOfFile:delegate.backroundImagePath] autorelease];
    [backroundImageView setImage:backroundImage];
    
    [sendingButton setTitle:NSLocalizedString(@"Weitersagen", nil) forState:UIControlStateNormal];
    [sendingButton setTitle:NSLocalizedString(@"Weitersagen", nil) forState:UIControlStateHighlighted];
    [sendingButton setTitle:NSLocalizedString(@"Weitersagen", nil) forState:UIControlStateReserved];
    [sendingButton setTitle:NSLocalizedString(@"Weitersagen", nil) forState:UIControlStateSelected];
    [sendingButton setTitle:NSLocalizedString(@"Weitersagen", nil) forState:UIControlStateDisabled];
    
    //[self showPicker:self];
}

-(IBAction)showPicker:(id)sender {
	// This sample can run on devices running iPhone OS 2.0 or later  
	// The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
	// So, we must verify the existence of the above class and provide a workaround for devices running 
	// earlier versions of the iPhone OS. 
	// We display an email composition interface if MFMailComposeViewController exists and the device can send emails.
	// We launch the Mail application on the device, otherwise.
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}


#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet {
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	//[picker setSubject:@"iPhone App"];
	

	// Set up recipients
	//NSArray *toRecipients = [NSArray arrayWithObject:nil]; 
	//[picker setToRecipients:toRecipients];
    
    MyCastAppDelegate* delegate = (MyCastAppDelegate*)[[UIApplication sharedApplication] delegate];
    picker.navigationBar.tintColor = delegate.navigationBarColor;
    

    
    [picker setSubject:Subject];
    [picker setMessageBody:MessageContend isHTML:NO];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
            NSString* title = @"";
            NSString* body = @"";
            
		case MFMailComposeResultCancelled:
                      
            title = NSLocalizedString(@"Abgebrochen", nil);
            body = NSLocalizedString(@"Schade, dass du den Podcast nicht weitergeben willst", nil);
            
			[MKInfoPanel showPanelInView:self.view
                                    type:MKInfoPanelTypeError
                                   title:title
                                subtitle:body
                               hideAfter:5];
			break;
		case MFMailComposeResultSaved:
            
            title = NSLocalizedString(@"Gespeichert", nil);
            body = NSLocalizedString(@"Deine Mail wurde in den Entwürfen gespeichert", nil);
            
			[MKInfoPanel showPanelInView:self.view
                                    type:MKInfoPanelTypeInfo
                                   title:title
                                subtitle:body
                               hideAfter:5];
			break;
		case MFMailComposeResultSent:
            
            title = NSLocalizedString(@"Versand", nil);
            body = NSLocalizedString(@"Deine Mail wurde erfolgreich verschickt", nil);
            
			[MKInfoPanel showPanelInView:self.view
                                    type:MKInfoPanelTypeInfo
                                   title:title
                                subtitle:body
                               hideAfter:5];
			break;
		case MFMailComposeResultFailed:
            title = NSLocalizedString(@"Fehler", nil);
            body = NSLocalizedString(@"Leider ist irgendetwas schief gelaufen", nil);
            
			[MKInfoPanel showPanelInView:self.view
                                    type:MKInfoPanelTypeError
                                   title:title
                                subtitle:body
                               hideAfter:5];
			break;
		default:
            
            title = NSLocalizedString(@"Fehler", nil);
            body = NSLocalizedString(@"Nicht gesendet", nil);
            
			[MKInfoPanel showPanelInView:self.view
                                    type:MKInfoPanelTypeInfo
                                   title:@"Fehler"
                                subtitle:@"Nicht gesendet"
                               hideAfter:5];
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice {
	NSString *recipients = @"mailto:&subject=Podcast";
	NSString *body = [NSString stringWithFormat:@"&body=%@",CastURL];
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


#pragma mark -
#pragma mark Unload views

- (void)viewDidUnload {
    [backroundImageView release];
    backroundImageView = nil;
    [navigationBar release];
    navigationBar = nil;
    [sendingButton release];
    sendingButton = nil;
    [sendingAdvice release];
    sendingAdvice = nil;
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.message = nil;
    
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [message release];
    [sendingAdvice release];
    [sendingButton release];
    [navigationBar release];
    [backroundImageView release];
	[super dealloc];
}

@end
