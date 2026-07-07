import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../../core/constants/app_colors.dart';
import '../../services/pyq_service.dart';

class PDFViewerScreen extends StatefulWidget {
  final PYQPaper paper;
  const PDFViewerScreen({super.key, required this.paper});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? _localPath;   // temp path for viewing
  bool _loading = true;
  String? _error;
  double _downloadProgress = 0;
  bool _saving = false;
  bool _alreadySaved = false;
  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController? _controller;

  @override
  void initState() {
    super.initState();
    _checkAlreadySaved();
    _loadPDF();
  }

  /// Persistent save directory: external storage (Android) or Documents (iOS)
  Future<Directory> _getSaveDir() async {
    Directory base;
    if (!kIsWeb && Platform.isAndroid) {
      base = (await getExternalStorageDirectory()) ??
          await getApplicationDocumentsDirectory();
    } else {
      base = await getApplicationDocumentsDirectory();
    }
    final dir = Directory('${base.path}/pyq_papers');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  String _savedFilename() => '${widget.paper.id}.pdf';

  Future<void> _checkAlreadySaved() async {
    if (kIsWeb) return;
    try {
      final dir = await _getSaveDir();
      final file = File('${dir.path}/${_savedFilename()}');
      if (file.existsSync()) {
        setState(() { _alreadySaved = true; });
      }
    } catch (_) {}
  }

  Future<void> _loadPDF() async {
    setState(() { _loading = true; _error = null; _downloadProgress = 0; });
    try {
      if (kIsWeb) {
        final url = Uri.parse(PYQService.fileUrl(widget.paper.id));
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
        setState(() { _loading = false; });
        return;
      }

      // Stream download with progress
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(PYQService.fileUrl(widget.paper.id)));
      final response = await client.send(request).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Server returned ${response.statusCode}');
      }

      final total = response.contentLength ?? 0;
      final bytes = <int>[];
      await for (final chunk in response.stream) {
        bytes.addAll(chunk);
        if (total > 0) {
          setState(() => _downloadProgress = bytes.length / total);
        }
      }
      client.close();

      // Save to temp for viewing
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${_savedFilename()}');
      await tempFile.writeAsBytes(bytes);
      setState(() { _localPath = tempFile.path; _loading = false; });
    } catch (e) {
      setState(() { _error = 'Failed to load PDF: $e'; _loading = false; });
    }
  }

  /// Download and save PDF to persistent storage on device
  Future<void> _downloadToDevice() async {
    if (_saving) return;
    setState(() { _saving = true; });
    try {
      final dir = await _getSaveDir();
      final destPath = '${dir.path}/${_savedFilename()}';

      if (_localPath != null && File(_localPath!).existsSync()) {
        // Copy from temp to persistent location
        await File(_localPath!).copy(destPath);
      } else {
        // Re-download directly to persistent location
        final response = await http.get(
          Uri.parse(PYQService.fileUrl(widget.paper.id)),
        ).timeout(const Duration(seconds: 60));
        if (response.statusCode != 200) throw Exception('Download failed (${response.statusCode})');
        await File(destPath).writeAsBytes(response.bodyBytes);
      }

      setState(() { _alreadySaved = true; _saving = false; });
      if (!mounted) return;
      _showSavedSnackbar();
    } catch (e) {
      setState(() { _saving = false; });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Save failed: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showSavedSnackbar() {
    final location = Platform.isIOS
        ? 'Files app → On My iPhone → Govt Exam Prep'
        : 'Android/data/[app]/files/pyq_papers/';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PDF saved to device!',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(location,
                style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Open in browser',
          textColor: Colors.yellow,
          onPressed: _openInBrowser,
        ),
      ),
    );
  }

  /// Open PDF URL in browser / default app (always works, no FileProvider needed)
  Future<void> _openInBrowser() async {
    final url = Uri.parse(PYQService.fileUrl(widget.paper.id));
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.paper.title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis),
            Text('${widget.paper.examName} • ${widget.paper.year}',
                style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/home/pyq'),
        ),
        actions: [
          // Page counter
          if (_totalPages > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  '${_currentPage + 1}/$_totalPages',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ),
            ),

          // Download button — shows spinner while saving, checkmark when saved
          if (!kIsWeb && !_loading && _error == null)
            _saving
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    ),
                  )
                : Tooltip(
                    message: _alreadySaved ? 'Saved to device' : 'Download to device',
                    child: IconButton(
                      icon: Icon(
                        _alreadySaved
                            ? Icons.download_done_rounded
                            : Icons.download_rounded,
                        color: _alreadySaved ? Colors.greenAccent : Colors.white,
                      ),
                      onPressed: _alreadySaved ? _showSavedSnackbar : _downloadToDevice,
                    ),
                  ),

          // Open in browser button
          if (!_loading && _error == null)
            IconButton(
              icon: const Icon(Icons.open_in_browser_rounded),
              tooltip: 'Open in browser / download',
              onPressed: _openInBrowser,
            ),
        ],
      ),

      body: _buildBody(),

      // Bottom page navigation bar
      bottomNavigationBar: (!_loading && _error == null && !kIsWeb &&
              _localPath != null && _totalPages > 1)
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: _currentPage > 0
                        ? () => _controller?.setPage(_currentPage - 1)
                        : null,
                    color: _currentPage > 0 ? AppColors.primary : AppColors.textHint,
                    iconSize: 32,
                  ),
                  Text(
                    'Page ${_currentPage + 1} of $_totalPages',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: _currentPage < _totalPages - 1
                        ? () => _controller?.setPage(_currentPage + 1)
                        : null,
                    color: _currentPage < _totalPages - 1
                        ? AppColors.primary
                        : AppColors.textHint,
                    iconSize: 32,
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 64, height: 64,
              child: CircularProgressIndicator(
                value: _downloadProgress > 0 ? _downloadProgress : null,
                strokeWidth: 3,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _downloadProgress > 0
                  ? 'Downloading… ${(_downloadProgress * 100).toStringAsFixed(0)}%'
                  : 'Loading PDF…',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            if (widget.paper.fileSize > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  widget.paper.fileSizeLabel,
                  style: const TextStyle(color: AppColors.textHint, fontSize: 12),
                ),
              ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 64, color: AppColors.error),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              const Text('Make sure the backend is running on port 4000.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textHint, fontSize: 12)),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: _loadPDF,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _openInBrowser,
                    icon: const Icon(Icons.open_in_browser_rounded),
                    label: const Text('Open in Browser'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (kIsWeb) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.open_in_browser_rounded, size: 64, color: AppColors.primary),
            SizedBox(height: 12),
            Text('PDF opened in your browser.',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    if (_localPath == null) return const SizedBox.shrink();

    return PDFView(
      filePath: _localPath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      onRender: (pages) => setState(() => _totalPages = pages ?? 0),
      onPageChanged: (page, total) => setState(() {
        _currentPage = page ?? 0;
        _totalPages = total ?? 0;
      }),
      onViewCreated: (ctrl) => setState(() => _controller = ctrl),
      onError: (e) => setState(() => _error = e.toString()),
    );
  }
}
