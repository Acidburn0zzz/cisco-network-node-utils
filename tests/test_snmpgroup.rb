# Copyright (c) 2013-2015 Cisco and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require File.expand_path("../ciscotest", __FILE__)
require File.expand_path("../../lib/cisco_node_utils/snmpgroup", __FILE__)

class TestSnmpGroup < CiscoTestCase
  # NXOS snmp groups will not be empty
  def test_snmpgroup_collection_not_empty
    snmpgroups = SnmpGroup.groups
    assert_equal(false, snmpgroups.empty?(),
                 "SnmpGroup collection is empty")
    snmpgroups = nil
  end

  def test_snmpgroup_collection_valid
    snmpgroups = SnmpGroup.groups
    s = @device.cmd("show snmp group | include Role | no-more")
    snmpgroups.each do |name, snmpgroup|
      line = /Role:\s#{snmpgroup.name}/.match(s)
      # puts "line: #{line}"
      assert_equal(false, line.nil?)
    end
    snmpgroups = nil
  end

  def test_snmpgroup_exists_with_name_empty
    assert_raises(ArgumentError) do
      SnmpGroup.exists?("")
    end
  end

  def test_snmpgroup_exists_with_name_invalid
    name = "group-dummy"
    exist = SnmpGroup.exists?(name)
    s = @device.cmd("show snmp group | in Role | no-more")
    line = /Role:\s#{name}/.match(s)
    assert_equal(exist, !line.nil?)
  end

  def test_snmpgroup_exists_with_name_bad_type
    assert_raises(TypeError) do
      SnmpGroup.exists?(:not_a_string)
    end
  end

  def test_snmpgroup_exists_with_name_valid
    name = "network-admin"
    exist = SnmpGroup.exists?(name)
    s = @device.cmd("show snmp group | in Role | no-more")
    line = /Role:\s#{name}/.match(s)
    assert_equal(exist, !line.nil?)
  end

  def test_snmpgroup_get_name
    name = "network-operator"
    snmpgroup = SnmpGroup.new(name)
    assert_equal(snmpgroup.name, name)
  end
end
