CheckInAppMapServer
===================

<h2> Summary </h2>

Checkin app is a mobile app, used for showing users the various activities happening at a location based on popularity.

Checkin App can be used by users for two reasons:
<ol>
<li> User wants to checkin activity at current location</li>
<li> User wants to know the different activities happening at a location</li>
</ol>

This is a backend service which persists users checkin at location, and also returns list of activities happening at a location based on user request.


<h2> Scope </h2>
 <ul>
 <li> Add activity at current location. User can select a category from 'food','drinks','deals','events' to checkin. </li>
 <li> Get all checkins at current location based on lat long range for a category. User can select a category and based on the zoom range, get ranked list of things happening at different points on the map.</li> 
 </ul>
 
 
 <h2> Implementaion</h2>
 The backend service is mainted in Ruby On Rails. The API's are used by the client to cerate a new checking and to show
 existing checkins. 
 ==================
 
 The create API is a POST request with params
 <br>
 {
 <br>
   'lat' => latitude of location being checked in,
   <br>
   'long' =>longitude of location ebing checked in,
   <br>
   'category' => Food/drinks/events/deals,
   <br>
   'extra_text' => Some misc text
   <br>
 }
 <br>
 
 The show API is a GET request with params
 <br>
 {
 <br>
  'min_lat' => the minimum latitude degree for zoom level of user,
  <br>
  'max_lat' => the maximum latitude degree for zoom level of user,
  <br>
  'min_long' => the minimum longitude degree for zoom level of user,
  <br>
  'max_long'=> the maximum longitude degree for zoom level of user,
  <br>
  'category' => the category for which checkin count is needed
  <br>
 }
 
 This API returns all the checkins that belong fit within the above lat long range
 
 <h2> Database Schema</h2>
 For now the app is simple with just a table for the checkins.
 This table has the following columns:
 <br>
  `id`,
  `latitude`,
  `longitude`,
  `text`,
  `category`,
  `created_at`,
  
  <h2> Run</h2>
  
  This app needs rails -version 3.0 and ruby -version 1.9.3
  Steps to get the app running:
  <ol>
  <li> git clone project
  <li> cd social_map_new
  <li> bundle install
  <li> bundle exec rake db:migrate
  <li>rails server
  </ol>
  
  <h2> curl requests for the API's</h2>
  <ol>
  <li> To checkin a user's ativity in current location
   Request : curl -X POST 'http://localhost:3000/checkins' --data "lat=1.2&lon=1.2&text='aoeuaoeuaoeuaoeu'&category=food"
{"social_map":{"id":5,"lat":1.2,"lon":1.2,"text":"'aoeuaoeuaoeuaoeu'","category":"food"}}

Response:
<br>
{"social_map":{"id":5,"lat":1.2,"lon":1.2,"text":"'aoeuaoeuaoeuaoeu'","category":"food"}}

<li> Get all checkins for category.
Request: curl -X GET 'http://localhost:3000/checkins' --data 'min_lat=1.2&max_lat=1.4&min_lon=1.2&max_lon=1.7&category=food'

Response:
<br>
{"social_map":[{"id":5,"lat":1.2,"lon":1.2,"text":"'aoeuaoeuaoeuaoeu'","category":"food"}]}
  </ol>
