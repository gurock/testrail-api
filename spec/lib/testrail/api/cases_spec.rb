# frozen_string_literal: true

RSpec.describe 'TestRail' do
  context 'API' do
    context 'Cases' do
      before(:each) do
        @project_id = RSpec.current_example.metadata[:project_id]
        @client = TestRail::Client.new
        @title = 'Case Title'
      end

      it 'can get/create/delete test case' do
        payload = @client.payload_for_adding_section
        payload[:name] = 'Section name'
        section = @client.add_section(@project_id, payload)

        payload = @client.payload_for_adding_case
        payload[:title] = @title
        test_case = @client.add_case(section['id'], payload)
        expect(test_case).not_to be_nil

        test_case_id = test_case['id']
        test_case = @client.get_case(test_case_id)
        expect(test_case['id']).to eq(test_case_id)

        @client.delete_case(test_case_id)
        expect { @client.get_case(test_case_id) }.to raise_error(TestRail::APIError, 'TestRail API returned HTTP 400 ("Field :case_id is not a valid test case.")')

        begin
          @client.delete_section(section['id'])
        rescue => e
          # Delete test data
          p e.message
        end
      end

      it 'can get test case' do
        payload = @client.payload_for_adding_section
        payload[:name] = 'Section name'
        section = @client.add_section(@project_id, payload)

        title1 = "#{@title}1"
        payload = @client.payload_for_adding_case
        payload[:title] = title1
        test_case1 = @client.add_case(section['id'], payload)

        title2 = "#{@title}2"
        payload[:title] = title2
        test_case2 = @client.add_case(section['id'], payload)

        payload = @client.params_for_getting_cases
        payload[:filter] = @title
        test_cases = @client.get_cases(@project_id, payload)

        is_title = false
        test_cases.each do |test_case|
          if test_case['title'] == title2
            is_title = true
            break
          end
        end
        expect(is_title).to be true

        begin
          @client.delete_case(test_case2['id'])
          @client.delete_case(test_case1['id'])
          @client.delete_section(section['id'])
        rescue => e
          # Delete test data
          p e.message
        end
      end

      it 'can update test case' do
        payload = @client.payload_for_adding_section
        payload[:name] = 'Section name'
        section = @client.add_section(@project_id, payload)

        payload = @client.payload_for_adding_case
        payload[:title] = @title
        test_case = @client.add_case(section['id'], payload)

        title1 = "#{@title}1"
        payload = @client.payload_for_updating_case
        payload[:title] = title1
        test_case = @client.update_case(test_case['id'], payload)

        test_case_id = test_case['id']
        test_case = @client.get_case(test_case_id)
        expect(test_case['id']).to eq(test_case_id)
        expect(test_case['title']).to eq(title1)

        begin
          @client.delete_case(test_case_id)
          @client.delete_section(section['id'])
        rescue => e
          # Delete test data
          p e.message
        end
      end

      it 'get params for getting cases' do
        payload = @client.params_for_getting_cases
        expect(payload[:project_id]).to be_nil
        expect(payload[:suite_id]).to be_nil
        expect(payload[:section_id]).to be_nil
        expect(payload[:limit]).to be_nil
        expect(payload[:offset]).to be_nil
        expect(payload[:filter]).to be_nil
      end

      it 'get payload for adding case' do
        payload = @client.payload_for_adding_case
        expect(payload[:title]).to be_nil
        expect(payload[:template_id]).to be_nil
        expect(payload[:type_id]).to be_nil
        expect(payload[:priority_id]).to be_nil
        expect(payload[:estimate]).to be_nil
        expect(payload[:milestone_id]).to be_nil
        expect(payload[:refs]).to be_nil
      end

      it 'get payload for updating case' do
        payload = @client.payload_for_updating_case
        expect(payload[:title]).to be_nil
        expect(payload[:template_id]).to be_nil
        expect(payload[:type_id]).to be_nil
        expect(payload[:priority_id]).to be_nil
        expect(payload[:estimate]).to be_nil
        expect(payload[:milestone_id]).to be_nil
        expect(payload[:refs]).to be_nil
      end
    end
  end
end
