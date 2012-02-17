# encoding: UTF-8

require 'spec_helper'

class Purchase < ActiveRecord::Base; end

module Histomatic
  describe Histogram do 
    let(:source) { Purchase } 
    let(:column) { 'amount' } 
    let(:bins)   { [0, 10, 20] } 

    subject { Histogram.new(source, column, bins) } 

    it 'initializes with a source, column and bins' do 
      subject.source.should == source
      subject.column.should == column
      subject.bins.should == bins
    end

    context 'with a generated histogram' do 
      let(:hash) { { 0 => 1, 1 => 2, 2 => 3 } }

      before do 
        subject.stub(:serializable_hash).and_return(hash)
      end

      it 'can return a hash' do 
        subject.to_hash.should == hash
      end

      it 'can return json' do 
        JSON.should_receive(:generate).with(hash)
        subject.to_json
      end
    end

    context 'given a few purchases' do 
      let(:purchases) do 
        10.times.map do |i|
          Purchase.new(:amount => i.to_i * 10, :name => "#{i % 2 == 0 ? "Chris" : "Bob"}")
        end
      end

      before do 
        purchases.map { |purchase| purchase.save! }
      end

      it 'generates a histogram for the amount' do 
        Histomatic.generate(Purchase, 'amount', [0, 10, 20]).
          serializable_hash.should == { 0 => 1, 10 => 1, 20 => 8 }
      end

      it 'generates a histogram for the amount by user' do 
        Histomatic.generate(Purchase.where(:name => 'Chris'), 'amount', [0, 10, 20]). 
          serializable_hash.should == { 0 => 1, 10 => 0, 20 => 4 }
      end

      it 'generates a histogram for the day difference by user' do 
        Histomatic.generate(Purchase.where(:name => 'Chris'), 
                            'datediff(purchases.created_at, date_sub(current_date, interval 20 day))', [0, 10, 20]). 
          serializable_hash.should == { 0 => 0, 10 => 0, 20 => 5 }
      end
    end
  end
end
