module LeeroyJenkins
  class Result
    def initialize(result_hashes)
      @result_hashes = result_hashes
    end

    def to_s
      result_hashes.to_yaml
    end

    private

    attr_reader :result_hashes
  end
end
