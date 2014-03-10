class Intel::V1::Classes::DimensionsController < Api::BaseController

  def index

    context = @_institution.classes.detect { |class_of| class_of.id.to_s == params[:id] }

    data = Intel::Dimension.for(context).with(params[:dimension])
    data = data.query(params[:q]) if params[:q]

    render json: data.as_json

  end

end