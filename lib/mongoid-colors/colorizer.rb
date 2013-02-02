# encoding: utf-8

require 'mongoid'
require 'coderay'
require 'colorize'

module MongoidColors::Colorizer
  def self.setup
    return unless Mongoid.logger

    old_formatter = Mongoid.logger.formatter
    Mongoid.logger.formatter = lambda do |severity, datetime, progname, msg|
      m = parse(msg)
      return if m == :ignore

      if m.nil?
        old_formatter.call(severity, datetime, progname, msg)
        return
      end

      m[:query].gsub!(/BSON::ObjectId\('([^']+)'\)/, '0x\1')
      m[:duration] = m[:duration].split('.')[0] if m[:duration]

      line = "☘ ".green + "MongoDB ".white
      line << "(#{m[:duration]}ms) " if m[:duration]

      if m[:database]
        if m[:collection]
          line << "[#{m[:database]}::#{m[:collection]}] "
        else
          line << "[#{m[:database]}] "
        end
      end

      line << case m[:operation]
      when 'QUERY'  then 'QUERY '.colorize(:green)
      when 'INSERT' then 'INSERT '.red
      when 'UPDATE' then 'UPDATE '.red
      else "#{m[:operation]} "
      end

      line << CodeRay.scan(m[:query], :ruby).term
      line << "\n"
    end
  end

  def self.parse(msg)
    case msg
    when /^MONGODB \((.*)ms\) (.*)\['(.*)'\]\.(.*)$/
      {:duration => $1, :database => $2, :collection => $3, :query => $4}
    when /^MONGODB (.*)\['(.*)'\]\.(.*)$/
      {:database => $1, :collection => $2, :query => $3}
    when /^ *MOPED: (\S+:\S+) (\S+) +database=(\S+)( collection=(\S+))? (.*[^)])( \((.*)ms\))?$/
      {:host => $1, :operation => $2, :database => $3, :collection => $5, :query => $6, :duration => $8}
    when /which could negatively impact client-side performance/
    when /COMMAND.*getlasterror/
      :ignore
    end
  end

  setup
end
