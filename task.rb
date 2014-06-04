
require 'fileutils'
require 'tmpdir'
require 'find'

module Backup
  class Task

    THREAD_NUM = 4

    def initialize(name, dest)
      raise if dest.nil?
      @name = name
      @src  = []
      @dest = dest
      @dest_file_name = @name + '_' + Time.now.strftime('%Y%m%d_%H-%M-%S')
    end

    def register(path, only: [%r(.*)], except: [])
      Find.find(path) do |f|
        if File.file? f
          Find.prune if !hit?(only, f)
        end
        Find.prune if hit?(except, f)
        @src << {root: File.dirname(path), src: f} if File.file?(f)
      end
    end

    def run
      printf "#{@name}\tstart\n"
      Dir.mktmpdir(@dest_file_name) do |temp_dir|

        Array.new(THREAD_NUM) do
          Thread.new do
            while s = @src.shift
              printf "#{@name}\tcopy\t#{s[:src]}\t#{@dest}\n"
              copy(s[:root], s[:src], temp_dir)
            end
          end
        end.each(&:join)

        tgz_file = File.join(@dest, @dest_file_name +'.tgz')
        puts `tar cfz #{tgz_file} -C #{temp_dir} .`
      end
      printf "#{@name}\tend\n"
    end

    private

    def copy(root, src, dest)
      tmp = src.sub(Regexp.new(root),'')
      d = File.join(dest, tmp)
      FileUtils.mkdir_p(File.dirname(d))
      FileUtils.cp(src, d)
    rescue => ex
      print ex.message, "\n"
    end

    def hit?(regs, value)
      regs.each do |r|
        return true if r =~ value
      end
      return false
    end

  end
end
