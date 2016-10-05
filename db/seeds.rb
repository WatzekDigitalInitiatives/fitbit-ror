# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

event1 = Event.create(name: 'Test Event 1', start_date: '2016-10-15', finish_date: '2016-10-28', start_location: 'Portland, OR',
                      end_location: 'Seattle, WA', createdby: 1, invitecode: 'M1BFVZ', private: false, team_event: false, avatar: File.new("#{Rails.root}/app/assets/images/event1.jpg"))
event2 = Event.create(name: 'Test Event 2', start_date: '2016-09-01', finish_date: '2016-09-14', start_location: 'Milwaukee, WI',
                      end_location: 'Madison, WI', createdby: 1, invitecode: 'P5VFBA', private: true, team_event: false)
event3 = Event.create(name: 'Test Event 3', start_date: '2016-09-28', finish_date: '2016-10-11', start_location: 'Mumbai',
                      end_location: 'Rajkot', createdby: 1, invitecode: 'M153KS', private: false, team_event: true)
event4 = Event.create(name: 'Test Event 4', start_date: '2016-09-28', finish_date: '2016-10-11', start_location: 'Kolkota',
                      end_location: 'Delhi', createdby: 1, invitecode: 'LAS0FL1', private: true, team_event: true)
event5 = Event.create(name: 'Test Event 5', start_date: '2016-10-28', finish_date: '2016-11-19', start_location: 'Paris',
                      end_location: 'Nice', createdby: 2, invitecode: 'MK30PK', private: false, team_event: true)
event6 = Event.create(name: 'Test Event 6', start_date: '2016-09-28', finish_date: '2016-10-11', start_location: 'Berlin',
                      end_location: 'Munich', createdby: 2, invitecode: 'TLA03K', private: true, team_event: false)
