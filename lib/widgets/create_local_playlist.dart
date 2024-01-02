import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/sharedpref/shared_preference_helper.dart';
import '../di/components/service_locator.dart';
import '../provider/local_playlist_provider.dart';

class CreateLocalPlaylist extends StatefulWidget {
  @override
  _CreateFavoriteState createState() => _CreateFavoriteState();
}

class _CreateFavoriteState extends State<CreateLocalPlaylist> {
  TextEditingController playlistNameController = TextEditingController();
  FocusNode playlistNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(playlistNameFocusNode);
    });
  }

  @override
  void dispose() {
    playlistNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'New Playlist',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('Enter playlist name below:'),
              const SizedBox(height: 8.0),
              TextField(
                controller: playlistNameController,
                focusNode: playlistNameFocusNode,
                decoration: InputDecoration(
                  hintText: 'Playlist Name',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(),
                ),
                  style: TextStyle(
                      color: Colors.white
                  ),
                cursorColor: Colors.white,
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.white
                        )
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      String playlistName = playlistNameController.text;
                      getIt<SharedPreferenceHelper>().getLocalPlaylists().then((value) {
                        if (value?.contains(playlistName) != true) {
                          getIt<SharedPreferenceHelper>().saveLocalPlaylists(value!..add(playlistName));
                          Provider.of<LocalPlaylistProvider>(context, listen: false).newPlaylist();
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                        'Done',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
