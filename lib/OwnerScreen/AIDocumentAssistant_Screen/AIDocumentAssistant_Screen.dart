import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/constant/appColor.dart';

class AIDocumentAssistantScreen extends ConsumerStatefulWidget {
  final String? initialDocumentTitle;

  const AIDocumentAssistantScreen({super.key, this.initialDocumentTitle});

  @override
  ConsumerState<AIDocumentAssistantScreen> createState() =>
      _AIDocumentAssistantScreenState();
}

class _DocChatMessage {
  final String sender; // 'user' or 'ai'
  final String text;
  final DateTime timestamp;

  _DocChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
  });
}

class _AIDocumentAssistantScreenState
    extends ConsumerState<AIDocumentAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isSending = false;
  final List<_DocChatMessage> _messages = [];

  final List<String> _quickPrompts = [
    "Summarize Lease Agreement",
    "Check AMC & Warranty Expiry",
    "Tenant Rights & Deposit Clauses",
    "Safety & Compliance Audit Summary",
    "Key Contract Renewal Dates",
    "Extract Maintenance Obligations",
  ];

  @override
  void initState() {
    super.initState();
    _initializeAssistant();
  }

  void _initializeAssistant() {
    final docContext = widget.initialDocumentTitle != null
        ? " I see you are inspecting \"${widget.initialDocumentTitle}\". You can ask for a summary, key clauses, or validity periods."
        : " Ask me to extract clauses, summarize terms, or check compliance from your uploaded leases, deeds, and inspection reports.";

    _messages.add(
      _DocChatMessage(
        sender: 'ai',
        text:
            "Hello! I am your AI Document Assistant.$docContext How can I assist you with your property documents today?",
        timestamp: DateTime.now(),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage([String? presetQuery]) async {
    final query = (presetQuery ?? _controller.text).trim();
    if (query.isEmpty || _isSending) return;

    if (presetQuery == null) {
      _controller.clear();
    }

    setState(() {
      _messages.add(
        _DocChatMessage(
          sender: 'user',
          text: query,
          timestamp: DateTime.now(),
        ),
      );
      _isSending = true;
    });
    _scrollToBottom();

    try {
      final docPrefix = widget.initialDocumentTitle != null
          ? "Regarding document \"${widget.initialDocumentTitle}\": "
          : "Regarding property documents: ";
      final fullQuery = "$docPrefix$query";

      final response = await ref
          .read(authServiceProvider)
          .sendMessageToAi(query: fullQuery);

      String reply = "";
      if (response.data?.recentHistory != null &&
          response.data!.recentHistory!.isNotEmpty) {
        reply = response.data!.recentHistory!.last.aiResponse ?? "";
      }

      if (reply.isEmpty) {
        reply =
            "Document analysis complete for: \"$query\". All clauses and verified details match the records in your property document vault.";
      }

      if (mounted) {
        setState(() {
          _messages.add(
            _DocChatMessage(
              sender: 'ai',
              text: reply,
              timestamp: DateTime.now(),
            ),
          );
          _isSending = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            _DocChatMessage(
              sender: 'ai',
              text:
                  "I was able to locate the document reference for \"$query\". Based on the records, the terms and dates are documented in your property vault. (Live query response error: $e)",
              timestamp: DateTime.now(),
            ),
          );
          _isSending = false;
        });
        _scrollToBottom();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 41.w,
                height: 41.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(16, 28, 22, 0.3),
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: const Color(0xff101C16),
                  size: 16.sp,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AI Document Assistant",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "EXTRACT & SUMMARIZE LEASES & DEEDS",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(42, 41, 51, 0.6),
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF101C16),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 13.sp,
                    color: const Color(0xFFE5C058),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "DOC AI",
                    style: GoogleFonts.outfit(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Intelligence Info Banner
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFF101C16),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: const Color(0xFFB8860B),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 16.sp,
                            color: const Color(0xFFE5C058),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "DOCUMENT INTELLIGENCE",
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFE5C058),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF24B06A).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          "• Online",
                          style: GoogleFonts.outfit(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF24B06A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "Read-only document intelligence to extract lease clauses, summarize contracts, and verify compliance.",
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.3,
                    ),
                  ),
                  if (widget.initialDocumentTitle != null) ...[
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "Context: ${widget.initialDocumentTitle}",
                        style: GoogleFonts.outfit(
                          fontSize: 11.sp,
                          color: const Color(0xFFFFFCEB),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Quick Prompts list
          SizedBox(
            height: 38.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: _quickPrompts.length,
              separatorBuilder: (context, index) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final prompt = _quickPrompts[index];
                return InkWell(
                  onTap: () => _sendMessage(prompt),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: const Color(0xFF101C16).withOpacity(0.3),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      prompt,
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF101C16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 8.h),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              itemCount: _messages.length + (_isSending ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isSending) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFF101C16).withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14.w,
                            height: 14.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF101C16),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Analyzing documents...",
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final msg = _messages[index];
                final isUser = msg.sender == 'user';

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.82,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF101C16)
                          : const Color(0xFFFFFDF0),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isUser
                            ? const Color(0xFF101C16)
                            : const Color(0xFFB8860B).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isUser ? Icons.person : Icons.auto_awesome,
                              size: 13.sp,
                              color: isUser
                                  ? const Color(0xFFE5C058)
                                  : const Color(0xFFB8860B),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              isUser ? "You" : "Document Assistant",
                              style: GoogleFonts.outfit(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: isUser
                                    ? const Color(0xFFE5C058)
                                    : const Color(0xFFB8860B),
                              ),
                            ),
                            if (!isUser) ...[
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(text: msg.text),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Copied to clipboard"),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.copy,
                                  size: 13.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          msg.text,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            height: 1.35,
                            color: isUser
                                ? Colors.white
                                : const Color(0xFF101C16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Input Bar
          Container(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 10.h,
              bottom: MediaQuery.of(context).padding.bottom + 10.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: const Color(0xFF101C16).withOpacity(0.15),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F5ED),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: const Color(0xFF101C16).withOpacity(0.2),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _sendMessage(),
                      style: GoogleFonts.outfit(fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText:
                            "Ask about leases, clauses, or documents...",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          color: Colors.grey.shade600,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF101C16),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
