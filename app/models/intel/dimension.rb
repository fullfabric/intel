class Intel::Dimension

  def self.for context
    Intel::CrossSectional::Query.new Profiles::Profile.collection, context
  end

end