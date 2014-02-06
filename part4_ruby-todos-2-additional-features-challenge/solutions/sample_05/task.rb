class Task
  attr_reader :task, :status, :priority, :date, :tag

  def initialize(task)
    @task     = task[:task]
    @status   = task[:status]   || "pending"
    @priority = task[:priority] || "10"
    @date     = task[:date]     || Time.now.strftime("%m/%d/%y")
    @tag      = task[:tag]
  end

  def complete!
    @status = "complete"
    @priority = "0"
  end

  def display_status
    return "[X]" if @status == "complete"
    return "[ ]"
  end
end