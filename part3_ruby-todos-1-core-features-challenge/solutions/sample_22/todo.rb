require_relative 'tasksandlists'
 
class TaskMaster
  def initialize()
    raise "Please enter a command after the filename to run this script" unless ARGV.length > 0
    @command = ARGV[0]
    @list = List.new()
    run(@commands)
  end
 
  def run(command)
 
    case @command.downcase
    when "list"
      puts "Full task list:"
      @list.tasks.each do |task|
        puts "#{task.id}: #{task.content}"
      end
    when "delete"
      raise "Must delete by task ID (number)" unless /\d+/.match(ARGV[1])
      # input = ""
      # puts "Are you sure you want to delete #{ARGV[1]}? (y/n)"
      # input = gets.chomp
      # if input == "y"
        puts "# of tasks before delete: #{@list.tasks.length}"
        @list.delete(ARGV[1])
        "So accomplished!"
        puts "# of tasks after delete: #{@list.tasks.length}"
      # else
      #   puts "Aborting delete..."
      #   EXIT
      # end
    when "complete"
      # raise "Must complete by task ID (integer)" unless ARGV[1].is_a?(Integer)
      @list.complete(ARGV[1])
    when "add"
      raise "Must add something..." unless ARGV.length > 1
      task_to_add = ""
      ARGV.shift
      @list.add(ARGV.join(" "))
 
      # ARGV.each do |arg|
      #  task_to_add += "#{arg} "
      # end
      # @list.add(task_to_add)
    else
      puts "I can't do that, Dave"
    end
 
    @list.save
  end
  
  # 
  
end
 
 
TaskMaster.new()