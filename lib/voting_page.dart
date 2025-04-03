import 'package:ballotify/candidates.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'candidate_card.dart';
import 'review.dart';
import 'users.dart';

class VotingPage extends StatefulWidget {

  final User usr;

  const VotingPage({super.key, required this.usr});

  @override
  _VotingPageState createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage>
  with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Candidate> votes = [];

  List<Candidate> presidentCandidates = [
    Candidate("John Doe", "President", "Republican Party",
        "assets/candidate_img/candidate1.png"),
    Candidate("Stephen Donald", "President", "Democrat Party",
        "assets/candidate_img/candidate1.png"),
    Candidate("Stephen Donald", "President", "Democrat Party",
        "assets/candidate_img/candidate1.png"),
    Candidate("John Doe", "President", "Republican Party",
        "assets/candidate_img/candidate1.png"),
    Candidate("John Doe", "President", "Republican Party",
        "assets/candidate_img/candidate1.png"),
    Candidate("Stephen Donald", "President", "Democrat Party",
        "assets/candidate_img/candidate1.png"),
  ];

  List<Candidate> governorCandidates = [
    Candidate("Johnson Obriene", "Governor", "Republican Party",
        "assets/candidate_img/candidate2.png"),
    Candidate("Jane Doe", "Governor", "Democrat Party",
        "assets/candidate_img/candidate2.png"),
    Candidate("Jane Doe", "Governor", "Democrat Party",
        "assets/candidate_img/candidate2.png"),
    Candidate("Johnson Obriene", "Governor", "Republican Party",
        "assets/candidate_img/candidate2.png"),
    Candidate("Johnson Obriene", "Governor", "Republican Party",
        "assets/candidate_img/candidate2.png"),
    Candidate("Jane Doe", "Governor", "Democrat Party",
        "assets/candidate_img/candidate2.png"),
  ];

  List<Candidate> senatorCandidates = [
    Candidate("David Keneth", "Senator", "Republican Party",
        "assets/candidate_img/candidate3.png"),
    Candidate("Alice Kamau", "Senator", "Democrat Party",
        "assets/candidate_img/candidate3.png"),
    Candidate("Alice Kamau", "Senator", "Democrat Party",
        "assets/candidate_img/candidate3.png"),
    Candidate("David Keneth", "Senator", "Republican Party",
        "assets/candidate_img/candidate3.png"),
    Candidate("David Keneth", "Senator", "Republican Party",
        "assets/candidate_img/candidate3.png"),
    Candidate("Alice Kamau", "Senator", "Democrat Party",
        "assets/candidate_img/candidate3.png"),
  ];

  List<Candidate> womanRepCandidates = [
    Candidate("Charlene Obama", "Woman Rep", "Republican Party",
        "assets/candidate_img/candidate4.png"),
    Candidate("Sylvia Mcman", "Woman Rep", "Democrat Party",
        "assets/candidate_img/candidate4.png"),
    Candidate("Sylvia Mcman", "Woman Rep", "Democrat Party",
        "assets/candidate_img/candidate4.png"),
    Candidate("Charlene Obama", "Woman Rep", "Republican Party",
        "assets/candidate_img/candidate4.png"),
    Candidate("Charlene Obama", "Woman Rep", "Republican Party",
        "assets/candidate_img/candidate4.png"),
    Candidate("Sylvia Mcman", "Woman Rep", "Democrat Party",
        "assets/candidate_img/candidate4.png"),
  ];

  List<Candidate> mpCandidates = [
    Candidate("Dennis Livingstone", "Mp", "Republican Party",
        "assets/candidate_img/candidate5.jpg"),
    Candidate("Alexis Sanchez", "Mp", "Democrat Party",
        "assets/candidate_img/candidate5.jpg"),
    Candidate("Alexis Sanchez", "Mp", "Democrat Party",
        "assets/candidate_img/candidate5.jpg"),
    Candidate("Dennis Livingstone", "Mp", "Republican Party",
        "assets/candidate_img/candidate5.jpg"),
    Candidate("Dennis Livingstone", "Mp", "Republican Party",
        "assets/candidate_img/candidate5.jpg"),
    Candidate("Alexis Sanchez", "Mp", "Democrat Party",
        "assets/candidate_img/candidate5.jpg"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _logout() {
    print("Logged out");
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  List<Candidate> getVotes() {
    return votes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          "Ballotify",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/profile_icon.png'), // Profile picture
            onPressed: () {
              if (_scaffoldKey.currentState!.isEndDrawerOpen) {
                Navigator.of(context).pop();
              } else {
                _scaffoldKey.currentState!.openEndDrawer();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.green,
              labelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16,
              ),
              dividerColor: Colors.green,
              dividerHeight: 2,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(
                  text: "President",
                ),
                Tab(
                  text: "Governor",
                ),
                Tab(
                  text: "Senator",
                ),
                Tab(
                  text: "MP",
                ),
                Tab(
                  text: "Women Rep",
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                GridView.builder(
                  padding: const EdgeInsets.all(10),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.0,
                    mainAxisExtent: 400.0,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: presidentCandidates.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Toggle the selected state
                          for (var i = 0; i < presidentCandidates.length; i++) {
                            if (i != index) {
                              presidentCandidates[i].isSelected = false;
                            }
                          }
                          for (var i = 0; i < votes.length; i++) {
                            if (votes[i].position == "President") {
                              votes.removeAt(i);
                            }
                          }
                          presidentCandidates[index].isSelected =
                              !presidentCandidates[index].isSelected;
                          if (presidentCandidates[index].isSelected) {
                            votes.add(presidentCandidates[index]);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: presidentCandidates[index].isSelected
                                ? Colors.orange
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CandidateCard(presidentCandidates[index]),
                      ),
                    );
                  },
                ),
                GridView.builder(
                  padding: const EdgeInsets.all(10),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.0,
                    mainAxisExtent: 400.0,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: governorCandidates.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Toggle the selected state
                          for (var i = 0; i < governorCandidates.length; i++) {
                            if (i != index) {
                              governorCandidates[i].isSelected = false;
                            }
                          }
                          for (var i = 0; i < votes.length; i++) {
                            if (votes[i].position == "Governor") {
                              votes.removeAt(i);
                            }
                          }
                          governorCandidates[index].isSelected =
                              !governorCandidates[index].isSelected;
                          if (governorCandidates[index].isSelected) {
                            votes.add(governorCandidates[index]);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: governorCandidates[index].isSelected
                                ? Colors.orange
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CandidateCard(governorCandidates[index]),
                      ),
                    );
                  },
                ),
                GridView.builder(
                  padding: const EdgeInsets.all(10),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.0,
                    mainAxisExtent: 400.0,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: senatorCandidates.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Toggle the selected state
                          for (var i = 0; i < senatorCandidates.length; i++) {
                            if (i != index) {
                              senatorCandidates[i].isSelected = false;
                            }
                          }
                          for (var i = 0; i < votes.length; i++) {
                            if (votes[i].position == "Senator") {
                              votes.removeAt(i);
                            }
                          }
                          senatorCandidates[index].isSelected =
                              !senatorCandidates[index].isSelected;
                          if (senatorCandidates[index].isSelected) {
                            votes.add(senatorCandidates[index]);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: senatorCandidates[index].isSelected
                                ? Colors.orange
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CandidateCard(senatorCandidates[index]),
                      ),
                    );
                  },
                ),
                GridView.builder(
                  padding: const EdgeInsets.all(10),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.0,
                    mainAxisExtent: 400.0,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: mpCandidates.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Toggle the selected state
                          for (var i = 0; i < mpCandidates.length; i++) {
                            if (i != index) {
                              mpCandidates[i].isSelected = false;
                            }
                          }
                          for (var i = 0; i < votes.length; i++) {
                            if (votes[i].position == "Mp") {
                              votes.removeAt(i);
                            }
                          }
                          mpCandidates[index].isSelected =
                              !mpCandidates[index].isSelected;
                          if (mpCandidates[index].isSelected) {
                            votes.add(mpCandidates[index]);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: mpCandidates[index].isSelected
                                ? Colors.orange
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CandidateCard(mpCandidates[index]),
                      ),
                    );
                  },
                ),
                GridView.builder(
                  padding: const EdgeInsets.all(10),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.0,
                    mainAxisExtent: 400.0,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: womanRepCandidates.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Toggle the selected state
                          for (var i = 0; i < womanRepCandidates.length; i++) {
                            if (i != index) {
                              womanRepCandidates[i].isSelected = false;
                            }
                          }
                          for (var i = 0; i < votes.length; i++) {
                            if (votes[i].position == "Woman Rep") {
                              votes.removeAt(i);
                            }
                          }
                          womanRepCandidates[index].isSelected =
                              !womanRepCandidates[index].isSelected;
                          if (womanRepCandidates[index].isSelected) {
                            votes.add(womanRepCandidates[index]);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: womanRepCandidates[index].isSelected
                                ? Colors.orange
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CandidateCard(womanRepCandidates[index]),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(widget.usr.name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                accountEmail: Text(widget.usr.email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile_icon.png'),
                  backgroundColor: Colors.green,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 15, 0, 99),
                ),
              ),
              ListTile(
                title: Text("Profile"),
                onTap: () {
                  // Navigate to Profile Page
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Settings"),
                onTap: () {
                  // Navigate to Settings Page
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Logout"),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(widget.usr.hasVoted){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You have already voted'),
                backgroundColor: Colors.red[900],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.all(10),
                duration: Duration(seconds: 5),
              ),
            );
          }
          else{
            // Navigate to Review Page with votes
            var presidentVote = 0;
            var governorVote = 0;
            var senatorVote = 0;
            var mpVote = 0;
            var womenrepVote = 0;

            for(var vote in votes)
            {
              if(vote.position == "President")
              {
                presidentVote++;
              }
              else if(vote.position == "Governor")
              {
                governorVote++;
              }
              else if(vote.position == "Senator")
              {
                senatorVote++;
              }
              else if(vote.position == "Mp")
              {
                mpVote++;
              }
              else if(vote.position == "Woman Rep")
              {
                womenrepVote++;
              }
            }
            if(presidentVote > 0 && governorVote > 0 && senatorVote > 0 && mpVote > 0 && womenrepVote > 0){
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Review(votes: votes, usr: widget.usr),
              ),
              );
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please vote for all positions'),
                  backgroundColor: Colors.amber[900],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(5),
                  duration: Duration(seconds: 2),
                )
              );
            }                        
          }          
        },
        child: Center(
          child: Icon(
            Icons.send_rounded,
            size: 40.0,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }
}
