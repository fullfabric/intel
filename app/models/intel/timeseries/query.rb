class Intel::Timeseries::Query

  def initialize collection, context, *fact_keys

    @collection = collection
    @context    = context
    @fact_keys  = fact_keys

    @_cumulator  = proc { |x| x }
    @_grouper    = proc { |x| x }

  end

  def between start_date, end_date

    @start_date = start_date
    @end_date = end_date
    self

  end

  def daily
    self
  end

  def weekly

    @_grouper = proc do |array|

      array.group_by { |entry| entry['date'].beginning_of_week }.map do |week, facts|
        stats = Hash[ *@fact_keys.map { |key|  state, substate = key.split("::"); [ key, facts[0][state][substate].to_i ] }.flatten ]
        stats[ "prospects" ]  = stats.reduce(0) { |acc, ( k, v ) | state, substate = k.split("::"); state == "prospect" ? acc + v : acc }
        stats[ "applicants" ] = stats.reduce(0) { |acc, ( k, v ) | state, substate = k.split("::"); state == "applicant" ? acc + v : acc }
        { date: week.to_date.to_s, week: week.to_date.cweek.to_s, year: week.to_date.year.to_s }.merge(stats)
      end

    end

    self

  end

  # def weekly

  #   @_grouper = proc do |array|

  #     array.group_by { |entry| entry['date'].beginning_of_week }.map do |week, facts|
  #       stats = Hash[ *@fact_keys.map { |key| [ key, facts.reduce(0) { |memo, fact| state, substate = key.split("::")  ; memo + fact[state][substate].to_i } ] }.flatten ]
  #       { date: week, week: week.to_date.cweek.to_s }.merge(stats)
  #     end

  #   end

  #   self

  # end

  def monthly

    @_grouper = proc do |array|

      array.group_by { |entry| entry['date'].beginning_of_month }.map do |key, facts|
        stats = Hash[ *@fact_keys.map { |key| [ key, facts.reduce(0) { |memo, fact| state, substate = key.split("::")  ; memo + fact[state][substate].to_i } ] }.flatten ]
        { date: week, week: week.to_date.cweek.to_s }.merge(stats)
      end

    end

    self

  end

  def cummulative
    @_cumulator = proc do |array|
      array.each_with_index.map do |hash, index|
        hash.keys.select{ |key| key =~ /::/ }.each { |key| hash[key] += array[index-1][key] } if index > 0
        hash
      end

      array
    end

    self

  end

  def as_json
    to_a.as_json
  end

  def to_a
    # @collection.find(_build_query).to_a
    @_cumulator.call(@_grouper.call(@collection.find(_build_query).to_a))
  end

  private

    def _build_query
      query = { context_id: @context.id }
      query.merge!({ date: { :$gte => @start_date.to_time.utc, :$lte => @end_date.end_of_day.to_time.utc} }) if @start_date && @end_date
      query
    end

end