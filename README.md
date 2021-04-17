## Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes.

### Prerequisites

To run this Ruby application, you will need to have the following software installed:

#### Ruby
Version 2.7.1 (Other versions will also work)


##### Ruby Installation Guides

https://www.ruby-lang.org/en/documentation/installation/

#### Bundler

[Bundler](https://bundler.io/) is a tool for managing Ruby dependencies.

Install by running:

```
gem install bundler
```

### Setup

Ensure you have installed all [prerequisites](#prerequisites) above and then:

1. Clone the repository
2. `cd` to project directory
3. Run `bundle install` to install dependencies

### Usage
1. Enter ruby console by running `irb`
2. Load file `load './minesweeper.rb'`
3. Initialize game
`game = Minesweeper.new(4, :hard)`
Board size can be 3 to 30
Difficulty levels can be `:easy`, `:medium` and `:hard`
4. Play game. Specify the row and column numbers to reveal a box
`game.attempt(2, 3)`

### Testing
run rspec to execute test cases
`rspec`

#### Environment Variables

This project uses [Figaro](https://github.com/laserlemon/figaro) to manage
environment variables.
Open [`config/application.yml.example`](config/application.yml.example) to see
how to set environment variables.

To set up variables on your machine:

1. Copy and rename `config/application.yml.example` to `config/application.yml`
   (this file is added to gitignore)
# minesweeper_game
