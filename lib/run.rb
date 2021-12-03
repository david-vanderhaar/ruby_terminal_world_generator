#!/usr/bin/env ruby

require 'tty-prompt'
require_relative './Display.rb'
require_relative './Engine.rb'

display = Display.new(40)
prompt = TTY::Prompt.new

engine = Engine.new(prompt, display)
engine.start
