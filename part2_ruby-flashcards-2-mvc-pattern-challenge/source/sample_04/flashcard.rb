class Flashcard
  attr_reader :term, :definition

  def initialize(term_definition_pair)
    @term = term_definition_pair[:term]
    @definition = term_definition_pair[:definition]
  end
end
