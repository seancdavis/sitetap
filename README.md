SiteTap
==========

SiteTap takes a home page URL and turns into into a packaged directory of:

* html
* plain text
* markdown

Installation
----------

To install this to a ruby project, add the following to your `Gemfile`:

```ruby
gem 'sitetap'
```

And then execute:

```text
$ bundle install
```

Or install it so you can run it globally:

```text
$ gem install sitetap
```

Usage
----------

Using SiteTap is quite simple. You just run the executable and give it a URL.

```text
$ sitetap [URL]
```

So, if I wanted to scrape Sapwood's website, I could do this:

```text
$ sitetap "http://sapwood.org/"
```

Within your current directory, this will create the following directory
structure:

```text
- sapwood.org
    - html
    - markdown
    - txt
    - tmp
```

Within each are the converted files from the website.

Bugs
----------

Please [create an issue](https://github.com/seancdavis/sitetap/issues/new) if
you encounter a bug.

Contributing
----------

Missing a feature? Add it!

Found a bug? Fix it!

1. Fork it ( https://github.com/[my-github-username]/sitetap/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
