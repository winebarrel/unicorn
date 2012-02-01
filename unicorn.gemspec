# -*- encoding: binary -*-
ENV["VERSION"] = "4.2.0"
ENV["VERSION"] or abort "VERSION= must be specified"
manifest = File.readlines('.manifest').map! { |x| x.chomp! }

# don't bother with tests that fork, not worth our time to get working
# with `gem check -t` ... (of course we care for them when testing with
# GNU make when they can run in parallel)
test_files = manifest.grep(%r{\Atest/unit/test_.*\.rb\z}).map do |f|
  File.readlines(f).grep(/\bfork\b/).empty? ? f : nil
end.compact

Gem::Specification.new do |s|
  s.name = %q{unicorn}
  s.version = ENV["VERSION"].dup
  s.authors = ["#{name} hackers"]
  s.summary = <<-SUMMARY
\Unicorn is an HTTP server for Rack applications designed to only serve
fast clients on low-latency, high-bandwidth connections and take
advantage of features in Unix/Unix-like kernels.  Slow clients should
only be served by placing a reverse proxy capable of fully buffering
both the the request and response in between \Unicorn and slow clients.
  SUMMARY
  s.date = Time.now.utc.strftime('%Y-%m-%d')
  s.description = "Rack HTTP server for fast clients and Unix"
  s.email = %q{mongrel-unicorn@rubyforge.org}
  s.executables = %w(unicorn unicorn_rails)
  s.extensions = %w(ext/unicorn_http/extconf.rb)
  s.files = manifest
  s.homepage = "http://unicorn.bogomips.org/"
  s.rubyforge_project = %q{mongrel}
  s.test_files = test_files

  # for people that are absolutely stuck on Rails 2.3.2 and can't
  # up/downgrade to any other version, the Rack dependency may be
  # commented out.  Nevertheless, upgrading to Rails 2.3.4 or later is
  # *strongly* recommended for security reasons.
  s.add_dependency(%q<rack>)
  s.add_dependency(%q<kgio>, '~> 2.6')
  s.add_dependency(%q<raindrops>, '~> 0.7')

  # s.licenses = %w(GPLv2 Ruby) # licenses= method is not in older RubyGems
end
