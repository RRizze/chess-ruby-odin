#!/usr/bin/sh ruby

require_relative "board"
require_relative "game"

game = Game.new
game.loop

