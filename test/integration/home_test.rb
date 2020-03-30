class HomeControllerTest < ActionDispatch::IntegrationTest
	test 'should display the requested text' do
		get root_path
		assert_select 'body', /Hi P161!/
	end
end