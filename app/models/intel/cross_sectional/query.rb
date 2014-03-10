class Intel::CrossSectional::Query

  def initialize collection, context

    @collection = collection
    @context = context

    @segment = ::Segments::Base.new institution: @context.institution
    @segment.rules << ::Segments::Rules::Context::IsIn.new(value: @context.id)

  end

  def query q
    @segment.rules += QueryParser.new(q, @context.institution).rules
    self
  end

  def with dimension
    @dimension = dimension.to_s
    self
  end

  def as_json
    to_a.as_json
  end

  def to_a

    if match = @dimension.match(/^roles\.(.*)$/)

        embedded_dimension = match[1] # use underscore for numeric, like _potential, should check if field exists?

        criteria = { :_id => { :$in => @segment.to_ids } }.merge({ 'roles.context_id' => @context.id })

        if embedded_dimension == "state_and_substate"

          grouped = @collection.find( critera, { fields: [ 'roles.$' ] } ).to_a.group_by { |hash| "#{hash['roles'][0]['state']}::#{hash['roles'][0]['substate']}" }
          grouped.map do |dimension_with_occurences|
            { dimension_with_occurences[0] => dimension_with_occurences[1].size }
          end.reduce(&:merge)

        else
          grouped = @collection.find( criteria , { fields: [ 'roles.$' ] } ).to_a.group_by { |hash| hash['roles'][0][embedded_dimension] }
          grouped.map do |dimension_with_occurences|
            { dimension_with_occurences[0] => dimension_with_occurences[1].size }
          end.reduce(&:merge)

        end

    else

      @collection.group( "function(record) { return { #{@dimension}: record.#{@dimension} } }", { :_id => { :$in => @segment.to_ids } }, { count: 0 }, "function(x, y) { y.count++ }" ).map do |hash|
        key = hash[@dimension].present? ? hash[@dimension] : "?"
        { key => hash["count"] }
      end.reduce(&:merge)

    end

  end

end