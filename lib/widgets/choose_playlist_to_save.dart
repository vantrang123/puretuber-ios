import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/sharedpref/shared_preference_helper.dart';
import '../di/components/service_locator.dart';

class ChoosePlaylistToSave extends StatefulWidget {
  final Function(String) callback;

  ChoosePlaylistToSave({required this.callback});

  @override
  _ChoosePlaylistToSaveState createState() => _ChoosePlaylistToSaveState();
}

class _ChoosePlaylistToSaveState extends State<ChoosePlaylistToSave> {
  String selectedPlaylist = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIt<SharedPreferenceHelper>().getLocalPlaylists(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data is List<String>) {
            final List<String> playlistNames = snapshot.data as List<String>;
            return CupertinoActionSheet(
              title: Column(
                children: [
                  Text('Select Playlist',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        fontWeight: FontWeight.w300
                      )
                  ),
                  const SizedBox(height: 4),
                ],
              ),
              actions: playlistNames.map((playlistName) {
                return CupertinoActionSheetAction(
                  onPressed: () {
                    if (selectedPlaylist != playlistName) {
                      selectedPlaylist = playlistName;
                    } else {
                      selectedPlaylist = '';
                    }

                    setState(() {
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        selectedPlaylist == playlistName
                            ? CupertinoIcons.check_mark_circled_solid
                            : CupertinoIcons.circle,
                        color: Colors.white,
                      ),
                      Text(playlistName,
                          style:
                          TextStyle(fontSize: 20, color: Colors.white)),
                    ],
                  ),
                );
              }).toList(),
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  widget.callback.call(selectedPlaylist);
                  Navigator.pop(context);
                },
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            );
          }
          return SizedBox.shrink();
        });
  }
}
