# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{nicovideo}
  s.version = "0.1.8.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["emergent"]
  s.date = %q{2009-05-26}
  s.description = %q{utils for nicovideo}
  s.email = %q{emergent22 (at) livedoor.com}
  s.extra_rdoc_files = ["README.txt"]
  s.files = ["README.txt", "ChangeLog", "Rakefile", "config/hoe.rb", "config/requirements.rb", "lib/nicovideo.rb", "lib/nicovideo/version.rb", "lib/nicovideo/mechanize-ext.rb", "lib/nicovideo/base.rb", "lib/nicovideo/page.rb", "lib/nicovideo/videopage.rb", "lib/nicovideo/comments.rb", "lib/nicovideo/mylist.rb", "lib/nicovideo/openlist.rb", "lib/nicovideo/ranking.rb", "lib/nicovideo/search.rb", "lib/nicovideo/tagsearch.rb", "lib/nicovideo/thumbnail.rb", "lib/nicovideo/newarrival.rb", "lib/nicovideo/random.rb", "test/test_helper.rb", "test/runner.rb", "test/test_nicovideo.rb", "test/test_login.rb", "test/test_videopage.rb", "test/test_mylist.rb", "test/test_openlist.rb", "test/test_ranking.rb", "test/test_search.rb", "test/test_tagsearch.rb", "test/test_newarrival.rb", "test/test_random.rb", "sample/nv_download.rb", "sample/nv_download2.rb", "sample/nv_mylist.rb", "sample/nv_openlist.rb", "sample/nv_ranking.rb", "test/community/test_community_main.rb", "test/test_advertise.rb", "test/test_thumbnail.rb"]
  s.homepage = %q{http://nicovideo.rubyforge.org}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{nicovideo}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{utils for nicovideo}
  s.test_files = ["test/community/test_community_main.rb", "test/test_advertise.rb", "test/test_helper.rb", "test/test_login.rb", "test/test_mylist.rb", "test/test_newarrival.rb", "test/test_nicovideo.rb", "test/test_openlist.rb", "test/test_random.rb", "test/test_ranking.rb", "test/test_search.rb", "test/test_tagsearch.rb", "test/test_thumbnail.rb", "test/test_videopage.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mechanize>, [">= 0.9.2"])
      s.add_runtime_dependency(%q<json>, [">= 1.1.4"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<mechanize>, [">= 0.9.2"])
      s.add_dependency(%q<json>, [">= 1.1.4"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<mechanize>, [">= 0.9.2"])
    s.add_dependency(%q<json>, [">= 1.1.4"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
