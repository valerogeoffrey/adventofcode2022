# frozen_string_literal: true
require_relative 'input'
require 'ostruct'

def part_1(_input = nil)
  file = File.open('input.txt')

  cursor = Folder.new(root: true, name: 'root')

  file.readlines.map(&:chomp).each_with_index do |line, idx|
    cursor = cursor.go_back_to_root if line == '$ cd /'

    if line.include?('$ cd') && line != '$ cd /'
      if line[5 .. line.size] == '..'
        cursor = cursor.previous_folder
      else
        cursor = cursor.go_in(line[5 .. line.size])
      end
    end

    if line.include?('dir')
      folder = Folder.new(name: line[4 .. line.size])
      cursor.add_folder(folder)
    end

    if line[0].numeric?
      ff = FileS.new(line.split(' ').last, line.split(' ').first)
      unless cursor.list_files.include? ff.to_a
        cursor.add_files(ff)
      end
    end
  end

  cursor = cursor.go_back_to_root
  pp cursor.list_all_folders.flatten.select { |size| size <= 100_000 }.sum
end

def part_2(_input = nil)
  file = File.open('input.txt')

  cursor = Folder.new(root: true, name: 'root')

  file.readlines.map(&:chomp).each_with_index do |line, idx|
    cursor = cursor.go_back_to_root if line == '$ cd /'

    if line.include?('$ cd') && line != '$ cd /'
      if line[5 .. line.size] == '..'
        cursor = cursor.previous_folder
      else
        cursor = cursor.go_in(line[5 .. line.size])
      end
    end

    if line.include?('dir')
      folder = Folder.new(name: line[4 .. line.size])
      cursor.add_folder(folder)
    end

    if line[0].numeric?
      ff = FileS.new(line.split(' ').last, line.split(' ').first)
      unless cursor.list_files.include? ff.to_a
        cursor.add_files(ff)
      end
    end
  end

  cursor = cursor.go_back_to_root
  all_folder_size = cursor.list_all_folders.flatten
  root_size = all_folder_size.first

  available_val = []
  total = 70_000_000
  target_size = 30_000_000
  min_value_to_delete = target_size - (total - root_size)

  all_folder_size.each do |size|
    if size >= min_value_to_delete
      available_val << size
    end
  end
  pp available_val.sort.first
end

class String
  def numeric?
    !Float(self).nil?
  rescue StandardError
    false
  end
end

class Folder
  attr_accessor :root, :previous, :name, :files, :folders, :end, :path, :folder_size

  def initialize(root: false, name:)
    @@list_all_folders = []
    @root = root
    @name = name
    @folders = []
    @files = []
    @previous = root ? :root : nil
    @path = root ? 'root' : nil
    @end = true
    @folder_size = 0
  end

  def previous_path
    previous? ? previous_folder.path : path
  end

  def add_files(files)
    @files << files
    @folder_size = folder_size + files.to_a.last

    sync_file(previous_folder, files.to_a.last) if previous_folder?
  end

  def sync_file(folder, file_size)
    folder.folder_size = folder.folder_size + file_size
    return unless folder.previous_folder?

    sync_file(folder.previous_folder, file_size)
  end

  def add_folder(folder)
    @folders << folder
    @end = false
    folder.previous = self
    folder.path = "#{path}/#{folder.name}"
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
    files.map(&:to_a)
  end

  def list_folders
    folders.map(&:name)
  end

  def list_all_folders
    @@list_all_folders << folder_size unless previous_folder?

    return @@list_all_folders if folders.size == 0
    @@list_all_folders << folders.map(&:folder_size)
    folders.each do |folder|
      folder.list_all_folders
    end
    @@list_all_folders
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
    !files.empty?
  end

  def folders?
    !folders.empty?
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

  def to_a
    [name, size]
  end

  def size
    sizef.to_i
  end
end


part_1
part_2
