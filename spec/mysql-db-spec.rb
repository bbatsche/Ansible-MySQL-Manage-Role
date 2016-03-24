require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook("playbooks/mysql-manage.yml", {
      db_name:        "test_db",
      new_db_user: "test_db_owner",
      new_db_pass: "db_password"
    })
  end
end

describe command("mysql -utest_db_owner -pdb_password test_db -e \"SHOW CREATE DATABASE test_db\"") do
  its(:stdout) { should match /CREATE DATABASE `|"test_db`|"/ }

  its(:exit_status) { should eq 0 }
end

describe command("mysql -utest_db_owner -pdb_password mysql") do
  its(:stderr) { should match /Access denied for user 'test_db_owner'@'localhost' to database 'mysql'/ }

  its(:exit_status) { should_not eq 0 }
end
