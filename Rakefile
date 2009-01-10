require 'config/requirements'
require 'config/hoe' # setup Hoe + all gem configuration

require 'rake/contrib/rubyforgepublisher'

Dir['tasks/**/*.rake'].each { |rake| load rake }

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'html'
  rdoc.options += RDOC_OPTS
  rdoc.template = "#{ENV['template']}.rb" if ENV['template']
  if ENV['DOC_FILES']
    rdoc.rdoc_files.include(ENV['DOC_FILES'].split(/,\s*/))
  else
    rdoc.rdoc_files.include('README.txt', 'ChangeLog')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
end

desc "Publish to RubyForge"
task :rubyforge => [:rdoc, :package] do
  Rake::RubyForgePublisher.new(RUBYFORGE_PROJECT, 'emergent').upload
end

