class HomeControllerTest < ActionDispatch::IntegrationTest
	test 'should display the requested text' do
		get root_path
		assert_select 'body', /Hi P161!/
	end
	test 'should create a visit' do
		assert_difference 'Visit.count', 1 do
			get root_path
		end
	end
end