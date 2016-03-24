require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook("playbooks/mysql-manage.yml", {
      new_db_user: "root_user",
      new_db_pass: "root_password"
    })
  end
end

describe command("mysql -u root_user -proot_password -e \"SELECT count(*) FROM mysql.user WHERE User = 'root_user'\"") do
  its(:stdout) { should match /^1$/ }

  its(:exit_status) { should eq 0 }
end
