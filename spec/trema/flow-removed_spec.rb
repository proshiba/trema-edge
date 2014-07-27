#
# Author: Nick Karanatsios <nickkaranatsios@gmail.com>
#
# Copyright (C) 2008-2013 NEC Corporation
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#


require File.join( File.dirname( __FILE__ ), "..", "spec_helper" )
require "trema"


describe Trema::FlowRemoved, ".new( VALID OPTIONS )" do
  context "when an instance is created" do
    subject do
      match = Match.new(
        :in_port => 1,
        :dl_src => "00:00:00:00:00:01",
        :dl_dst => "00:00:00:00:00:02",
        :dl_vlan => 65535,
        :dl_vlan_pcp => 0,
        :dl_type => 0x800,
        :nw_tos => 0,
        :nw_proto => 17,
        :nw_src => "192.168.0.1",
        :nw_dst => "192.168.0.2",
        :tp_src => 1,
        :tp_dst => 1
      )
      
      FlowRemoved.new(
        :datapath_id=>2748,
        :transaction_id=>0,
        :match => match,
        :cookie => 123456789,
        :priority => 65535,
        :reason => 0,
        :duration_sec=>1, 
        :duration_nsec=>779000000,
        :idle_timeout=>1,  
        :packet_count=> 6,
        :byte_count => 256
      )
    end

    describe ( :datapath_id ) do
      subject { super().send(( :datapath_id )) }
      it { is_expected.to eq(2748) }
    end

    describe ( :transaction_id ) do
      subject { super().send(( :transaction_id )) }
      it { is_expected.to eq(0) }
    end

    describe ( :match ) do
      subject { super().send(( :match )) }
      it { is_expected.to be_instance_of( Match ) }
    end

    describe ( :cookie ) do
      subject { super().send(( :cookie )) }
      it { is_expected.to eq(123456789) }
    end

    describe ( :priority ) do
      subject { super().send(( :priority )) }
      it { is_expected.to eq(65535) }
    end

    describe ( :reason ) do
      subject { super().send(( :reason )) }
      it { is_expected.to eq(0) }
    end

    describe ( :duration_sec ) do
      subject { super().send(( :duration_sec )) }
      it { is_expected.to eq(1) }
    end

    describe ( :duration_nsec ) do
      subject { super().send(( :duration_nsec )) }
      it { is_expected.to eq(779000000) }
    end

    describe ( :idle_timeout ) do
      subject { super().send(( :idle_timeout )) }
      it { is_expected.to eq(1) }
    end

    describe ( :packet_count ) do
      subject { super().send(( :packet_count )) }
      it { is_expected.to eq(6) }
    end

    describe ( :byte_count ) do
      subject { super().send(( :byte_count )) }
      it { is_expected.to eq(256) }
    end
  end
  
  
  context "when a flow expires" do
    it "should #flow_removed" do
      class FlowRemovedController < Controller; end
      network {
        vswitch { datapath_id 0xabc }
      }.run( FlowRemovedController ) {
        expect(controller( "FlowRemovedController" )).to receive( :flow_removed )
        controller( "FlowRemovedController" ).send_flow_mod_add(
          0xabc,
          :idle_timeout => 1,
          :send_flow_rem => true
        )
        sleep 2 # FIXME: wait to receive flow_removed
      }
    end
    
    
    it "should #flow_removed with valid attributes as per flow mod add" do
      class FlowRemovedController < Controller; end
      match = Match.new( 
        :in_port=> 1, 
        :dl_src => "00:00:00:00:00:01",
        :dl_dst => "00:00:00:00:00:02",
        :dl_type => 0x800,
        :dl_vlan => 65535,
        :dl_vlan_pcp => 0,
        :nw_tos => 0,
        :nw_proto => 17,
        :nw_src => "192.168.0.1",
        :nw_dst => "192.168.0.2",
        :tp_src => 1,
        :tp_dst => 1
      )
      network {
        vswitch { datapath_id 0xabc }
      }.run( FlowRemovedController ) {
        expect(controller( "FlowRemovedController" )).to receive( :flow_removed ) do | datapath_id, message |
          expect(datapath_id).to eq(0xabc)
          expect(message.match.in_port).to eq(1)
          expect(message.match.dl_src.to_s).to eq("00:00:00:00:00:01")
          expect(message.match.dl_dst.to_s).to eq("00:00:00:00:00:02")
          expect(message.match.dl_type).to eq(0x800)
          expect(message.match.dl_vlan).to eq(65535)
          expect(message.match.dl_vlan_pcp).to eq(0)
          expect(message.match.nw_tos).to eq(0)
          expect(message.match.nw_proto).to eq(17)
          expect(Trema::IP.new( message.match.nw_src ).to_s).to eq("192.168.0.1")
          expect(Trema::IP.new( message.match.nw_dst ).to_s).to eq("192.168.0.2")
          expect(message.match.tp_src).to eq(1)
          expect(message.match.tp_dst).to eq(1)
          expect(message.cookie).to eq(123456789)
          expect(message.idle_timeout).to eq(1)
          expect(message.reason).to eq(0)
          expect(message.duration_sec).to be >= 1
          expect(message.packet_count).to eq(0)
          expect(message.byte_count).to eq(0)
        end
        controller( "FlowRemovedController" ).send_flow_mod_add(
          0xabc,
          :match => match,
          :cookie => 123456789,
          :idle_timeout => 1,
          :send_flow_rem => true
        )
        sleep 2 # FIXME: wait to receive flow_removed
      }
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
