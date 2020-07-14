![Unit Tests](https://github.com/anycable/anycable_rails_demo/workflows/Unit%20Tests/badge.svg)
![System Tests](https://github.com/anycable/anycable_rails_demo/workflows/System%20Tests/badge.svg)

# AnyCable Rails Demo

This repository contains the code for AnyCable Rails demo application and its different variations.

[List of all demonstration PRs](https://github.com/anycable/anycable_rails_demo/pulls?q=is%3Apr++label%3Ademo+)

<img align="center" width="1416"
     title="AnWork screenshot" src="./public/demo.png">

## Installation

This app has a Docker-first configuration based one the [Ruby on Whales post](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development).

You need:

- `docker` and `docker-compose` installed.

For MacOS just use [official app](https://docs.docker.com/engine/installation/mac/).

- [`dip`](https://github.com/bibendi/dip) installed.

Run the following command to build images and provision the application:

```sh
dip provision
```

## Running

You can start Rails server along with AnyCable by running:

```sh
dip up rails anycable
```

Then go to [http://localhost:3000/](http://localhost:3000/) and see the application in action.

## Debugging

If you want to run Rails server and/or with debugging capabilites, run the following commands:

```sh
# for Rails server
dip rails s

# for AnyCable
dip anycable
```

## Testing

We separate unit and system specs and provide convenient Dip commands to run them:

```sh
# only unit tests
dip rspec

# only system tests
dip rspec system

# NOTE: if you encounter random multi-session tests failures,
# try stopping AnyCable WebSocket server
dip stop ws_test
```

## Resources

- [Ruby on Whales](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development)—learn about the Docker development setup used for this application.
- [RuboCoping with legacy](https://evilmartians.com/chronicles/rubocoping-with-legacy-bring-your-ruby-code-up-to-standard)—this is how we configure RuboCop.
- [Evil Front](https://evilmartians.com/chronicles/evil-front-part-3)—some frontend ideas are borrowed from this post.
- [Ruby Next](https://evilmartians.com/chronicles/ruby-next-make-all-rubies-quack-alike)—we're using the edge Ruby syntax!
- [System of a test](https://evilmartians.com/chronicles/system-of-a-test-setting-up-end-to-end-rails-testing)—our system tests setup.

## Aknowledgements

Built and tested with the help of these awesome technologies:

- [Tailwind CSS](https://tailwindcss.com)
- [StimulusJS](https://stimulusjs.org)
- [Cuprite](https://github.com/rubycdp/cuprite) & [Browserless](https://www.browserless.io)

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/anycable/anycable_rails_demo](https://github.com/anycable/anycable_rails_demo).

## License

The application is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
