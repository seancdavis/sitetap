require 'fileutils'

module Sitetap
  class Scraper

    def initialize(url)
      @url = url.strip.gsub(/\/$/, '')
    end

    def self.scrape!(url)
      scraper = Sitetap::Scraper.new(url)
      scraper.scrape!
      scraper
    end

    def scrape!
      verify_dir
      wget
      self
    end

    def dir
      root
    end

    private

      def domain
        @domain ||= @url.gsub(/http(s)?\:\/\//, '')
      end

      def root
        @root ||= "#{Dir.pwd}/#{domain}"
      end

      def html_dir
        "#{root}/html"
      end

      def verify_dir
        unless Dir.exists?(html_dir)
          FileUtils.mkdir_p(html_dir)
        end
      end

      def wget_options
        [
          '--recursive',
          '--page-requisites',
          '--html-extension',
          '--convert-links',
          '--restrict-file-names=windows',
          '--span-hosts',
          '-e robots=off'
        ]
      end

      def wget
        system("cd #{html_dir}; wget #{wget_options.join(' ')} --domains #{domain} #{@url}; cd ../../")
        # add `-o #{log_dir}/scrape.log` to store logfile
      end

  end
end
