# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Group.find_or_create_by( title: 'Admins' )

User.find_or_create_by( email: 'admin@domain.org' ) do |user|
	user.password = '123456789'
  user.role = 'admin'
  user.group = Group.find_by( title: 'Admins' )
  user.confirmed_at = DateTime.now
  user.add_role :admin
  puts 'Created a admin group and an admin user: admin@domain.org'
end

Group.find_or_create_by( title: 'Users' )

User.find_or_create_by( email: 'user@domain.org' ) do |user|
	user.password = '123456789'
  user.role = 'user'
  user.group = Group.find_by( title: 'Users' )
  user.confirmed_at = DateTime.now
  user.add_role :user
  puts 'Created a user role and a normal user: user@domain.org'
end