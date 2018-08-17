[![Version](https://img.shields.io/cocoapods/v/AlamoRecord.svg?style=flat)](http://cocoapods.org/pods/AlamoRecord)
[![Platform](https://img.shields.io/cocoapods/p/AlamoRecord.svg?style=flat)](http://cocoapods.org/pods/AlamoRecord)
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift-4.2-4BC51D.svg?style=flat" alt="Language: Swift" /></a>
[![License](https://img.shields.io/cocoapods/l/AlamoRecord.svg?style=flat)](http://cocoapods.org/pods/AlamoRecord)

## Written in Swift 4.2

AlamoRecord is a powerful yet simple framework that eliminates the often complex networking layer that exists between your networking framework and your application. AlamoRecord uses the power of [AlamoFire](https://github.com/Alamofire/Alamofire), [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper) and the concepts behind the [ActiveRecord](http://guides.rubyonrails.org/active_record_basics.html) pattern to create a networking layer that makes interacting with your API easier than ever.

## Requirements

- iOS 9.0+ / macOS 10.11+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 9.0+
- Swift 4.0+

## Installation

AlamoRecord is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AlamoRecord'
```

## Getting Started

The power of AlamoRecord lies within four main components.

### `AlamoRecordObject`

These are data objects that are retrieved from an API. All data objects that inherit from this class automatically receive built in helpers such as create, find, update, and destroy. This is also known as [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete).

### `RequestManager`
These are the work horses of AlamoRecord. They contain all of the networking helpers that AlamoRecord needs in order to create your application's networking layer. They are responsible for each request that your `AlamoRecordObject`'s make. They also contain upload and download helpers.

### `URLProtocol`
These store all of the information needed in order to make a proper request through instances of `RequestManager`'s.

### `AlamoRecordError`
These are errors that are returned from an API. On a failed request, the JSON returned will be mapped from the predefined fields that are setup.


## Example
Let's assume we are developing an application that allows user's to interact with each other via posts.

### Step 1
We first need to create a class that conforms to `URLProtocol`. Let's name it `ApplicationURL`:

#### `ApplicationURL`

```swift
class ApplicationURL: AlamoRecord.URLProtocol {

    var absolute: String {
        return "https://jsonplaceholder.typicode.com/\(url)"
    }
    
    private var url: String
    
    required init(url: String) {
        self.url = url
    }
}

```
Notice how you only need to pass the path and not the domain to each instance that conforms to `URLProtocol`. That's because you set the domain of each instance in the `absolute` variable. 

### Step 2

This step can be ignored if your server does not return back custom error messages. If this is the case, then base `AlamoRecordError` objects can be used in return. 

Let's assume our API returns custom error messages. Let's create a class that inherits from `AlamoRecordError` and name it `ApplicationError`. Let's also assume our JSON structure looks similar to this on failed requests:

```json
{
	"status_code": 401,
	"message": "You are not authorized to make this request.",
}
```

Our class structure would then look very similar to this:

#### `ApplicationError`

```swift
class ApplicationError: AlamoRecordError {

    private(set) var statusCode: Int?
    private(set) var message: String?

    required init(nsError: NSError) {
        super.init(nsError: nsError)
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        statusCode <- map["status_code"]
        message <- map["message"]
    }
}
```

### Step 3

We next need to create an instance of a `RequestManager` and pass in the `ApplicationURL` and `ApplicationError` we just created to the inheritance structure to satisfy the generic requirements. Let's name it `ApplicationRequestManager `.

#### `ApplicationRequestManager`

```swift
class ApplicationRequestManager: RequestManager<ApplicationURL, ApplicationError> {
   
    static var `default`: ApplicationRequestManager = ApplicationRequestManager()
    
    init() {
    	// See the Configuration documentation for all possible options
        super.init(configuration: Configuration())
    }
}
```

### Step 4

The final step is to create data objects inheriting from `AlamoRecordObject` that our application needs from our API. In this example, we only have one object named `Post`. 

#### `Post`

```swift
class Post: AlamoRecordObject<ApplicationURL, ApplicationError> {
    
    override class var requestManager: RequestManager<ApplicationURL, ApplicationError> {
        return ApplicationRequestManager
    }
    
    override class var root: String {
        return "post"
    }

    private(set) var userId: Int!
    private(set) var title: String!
    private(set) var body: String!
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        userId <- map["userId"]
        title <- map["title"]
        body <- map["body"]
    }

}
```

With this class definition, we would expect each `Post` json to look like this:

```json
{
	"userId": 1,
	"id": 1,
	"title": "This is a post's title",
	"body": "This is the post's body"
}
```

If our `Post` object was encapsulated in an object like this:

```json
{
	"post": {
		"userId": 1,
		"id": 1,
		"title": "This is a post's title",
		"body": "This is the post's body"
	}
}
```

we would only simply need to override the `keyPath` in the class declaration:

```swift
open override class var keyPath: String? {
     return "post"
}
```

Notice how the `requestManager` class variable is overrided and returns the `ApplicationRequestManager` just created in step 3. Also notice how the `root` class variable is overrided. Both of these overrides are required for each instance that **directly** inherits from `AlamoRecordObject`. 

##### That's it! With just a few lines of code, your networking layer to your application is ready to be used. In the next section, we see all the built in helpers we get by using AlamoRecord.

### Getting all instances of `Post` 

`GET` [https://jsonplaceholder.typicode.com/posts](https://jsonplaceholder.typicode.com/posts)

```swift
Post.all(success: { (posts: [Post]) in
   // Do something with the posts
}) { (error) in
   // Handle the error      
}
```

### Creating an instance of `Post`

`POST` [https://jsonplaceholder.typicode.com/posts](https://jsonplaceholder.typicode.com/posts)

```swift
let parameters: [String: Any] = ["userId": user.id,
                                 "title": title,
                                 "body": body]
                                    
Post.create(parameters: parameters, success: { (post: Post) in
	// Do something with the post          
}) { (error) in
	// Handle the error            
}
```

### Finding an instance of `Post`

`GET` [https://jsonplaceholder.typicode.com/posts/1](https://jsonplaceholder.typicode.com/posts/1)

```swift
Post.find(id: 1, success: { (post: Post) in
	// Do something with the post
}) { (error) in
   	// Handle the error        
}
```

### Updating an instance of `Post`

`PUT` [https://jsonplaceholder.typicode.com/posts/1](https://jsonplaceholder.typicode.com/posts/1)

```swift
let parameters: [String: Any] = ["userId": user.id,
                                 "title": title,
                                 "body": body]
                                    
post.update(parameters: parameters, success: { (post: Post) in
	// Do something with the post     
}) { (error) in
	// Handle the error     
}
```
This can also be done at the class level:

```swift
Post.update(id: 1, parameters: parameters, success: { (post: Post) in
	// Do something with the post    
}) { (error) in
   	// Handle the error        
}
```

### Destroying an instance of `Post`

`DELETE` [https://jsonplaceholder.typicode.com/posts/1](https://jsonplaceholder.typicode.com/posts/1)

```swift
post.destroy(id: 1, success: { 
	// The post is now destroyed       
}) { (error) in
	// Handle the error   
}
```
This can also be done at the class level:

```swift
Post.destroy(id: 1, success: { 
	// The post is now destroyed       
}) { (error) in
	// Handle the error   
}
```

### Uploading a file

```swift
requestManager.upload(url: url,
                      multipartFormData: data,
                      multipartFormDataName: dataName,
                      success: { (any: Any?) in
   	// Upload was successful                                           
}) { (error) in
	// Handle the error      
}
```

### Downloading a file

```swift
requestManager.download(url: url,
                        destination: destination,
                        progress: { (progress) in
    // Check the progress                                        
}, success: { (url) in
    // Do something with the url            
}) { (error) in
    // Handle the error        
}
```
Providing a destination is optional. If a destination is not provided, then the file will be saved to a temporary location. This file will be overwritten if another download request is made without providing a destination.

#### Download the example project to see just how easy creating an application that interacts with an API is when using AlamoRecord!

## Author

Original concept designed by [Rick Pernikoff](https://github.com/rickpern). AlamoRecord implementation by [Dalton Hinterscher](https://github.com/daltron).

## License

AlamoRecord is available under the MIT license. See the LICENSE file for more info.



