require_relative 'input'

def highest_calories(input = nil)

  i = input.split("\n")
  data = []
  data << []
  i.each do |val|
    if val.to_s.empty?
      data << []
      next
    end
    data.last << val.to_i
  end

  res = {
    first: data.map{|arr| arr.sum}.max,
    second: data.map{|arr| arr.sum}.sort.reverse[0..2].sum
  }
  pp res
end


highest_calories(fetch_input)