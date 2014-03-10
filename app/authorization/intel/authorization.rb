class Intel::Authorization

  def self.all

    {

      intel_access: {
        description: "Intel access",
        includes: [],
        resources: [ "Intel::Classes::DimensionsController",
                     "Intel::Classes::StatesController" ]
      }

    }

  end

end