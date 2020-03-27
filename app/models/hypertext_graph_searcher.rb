class HypertextGraphSearcher

  # @param source [HypertextManager]
  # @param dest [HypertextManager]
  # @return [<HypertextManager>]
  def self.find_shortest_path(source, dest)
    waves = get_waves(source, dest)
    return nil unless waves
    get_backward_path(waves)
  end

  private

  # @param source [HypertextManager]
  # @param dest [HypertextManager]
  # @return [<<HypertextManager>>]
  def self.get_waves(source, dest)
    waves = [[source]]
    passed_texts = { source.identifier => source }

    loop do
      prev_wave = waves.last
      new_wave = prev_wave.flat_map { |text| text.get_linked_hypertexts }

      # Reject passed text
      new_wave.reject! { |text| passed_texts.has_key? text.identifier }

      return nil if new_wave.empty?

      # Mark current wave texts as passed.
      new_wave.each { |text| passed_texts[text.identifier] = text }

      if dest.in? new_wave
        waves << [dest]
        break
      else
        waves << new_wave
      end
    end

    waves
  end

  # @param waves [<<HypertextManager>>]
  # @return [<HypertextManager>]
  def self.get_backward_path(waves)
    path = []
    path << waves.pop.flatten.first

    loop do
      wave = waves.pop
      break unless wave
      path << wave.find { |text| path.last.in? text.get_linked_hypertexts }
    end

    path.reverse
  end

end