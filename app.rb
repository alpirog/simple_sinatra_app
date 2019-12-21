# require 'rubygems'
# require 'sinatra'
# require 'sinatra/reloader'

get '/' do
  erb :index
end

post '/' do
  @height = params[:height].to_f
  @weight = params[:weight].to_f
  if params[:height] == '' || params[:weight] == ''
    @input_error = "Field can't be empty! Try again."
    erb :index
  else
    @bmi = (@weight / ((@height / 100) ** 2)).round(2)

    f = File.open('bmis.txt', 'a')
    f.write "Height: #{@height}; weight: #{@weight}; BMI: #{@bmi}\n"
    f.close

    erb :bmi
  end
end

get '/tdee' do
  erb :tdee
end

post '/tdee' do
  @gender = params[:gender]
  @height = params[:height].to_i
  @weight = params[:weight].to_i
  @age = params[:age].to_i
  @activity = params[:activity]

  @activity_select = {
    "sedentary" => 1.2,
    "light" => 1.375,
    "moderate" => 1.55,
    "active" => 1.725,
    "extreme" => 1.9
  }

  @gender_select = { '1' => 5, '2' => -161 }

  @bmr = (@height * 6.25) + (@weight * 10) - (@age * 5) + @gender_select[@gender]
  @tdee = (@bmr * @activity_select[@activity]).round

  erb :show_tdee
end

get '/about' do
  under_construction
  erb :message
end

get '/show_bmi' do
  @file = File.open("./bmis.txt", "r")
  erb :show_bmi
end

def under_construction
  @message = "This page is under construcion."
end
