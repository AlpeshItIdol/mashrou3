import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();

  void initDeepLinks(GoRouter router) {
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        router.go(uri.path);
      }
    });

    _appLinks.uriLinkStream.listen((uri) {
      router.go(uri.path);
    });
  }
}
