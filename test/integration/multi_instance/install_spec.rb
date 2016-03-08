
describe package('pgbouncer') do
  it { is_expected.to be_installed }
end

describe user('pgbouncer') do
  it { should exist }
end

describe group('pgbouncer') do
  it { should exist }
end
