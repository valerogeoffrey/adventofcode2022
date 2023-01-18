require_relative 'input'
require 'ostruct'

def sys(input = nil)
  file = File.open("input.txt")

  cd_x = []
  dir_x = []
  cursor = Folder.new(root: true, name: 'root')
  file.readlines.map(&:chomp).each do |line|

    cursor = cursor.go_back_to_root if line == '$ cd /'

    if line.include?("$ cd") && line != '$ cd /'
      if line[5 .. line.size] == '..'
        cursor = cursor.previous_folder
      else
        cd_x << line[5 .. line.size]
        cursor = cursor.go_in(line[5 .. line.size])
      end
    end

    if line.include?("dir")
      dir_x << line[4 .. line.size]
      folder = Folder.new(name: line[4 .. line.size])
      cursor.add_folder(folder)
    end

    if line[0].numeric?
      ff = FileS.new(line.split(' ').last, line.split(' ').first)
      cursor.add_files(ff)
    end
  end

  pp 'dir_x.size'
  pp dir_x.size
  pp cd_x.size
  data = {}
  cursor = cursor.go_back_to_root

  pp "start"
  pp "DATA --> #{data}"
  pp "in cursor -> #{cursor.name} // prev --> #{cursor.previous_folder?} // has_previous? #{cursor.previous_folder?}"
  data['rrr'] = cursor.files_size.sum

  tt = dig_folder(cursor, data)
  tt.delete('root')
  pp tt
  pp tt.values.select{|v| v < 100_000}.sum
end

def dig_folder(cursor, data)
  cursor.folders.each do |cursor|
    data[cursor.path_name] = 0 if data[cursor.path_name].nil?
    data[cursor.previous.path_name] = 0 if data[cursor.previous.path_name].nil?
    data[cursor.path_name] = data[cursor.path_name] + cursor.files_size.sum
    data['rrr'] = data['rrr'] + cursor.files_size.sum

    if cursor.previous_folder? && cursor.previous.path_name != 'root'
      data[cursor.previous.path_name] = data[cursor.previous.path_name] + data[cursor.path_name]
    end

    return data unless cursor.folders?

    dig_folder(cursor, data)
  end
  data
end

def sys_2(input = nil) end

class String
  def numeric?
    Float(self) != nil rescue false
  end
end

class Folder
  attr_accessor :root, :previous, :name, :files, :folders, :end, :path_name

  def initialize(root: false, name:)
    @root = root
    @name = name
    @folders = []
    @files = []
    @previous = root ? :root : nil
    @path_name = root ? 'root' : nil
    @end = true
  end

  def previous_path_name
    previous? ? previous_folder.path_name : path_name
  end

  def add_files(files)
    @files << files
  end

  def add_folder(folder)
    @folders << folder
    @end = false
    folder.previous = self
    folder.path_name = "#{path_name}/#{folder.name}"
  end

  def next
    return @folders.first if @folders.size == 1

    self
  end

  def go_in(name)
    cursor = nil
    @folders.each do |node|
      if node.name == name
        cursor = node
        break
      end

      self
    end
    cursor
  end

  def go_back_to_root
    cursor = self
    if root == false
      cursor = previous_folder
      cursor.go_back_to_root
    else
      cursor
    end
  end

  def list_files
    files.map(&:to_s)
  end

  def list_folders
    folders.map(&:name)
  end

  def info
    pp name
    pp list_files
    pp list_folders
  end

  def previous_folder
    if root == true
      self
    else
      previous
    end
  end

  def previous_folder?
    @root == false
  end

  def files?
    files.size > 0
  end

  def folders?
    folders.size > 0
  end

  def files_size
    files.map(&:size)
  end
end

class FileS
  attr_accessor :name, :sizef

  def initialize(name, sizef)
    @name = name
    @sizef = sizef
  end

  def to_s
    { name: name, size: sizef }
  end

  def size
    sizef.to_i
  end
end

pp 'sys'
sys
pp 'sys_response'
#sys_response

root = Folder.new(root: true, name: 'root')
a = Folder.new(name: 'a')
e = Folder.new(name: 'e')
x = Folder.new(name: 'x')
z = Folder.new(name: 'z')

root.add_folder(a)
a.add_folder(e)
e.add_folder(x)
x.add_folder(z)

cursor = z

pp cursor.name
cursor = cursor.go_back_to_root
pp cursor.name

#pp a.previous_folder
raise('END')

puts root.files.map(&:sizef).sum
puts root.folders.map(&:name)
puts root.files
f = root.go_in('a')
puts f.folders.map(&:name)
e = f.next
pp e.name