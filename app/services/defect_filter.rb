class DefectFilter
  attr_accessor :statuses,
                :types,
                :schemes,
                :escalations

  def initialize(statuses: [], types: [], schemes: [], escalations: [])
    self.statuses = statuses
    self.types = types
    self.schemes = schemes
    self.escalations = escalations
  end

  def scopes
    scopes = [status_scope, type_scope, scheme_scope, escalation_scope].compact
    return [:all] if scopes.empty?
    scopes
  end

  private

  def status_scope
    return :open_and_closed if open? && closed?
    return :open if open?
    return :closed if closed?
  end

  def type_scope
    return :property_and_communal if property? && communal?
    return :property if property?
    return :communal if communal?
  end

  def scheme_scope
    return nil if schemes.empty?
    [:for_scheme, schemes]
  end

  def escalation_scope
    return escalated_permutations if manually_escalated?
    return :overdue_and_due_soon if due_soon? && overdue?
    return :overdue if overdue?
    return :due_soon if due_soon?
  end

  def escalated_permutations
    return if overdue? && due_soon?
    return :flagged_and_overdue if overdue?
    return :flagged_and_due_soon if due_soon?
    :flagged
  end

  def none?
    statuses.empty?
  end

  def open?
    statuses.include?(:open)
  end

  def closed?
    statuses.include?(:closed)
  end

  def property?
    types.include?(:property)
  end

  def communal?
    types.include?(:communal)
  end

  def manually_escalated?
    escalations.include?(:manually_escalated)
  end

  def overdue?
    escalations.include?(:overdue)
  end

  def due_soon?
    escalations.include?(:due_soon)
  end
end
