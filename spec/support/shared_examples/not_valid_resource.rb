shared_examples_for "not valid JSON" do |action, options|
  it "gets a not valid notification" do
    params = "I'm not an Hash"
    eval(action)
    page.status_code.should == 422
    should_have_a_not_valid_resource code: "notifications.json.not_valid", error: "Not valid", method: options[:method]
    page.should have_content params
  end
end

shared_examples_for "not valid params" do |action, options|
  it "does not create a resource" do
    params = {}
    eval(action)
    page.status_code.should == 422
    should_have_a_not_valid_resource options
  end
end
