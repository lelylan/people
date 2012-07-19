module LocationsViewMethods

  def should_have_owned_location(location)
    location = LocationDecorator.decorate(location)
    json = JSON.parse(page.source)
    should_contain_location(location)
    should_not_have_not_owned_locations
  end

  def should_contain_location(location)
    location = LocationDecorator.decorate(location)
    json = JSON.parse(page.source).first
    should_have_location(location, json)
  end

  def should_have_location(location, json = nil)
    location = LocationDecorator.decorate(location)
    should_have_valid_json
    json = JSON.parse(page.source) unless json 
    json = Hashie::Mash.new json
    json.uri.should == location.uri
    json.id.should == location.id.to_s
    json.name.should == location.name
    json.type.should == location.type

    should_have_parent(json, location)
    should_have_ancestors(json, location)
    should_have_children(json, location)
    should_have_descendants(json, location)
  end

  def should_have_parent(json, location)
    if location.the_parent
      parent = LocationDecorator.decorate(location.the_parent)
      json.locations.parent.uri.should == parent.uri if parent
    else
      json.locations.parent.should == nil
    end
  end

  def should_have_ancestors(json, location)
    ancestors = LocationDecorator.decorate(location.ancestors)
    json.locations.ancestors.each_with_index do |json_ancestor, i|
      json_ancestor.uri.should == ancestors[i].uri
    end
  end

  def should_have_children(json, location)
    children = LocationDecorator.decorate(location.children)
    json.locations.children.each_with_index do |json_child, i|
      json_child.uri.should == children[i].uri
    end
  end

  def should_have_descendants(json, location)
    descendants = LocationDecorator.decorate(location.descendants)
    json.locations.descendants.each_with_index do |json_descendant, i|
      json_descendant.uri.should == descendants[i].uri
    end
  end

  def should_not_have_not_owned_locations
    should_have_valid_json
    json = JSON.parse(page.source)
    json.should have(1).item
    Location.all.should have(2).items
  end

end

RSpec.configuration.include LocationsViewMethods
