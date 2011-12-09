

(class AppDelegate is NSObject
     (ivar (id) window (id) tabBar (id) topPlacesNavController (id) recentsNavController )

         (- (void)applicationDidFinishLaunching:(id)application is
            ; top places table view 
            (set topPlacesTable ((topPlacesTableViewController alloc) initWithStyle:0))
            (topPlacesTable setFlickrData:(FlickrFetcher topPlaces))
            ; navigation controller for 'top places' 
            (set @topPlacesNavController ((UINavigationController alloc)
                                          initWithRootViewController:topPlacesTable))
            ; set title of topPlacesNavController
            (@topPlacesNavController setTitle:"Top Places")
            
            ; recents table view
            (set recentsTable ((recentsTableViewController alloc) init))
            ; nav controller for recent places
            (set @recentsNavController ((UINavigationController alloc)
                                        initWithRootViewController:recentsTable))
            ; set title of recentsNavController 
            (@recentsNavController setTitle:"Recents")
            
            ; create a tab bar 		
            (set @tabBar ((UITabBarController alloc) init))
            ; put nav controllers into an array
            (set viewControllers (NSArray arrayWithList:(list @topPlacesNavController @recentsNavController)))
            ; push the viewController array to auto generate the tabs
            (@tabBar setViewControllers:viewControllers)
            ; set up the window 
            (set screenRect ((UIScreen mainScreen) bounds))
            (set @window ((UIWindow alloc) initWithFrame:screenRect))
            ; Add the @view to the window 
            ; in this case, we add the @tabBar view so we get a tab bar
            (@window addSubview:(@tabBar view))
            ; make the window front and center
            (@window makeKeyAndVisible)))

(class recentsTableViewController is UITableViewController 
       (ivar (id)recentsArray)
       ; the content here is set by the placeTableView to collect 

       ; set the title of the nav bar to "Recents"
       (- viewDidLoad is
          (self setTitle:"Recents")))

(class topPlacesTableViewController is UITableViewController
       (ivar (id)flickrData (id)placeTableView )

       ;; set the title of the nav bar to "Top Places"
       (- viewDidLoad is
          (self setTitle:"Top Places"))

       (- tableView:(id)tableView numberOfRowsInSection:(id)section is
          ;; the amount of items in the flickrFetcher array (about 100)
          (@flickrData count))

       (- tableView:(id)tableView cellForRowAtIndexPath:(id)indexPath is
          ;; standard cell house keeping
          (set myid "myid")
          (set cell ((UITableViewCell alloc) initWithStyle:3 reuseIdentifier:myid))

          ;; get the place out of the flickrData variable
          (set place (@flickrData (indexPath row)))

          ;; get the name out of the place variable
          (set longString (place "_content"))
          ;; seperate longString by the commas. put them into an array for access
          (set nameArray (longString componentsSeparatedByString:", "))

          ;; CELL NAMING SCHEME
          ;; set the title of the cell as index 0
          (cell setText:(nameArray 0))
          ;; set the detail label as index 1 + index 2
          ((cell detailTextLabel) setText:(+ (nameArray 1) ", " (nameArray 2)))
          ;; add a chevron to the cell
          (cell setAccessoryType:1)
          ;; return the cell
          cell)

       (- tableView:(id)tableView didSelectRowAtIndexPath:(id)indexPath is
          ;; init the placeViewTable
          (set @placeTableView ((placeTableViewController alloc) init))

          ;; set the placeTableViews data source

          ; adjust this for the new flickr fetcher program !!!!!!!!!!!!
          (set FFrow (@flickrData objectAtIndex:(indexPath row)))
          (set placeData (FlickrFetcher photosInPlace:FFrow maxResults:20))
          (@placeTableView setPlaceData:placeData)

          ;; get the name of the place selected, then set the title of the nav bar
          (set longString (FFrow "_content"))
          (set nameArray (longString componentsSeparatedByString:", "))
          (@placeTableView setTitleString:(nameArray 0))

          ;; tell the navcontroller to push the placeTableView after setting it up
          ((self navigationController) pushViewController:@placeTableView animated:YES)))


(class placeTableViewController is UITableViewController 
       (ivar (id) titleString (id) placeData (id) photoView )

       (- viewDidLoad is
          (self setTitle:@titleString))

       (- tableView:(id)tableView numberOfRowsInSection:(id)section is
          ;; the number of items in @placeData
          (@placeData count))

       (- tableView:(id)tableView cellForRowAtIndexPath:(id)indexPath is
          ;; standard cell memory housekeeping
          (set myid "myid")
          (set cell ((UITableViewCell alloc) initWithStyle:3 reuseIdentifier:myid))
          
          (set row (indexPath row))
          (set cellData (@placeData objectAtIndex:row))
          
          (set des (cellData valueForKey:"description"))

          (set detailText (des valueForKey:"_content"))
          (set title (cellData valueForKey:"title"))
          
          (if (eq (title length) 0)
            (set title detailText))
          
          (if (and (eq (title length) 0)
                   (eq (detailText length) 0))
            (set title "Unknown"))
          
          (cell setText:title)
          ((cell detailTextLabel) setText:detailText)
          ; give the cell a chevron
          (cell setAccessoryType:1)

          cell)

       (- tableView:(id)tableView didSelectRowAtIndexPath:(id)indexPath is
          
          ; photoData is a NSURL
          (set photoData (FlickrFetcher urlForPhoto:(@placeData objectAtIndex:(indexPath row))
                                        format:"large"))
          
          ; convert the NSURL to NSData
          (set imageData (NSData dataWithContentsOfURL:photoData))
          ; conver NSData to UIImage
          (set image (UIImage imageWithData:imageData))

          ; init a PhotoViewer 
          (set @photoView ((PhotoViewer alloc) init))
          (@photoView setTheImage:image)
          
          ((self navigationController) pushViewController:@photoView animated:YES)))

(class PhotoViewer is UIViewController
       (ivar (id)theImage))
       
       



          
          