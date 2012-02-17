# encoding: UTF-8

require 'histomatic/version'

# {{Histomatic}}: Quick 'n dirty histograms from {{ActiveRecord}} sources.
#
module Histomatic

  class << self

    # Generate a histogram from a particular {{ActiveRecord}} or
    # {{ActiveRelation}} source.
    #
    # @param  [ActiveRelation]
    # @param  [String] 
    # @param  [Array<Float>]
    # @return [Histogram]
    #
    def generate(source, column, bins) 
      Histogram.new(source, column, bins)
    end

  end

  class Histogram

    attr_reader :source, :column, :bins

    # Create a new {{Histogram}} instance.
    #
    def initialize(source, column, bins)
      @source = source
      @column = column 
      @bins   = bins
    end

    # Return hash representation.
    #
    # @return [Hash]
    #
    def to_hash
      serializable_hash
    end

    # Return json representation.
    #
    # @return [String]
    #
    def to_json
      JSON.generate(to_hash)
    end

    # Return the result as a keys representing the lower inclusive bound
    # of bin, with values pointing to the number of objects represented.
    #
    # @return [Hash]
    #
    def serializable_hash 
      results.each.inject(empty_bins) do |histogram, result|
        histogram[result] = histogram[result] ? histogram[result] + 1 : 1; histogram
      end
    end

    # Return SQL for generating the source data for this histogram.
    #
    # @return  [String]
    # @private 
    #
    def to_sql
      source.select(bin_sql).to_sql
    end
    private :to_sql

    # Return results.
    #
    # @return  [Mysql2::Results]
    # @private
    #
    def results 
      ActiveRecord::Base.connection.execute(to_sql).each.map(&:first)
    end
    private :results

    # Convert bins to SQL conditions which can be used to generate the
    # histogram.
    #
    # @return  [String]
    # @private 
    #
    def bin_sql
      selection = [
        "CASE",
        bins.each_cons(2).map do |bounds|
          case_for(column, bounds.first, bounds.last)
        end,
        case_for(column, bins.last),
        "END"
      ].flatten.join(' ')
    end
    private :bin_sql

    # Returns a case condition and implications for a particular set of
    # bounds.
    #
    # @param   [String]
    # @param   [Float]
    # @param   [Float]
    # @return  [String]
    # @private 
    #
    def case_for(column, lower, upper = nil)
      "WHEN #{column} >= #{lower} #{" AND #{column} < #{upper} " if upper} THEN #{lower}"
    end

    # Generate a hash of empty bins used during output.
    #
    # @return  [Hash]
    # @private
    #
    def empty_bins
      bins.inject({}) { |bins, bin| bins[bin] = 0; bins }
    end
    private :empty_bins

  end

end
