# Ruby World Generator

This project exists to aid my growth in writing clean, object-oriented ruby code.

The user will be able to run this program from the terminal and generate interesting and beautiful world maps using text and color.

## Features

The user can: 
 - generate a new world with a cool name
 - scroll along the x/y axis to explore the world
 - Zoom in/and out to explore the world
 - label and name tiles in the world

## Run it yourself!

`$ bundle install`     
`$ bundle exec ruby lib/run.rb`     

## Or install it as a gem
`$ gem install 'world_in_your_terminal'`   

After install you can either:

- Run it as a command line tool: `$ world_in_your_terminal`      
- Import it into you own script: 
```
require 'world_in_your_terminal'
WorldInYourTerminal.new.explore
```      

## What I've Learned During Development

 - Ruby syntax
    - `%w(item item item)` == `["item", "item", "item"]`
    - `method(:method_symbol)` allows us to pass methods as variables and call them later
- Defining Modules
- TTY libraries for nice terminal functionality
- Installing gems locally with bundle config
- Executing ruby code with specific bundles: `bundle exec ...`
- Packaging and publishing code as a ruby gem
- Allowing ruby code to be executed as a command in the terminal