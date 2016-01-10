require_relative 'spec_helper'

RSpec.configure do |config|
  config.before :suite do
    SpecHelper.instance.provision('playbooks/mysql-manage.yml', {
      new_mysql_user:  "root_user",
      new_mysql_pass:  "root_password"
    })
  end
end

describe command("mysql -u root_user -proot_password -e \"SELECT count(*) FROM mysql.user WHERE User = 'root_user'\"") do
  its(:stdout) { should match /^1$/ }

  its(:exit_status) { should eq 0 }
end
