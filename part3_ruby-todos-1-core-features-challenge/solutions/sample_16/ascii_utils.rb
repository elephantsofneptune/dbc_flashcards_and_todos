# Use "reputs" to print over a previously printed line,
# assuming the cursor is positioned appropriately.
def reputs(str = '')
  puts "\e[0K" + str
end

# Clear the screen
def clear_screen!
  print "\e[2J"
end

# Moves cursor to the top left of the terminal
def move_to_home!
  print "\e[H"
end


# Flushes the STDOUT buffer.
# By default STDOUT is only flushed when it encounters a newline (\n) character
def flush!
  $stdout.flush
end

def print_line
  puts "---------------------------------------"
end
