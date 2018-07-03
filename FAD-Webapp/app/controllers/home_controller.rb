class HomeController < ApplicationController
  def index
    @tags = generate_tags
  end


private
  def generate_tags
    tags = []
    Food.column_names.each do |name|
      # e.g. contains_gluten
      if name =~ /^contains/
        tags << name[name.index('_')+1..-1]
      end
    end
    return tags
  end

end
