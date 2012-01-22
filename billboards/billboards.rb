#!/usr/env ruby

# Hacker cup 2012 - Billboards
#
# Essentially a tiling problem.
# Given a billboard of area A, and a string S
# Define: W as the words in S, L as the set of word lengths
# Then solve for font size f with
#
# f^2(SUM(L)) = A
#
#
#                A
# f^2 =    ------------
#         (SUM(L) + W-1)
#
#
# This gives the optimum font size for a bilboard that is not constrained.
# However, as this is constrained, and the words must be in order - it gives enough information to find the optimum size
# easily.
# Starting at the optimum font size, walk through the string in order to make sure each work fits on a row, and go
# through until either you run out fo words or use up all the space.
# If the latter is true, reduce f by one point and retry until the correct size is found.

LINE_REGEX = /([0-9]+) ([0-9]+) (.+)/


def optimumfontsize(w, h, s)

  if s.length == 0 || w == 0 || h == 0
    return 0
  end
  a = w*h.to_f
  words = s.split(" ")
  no_words = words.length
  len = []
  words.each { |word| len << word.length }
  lensum = 0
  len.each { |l| lensum += l }

  pre_root = a / (lensum + no_words - 1)
  f = Math.sqrt(pre_root).floor

  return f
end

def fitwords(w,h,s,f)

  if f == 0
    return 0
  end

  fit = false
  words = s.split(" ")

  while (!fit)
    if f == 0
      break
    end
    max_rows = h/f
    #puts "[font] #{f}"
    word_index = 0

    # for each row, fit as many words as possible
    (0...max_rows).each do |r|

      allowance = w
      overflow = false
      debug_string = ""

      while (allowance > 0 && !overflow)

        word = words[word_index]

        # Words at the start of a line don't need a space behind them
        if allowance != w
          word = " #{word}"
        end

        word_length = (word.length) * f

        # check if it fits
        if (allowance - word_length > 0)
          allowance -= word_length
          word_index += 1
          debug_string << word
          if (word_index == words.length)
             # fitted all the words!
             fit = true
             #puts "Row #{r}/#{max_rows}, Allow: #{allowance}, Over #{overflow}, fit #{fit}, Prog #{word_index}/#{words.length}, sofar: #{debug_string}"
             break
           end
        else
          # didn't fit - next line
          overflow = true
        end

        #debug
        #puts "Row #{r}/#{max_rows}, Allow: #{allowance}, Over #{overflow}, fit #{fit}, Prog #{word_index}/#{words.length}, sofar: #{debug_string}"
      end

      if (fit)
        break
      end

    end

    #puts "[font] tried font size #{f} and returned #{fit}"

    if (fit)
      break
    else
      f -= 1
    end
  end
  return f
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
  m = input.match(LINE_REGEX)
  if m.nil?
    puts "PANIC - SOMETHING IS WRONG"
  end
  w = m[1].to_i
  h = m[2].to_i
  s = m[3]

  puts pretty_output(t, fitwords(w,h,s, optimumfontsize(w, h, s)))
end

w = 1000
h = 1000
s = "hiofh os ifhdos fdih"

if ARGV[0].nil?
  puts "Give an input file"
  exit
end

t = 1
input_file(ARGV[0]).each { |i| process_input(t, i); t += 1 }

