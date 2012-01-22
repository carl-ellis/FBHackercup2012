#!/usr/env ruby

# Get the letter count of the given string, and then see how many times you can subtract the counts for HACKERCUP

BASELINE = ?A.ord
H = ?H.ord - BASELINE
A = ?A.ord - BASELINE
C = ?C.ord - BASELINE
K = ?K.ord - BASELINE
E = ?E.ord - BASELINE
R = ?R.ord - BASELINE
U = ?U.ord - BASELINE
P = ?P.ord - BASELINE

def lettercount(string)
  # Strip all the spaces and ensure upper case
  string = string.upcase
  string = string.gsub(/\s+/, "")
  alphacount = []
  (0...26).each { |l| alphacount[l] = 0 }
  string.each_byte do |b|
    alphacount[b - BASELINE] += 1
  end
  return alphacount
end

def numberhacker(alphacount)
  # Get the letter counts which are needed
  hs = alphacount[H] 
  as = alphacount[A] 
  cs = alphacount[C] 
  ks = alphacount[K] 
  es = alphacount[E] 
  rs = alphacount[R] 
  us = alphacount[U] 
  ps = alphacount[P] 

  # Count the number of hackers - C is needed twise, so different thresholds
  hackers = 0
  while(hs > 0 && as > 0 && cs > 1 && ks >0 && es > 0 && rs > 0 && us > 0 && ps >0)
    hs -= 1
    as -= 1
    cs -= 2
    ks -= 1
    es -= 1
    rs -= 1
    us -= 1
    ps -= 1

    hackers += 1
  end
  return hackers
end
# Pretty output that is required
def pretty_output(t, f)
  return "Case ##{t}: #{f}"
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
  s = input

  puts pretty_output(t, numberhacker(lettercount(s)))
end

if ARGV[0].nil?
  puts "Give an input file"
  exit
end

t = 1
input_file(ARGV[0]).each { |i| process_input(t, i); t += 1 }


