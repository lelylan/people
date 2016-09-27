# People API

OAuth 2.0 user authentication and authorization.


## Requirements

People API is tested against MRI 1.9.3.


## Installation

    $ git clone git@github.com:lelylan/people.git && cd people
    $ gem install bundler
    $ bundle install 
    $ foreman start

## Install with docker

    $ docker build --tag=people .
    $ docker run -d -it --name people people

## Resources

* [Lelylan OAuth 2.0 API](http://dev.lelylan.com/api#api-oauth)


## Contributing

Fork the repo on github and send a pull requests with topic branches. 
Do not forget to provide specs to your contribution.


### Running specs

        $ gem install bundler
        $ bundle install 
        $ bundle exec guard

Press enter to execute all specs.


## Spec guidelines

Follow [betterspecs.org](http://betterspecs.org) guidelines.


## Coding guidelines

Follow [github](https://github.com/styleguide/) guidelines.


## Feedback

Use the [issue tracker](http://github.com/lelylan/people/issues) for bugs or [stack overflow](http://stackoverflow.com/questions/tagged/lelylan) for questions.
[Mail](mailto:dev@lelylan.com) or [Tweet](http://twitter.com/lelylan) us for any idea that can improve the project.


## Links

* [GIT Repository](http://github.com/lelylan/people)
* [Lelylan Dev Center](http://dev.lelylan.com)
* [Lelylan Site](http://lelylan.com)


## Authors

[Andrea Reginato](https://www.linkedin.com/in/andreareginato)


## Contributors

Special thanks to all [contributors](https://github.com/lelylan/people/contributors)
for submitting patches.


## Changelog

See [CHANGELOG](https://github.com/lelylan/people/blob/master/CHANGELOG.md)


## License

Lelylan is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
