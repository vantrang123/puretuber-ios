import 'package:extractor/extractor.dart';
import 'package:flutter/material.dart';

class ExtractorLink extends StatefulWidget {
  const ExtractorLink({Key? key}) : super(key: key);

  @override
  State<ExtractorLink> createState() => _ExtractorLink();
}

class _ExtractorLink extends State<ExtractorLink> {
  final TextEditingController _urlController = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  VideoData? data;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text('Direct Link Extractor'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: _urlController,
              decoration: InputDecoration(
                  hintText: 'Enter Url',
                  isDense: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  suffixIcon: IconButton(
                      onPressed: _handleDirectLink,
                      icon: const Icon(Icons.search))),
            ),
          ),
          Expanded(
            child: _isLoading ? const Center(child: CircularProgressIndicator(),)
                : ListView(
              shrinkWrap: true,
              children: data?.links
                  ?.map((e) {
                    print(e.href);
                    return ListTile(
                        leading: CircleAvatar(
                          child: Text(e.videoFormat ?? 'N/A'),
                        ),
                        title: Text(e.text ?? ''),
                        subtitle: Text(e.href ?? '', maxLines: 2));
              }
              ).toList() ?? [
                    const Text(
                      'Links will be here',
                      textAlign: TextAlign.center,
                    )
                  ]),
          )
        ],
      ),
    );
  }

  _handleDirectLink() {
    FocusScope.of(context).unfocus();
    if (_urlController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      Extractor.getDirectLink(link: _urlController.text).then((value) {
        if (value?.status ?? false) {
          data = value;
          _isLoading = false;
          setState(() {});
        } else {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value!.message!)));
        }
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter url')));
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}