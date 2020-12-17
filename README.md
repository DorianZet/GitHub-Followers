<!-- PROJECT LOGO -->
<br />
<p align="center"> 

  <a href="https://user-images.githubusercontent.com/62523613/102473264-8bfedc00-4057-11eb-9139-78e807e4d3fe.png">
    <img src="https://user-images.githubusercontent.com/62523613/102473264-8bfedc00-4057-11eb-9139-78e807e4d3fe.png" alt="Icon" width="80" height="80">
  </a>

  <h1 align="center">GitHub Followers (AKA DogHub)</h1>
  <p align="center">
    <h3 align ="center"> A (not so) silly GitHub followers browser iOS app. <h3>
</p>



<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
  * [GitHub Followers Module](#github-followers-module)
  * [DogHub Module](#doghub-module)
* [What did I get from this project?](#what-did-i-get-from-this-project)
* [Built With](#built-with)
* [Installation](#installation)
* [License](#license)

<!-- ABOUT THE PROJECT -->
## About The Project

![iPhoneScr](https://user-images.githubusercontent.com/62523613/102473546-dbdda300-4057-11eb-9edd-51ea07339a8f.png)

GitHub Followers is a project based on <a href="https://seanallen.teachable.com/p/take-home">Sean Allen's Take Home Project</a> course. The DogHub module (haven't had a lot of time to think about the name, have I?) is my very own creation, built upon the base project.

Let's discuss both modules!

### GitHub Followers Module
GitHub Followers is essentially a GitHub followers browser app. By entering a username in the search controller, we download their data from <a href="https://docs.github.com/en/free-pro-team@latest/rest">GitHub API</a> which include:
- user's login
- user's repos
- user's gists
- user's date of GitHub account creation
- and many other entities, among which are the user's followers - the main point of this app!

Once the followers are downloaded from the API, they are presented in a collection view with a diffable data source - it makes for nice animations when using the search controller inside the followers list. Tapping on a follower shows a modal view controller, revealing more info about them. It's also possible to add a user to favorites and access them any time. 

### DogHub Module
The DogHub module is an extension of the app - apart from fancy animations in the home view controller, it populates the collection view images with... dogs.<br>
<br>
Once the followers are downloaded and the Dog Mode is enabled, another network call - this time to <a href="https://dog.ceo/dog-api/">Dog API</a> - gets the same number of random images of dogs and then the followers' avatar URLs are swapped with the dog image URLs. To see the true GitHub avatar of a user, you have to enter their profile by tapping their cell in the collection view.

## What did I get from this project?
Among many things I learnt/trained during this project, here are the most important ones for me:
- writing UI programmatically
- creating network calls in native Swift
- using multiple APIs in one app
- MVC design pattern
- using delegates and protocols
- using diffable data source in a collection view
- managing persisting objects in UserDefaults with a possibility of their removal
- implementation of Dynamic Type
- Dark Mode support
- implementation of child view controllers
- constrained views animation
- creating a CAEmitterLayer with a finite animation

## Built With
* [Swift 5.3](https://developer.apple.com/swift/)
* [UIKit](https://developer.apple.com/documentation/uikit)

<!-- GETTING STARTED -->

## Installation

No big deal here really, just open the project in Xcode 12.

<!-- LICENSE -->
## License

See `LICENSE` for information.
