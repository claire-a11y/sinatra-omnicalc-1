require "sinatra"
require "sinatra/reloader"
require "active_support/all"

# Navigation menu
def navigation_menu
  <<-HTML
    <div>
      <strong>Calculators</strong>
      <ul>
        <li><a href="/square/new">Square with Form</a></li>
        <li><a href="/square_root/new">Square Root with Form</a></li>
        <li><a href="/payment/new">Payment with Form</a></li>
        <li><a href="/random/new">Random with Form</a></li>
      </ul>
    </div>
  HTML
end

# Form for squaring a number
get "/square/new" do
  navigation_menu + <<-HTML
    <form action="/square/results" method="post">
      <label for="square_input">Enter a number:</label>
      <input id="square_input" type="text" name="number" placeholder="What number do you want to square?">
      <button>Calculate square</button>
    </form>
  HTML
end

# Result for squaring a number
post "/square/results" do
  number = params[:number].to_f
  square = number ** 2
  navigation_menu + "<h1>The square of #{number} is #{square}</h1>"
end

# Form for square root of a number
get "/square_root/new" do
  navigation_menu + <<-HTML
    <form action="/square_root/results" method="post">
      <label for="square_root_input">Enter a number:</label>
      <input id="square_root_input" type="text" name="number" placeholder="What number do you want to find the square root of?">
      <button>Calculate square root</button>
    </form>
  HTML
end

# Result for square root of a number
post "/square_root/results" do
  number = params[:number].to_f
  square_root = Math.sqrt(number)
  navigation_menu + "<h1>The square root of #{number} is #{square_root}</h1>"
end

# Form for generating a random number between two numbers
get "/random/new" do
  navigation_menu + <<-HTML
    <form action="/random/results" method="post">
      <div>
        <label for="min_input">Minimum:</label>
        <input id="min_input" type="text" name="min" placeholder="E.g. 1.5">
      </div>
      <div>
        <label for="max_input">Maximum:</label>
        <input id="max_input" type="text" name="max" placeholder="E.g. 4.5">
      </div>
      <button>Pick random number</button>
    </form>
  HTML
end

# Result for random number generation
post "/random/results" do
  min = params[:min].to_f
  max = params[:max].to_f
  random_number = rand(min..max)
  navigation_menu + "<h1>Your random number between #{min} and #{max} is #{random_number}</h1>"
end

# Form for calculating monthly payment
get "/payment/new" do
  navigation_menu + <<-HTML
    <form action="/payment/results" method="post">
      <div>
        <label for="apr_input">APR (annual percentage rate):</label>
        <input id="apr_input" type="text" name="apr" placeholder="E.g. 5.42" required>
      </div>
      <div>
        <label for="years_input">Number of years remaining:</label>
        <input id="years_input" type="text" name="years" placeholder="How many years to repay?" required>
      </div>
      <div>
        <label for="present_value_input">Present value (principal):</label>
        <input id="present_value_input" type="text" name="present_value" placeholder="How much principal?" required>
      </div>
      <button>Calculate monthly payment</button>
    </form>
  HTML
end

# Result for monthly payment calculation
post "/payment/results" do
  apr = params[:apr].to_f / 100 / 12
  years = params[:years].to_i * 12
  present_value = params[:present_value].to_f

  numerator = apr * present_value
  denominator = 1 - (1 + apr) ** -years
  monthly_payment = numerator / denominator
  monthly_payment = monthly_payment.round(2)
  formatted_apr = (apr * 12 * 100).round(4).to_fs(:percentage, { precision: 4 })

  navigation_menu + "<h1>Your monthly payment is #{(monthly_payment.to_fs(:currency))}</h1><p>APR: #{formatted_apr}</p>"
end

