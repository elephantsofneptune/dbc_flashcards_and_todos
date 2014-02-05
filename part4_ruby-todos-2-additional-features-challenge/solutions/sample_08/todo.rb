require './middle_man'

class ToDo
  def self.run(commands)
    action = prep_action(commands.first)
    args = { :action => action }

    if action == :add
      args.merge!(:task => commands[1..-1].join(" "))
    elsif action == :delete || action == :complete
      args.merge!(:id => commands[1])
    elsif action == :tag || action == :remove_tag
      tags = commands[2..-1]
      args.merge!(:id => commands[1], :tags => tags)
    elsif action == :filter_tag
      tag = commands.first.split(":").last
      args.merge!(:tags => tag)
    end

    MiddleMan.new(args)
  end

  private
  def self.prep_action(action)
    action =~ /filter/ ? :filter_tag : action.gsub(/:/, "_").to_sym
  end
end

commands = ARGV
ToDo.run(commands)
