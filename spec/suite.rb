#simple way to make sure requires are isolated
result = Dir["**/*_spec.rb"].collect{|spec_file| system("ruby #{spec_file}") }.uniq == [true]
exit(result ? 0 : 1)