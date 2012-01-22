#!/usr/bin/env ruby

# This one was tricky!
# first create all the items, then check each against each other
# count the number of better, the number of worst
# those with better = 0 are deals
# those with worse = 0 are terrible

# Lots of information here, a class would be good
class Product
  include Comparable

  attr_accessor :p, :w, :better, :worse

  def initialize(price, width)
    @p = price
    @w = width
    @better = 0
    @worse = 0
  end

  def is_deal?
    return @better == 0
  end

  def is_terrible?
    return @worse == 0
  end

  def <=>(prod)
    if (self.p < prod.p) && (self.w <= prod.w)
      -1
    elsif(self.w < prod.w) && (self.p <= prod.p)
      -1
    elsif(self.p > prod.p) && (self.w >= prod.w)
      1
    elsif(self.w > prod.w) && (self.p >= prod.p)
      1
    else
      0
    end
  end

  def to_s
    return "#{@p}p,  #{@w}KG"
  end
end


# implements the random number generator
def PRNG(n, p1, w1, m, k, a, b, c, d)
  
  #initalise array
  output = [Product.new(p1,w1)]

  # fill up to n
  (1...n).each do |i|
    #P_i-1 and W_i-1
    pim1 = output[i-1].p
    wim1 = output[i-1].w

    pi = ((a*pim1 + b)%m)+1
    wi = ((c*wim1 + d)%k)+1
    output << Product.new(pi, wi)
  end

  return output
end

# Compare each product against each other
def compare_products(products)

  no_p = products.length
  (0...no_p).each do |i|
    (i+1...no_p).each do |j|
        p1 = products[i]
        p2 = products[j]
        if p1 < p2
          p1.better += 1
          p2.worse += 1
        elsif p1 > p2
          p1.worse += 1
          p2.better += 1
        end
    end
  end
  return products
end

# Count the deals and horrible bargains
def count_deals_and_terrible(products)
  deals = 0
  terrible = 0
  products.each do |p|
    deals += 1 if p.is_deal?
    terrible += 1 if p.is_terrible?
  end
  return [deals, terrible]
end

# Pretty output that is required
def pretty_output(t, a, b)
  return "Case ##{t}: #{a} #{b}"
end

# Get the lines from the file (ONLY THE NUMBER SPECIFIED)
def input_file(file)
  inputs = []
  t = -1
  i = 0
  f = File.new(file)
  f.each_line do |line|
    if t == -1
      t = line.to_i
    else
      if i < t
        inputs << line
        i += 1
        end
    end
  end
  return inputs
end

def process_input(t, input)
  params = input.split(" ")

  n = params[0].to_i
  p = params[1].to_i
  w = params[2].to_i
  m = params[3].to_i 
  k = params[4].to_i 
  a = params[5].to_i 
  b = params[6].to_i 
  c = params[7].to_i 
  d = params[8].to_i 

  out = count_deals_and_terrible(compare_products(PRNG(n,p,w,m,k,a,b,c,d)))
  puts pretty_output(t, out[0], out[1])
end

if ARGV[0].nil?
  puts "Give an input file"
  exit
end

t = 1
input_file(ARGV[0]).each { |i| process_input(t, i); t += 1 }

