# COVID-19 APP

An app for latest updates on the Coronavirus epidemic.

![alt text](https://github.com/Marcellofabbri/Covid-19-App/blob/master/Snapshot-020420.png)

# Project's backstory

This is my first personal side project after completing the Makers Bootcamp in London in March 2020. It's an idea I had for our final project at the course that I couldn't realize, and since it had not been picked up I started working on it on my own after the end of the course.
I had never coded anything for mobile platforms during the bootcamp so I wanted to extend my knowledge to that field and learn new technologies. This app has been created through [Flutter](https://flutter.dev/), a software development kit released by Google, that runs on the Android Studio IDE, lets the developer inject changes and see them live on an emulator, uses the programming language *Dart*, and compiles apps that are meant to work cross-platform on both Android and iOS.

# The evolution of the app through features

In order to build an app it was necessary to line up a set of priorities that would lead to an orderly development of the project.
The MVP of this project would be an app that lets the user see the latest numbers of the epidemic in a selected country.

- **Retrieve data from an online API**: [RapidAPI](rapidapi.com) has a number of free APIs that provide appropriate figures (new cases, total cases, deaths registered today, deaths registered in total, timestamp) for each country. So I created a simple column widget on the only page of the app that would return the raw data for a queried country, Italy for example, organized in rows (1 per figure).

<p align=center>
<img src="https://github.com/Marcellofabbri/Covid-19-App/blob/master/screenshots/talk-to-first-api.png?raw=true">
</p>

-**Select which country to query**: I learnt how to do a scrollable set of widgets, each containing a country. Initially the set of scrollable countries was the result of an iteration of a hardcoded list of 10 nations, later on I populated the list with all the countries available in the API, which set me up for the first challenges against the creation of widgets that depend on asynchronous calls. By this stage the app looked like a scrollable container of countries on the top half of the app and some sort of table of figures on the bottom half, which will be meant to change upon selecting a different country.

<p align=center>
<img src="https://github.com/Marcellofabbri/Covid-19-App/blob/master/screenshots/scrollbar.png?raw=true">
</p>

-**Actually select the country**: now that a list (array) of Country objects is created, each carrying information about their latest figures and name (and intrisically index), there were two tasks left to complete to achieve MVP. The most important was make tapping on a country update the table underneath with the figures relevant for that specific country.
E.g.:
(tap on Spain) ----> (show total Covid-19 cases in Spain)
(tap on Italy) ----> (update that same widget by showing total Covid-19 cases in Italy)
(tap on Luxembourg) ----> (update that same widget by showing total Covid-19 cases in Luxembourg)

So each country card had to become a button capable of firing a function that would do reach such output.
The other task was about making sure the selection was visible, so, when clicking on a country, it would change color and add a border, so that it'd appear "glowing", or "switched on".

<p align=center>
<img src="https://github.com/Marcellofabbri/Covid-19-App/blob/master/screenshots/selection.png?raw=true">
</p>

-**Add images per each country widget**: at this point I had already abstracted the concept of _country_ into its own class, and each instance of Country would have its own properties, among which the name of the nation. So I imported from the web all of their flags and renamed them so that each image would be named exactly like the "name" property of each Country object. At some point I decided to sort the list alphabetically.
Two countries, Curaçao and Réunion, contain problematic characteres that rendered very differently in the app, so I created a debugger function that upon retrival of all countries would search for those two malformed names and correct them with names that would render fine.

<p align=center>
<img src="https://github.com/Marcellofabbri/Covid-19-App/blob/master/screenshots/flags.png?raw=true">
</p>

-**Cache the data**: by now each tapping of the countries prompts an API request that obtains data for that nation. In order to make the app more savvy I made an API request be sent upon initialization, and stored the entire body of the response locally, so that when selecting countries they would not send an API call through the web but would be retrieving the data from a locally stored data structure.

-**Reload button**: the user can update the data and retrieve the latest update available by pressing a button that sends the API the same request sent upon initialization, so that a fresh set of data can be overwritten on the previous one. This was a good time to introduce another package that renders animations. In this case, the _reload_ button shows a static blue circle that is changed with an animated red circle at the beginning of the asynchronous API call. At the end of the call (when the app is done retrieving data) it's set back to the static blue circle.

-**Search box**: populating the list of countries based on the ones available in the API meant having around 200 countries to choose from, so I implemented a search box, that would filter the countries based on what is typed on the text field. The logic behind it is to have a second list of countries ony for displaying purposes: this second list is set equal to the original one created from the first API call, but the search box fires a function at every character typed that filters the original and presents only the countries that contain what's been typed. This way it'll show the unfiltered collection of all countries by default (when nothing's typed), before presenting a new filtered list of countries at each key stroke.

<p align=center>
<img src="https://github.com/Marcellofabbri/Covid-19-App/blob/master/screenshots/reload.png?raw=true">
</p>

-**Selected country by default**: by default the selected country is set to 0. The selection works with the index of the array of countries. Since one of the "countries" was "All" and was fourth in line alphabetically, I set the selected country as 3, so it would show the world's figures at the beginning. I then renamed it "World", sorted it so that it'd be first in the list (with the rest of the countries following alphabetically) and set the selected country as 0 again.

-**Timestamp**: it felt like a good idea to have a bar at the bottom of the screen that showed what timestamp these data were carrying, especially now that there's a button to refresh them. The _reload_ button got moved in this bar as well.

-**Space for more features**: to have more features without clogging the page it was necessary to introduce *routing*. By tapping a button in the middle of the home screen the user can be shown a different page, a different route, where more data can be shown. So I created a route called _/history_.

<p align=center>
<img src="https://github.com/Marcellofabbri/Covid-19-App/blob/master/screenshots/historybutton.png?raw=true">
</p>

-**Line chart**: when tapping on that newly created button at the center of the front page the user is brought to another route where a chart for the selected country is shown. The graph describes the trend of daily infections. The chart has a weekly scale, but can be scrolled back and forth. It goes as far back as December 1st 2019. When tapped on persistently (onLongPressed) it shows details of that particular point in time on the chart. The data comes from another API that gives information about different countries history with Coronavirus.

<p align=center>
<img src="https://github.com/Marcellofabbri/Covid-19-App/blob/master/screenshots/chart.png?raw=true">
</p>

-**Trend**: below the chart I build a table that takes the data retrieved from the second API, and filters them according to what country was selected before going into this route, and takes the figures for daily cases from the last five days. The figures shown for each day are: 1) the daily cases on that day. 2) the increase/decrease compared to the previous day expressed in percentage. 3) the actual number of how many more or how many fewer cases there have been compared to the previous day.
The percentage column has an icon that shows a green downward arrow when there's a decrease or a red upward arrow when there's an increase.
A notable bug: when a country has a day with 0 cases followed by a day with a number of cases it makes the app crash due to the calculations to obtain the percentage of variance, which involve dividing today's cases with yesterday's cases. And if yesterday's cases are zero the calculation would need the number to be divided by zero. So when yesterday's numbers are zero the calculation is avoided and 'N/A' is shown.
Another bug: the second API does not necessarily have all of the countries provided by the first API (which is responsible for creating our list of countries). So certain Countries object, such as 'World', 'Isle-of-Man' and others might not have corresponding data in the second API, therefore causing an error. Some of these simple have a rendering problem: I already fixed Britain for example, whose name extrapolated from the first API on the home page is _UK_ and couldn't be queried in the second API, where it's called _UnitedKingdom_. For now I implemented a function that changes the button for routing: when the selected country exists on the second API (thus when the query pans out) the button appears green. When it doesn't exists, it looks red and has a different label. When it's completing the task and is determining which scenario we're in it shows a yellow animated dot.

<p align=center>
<img src="https://github.com/Marcellofabbri/Covid-19-App/blob/master/screenshots/trend.png?raw=true">
</p>

-**Launcher icon**: every app on every phone has an icon that starts it when tapped. I'm working on it. I created one already, but it appears enclosed in a bigger white container. What I need to figure out is how to make an _adaptive icon_ that renders well on mobile devices.

-**Deployment**: every app released on Google Play needs to be signed and its building is not straightforward like creating a whole APK but split and bundled. I have to figure out how to do these and hopefully deploy the app so it's available for download.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
