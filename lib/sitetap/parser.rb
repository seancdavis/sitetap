require 'nokogiri'
require 'reverse_markdown'
require 'fileutils'

module Sitetap
  class Parser

    def initialize(root_dir)
      @root = root_dir
    end

    def self.parse!(root_dir)
      parser = Sitetap::Parser.new(root_dir).parse!
      parser
    end

    def parse!
      verify_directories
      do_the_loop
      self
    end

    private

    # ------------------------------------ References

    def root
      @root
    end

    def html_dir
      @html_dir ||= "#{root}/html"
    end

    def tmp_dir
      @tmp_dir ||= "#{root}/tmp"
    end

    def md_dir
      @md_dir ||= "#{root}/markdown"
    end

    def txt_dir
      @txt_dir ||= "#{root}/text"
    end

    def selector
      @selector ||= "body"
    end

    def files
      @files ||= Dir.glob("#{html_dir}/**/*.html")
    end

    # ------------------------------------ Directories

    def mkdir_p(dir)
      unless Dir.exists?(dir)
        FileUtils.mkdir_p(dir)
      end
    end

    def verify_directories
      [tmp_dir, md_dir, txt_dir].each { |dir| mkdir_p(dir) }
    end

    def verify_file_directories(files)
      files.each do |file|
        dir = file.split('/')[0..-2].join('/')
        mkdir_p(dir)
      end
    end

    # ------------------------------------ The Loop

    def do_the_loop
      files.each do |file|

        # get the path of the file relative to the html
        # directory (scraped dir)
        # 
        file_path = file.gsub(/#{html_dir}\//, '')

        # clean the contents of the html file so we can work
        # with it
        # 
        contents = clean_html(file)

        # set the references to where the new files will
        # live
        # 
        tmp_file_path       = "#{tmp_dir}/#{file_path}"
        markdown_file_path  = "#{md_dir}/#{file_path}.md"
        text_file_path      = "#{txt_dir}/#{file_path}.txt"

        # find or create directories that will contain the
        # file
        # 
        verify_file_directories([
          tmp_file_path,
          markdown_file_path,
          text_file_path
        ])

        # write a temporary html file with the cleaned-up
        # contents
        # 
        write_file(tmp_file_path, contents)

        # now we hone in on the html contents and strip the
        # stuff we don't need
        # 
        adj_contents = filter_html(tmp_file_path)

        # convert the adjusted html to markdown and write it
        # to file
        # 
        write_file(markdown_file_path, html2markdown(adj_contents))

        # last, we remove all the tags and write the plain
        # text file
        # 
        write_file(text_file_path, strip_tags(adj_contents))

      end
    end

    # ------------------------------------ Parsing Actions

    def clean_html(file)
      File.read(file)
        .encode('UTF-8', :invalid => :replace, :undef => :replace)
        .split(' ')
        .to_s
        .gsub(/\\u0000/, '')
        .split('", "')
        .join(' ')
        .gsub(/\\/, '')
        .gsub(/\"\]/, '')
        .gsub(/\[\"/, '')
        .gsub(/[”“]/, '"')
        .gsub(/[’]/, "'")
        .gsub(/[é]/, 'e')
        .gsub(/[–]/, '-')
    end

    def filter_html(file_path)
      contents = File.read(file_path, :encoding => 'ASCII')
      page = Nokogiri::HTML(contents)
      content = page.css(selector).to_s
      # content = page.css('body').to_s if content == ''
    end

    def strip_tags(html)
      html = html.gsub(/(<[^>]*>)|\n|\t/s, ' ')
      html.gsub(/(\ \ )+/, "\n\n")
    end

    def html2markdown(html)
      ReverseMarkdown.convert(
        html, 
        :unknown_tags => :bypass, 
        :github_flavored => true
      )
    end

    # ------------------------------------ Writing Files

    def write_file(file_path, content)
      File.open(file_path, 'w') { |file| file.write(content) }
    end

  end
end
