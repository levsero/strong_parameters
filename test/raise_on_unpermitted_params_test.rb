require 'test_helper'
require 'action_controller/parameters'

class RaiseOnUnpermittedParamsTest < ActiveSupport::TestCase
  def setup
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
    ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  test "raises on unexpected params" do
    params = ActionController::Parameters.new({
      :book => { :pages => 65 },
      :fishing => "Turnips"
    })

    assert_raises(ActionController::UnpermittedParameters) do
      params.permit(:book => [:pages])
    end
  end

  test "raises on unexpected nested params" do
    params = ActionController::Parameters.new({
      :book => { :pages => 65, :title => "Green Cats and where to find then." }
    })

    assert_raises(ActionController::UnpermittedParameters) do
      params.permit(:book => [:pages])
    end
  end
  
  test "not raise on params included in NEVER_UNPERMITTED_PARAMS" do
    key = ActionController::Parameters::NEVER_UNPERMITTED_PARAMS[0]
    params = ActionController::Parameters.new({
      key => "Turnips"
    })

    assert_nothing_raised do
      params.permit
    end
  end
end
