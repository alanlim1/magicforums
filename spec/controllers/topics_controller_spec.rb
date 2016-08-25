require 'rails_helper'

RSpec.describe TopicsController, type: :controller do
    before(:all) do
        @admin = create(:user, :admin)
        @user = create(:user)
        @topic = create(:topic)
    end

    describe "index topics" do
        it "should render index topics" do
            get :index
            expect(assigns[:topics].count).to eql(1)
            expect(subject).to render_template(:index)
        end
    end

    describe "new topic" do
        it "should deny if not logged in" do
            get :new, params: nil
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should render new for admin" do
            get :new, params: nil, session: { id: @admin.id }
            expect(subject).to render_template(:new)
        end

        it "should deny user" do
            cookies.signed[:id] = @user.id
            get :new, params: nil
            expect(flash[:danger]).to eql("You need to login first")
        end
    end

    describe "create topic" do
        it "should deny if not logged in" do
            params = { topic: { title: "New Title Nu", description: "New Description Nu" } }
            post :create, params: params

            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should create new topic for admin" do
            params = { topic: { title: "New Title", description: "New Description" } }
            post :create, params: params, session: { id: @admin.id }

            topic = Topic.find_by(title: "New Title")

            expect(Topic.count).to eql(2)
            expect(topic).to be_present
            expect(topic.description).to eql("New Description")
            expect(subject).to redirect_to(topics_path)
        end

        it "should deny if user not admin" do
            params = { topic: { title: "New Title", description: "New Description" } }
            post :create, params: params, session: { id: @user.id }

            expect(subject).to redirect_to(topics_path)

        end
    end

    describe "edit topic" do
        it "should redirect if not logged in" do
            params = { id: @topic.slug }
            get :edit, params: params

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should redirect if user unauthorized" do
            params = { id: @topic.slug }
            get :edit, params: params, session: { id: @user.id }

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You're not authorized")
        end

        it "should render edit" do
            params = { id: @topic.slug }
            get :edit, params: params, session: { id: @admin.id }

            current_user = subject.send(:current_user)
            expect(current_user).to be_present
            expect(subject).to render_template(:edit)
        end
    end

    describe "update topic" do
        it "should redirect if not logged in" do
            params = { id: @topic.slug } 
            patch :update, params: params

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should redirect if user unauthorized" do
            params = { id: @topic.slug }
            patch :update, params: params, session: { id: @user.id}

            expect(flash[:danger]).to eql("You're not authorized")
            expect(subject).to redirect_to(root_path)
        end

        it "should update topic for admin" do
            params = { id: @topic.id, topic: { title: "NEW TITLE YO", description: "NEW DESC YO" } }
            patch :update, params: params, session: { id: @admin.id }

            @topic.reload
            current_user = subject.send(:current_user).reload

            expect(current_user).to eql(@admin)
            expect(flash[:success]).to eql("You've updated your topic.")
            expect(subject).to redirect_to(topics_path)
        end
    end

    describe "destroy topic" do
        it "should redirect if not logged in" do
            params = { id: @topic.id }
            delete :destroy, params: params

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should redirect if user unauthorized" do
            params = { id: @topic.id }
            delete :destroy, params: params, session: { id: @user.id }

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You're not authorized")
        end

        it "should render destroy" do
            params = { id: @topic.id }
            delete :destroy, params: params, session: { id: @admin.id }

            current_user = subject.send(:current_user)
            expect(subject).to redirect_to(topics_path)
            expect(current_user).to be_present
        end
    end

end