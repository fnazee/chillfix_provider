import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chillfix_provider/services/mock_service.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  Widget build(BuildContext context) {
    final requests = MockService.getRelevantRequests();

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {}); // Refresh the list
      },
      child: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return _buildRequestCard(request);
        },
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(request['customerName'],
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Service: ${request['serviceType']}'),
            Text('Problem: ${request['problem']}'),
            Text('Date: ${DateFormat('MMM dd, yyyy - hh:mm a').format(request['date'])}'),
            SizedBox(height: 16),
            if (request['status'] == 'pending')
              _buildActionButtons(request['id']),
            if (request['status'] == 'accepted')
              Text('Status: Accepted',
                  style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(String requestId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text('Decline', style: TextStyle(color: Colors.red)),
          onPressed: () {
            MockService.declineRequest(requestId);
            setState(() {}); // Update UI
          },
        ),
        SizedBox(width: 8),
        ElevatedButton(
          child: Text('Accept'),
          onPressed: () {
            MockService.acceptRequest(requestId);
            setState(() {}); // Update UI
          },
        ),
      ],
    );
  }
}