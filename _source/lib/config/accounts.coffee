if Meteor.users.find().count() is 0
  Accounts.createUser(
    email: "lauren.craig@newspring.cc"
    password: "newspring"
    profile:
      name: "Lauren Craig"
  )
