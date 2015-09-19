#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
}

NSString* const c1 =@"folder";
NSString* const c2 =@"count";
-(NSArray *)dataArray
{
    NSArray *array = [NSArray arrayWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:@"inbox",c1,@"0",c2,nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"draft",c1,@"0",c2,nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"sent",c1,@"0",c2,nil],
                      nil];
    return array;
}

-(void)createTableView
{
    NSRect rect = NSMakeRect(10,10,200,100);
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:rect];
    [scrollView setBorderType:NSBezelBorder];
    NSRect rect1 = NSMakeRect(0,10,500,100);
    NSTableView *myTableView = [[NSTableView alloc] initWithFrame:rect1];
    NSTableColumn *tCol;
    {
        tCol = [[NSTableColumn alloc] initWithIdentifier:c1];
        [tCol setWidth:100.0];
        [[tCol headerCell] setStringValue:c1];
        [myTableView addTableColumn:tCol];
    }
    {
        tCol = [[NSTableColumn alloc] initWithIdentifier:c2];
        [tCol setWidth:100.0];
        [[tCol headerCell] setStringValue:c2];
        [myTableView addTableColumn:tCol];
    }
    [myTableView setDataSource:self];
    [scrollView setDocumentView:myTableView];
    [self.view addSubview:scrollView];
}

// TableView Datasource method implementation
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    NSString *aString;
    aString = [[self.dataArray objectAtIndex:rowIndex] objectForKey:[aTableColumn identifier]];
    return aString;
}

// TableView Datasource method implementation
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    long recordCount = [self.dataArray count];
    return recordCount;
}

@end