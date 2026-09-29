import 'dart:io';

void main() async {
  final staticDir = Directory('build/web');
  if (!staticDir.existsSync()) {
    stderr.writeln('Error: Directory build/web not found!');
    exit(1);
  }

  final mimeTypes = {
    '.html': 'text/html; charset=UTF-8',
    '.js': 'application/javascript; charset=UTF-8',
    '.json': 'application/json',
    '.css': 'text/css; charset=UTF-8',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.svg': 'image/svg+xml',
    '.wasm': 'application/wasm',
    '.ttf': 'font/ttf',
    '.otf': 'font/otf',
    '.woff': 'font/woff',
    '.woff2': 'font/woff2',
    '.ico': 'image/x-icon',
  };

  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  stdout.writeln('MomBee web server active on http://localhost:${server.port}');

  await for (HttpRequest request in server) {
    var path = request.uri.path;
    if (path == '/' || path.isEmpty) {
      path = '/index.html';
    }

    var file = File('${staticDir.path}$path');
    if (!await file.exists()) {
      // Fallback to index.html for SPA routing
      file = File('${staticDir.path}/index.html');
    }

    final ext = file.path.contains('.') ? '.${file.path.split('.').last.toLowerCase()}' : '';
    final contentType = mimeTypes[ext] ?? 'application/octet-stream';

    request.response.headers.set('Content-Type', contentType);
    request.response.headers.set('Access-Control-Allow-Origin', '*');
    try {
      await file.openRead().pipe(request.response);
    } catch (_) {
      request.response.statusCode = HttpStatus.internalServerError;
      await request.response.close();
    }
  }
}
