class RouterVersioning

  def initialize options
    @version = options[ :version ]
    @default = options[ :default ]
  end

  def matches? req
    @default || req.headers['Accept'].include?( "application/ffintelapi.v#{ @version }" )
  end

end