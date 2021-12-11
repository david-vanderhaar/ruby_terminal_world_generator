# Ruby World Generator

This project exists to aid my growth in writing clean, object-oriented ruby code.

The user will be able to run this program from the terminal and generate interesting and beautiful world maps using text and color.

## Features

The user can: 
 - generate a new world with a cool name
 - scroll along the x/y axis to explore the world
 - Zoom in/and out to explore the world
 - label and name tiles in the world

## Run it!

`$ bundle install`     
`$ bundle exec ruby lib/run.rb`    

## Install it as a gem
`gem install 'world_in_your_terminal'`     
Then require it: `require 'world_in_your_terminal'`     
Then run it: `WorldInYourTerminal.new.explore`

## What I've Learned During Development

 - Ruby syntax
    - `%w(item item item)` == `["item", "item", "item"]`
    - `method(:method_symbol)` allows us to pass methods as variables and call them later
- Defining Modules
- TTY libraries for nice terminal functionality
- Installing gems locally with bundle config
- Executing ruby with specific bundles: `bundle exec ...`
- Packaging and publishing code as a ruby gem