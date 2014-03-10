class Intel::V1::Classes::StatesController < Api::BaseController

  def index

    context = @_institution.classes.detect { |class_of| class_of.id.to_s == params[:id] }

    start_date = 6.weeks.ago
    end_date = Date.yesterday.end_of_day

    start_date = Date.parse params[:start_date] if params[:start_date]
    end_date = Date.parse params[:end_date] if params[:end_date]

    data = Intel::States.for(context).between(start_date, end_date).as_json

    render json: data.as_json

  end


  def weekly

    context = @_institution.classes.detect { |class_of| class_of.id.to_s == params[:id] }

    start_date = context.opens_on.try( :to_date )

    end_date = Date.yesterday.end_of_day.to_date
    end_date = context.closes_on.to_date if context.closes_on.present? && context.closes_on.to_date < end_date


    start_date = Date.parse params[ :start_date ] if params[ :start_date ]
    end_date = Date.parse params[ :end_date ] if params[ :end_date ]


    query = Intel::Timeseries::Query.new Intel::States.collection, context, *facts
    data = query.between( start_date, end_date ).weekly

    respond_to do |format|

      format.json { render json: data.as_json }

      format.csv do

        csv_string = CSV.generate do |csv|
          csv << [ "date" ] + facts
          data.to_a.each { |row| csv << [ row[:date] ] + facts.map { |f| row[ f ] } }
        end

        send_data csv_string, type: 'text/csv; charset=iso-8859-1; header=present', disposition: "attachment; filename=export.csv"

      end
    end

  end


  private


    def facts

      @facts = begin

        lifecycle = Institutions::Institution.current.lifecycle

        prospect_substates = lifecycle.find_state_by_name("prospect").substates.map { |substate| "#{substate.state.name}::#{substate.name}"}
        applicant_substates = lifecycle.find_state_by_name("applicant").substates.map { |substate| "#{substate.state.name}::#{substate.name}"}

        prospect_substates + applicant_substates

      end

    end

end