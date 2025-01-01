// Import necessary Flutter material package and YouTube player.
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../youtube_service.dart';  // Assuming this contains logic for fetching YouTube data.

// StatefulWidget for selecting a subject.
class SubjectSelection extends StatefulWidget {
  @override
  // Create the state for this widget.
  State<SubjectSelection> createState() => _SubjectSelectionState();
}

// State class for handling the subject selection screen.
class _SubjectSelectionState extends State<SubjectSelection> {
  // List of subjects available for selection.
  final List<String> subjects = ['All Subjects', 'Biology', 'Physics', 'Chemistry', 'English', 'Logical Reasoning'];

  @override
  // Build the UI for the subject selection screen.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a Subject", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(2, 19, 34, 1.0),  // Custom color for the AppBar.
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.jpg',  // Background image for the subject screen.
                fit: BoxFit.cover,  // Ensures the background covers the whole screen.
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ListView.builder(
                  itemCount: subjects.length,  // Build a list item for each subject.
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _navigateToVideosScreen(subjects[index]),  // When tapped, navigate to the video screen.
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            subjects[index],
                            style: const TextStyle(
                              fontSize: 24,
                              color: Color.fromRGBO(2, 19, 34, 1.0),
                              fontWeight: FontWeight.bold,
                              fontFamily: "Orbitron",
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to navigate to the video display screen for a specific subject.
  void _navigateToVideosScreen(String subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoDisplayScreen(selectedSubject: subject),
      ),
    );
  }
}

// StatefulWidget for displaying selected videos.
class VideoDisplayScreen extends StatefulWidget {
  final String selectedSubject;  // Subject for which to display videos.

  const VideoDisplayScreen({Key? key, required this.selectedSubject}) : super(key: key);

  @override
  // Create the state for this widget.
  _VideoDisplayScreenState createState() => _VideoDisplayScreenState();
}

// State class for handling the video display.
class _VideoDisplayScreenState extends State<VideoDisplayScreen> {
  List<dynamic> videos = [];  // List to store video data.
  bool isSearching = false;  // Flag to indicate if a search is ongoing.
  TextEditingController searchController = TextEditingController();  // Controller for the search input.

  @override
  // Initial setup to load videos when the widget is first created.
  void initState() {
    super.initState();
    if (widget.selectedSubject != " ") {
      _loadVideos("${widget.selectedSubject} tutorials Khan Academy");  // Load videos for the selected subject.
    }
  }

  // Fetch videos based on a query.
  void _loadVideos(String query) async {
    videos = await YouTubeService.fetchVideos(query);  // Assuming YouTubeService handles API calls.
    setState(() {});  // Trigger UI update after fetching videos.
  }

  // Handle search logic.
  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      _loadVideos(query);
      isSearching = true;
    } else {
      setState(() {
        isSearching = false;
        videos = [];
      });
    }
  }

  @override
  // Build the UI for the video display screen.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSearching ? "Search Results" : "${widget.selectedSubject} Videos", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(2, 19, 34, 1.0),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          _handleSearch('');
                        },
                      ),
                    ),
                    onSubmitted: _handleSearch,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: videos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Scrollbar(
          thumbVisibility: true,
          thickness: 8.0,
          radius: const Radius.circular(20),
           child: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            var videoId = YoutubePlayer.convertUrlToId(videos[index]['id']['videoId']);  // Extract video ID from YouTube URL.
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: videoId!,
                  flags: const YoutubePlayerFlags(autoPlay: false),
                ),
                showVideoProgressIndicator: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
