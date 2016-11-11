# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

event1 = Event.create(name: 'Test Event 1', start_date: '2016-10-15', finish_date: '2016-10-28', start_location: 'Portland, OR',
                      end_location: 'Seattle, WA', createdby: 1, invitecode: 'M1BFVZ', private: false, team_event: false, description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', avatar: File.new("#{Rails.root}/app/assets/images/event1.jpg"), distance: 292000)
event2 = Event.create(name: 'Test Event 2', start_date: '2016-09-01', finish_date: '2016-09-14', start_location: 'Milwaukee, WI',
                      end_location: 'Madison, WI', createdby: 1, invitecode: 'P5VFBA', private: true, team_event: false, description: 'Quisque molestie velit purus, ut varius justo vestibulum fermentum.', distance: 130000)
event3 = Event.create(name: 'Test Event 3', start_date: '2016-09-28', finish_date: '2016-10-11', start_location: 'Mumbai',
                      end_location: 'Rajkot', createdby: 1, invitecode: 'M153KS', private: false, team_event: true, description: 'Mauris in faucibus dui, euismod ornare massa.', distance: 666000)
event4 = Event.create(name: 'Test Event 4', start_date: '2016-09-28', finish_date: '2016-10-11', start_location: 'Kolkota',
                      end_location: 'Delhi', createdby: 1, invitecode: 'LAS0FL1', private: true, team_event: true, description: 'Duis et consequat erat. Nulla risus nisi, tempor ac accumsan eu, euismod sed nisl. Sed id dui id sem dignissim vulputate.', distance: 1423000)
event5 = Event.create(name: 'Test Event 5', start_date: '2016-10-28', finish_date: '2016-11-19', start_location: 'Paris',
                      end_location: 'Nice', createdby: 2, invitecode: 'MK30PK', private: false, team_event: true, description: 'Nulla a porta mauris. Suspendisse lacus nulla, laoreet sed lacinia eget, dignissim sodales odio. Fusce pellentesque cursus neque eget tincidunt.', distance: 835000)
event6 = Event.create(name: 'Test Event 6', start_date: '2016-09-28', finish_date: '2016-10-11', start_location: 'Berlin',
                      end_location: 'Munich', createdby: 2, invitecode: 'TLA03K', private: true, team_event: false, description: 'Mauris a purus condimentum nulla dictum aliquet. Vestibulum interdum non metus id ultrices. Praesent sodales nibh sapien, eu eleifend metus rutrum et.', distance: 568000)
UserEvent.create(event_id: event1.id, user_id: 1)
UserEvent.create(event_id: event2.id, user_id: 1)
UserEvent.create(event_id: event6.id, user_id: 2)

team1 = Team.create(name: 'Team A', createdby: 1, invitecode: [*('A'..'Z'), *('0'..'9')].sample(6).join, hexcolor: '#' + '%06x' % (rand * 0xffffff), private: false)
team2 = Team.create(name: 'Team B', createdby: 1, invitecode: [*('A'..'Z'), *('0'..'9')].sample(6).join, hexcolor: '#' + '%06x' % (rand * 0xffffff), private: true)
team3 = Team.create(name: 'Team X', createdby: 2, invitecode: [*('A'..'Z'), *('0'..'9')].sample(6).join, hexcolor: '#' + '%06x' % (rand * 0xffffff), private: false)
team4 = Team.create(name: 'Team Y', createdby: 2, invitecode: [*('A'..'Z'), *('0'..'9')].sample(6).join, hexcolor: '#' + '%06x' % (rand * 0xffffff), private: true)
UserTeam.create(team_id: team1.id, user_id: 1)
UserTeam.create(team_id: team2.id, user_id: 1)
UserTeam.create(team_id: team3.id, user_id: 2)
UserTeam.create(team_id: team4.id, user_id: 2)
