describe pip('jupyter','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '1.0.0' }
end

describe pip('numpy','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '1.18.0' }
end


describe pip('statistics','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '1.0.3.5' }
end

describe pip('pandas','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '1.1.0' }
end

describe pip('scipy','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '1.4.1' }
end


describe pip('more-itertools','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '8.4.0' }
end



describe pip('lxml','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '4.5.2' }
end


describe pip('nltk','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '3.5' }
end

describe pip('sas7bdat','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '2.2.3' }
end

describe pip('scikit-learn','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '0.23.1' }
end


describe pip('sortedcollections','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '1.2.1' }
end

describe pip('plotly','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '4.9.0' }
end

describe pip('tensorflow','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '2.3.0' }
end


describe pip('rdflib','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '5.0.0' }
end


describe pip('rdflib-jsonld','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '0.5.0' }
end

describe pip('flask','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '1.1.2' }
end

describe pip('flask-script','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '2.0.6' }
end

describe pip('statsmodels','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '0.11.1' }
end





describe pip('sympy','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '1.6.1' }
end

describe pip('seaborn','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '0.10.1' }
end
describe pip('bokeh','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '2.1.1' }
end


describe pip('plotnine','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '0.7.0' }
end


describe pip('numba','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '0.50.1' }
end

describe pip('pyodbc','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '4.0.30' }
end


describe pip('argparse','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '1.4.0' }
end

describe pip('psycopg2','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '2.8.5' }
end

describe pip('Scikit-image','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '0.17.2' }
end

describe pip('Sqlalchemy','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '1.3.18' }
end


describe pip('Sorted','/usr/local/bin/pip3.7') do
  it { should be_installed }
  its('version') { should be >= '0.1.0' }
end


