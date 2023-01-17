require_relative 'input'
require 'ostruct'

def sys(input = nil)
  # take account
  #  dir X
  # cd /
  # cd ..
  file = File.open("input_test.txt")
  folder = {}
  folder[:root] = {}
  cursor = folder[:root]

  file.readlines.map(&:chomp).each_with_index do |line, idx|
    if line == '$ cd /'
      cursor = folder[:root]
    end

    if line.include?( "$ cd") && line != '$ cd /'
      pp line[5..line.size]
      cursor = cursor[]
    end
  end
end

def sys_2(input = nil)
end

class Folder
  attr_accessor :root, :previous, :name, :files, :folders
  def initialize(root: false, name: )
    @root = root
    @name  = name
    @folders = []
    @files = []
    @previous = root ? :root : nil
  end

  def list
  end

  def previous=(node)
    @previous = node
  end

  def add_files(files)
    @files << files
  end

  def add_folder(folder)
    @folders << folder
    folder.previous= folder
  end

  def next
    return @folders.first if @folders.size == 1

    :end
  end

  def go_in(name)
    @list.each do |node|
      if node.name == name
        return node and break
      end

      :not_exist
    end
  end

  def previous_folder
    if @root
      :you_are_in_the_root_folder
    else
      previous
    end
  end
end


root = Folder.new(root: true, name:'root')
a = Folder.new( name:'a')
d = Folder.new( name:'d')
root.add_folder(a)
root.add_folder(b)
e = Folder.new( name:'e')
a.add_folder(e)


puts f.folders.map(&:name)