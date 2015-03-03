require 'fileutils'

module Sitetap
  class Scraper

    def initialize(url)
      @url = url.strip.gsub(/\/$/, '')
    end

    def self.scrape!(url)
      Sitetap::Scraper.new(url).scrape!
    end

    def scrape!
      wget
    end

    private

      def wget_options
        [
          '--recursive',
          '--page-requisites',
          '--html-extension',
          '--convert-links',
          '--restrict-file-names=windows',
          '--span-hosts'
        ]
      end

      def domain
        @domain ||= @url.gsub(/http(s)?\:\/\//, '')
      end

      def wget
        system("wget #{wget_options.join(' ')} --domains #{domain} #{@url}")
        # add `-o #{log_dir}/scrape.log` to store logfile
      end

  end
end
