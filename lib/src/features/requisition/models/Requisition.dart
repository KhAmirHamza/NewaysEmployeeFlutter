class Requisition {
  int? id;
  String? requisitionId;
  int? branchId;
  String? branchName;
  int? departmentId;
  String? departmentName;
  int? employeeId;
  String? employeeName;
  int? designationId;
  String? designationName;
  String? totalProduct;
  String? totalQuantity;
  String? requestDate;
  String? expectedDate;
  String? note;
  String? attachment;
  int? dheadApproval;
  int? bossApproval;
  int? warehouseApproval;
  int? processStatus;
  String? processInfo;
  String? requestType;
  int? requestTypeNumber;
  String? requestYear;
  String? uploaderId;
  String? uploaderInfo;
  String? data;
  String? dateFilter;
  String? productName;
  String? productImage;

  Requisition(
      {this.id,
        this.requisitionId,
        this.branchId,
        this.branchName,
        this.departmentId,
        this.departmentName,
        this.employeeId,
        this.employeeName,
        this.designationId,
        this.designationName,
        this.totalProduct,
        this.totalQuantity,
        this.requestDate,
        this.expectedDate,
        this.note,
        this.attachment,
        this.dheadApproval,
        this.bossApproval,
        this.warehouseApproval,
        this.processStatus,
        this.processInfo,
        this.requestType,
        this.requestTypeNumber,
        this.requestYear,
        this.uploaderId,
        this.uploaderInfo,
        this.data,
        this.dateFilter,
        this.productName,
        this.productImage

      });

  Requisition.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requisitionId = json['requisition_id'];
    branchId = json['branch_id'];
    branchName = json['branch_name'];
    departmentId = json['department_id'];
    departmentName = json['department_name'];
    employeeId = json['employee_id'];
    employeeName = json['employee_name'];
    designationId = json['designation_id'];
    designationName = json['designation_name'];
    totalProduct = json['total_product'];
    totalQuantity = json['total_quantity'];
    requestDate = json['request_date'];
    expectedDate = json['expected_date'];
    note = json['note'];
    attachment = json['attachment'];
    dheadApproval = json['dhead_approval'];
    bossApproval = json['boss_approval'];
    warehouseApproval = json['warehouse_approval'];
    processStatus = json['process_status'];
    processInfo = json['process_info'];
    requestType = json['request_type'];
    requestTypeNumber = json['request_type_number'];
    requestYear = json['request_year'];
    uploaderId = json['uploader_id'];
    uploaderInfo = json['uploader_info'];
    data = json['data'];
    dateFilter = json['date_filter'];
    productName = json['product_name'];
    productImage = json['product_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['requisition_id'] = this.requisitionId;
    data['branch_id'] = this.branchId;
    data['branch_name'] = this.branchName;
    data['department_id'] = this.departmentId;
    data['department_name'] = this.departmentName;
    data['employee_id'] = this.employeeId;
    data['employee_name'] = this.employeeName;
    data['designation_id'] = this.designationId;
    data['designation_name'] = this.designationName;
    data['total_product'] = this.totalProduct;
    data['total_quantity'] = this.totalQuantity;
    data['request_date'] = this.requestDate;
    data['expected_date'] = this.expectedDate;
    data['note'] = this.note;
    data['attachment'] = this.attachment;
    data['dhead_approval'] = this.dheadApproval;
    data['boss_approval'] = this.bossApproval;
    data['warehouse_approval'] = this.warehouseApproval;
    data['process_status'] = this.processStatus;
    data['process_info'] = this.processInfo;
    data['request_type'] = this.requestType;
    data['request_type_number'] = this.requestTypeNumber;
    data['request_year'] = this.requestYear;
    data['uploader_id'] = this.uploaderId;
    data['uploader_info'] = this.uploaderInfo;
    data['data'] = this.data;
    data['date_filter'] = this.dateFilter;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    return data;
  }
}