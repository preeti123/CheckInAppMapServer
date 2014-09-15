CheckInAppMapServer
===================

<h2> Summary </h2>

Checkin app is a mobile app, used to shows users the different activities happening at a location based on popularity.

Checkin App can be used by users for two reasons:
<ol>
<li> User wants to checkin activity at current location</li>
<li> User wants to know the different activities happening at a location</li>
</ol>

This is a backend service which persists users checkin at location, and returns list of activities happening at a location based on user request.


<h2> Scope </h2>
 <ul>
 <li> Add activity at current location. User can select a category from 'food','drinks','deals','events' to checkin. </li>
 <li> Get all checkins at current location based on lat long range for a category. User can select a category and based on the zoom range, get ranked list of things happening at different points on the map.</li> 
 </ul>
 
 
 <h2> Implementaion</h2>
 The backend service is mainted in Ruby On Rails. The API's are used by the client to cerate a new checking and to show
 existing checkins. 
 The create API is a POST request with params
 {
   'lat' => latitude of location being checked in,
   'long' =>longitude of location ebing checked in,
   'category' => Food/drinks/events/deals,
   'extra_text' => Some misc text
 }
 
 The show API is a GET request with params
 </br>
 {
  'min_lat' => the minimum latitude degree for zoom level of user,
  'max_lat' => the maximum latitude degree for zoom level of user,
  'min_long' => the minimum longitude degree for zoom level of user,
  'max_long'=> the maximum longitude degree for zoom level of user,
  'category' => the category for which checkin count is needed
 }
 
 This API returns all the checkins that belong fit within the above lat long range
 
 <h2> Database Schema</h2>
 For now the app is simple with just a table for the checkins.
 This table has the following columns:
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
  </ol>
