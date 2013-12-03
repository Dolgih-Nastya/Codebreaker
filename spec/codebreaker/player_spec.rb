require 'spec_helper'
module Codebreaker
  describe Player do
     context "should have a name" do
       it "should have default name" do
         player=Player.new
         expect(player.name).not_to be_empty
       end

       it "should have name like param" do
         player=Player.new "Nastya"
         expect(player.name).to eq "Nastya"
       end
     end
  end
end