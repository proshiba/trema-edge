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



module Trema
  module MessageHelper
    def send_flow_mod_add datapath_id, options
      options[ :command ] = OFPFC_ADD 
      send_flow_mod datapath_id, options
    end

    def send_flow_mod_delete datapath_id, options
      options[ :command ]      = OFPFC_DELETE
      options[ :table_id ]     = OFPTT_ALL if options[ :table_id ].nil?
      options[ :cookie ]       = 0         if options[ :cookie ].nil?
      options[ :cookie_mask ]  = 0         if options[ :cookie_mask ].nil?
      options[ :out_port ]     = OFPP_ANY  if options[ :out_port ].nil?
      options[ :out_group ]    = OFPG_ANY  if options[ :out_group ].nil?
      send_flow_mod datapath_id, options
    end

    def send_group_mod_add datapath_id, options
      options[ :command ] = OFPGC_ADD
      send_group_mod datapath_id, options
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
