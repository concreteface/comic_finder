# Comic Release Finder
---
[![Code Climate](https://codeclimate.com/github/concreteface/comic_finder/badges/gpa.svg)](https://codeclimate.com/github/concreteface/comic_finder)

A simple app to find what was released on a given Wednesday. It's mainly geared toward recent releases, especially finding out what is/will be released in the current week.

## App Usage
---

The search field accepts several date formats. It will let you know if it doesn't like the one you choose. There are a couple examples as placeholders. It's just using Ruby's `Date.parse` so anything that works there will work here.

All the information this app supplies is being scraped from [Comicbook Round Up](http://comicbookroundup.com/) so head on over there if you want to know more about comics.

## Roadmap
---

Future development plans include *a lot* of styling, and some sort of user system to keep track of pull lists and/or favorites.

## Installation and Configuration
---
`git clone https://github.com/concreteface/comic_finder.git`

`bundle install`

`rake db:create`
