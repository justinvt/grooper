# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{grooper}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin Thibault"]
  s.cert_chain = ["/Users/jvthibault/.gem/gem-public_cert.pem"]
  s.date = %q{2011-02-24}
  s.description = %q{A gem that managers javascript assets}
  s.email = %q{jvthibault @nospam@ gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/assets/asset.rb", "lib/assets/asset_db.rb", "lib/assets/asset_set.rb", "lib/exceptions/exceptions.rb", "lib/grooper.rb", "lib/helpers/helpers.rb", "lib/upload/s3.rb"]
  s.files = ["Manifest", "README.rdoc", "Rakefile", "config/assets.yml", "config/grooper.yml", "grooper.gemspec", "lib/assets/asset.rb", "lib/assets/asset_db.rb", "lib/assets/asset_set.rb", "lib/exceptions/exceptions.rb", "lib/grooper.rb", "lib/helpers/helpers.rb", "lib/upload/s3.rb"]
  s.homepage = %q{http://github.com/justinvt/grooper}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Grooper", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{grooper}
  s.rubygems_version = %q{1.5.2}
  s.signing_key = %q{/Users/jvthibault/.gem/gem-private_key.pem}
  s.summary = %q{A gem that managers javascript assets}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
