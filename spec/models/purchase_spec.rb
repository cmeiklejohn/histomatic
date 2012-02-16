# encoding: UTF-8

require 'spec_helper'

describe Purchase do 

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
        to_hash.should == { 0 => 1, 10 => 1, 20 => 8 }
    end

    it 'generates a histogram for the amount by user' do 
      Histomatic.generate(Purchase.where(:name => 'Chris'), 'amount', [0, 10, 20]). 
        to_hash.should == { 0 => 1, 10 => 0, 20 => 4 }
    end

    it 'generates a histogram for the day difference by user' do 
      Histomatic.generate(Purchase.where(:name => 'Chris'), 
                          'datediff(purchases.created_at, date_sub(current_date, interval 20 day))', [0, 10, 20]). 
        to_hash.should == { 0 => 0, 10 => 0, 20 => 5 }
    end
  end

end
