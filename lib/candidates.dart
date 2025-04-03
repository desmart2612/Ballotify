class Candidate {
  var name;
  var position;
  var party;
  var image;
  var votes = 0;
  var isSelected = false;

  Candidate(this.name, this.position, this.party, this.image);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'position': position,
      'party': party,
    };
  }

}