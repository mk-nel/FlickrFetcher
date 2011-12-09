//
//  main.m
//
//
#import "Nu.h"
#import "FF.h"

int main(int argc, char *argv[]) {    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSError *error;
	NSString *main_nu = [NSString stringWithContentsOfFile:
						  [[NSBundle mainBundle] pathForResource:@"FlickrFetcher" ofType:@"nu"]
												   encoding:NSUTF8StringEncoding
													  error:&error];

	id parser = [Nu parser];
	
	NSLog(@"parsing...");
	
	[parser parseEval:main_nu];
	
	NSLog(@"running...");
    
    int retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate");
	
	NSLog(@"done");

    [pool release];
    return retVal;
}
