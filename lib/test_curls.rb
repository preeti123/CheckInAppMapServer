curl -X GET 'http://localhost:3000/checkins' --data 'lat=1.2&lon=1.2&dist=985'

curl -X POST 'http://localhost:3000/checkins' --data "lat=1.2&lon=1.2&text='aoeuaoeuaoeuaoeu'&category=food_and_drinks" 