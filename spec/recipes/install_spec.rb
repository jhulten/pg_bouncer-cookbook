#
# Cookbook Name:: pg_bouncer
# Spec:: install
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Jeffrey Hulten
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'spec_helper'

describe 'pg_bouncer::install' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:runner) { ChefSpec::ServerRunner.new }
    subject { runner.converge(described_recipe) }

    it { is_expected.to install_package('pgbouncer') }
    it { is_expected.to upgrade_package('pgbouncer') }

    it { is_expected.to create_directory('/etc/pgbouncer') }

    it { is_expected.to create_user('pgbouncer') }
    it { is_expected.to create_group('pgbouncer') }
  end

  context 'When auto-upgrade is disabled' do
    let(:runner) do
      ChefSpec::ServerRunner.new do |node|
        node.set['pg_bouncer']['upgrade'] = false
        node.set['pg_bouncer']['user'] = 'pguser'
        node.set['pg_bouncer']['group'] = 'pggroup'
      end
    end
    subject { runner.converge(described_recipe) }

    it { is_expected.to install_package('pgbouncer') }
    it { is_expected.not_to upgrade_package('pgbouncer') }

    it { is_expected.to create_user('pguser') }
    it { is_expected.to create_group('pggroup') }
  end
end
