module LeeroyJenkins
  class Result
    def initialize(result_hashes)
      @result_hashes = result_hashes
    end

    def to_s
      JSON.pretty_generate(result_hashes)
    end

    def ==(other)
      other.class == self.class && result_hashes == other.result_hashes
    end

    protected

    attr_reader :result_hashes
  end
end
