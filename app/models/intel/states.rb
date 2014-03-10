class Intel::States

  include MongoMapper::Document
  timestamps!

  key :date, Time
  key :week, Integer
  key :month, Integer
  key :year, Integer

  belongs_to :context, polymorphic: true

  validates_presence_of :date, :week, :month, :year, :context

  def self.for context
    Intel::Timeseries::Query.new self.collection, context, 'applicant::submitted', 'prospect::started_application'
  end

end