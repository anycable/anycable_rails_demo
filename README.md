# AnyCable Rails Demos

This repository contains the code for AnyCable Rails demo application and its different variations (in a separate branches).

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

You can start Rails server by running:

```sh
dip up rails
```

Then go to [http://localhost:3000/](http://localhost:3000/) and see the application in action.

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/anycable/anycable_rails_demo](https://github.com/anycable/anycable_rails_demo).

## License

The application is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
