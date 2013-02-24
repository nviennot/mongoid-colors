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
      when /(QUERY|COUNT)/ then "#{m[:operation]} ".colorize(:green)
      when /(INSERT|UPDATE|MODIFY|DELETE)/ then "#{m[:operation]} ".red
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
      res = {:host => $1, :operation => $2, :database => $3, :collection => $5, :query => $6, :duration => $8}
      if res[:operation] == 'COMMAND'
        begin
          command = eval(res[:query])
          if command[:count]
            res[:operation]  = 'COUNT'
            res[:collection] = command.delete(:count)
            res[:query]      = command.inspect
          end
          if command[:findAndModify]
            res[:operation]  = 'FIND AND MODIFY'
            res[:collection] = command.delete(:findAndModify)
            res[:query]      = command.inspect
          end
        rescue Exception
        end
      end
      res
    when /which could negatively impact client-side performance/
    when /COMMAND.*getlasterror/
      :ignore
    end
  end

  setup
end
