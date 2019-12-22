get '/' do
  erb :index
end

post '/' do
  @height = params[:height]
  @weight = params[:weight]
  if params[:height] == '' || params[:weight] == ''
    @input_error = "Field can't be empty! Try again."
    erb :index
  else
    @bmi = (@weight.to_f / ((@height.to_f / 100) ** 2)).round(2)

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
  @height = params[:height]
  @weight = params[:weight]
  @age = params[:age]
  @activity = params[:activity]

  @checked = "checked" # For radio element validation (see tdee.erb)

  # Check if gender is selected
  # If gender is not selected, then params hash won't include the "gender" key
  # so the validation will be missed and an error occur
  if params.has_key?("gender") == false
    @input_error = "Select gender"
    return erb :tdee
  end

  params.each do |key, value|
    if params[key] == ""
      @input_error = "Field can't be empty! Try again."
      return erb :tdee
    end
  end

  @activity_select = {
    "sedentary" => 1.2,
    "light" => 1.375,
    "moderate" => 1.55,
    "active" => 1.725,
    "extreme" => 1.9
  }

  @gender_select = { 'male' => 5, 'female' => -161 }

  @bmr = (@height.to_i * 6.25) + (@weight.to_i * 10) - (@age.to_i * 5) + @gender_select[@gender]
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
