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

  def add_files(files)
    @files << files
  end

  def add_folder(folder)
    pp folder.name
    pp self.name
    @folders << folder
    @previous = self
  end

  def next
    return @folders.first if @folders.size == 1

    :end
  end

  def go_in(name)
    cursor = nil
      @folders.each do |node|
      if node.name == name
        cursor = node
        break
      end

      :not_exist
    end
    cursor
  end

  def previous_folder
    pp self&.name
    if @root
      :you_are_in_the_root_folder
    else
      @previous
    end
  end
end

class FileS
  attr_accessor :name, :sizef
  def initialize(name, sizef)
    @name = name
    @sizef = sizef
  end
end

root = Folder.new(root: true, name:'root')
i = FileS.new('i', 584)
b = FileS.new('b', 29116)
c = FileS.new('c', 2557)
root.add_files(i)
root.add_files(b)
root.add_files(c)

a = Folder.new( name:'a')
e = Folder.new( name:'e')

root.add_folder(a)
a.add_folder(e)

e = root.go_in('a').go_in('e')
root = e.previous_folder

pp e.name
pp root.inspect
raise
puts root.files.map(&:sizef).sum
puts root.folders.map(&:name)
puts root.files
f = root.go_in('a')
puts f.folders.map(&:name)
e = f.next
pp e.name