Predicated is a simple predicate model for Ruby.

Tracker project:
[http://www.pivotaltracker.com/projects/95014](http://www.pivotaltracker.com/projects/95014)


Right now this project makes use of Wrong for assertions.  Wrong uses this project.  It's kind of neat in an eat-your-own-dogfood sense, but it's possible that this will be problematic over time (particularly when changes in this project cause assertions to behave differently - if even temporarily).

A middle ground is to make "from ruby string" and "from callable object" use minitest asserts, since these are the "interesting" parts of Predicated relied on by Wrong.