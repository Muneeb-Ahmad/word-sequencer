class Sequencer
  attr_accessor :dictionary_path
 
  def initialize(dictionary_path)
    @dictionary_path = dictionary_path
  end
  
  def process
    sequences = []
    words = []
    
    File.foreach(@dictionary_path).with_index do |word, line_num|
      next if word.length < 4
      characters = word.chars
      char_length = word.chars.length - 3
      i = 0

      char_length.times do |i|
        current_sequence = characters[i]
        next if !current_sequence.match?(/[A-Za-z]/)
        for j in i+1..i+3
          break if !characters[j].match?(/[A-Za-z]/)
          current_sequence = current_sequence + characters[j]
        end

        if current_sequence.length < 4 || sequences.include?(current_sequence)
          if current_sequence.length == 4
            duplicate_seauence_index = sequences.index(current_sequence)
            sequences.delete_at(duplicate_seauence_index)
            words.delete_at(duplicate_seauence_index)
          end
          next
        else
          sequences << current_sequence
          words <<  word
        end
      end
    end

    generate_output_files(sequences,words)

  end

  private

  def generate_output_files(sequences,words)
    sequences_file_path = "sequences.txt"
    words_file_path = "words.txt"

    File.delete(sequences_file_path) if File.exists?(sequences_file_path)
    File.delete(words_file_path) if File.exists?(words_file_path)

    sequences_file = File.open(sequences_file_path, 'w')
    words_file = File.open(words_file_path, 'w')

    sequences.each {|output_sequence| sequences_file.puts(output_sequence) }
    words.each {|output_word| words_file.puts(output_word)}

    sequences_file.close
    words_file.close
  end
end
    