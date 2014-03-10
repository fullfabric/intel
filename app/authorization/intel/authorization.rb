class Intel::Authorization

  def self.all

    {

      intel_access: {
        description: "Intel access",
        includes: [],
        resources: [
          "Intel::Classes::DimensionsController",
          "Intel::V1::Classes::StatesController"
        ]
      }

    }

  end

end