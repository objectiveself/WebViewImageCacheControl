This sample code shows how to prevent caching images from documents loaded by a UIWebView when a memory warning occurs.

This is achieved by setting a global property called _WebKitDiskImageCacheEnabled_:

```
[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
[[NSUserDefaults standardUserDefaults] synchronize];
```

This setting takes effect the next time the application is launched!

For more info, refer to http://stackoverflow.com/questions/16525065/disable-uiwebview-diskimagecache

