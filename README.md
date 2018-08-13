# Bacon Number

A Ruby gem to calculate the number links between two Wikipedia pages (Defaulting to Kevin Bacon of course).

## Introduction

This is an initial hacked together version of what I think is a very cool and interesting simple gem. This version uses screen scraping to parse all the links and find a path to the target page URL. After thinking a little more about this idea I realized it could probably be done given a URL to parse the title and use the Wikipedia JSON API. Making this much faster and easier.

That said, you have been warned and it will probably kill your CPU unless you pick some obvious use cases.

## Installation

Currently this gem is not published. You will have to clone and install using a local copy:

```shell
git clone https://gitlab.com/chriskaukis/bacon_number.git
cd bacon_number
rake install
```

## Usage
Require it and go. Since it is scraping the actual page it will return the first result found.

```ruby
require 'bacon_number'
BaconNumber.separations('https://en.wikipedia.org/wiki/Tom_Cruise')
=> {:separations=>2, :via=>"https://en.wikipedia.org/wiki/Dustin_Hoffman"}
```

## Notes
Due to time constraints this initial version doesn't have a good (or any) tests setup.

## Todo
* Tests
* Convert to using the Wikipedia JSON API or in addition to
* Graphical representation of the path(s) taken to the target
* Error handling
* Command line interface

## Requirements

* Ruby (developed using 2.5.1)
