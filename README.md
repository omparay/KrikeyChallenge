# Krikey Challenge

I kept to using MVC for this application mostly because it's primary function is simple...

1. Perform a search with the iTunes Search API
2. Display the results in a UITableView

I chose to expose the iTunes search as a function that uses an object I developed last year while I was working
for a company called USA-UES. I basically became tired of using various HTTP libraries like ASIHttpRequest,
AlamoFire, PromiseKit, etc. Every time I use them they keep updating and making fixes. This is already so
annoying in PHP, Arduino and NodeJS projects that I follow.

I know that Apple had made significan strides in making their native HTTP client system as robust as possible
so I opted to use that and basically expose execution blocks as failure or success parameters in my HttpClient
object.

I have also over time encountered a number of useful functions, extensions, techniques and tricks that are
basically all encoded in a generic library of source codes that I tend to use on all my projects.

If anything you will notice most of my coding style is plain-vanilla with the exception of this...

In my Library are a ton of extensions because that is where I believe Apple and their main languages of 
Swift and Objective-C is a cut above the rest of other programming languages. No longer do I have to
subclass objects in order to add functionality to them. They can be added after-the-fact by using what is known
as retroactive modelling. You just create an extension (and this is never to be confused with a partial class) that
adds the additional behaviour on top of existing objects.

Using this technique will keep your object inheritance tree simpler and can serve as a good means of 
separating a functional concern from an existing object. Good code reads like a human is writing instructions to
another human not to a machine. This way when someone else takes over your code they need only read it
a few times to understand what is going on.

Having said all this I am a fan of CocoaPods and I have used several in past projects.

Why did I use a static library as opposed to a framework??? If you use too many frameworks on your iOS 
project it tends to slow down not the load time but the launch time of your app. To summarize, the load time
is from when you touch your app until it does an intial wipe of the screen. The time it takes from that initial
screen wipe (including the time it takes to display the launch screen) until the first instance that the app is usable
and can actively respond to user interactions is the launch time.

The app I have made is simple and if I may say so, it is as responsive as can be.

But it is plain vanilla. because my skill is in coding first then performance second. I do not try to be everything
at once. I do not try to give you the world at once. I write code to live and I debug code to keep on living.
