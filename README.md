# Yelp IOS Client

## Time spent ~ 20

# Requirements Satisfied

![Auto Layout](https://dl.dropboxusercontent.com/u/42075244/autolayout.gif)
![Search](https://dl.dropboxusercontent.com/u/42075244/search.gif)
![Filters](https://dl.dropboxusercontent.com/u/42075244/filter.gif)
![Categories](https://dl.dropboxusercontent.com/u/42075244/categories.gif)
![Infinite Scrolling](https://dl.dropboxusercontent.com/u/42075244/infinite_scrolling.gif)

## Search results page

- [x] Table rows should be dynamic height according to the content height

- [x] Custom cells should have the proper Auto Layout constraints

- [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).

- [x] Optional: infinite scroll for restaurant results

- [ ] Optional: Implement map view of restaurant results

## Filter page. Unfortunately, not all the filters are supported in the Yelp API.

- [x] The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).

- [x] The filters table should be organized into sections as in the mock.

- [x] You can use the default UISwitch for on/off states. Optional: implement a custom switch

- [x] Radius filter should expand as in the real Yelp app

- [x] Categories should show a subset of the full list with a "See All" row to expand. Category list is here: http://www.yelp.com/developers/documentation/category_list (Links to an external site.)

- [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
