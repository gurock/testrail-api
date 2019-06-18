# frozen_string_literal: true

RSpec.describe 'TestRail' do
  context 'API' do
    context 'Projects' do
      before(:each) do
        @client = TestRail::Client.new
        @name = 'Project name'
        @announcement = 'Project announcement'
      end

      it 'can create/get/delete project' do
        payload = @client.payload_for_adding_project
        payload[:name] = @name
        payload[:announcement] = @announcement
        project = @client.add_project(payload)

        expect(project).not_to be_nil

        project_id = project['id']
        project = @client.get_project(project_id)
        expect(project['id']).to eq(project_id)
        expect(project['name']).to eq(@name)
        expect(project['announcement']).to eq(@announcement)

        @client.delete_project(project['id'])
        expect { @client.get_project(project['id']) }.to raise_error(TestRail::APIError, 'TestRail API returned HTTP 400 ("Field :project_id is not a valid or accessible project.")')
      end

      it 'can get projects' do
        payload = @client.payload_for_adding_project

        name1 = "#{@name}1"
        announcement1 = "#{@announcement}1"
        payload[:name] = name1
        payload[:announcement] = announcement1
        project1 = @client.add_project(payload)

        name2 = "#{@name}2"
        announcement2 = "#{@description}2"
        payload[:name] = name2
        payload[:announcement] = announcement2
        project2 = @client.add_project(payload)

        is_name = false
        is_announcement = false

        projects = @client.get_projects
        projects.each do |project|
          if project['name'] == name2
            is_name = true
            break
          end
        end
        expect(is_name).to be true

        projects.each do |project|
          if project['announcement'] == announcement2
            is_announcement = true
            break
          end
        end
        expect(is_announcement).to be true

        begin
          @client.delete_project(project1['id'])
          @client.delete_project(project2['id'])
        rescue => e
          # Delete test data.
          p e.message
        end
      end

      it 'can update project' do
        payload = @client.payload_for_adding_project
        payload[:name] = @name
        payload[:announcement] = @announcement
        project = @client.add_project(payload)

        project = @client.get_project(project['id'])
        expect(project['is_completed']).to be false

        @client.update_project(project['id'], true)
        project = @client.get_project(project['id'])
        expect(project['is_completed']).to be true

        begin
          @client.delete_project(project['id'])
        rescue => e
          # Delete test data.
          p e
        end
      end

      it 'get default payload' do
        payload = @client.payload_for_adding_project

        expect(payload[:name]).to be_nil
        expect(payload[:announcement]).to be_nil
        expect(payload[:show_announcement]).to be_nil
        expect(payload[:suite_mode]).to be_nil
      end
    end
  end
end
