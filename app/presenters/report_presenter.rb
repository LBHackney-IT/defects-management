class ReportPresenter
  delegate :name, to: :scheme
  delegate :priorities, to: :scheme

  attr_accessor :scheme

  def initialize(scheme:)
    self.scheme = scheme
  end

  def defects
    @defects ||= Defect.for_scheme([scheme.id])
  end

  def defects_for(status:)
    defects.send(status)
  end

  def trade_count_for(trade:)
    defects.for_trade(trade).count
  end

  def trade_percentage(trade:)
    total = Float(defects.count)
    trade_total = Float(trade_count_for(trade: trade))

    percentage = (trade_total / total) * 100
    "#{percentage}%"
  end

  def priority_count_for(priority:)
    defects.for_priorities([priority.id]).count
  end

  def priority_completed_on_time_percentage(priority:)
    total = Float(defects.count)
    priority_total = priority_count_for(priority: priority)

    percentage = (priority_total / total) * 100
    "#{percentage}%"
  end
end
