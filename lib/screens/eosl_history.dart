import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart'; // 파일 선택을 위한 패키지
import 'package:oneline/models/eosl_detail_model.dart';
import 'package:oneline/models/contact_model.dart'; // Contact 모델 불러오기
import 'package:oneline/models/eosl_provider.dart'; // EOSL provider 불러오기
import 'package:oneline/models/contact_provider.dart'; // Contact provider 불러오기
import 'package:provider/provider.dart'; // 상태 관리를 위한 provider 불러오기

class EoslHistoryPage extends StatefulWidget {
  final String hostName;
  final int taskIndex;

  const EoslHistoryPage({
    super.key,
    required this.hostName,
    required this.taskIndex,
  });

  @override
  _EoslHistoryPageState createState() => _EoslHistoryPageState();
}

class _EoslHistoryPageState extends State<EoslHistoryPage> {
  bool isEditing = false; // 수정 모드 상태 변수
  TextEditingController taskController =
      TextEditingController(); // 작업 내용 입력 컨트롤러
  TextEditingController specialNotesController =
      TextEditingController(); // 특이사항 입력 컨트롤러
  List<PlatformFile> attachedFiles = []; // 첨부된 파일 목록

  @override
  void initState() {
    super.initState();
    // 초기값 설정이나 상태 초기화 로직 추가 가능
    // final eoslProvider = context.read<EoslProvider>();
    // final eoslMaintenance =
    //     eoslProvider.getEoslMaintenanceByHostName(widget.hostName);
    // if (eoslMaintenance != null &&
    //     widget.taskIndex < eoslMaintenance.tasks.length) {
    //   final task = eoslMaintenance.tasks[widget.taskIndex];
    //   taskController.text = task['content'] ?? '';
    //   specialNotesController.text = task['notes'] ?? '';
    // }
    _loadData();
  }

  // 새로고침 시에도 데이터를 가져올 수 있도록 _loadData 메서드 추가
  void _loadData() {
    final eoslProvider = context.read<EoslProvider>();
    final eoslMaintenance =
        eoslProvider.getEoslMaintenanceByHostName(widget.hostName);

    // 유지보수 데이터가 있을 때만 설정
    if (eoslMaintenance != null &&
        widget.taskIndex < eoslMaintenance.tasks.length) {
      final task = eoslMaintenance.tasks[widget.taskIndex];
      taskController.text = task['content'] ?? '';
      specialNotesController.text = task['notes'] ?? '';
    } else {
      // 데이터가 없을 때 초기화
      taskController.text = '';
      specialNotesController.text = '';
      print(
          'EoslHistoryPage: 데이터 조회 실패 - 호스트 이름: ${widget.hostName}, 인덱스: ${widget.taskIndex}');
    }
  }

  void _saveTask() {
    final eoslProvider = context.read<EoslProvider>();
    eoslProvider.addTaskToDetail(widget.hostName, {
      'date': DateTime.now().toIso8601String(),
      'content': taskController.text,
      'notes': specialNotesController.text,
    });
    Navigator.of(context).pop(); // 저장 후 페이지를 닫음
  }

  Future<void> _pickFiles() async {
    // 파일 선택 다이얼로그 열기
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        attachedFiles.addAll(result.files);
      });
    }
  }

  void _removeFile(int index) {
    // 선택한 파일 제거
    setState(() {
      attachedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // EoslDetailModel 데이터를 provider를 사용하여 불러오기
    final eoslDetail =
        context.read<EoslProvider>().getEoslDetailByHostName(widget.hostName);

    // EoslDetailModel의 supplier를 바탕으로 Contact 데이터 불러오기
    final contact = eoslDetail != null
        ? context
            .read<ContactProvider>()
            .getContactByWorkplace(eoslDetail.supplier)
        : null;

    // Contact 데이터가 없을 경우 임시 데이터 생성
    final Contact tempContact = Contact(
      name: '임시 데이터',
      phone: '010-1234-5678',
      email: 'temp@company.com',
      workplace: eoslDetail?.supplier ?? 'Unknown',
      notes: 'This is a temporary contact record.',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('유지보수 작업 상세: ${widget.hostName}'),
        backgroundColor: Colors.teal,
      ),
      body: eoslDetail == null
          ? const Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // EoslDetailModel과 Contact를 한 row에 나란히 배치
                  // Row 위젯 안의 내용 수정
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // 원하는 높이를 지정, 예를 들어 300으로 제한
                        const double maxHeight = 200; // 최대 높이 설정

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 왼쪽: EoslDetailModel 정보
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: _boxDecoration(),
                                padding: const EdgeInsets.all(16),
                                constraints: const BoxConstraints(
                                  minHeight: maxHeight,
                                  maxHeight: maxHeight,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildEoslDetailTile(context, eoslDetail),
                                  ],
                                ),
                              ),
                            ),
                            // 오른쪽: Contact 정보
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: _boxDecoration(),
                                padding: const EdgeInsets.all(16),
                                constraints: const BoxConstraints(
                                  minHeight: maxHeight,
                                  maxHeight: maxHeight,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildContactTile(
                                        context, contact ?? tempContact),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // 작업 정보 작성 섹션
                  _buildTaskInformationSection(),
                  const SizedBox(height: 16),
                  // 첨부파일 등록 섹션
                  _buildAttachmentSection(),
                  const SizedBox(height: 16),
                  // 작업 이력 등록 버튼
                  _buildSubmitButton(context, eoslDetail),
                ],
              ),
            ),
    );
  }

  // 카드 스타일
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // EoslDetailModel ListTile 생성 메서드
  Widget _buildEoslDetailTile(BuildContext context, EoslDetailModel detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          title: Text(
            'Host Name: ${detail.hostName}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Field: ${detail.field}'),
              Text('Quantity: ${detail.quantity}'),
              Text('Note: ${detail.note}'),
              Text('Supplier: ${detail.supplier}'),
              Text(
                'EOSL Date: ${detail.eoslDate != null ? DateFormat('yyyy-MM-dd').format(detail.eoslDate!) : 'None'}',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Contact ListTile 생성 메서드
  Widget _buildContactTile(BuildContext context, Contact contact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          title: Text(
            'Name: ${contact.name}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phone: ${contact.phone}'),
              Text('Email: ${contact.email}'),
              Text('Workplace: ${contact.workplace}'),
              Text('Notes: ${contact.notes}'),
            ],
          ),
        ),
      ],
    );
  }

  // 작업 정보 작성 섹션 생성 메서드
  Widget _buildTaskInformationSection() {
    return Container(
      width: double.infinity,
      height: 400, // 높이 증가
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '작업 정보',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                // 읽기 모드에서 수정 버튼 제공
                if (!isEditing)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (isEditing)
              // 수정 모드에서 텍스트 필드 제공
              TextField(
                controller: taskController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: '작업 내용을 입력하세요',
                  border: OutlineInputBorder(),
                ),
              )
            else
              const Text('작업 내용: 점검 내용 및 특이사항 작성'), // 기본 내용 표시
            const SizedBox(height: 8),
            if (isEditing)
              // 수정 모드에서 특이사항 필드 제공
              TextField(
                controller: specialNotesController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: '특이사항 및 권고사항 입력',
                  border: OutlineInputBorder(),
                ),
              )
            else
              const Text('특이사항 및 권고사항'),
          ],
        ),
      ),
    );
  }

  // 첨부파일 등록 섹션 생성 메서드
  Widget _buildAttachmentSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '첨부파일',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _pickFiles, // 파일 추가 버튼 눌렀을 때 파일 선택
            icon: const Icon(Icons.attach_file),
            label: const Text('파일 추가'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // 첨부된 파일 목록 표시
          ...attachedFiles.map(
            (file) => ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: Text('파일명: ${file.name ?? '알 수 없음'}'), // 파일명이 null인지 확인
              subtitle: Text(
                  '용량: ${(file.size != null ? (file.size / 1024).toStringAsFixed(2) : '0.00')} KB'), // 파일 크기가 null인지 확인
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () =>
                    _removeFile(attachedFiles.indexOf(file)), // 파일 삭제
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 작업 이력 등록 버튼
  Widget _buildSubmitButton(BuildContext context, EoslDetailModel detail) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Task 등록 로직: eosl_detail 페이지의 task card에 추가
          if (isEditing) {
            final taskContent = taskController.text;
            final specialNotes = specialNotesController.text;

            // Task 추가 로직 - eosl_detail 페이지에 반영되도록 수정
            context.read<EoslProvider>().addTaskToDetail(
              widget.hostName,
              {
                'date': DateTime.now().toIso8601String(),
                'content': taskContent,
                'notes': specialNotes,
              },
            );

            // 수정 완료 후 읽기 모드로 전환
            setState(() {
              isEditing = false;
            });

            // eosl_detail 페이지로 이동
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('작업 등록'),
      ),
    );
  }
}
