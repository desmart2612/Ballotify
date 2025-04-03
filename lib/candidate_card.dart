import 'package:flutter/material.dart';
import 'candidates.dart';

class CandidateCard extends StatelessWidget {
  
  final Candidate candidate;
  
  CandidateCard(this.candidate);

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.amberAccent,
      // margin: const EdgeInsets.all(10),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                candidate.image,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              candidate.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              candidate.position,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              candidate.party,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

}