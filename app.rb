require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require './models.rb'
enable :sessions

helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

get '/' do
    if current_user.nil?
        @tasks = Task.none
    else
        @tasks = current_user.tasks
    end
    erb :index
end

get '/events' do
    @date = Date.today
    events = current_user.tasks
    current_year = Date.today.year
    # next_year = Date.today.year + 1
   
        # formatted_current_year_events = events.map do |event|
        #     {
        #         id: event.id,
        #         title: event.event,
        #         start: "2000-1-1"
        #     }
        # end
    future_years_count = 1000
    formatted_events = []

    (0..future_years_count).each do |offset|
        year = current_year + offset

        formatted_current_year_events = events.map do |event|
            {
                id: event.id,
                title: event.event,
                start: "#{year}-#{event.ymd.strftime('%m-%d')}"
            }
        end

        formatted_events.concat(formatted_current_year_events)
    end

    content_type :json
    formatted_events.to_json
    
        # formatted_current_year_events = events.map do |event|
        #     {
        #             id: event.id,
        #             title: event.event,
        #             start: "#{current_year}-#{event.ymd.strftime('%m-%d')}"
        #     }
        # end
   
        # formatted_current_year_events = events.map do |event|(0..100).map |pasty| do
        #     {
        #             id: event.id,
        #             title: event.event,
        #             start: "#{current_year+pasty}-#{event.ymd.strftime('%m-%d')}"
        #     }
        # end
        # end.flatten

    # formatted_next_year_events = events.map do |event|
    #     {
    #         id: event.id,
    #         title: event.event,
    #         start: "#{next_year}-#{event.ymd.strftime('%m-%d')}"
    #     }
    # end
    #   current_year = current_year + 1
    #   content_type :json
    #   (formatted_current_year_events).to_json
    
end

get '/signup' do
    erb :sign_up
end

post '/signup' do
    user = User.create(
        name: params[:name],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
    )
    if user.persisted?
        session[:user] = user.id
    end
    redirect '/'
end

get '/signin' do
    erb :sign_in
end

post '/signin' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
    end
    redirect '/'
end

get '/signout' do
    session[:user] = nil
    redirect'/'
end

get '/tasks/new' do
    erb :new
end

post '/tasks' do
    current_user.tasks.create(event: params[:event], ymd: params[:ymd], category: params[:category])
    redirect '/'
end