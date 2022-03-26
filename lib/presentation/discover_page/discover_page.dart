/*
 * Copyright (c) 2021 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/repository.dart';
import '../../helpers/string_formatters.dart';
import '../app_colors.dart';
import 'widgets/footer_widget.dart';

/// Discover new websites tab
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({
    Key? key,
    required this.repository,
    required this.routeToSavedUrlsTab,
  }) : super(key: key);

  final Repository repository;
  final void Function() routeToSavedUrlsTab;

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  
  //TODO: add WebViewController here
  
  String? url;
  String? prevUrl;
  bool isLoading = true;
  String? invalidUrl;

  Repository get repository => widget.repository;
  bool get shouldSendUrlToHelpPage => invalidUrl != null;
  String get domainName => StringFormatters.getDomainNameFromUrl(url);

  @override
  void initState() {
    onImFeelingLuckyPressed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: buildAppBar(),
      body: url == null
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Expanded(
                  child: buildWebView(context),
                ),
                FooterWidget(
                  navigationControls: const Placeholder(),
                  url: url,
                  routeToHelpPage: routeToHelpPage,
                ),
              ],
            ),
    );
  }

  Widget buildWebView(BuildContext context) {
    //TODO: Add WebView
    return const Placeholder();
  }

  void onPageFinishedWebView(String? _) {
    if (shouldSendUrlToHelpPage) {
      //TODO: Send url to web page
      setState(() {
        invalidUrl = null;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void onProgressWebView(int? _) {
    setState(() {
      isLoading = true;
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('URL Gems'),
      actions: [
        ElevatedButton(
          onPressed: () async => onImFeelingLuckyPressed(),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                return AppColors.accentColor;
              },
            ),
          ),
          child: const Text(
            "I'm feeling lucky!",
            style: TextStyle(color: Colors.white),
          ),
        ),
        IconButton(
          onPressed: onSaveUrlPressed,
          icon: const Icon(Icons.save),
        ),
      ],
    );
  }

  void onSaveUrlPressed() async {
    setState(() {
      isLoading = true;
    });
    if (url != null) {
      await repository.saveUrl(url!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved $url!'),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> routeToHelpPage() async {
    final contentBase64 = await repository.fetchHelpHtmlPage();
    setState(() {
      prevUrl = url;
      url = contentBase64;
    });
	await loadUrlOnWebView('data:text/html;base64,$contentBase64');
  }

  void onImFeelingLuckyPressed() async {
    final fetchedUrl = await widget.repository.getRandomUrl(exclude: url);
    setState(() {
      url = fetchedUrl;
    });
    await loadUrlOnWebView(fetchedUrl);
  }

  Future<void> loadUrlOnWebView(String url) async {
    //TODO: load url to be displayed on WebView
  }

  ///TODO: Add Navigation Delegate to prevent navigation to certain domains

  //TODO: Send data to web page function

  //TODO: receive RefreshUrl message from web page

  //TODO: receive RouteToSavedWebsites message from web page
}
