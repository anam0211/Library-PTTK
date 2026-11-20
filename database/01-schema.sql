-- LibMan: MySQL 8.0.16+, InnoDB, UTF-8.
-- Source: report section 8.2 / Figure 8.2; select the database before running.
-- Additive bootstrap only: existing tables/data are never dropped or altered.
-- IF NOT EXISTS is NOT a migration of an incompatible existing schema.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblMember (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fullName VARCHAR(255) NOT NULL,
    dateOfBirth DATE NULL,
    address VARCHAR(255) NULL,
    phoneNumber VARCHAR(20) NULL,
    email VARCHAR(255) NULL,
    username VARCHAR(100) NOT NULL,
    authenticationInfo VARCHAR(255) NOT NULL,
    accountStatus VARCHAR(30) NOT NULL,
    role VARCHAR(30) NOT NULL,
    note VARCHAR(255) NULL,
    CONSTRAINT uq_member_username UNIQUE (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblReader (
    memberId INT NOT NULL PRIMARY KEY,
    readerCode VARCHAR(50) NOT NULL,
    readerStatus VARCHAR(30) NOT NULL,
    institutionCode VARCHAR(100) NULL,
    readerGroup VARCHAR(100) NOT NULL,
    unitOrClass VARCHAR(100) NULL,
    registeredAt DATE NOT NULL,
    CONSTRAINT uq_reader_code UNIQUE (readerCode),
    CONSTRAINT fk_reader_member FOREIGN KEY (memberId) REFERENCES tblMember(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblStaff (
    memberId INT NOT NULL PRIMARY KEY,
    position VARCHAR(100) NOT NULL,
    employmentStatus VARCHAR(30) NOT NULL,
    CONSTRAINT fk_staff_member FOREIGN KEY (memberId) REFERENCES tblMember(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblCardApplication (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    applicationType VARCHAR(50) NOT NULL,
    submittedAt TIMESTAMP NOT NULL,
    status VARCHAR(30) NOT NULL,
    processedAt TIMESTAMP NULL,
    requestReason VARCHAR(255) NOT NULL,
    outcome VARCHAR(255) NULL,
    rejectionReason VARCHAR(255) NULL,
    librarianId INT NULL,
    readerId INT NOT NULL,
    CONSTRAINT fk_application_staff FOREIGN KEY (librarianId) REFERENCES tblStaff(memberId),
    CONSTRAINT fk_application_reader FOREIGN KEY (readerId) REFERENCES tblReader(memberId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblLibraryCard (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    issuedAt DATE NOT NULL,
    cardNumber VARCHAR(50) NOT NULL,
    expiresAt DATE NOT NULL,
    status VARCHAR(30) NOT NULL,
    lockOrReplacementReason VARCHAR(255) NULL,
    statusChangedAt TIMESTAMP NULL,
    cardApplicationId INT NOT NULL,
    CONSTRAINT uq_card_number UNIQUE (cardNumber),
    CONSTRAINT uq_card_application UNIQUE (cardApplicationId),
    CONSTRAINT fk_card_application FOREIGN KEY (cardApplicationId) REFERENCES tblCardApplication(id),
    CONSTRAINT ck_card_dates CHECK (expiresAt >= issuedAt)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblBorrowingPolicy (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    maximumCopies INT NOT NULL,
    loanPeriodDays INT NOT NULL,
    dueDateRule VARCHAR(255) NULL,
    borrowingRestriction VARCHAR(255) NULL,
    effectiveFrom DATE NOT NULL,
    effectiveTo DATE NULL,
    readerGroup VARCHAR(100) NOT NULL,
    CONSTRAINT ck_policy_limits CHECK (maximumCopies > 0 AND loanPeriodDays > 0),
    CONSTRAINT ck_policy_dates CHECK (effectiveTo IS NULL OR effectiveTo >= effectiveFrom)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblStorageLocation (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    area VARCHAR(100) NOT NULL,
    shelf VARCHAR(50) NOT NULL,
    compartment VARCHAR(50) NOT NULL,
    description VARCHAR(255) NULL,
    CONSTRAINT uq_storage_location UNIQUE (area, shelf, compartment)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblDocumentType (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    typeName VARCHAR(100) NULL,
    description VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblPublisher (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    publisherName VARCHAR(255) NULL,
    address VARCHAR(255) NOT NULL,
    contactInformation VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblAuthor (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    authorName VARCHAR(255) NULL,
    description VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblDocumentTitle (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    titleName VARCHAR(255) NOT NULL,
    coverImage VARCHAR(255) NULL,
    publicationYear INT NULL,
    edition VARCHAR(50) NULL,
    issueNumber VARCHAR(50) NULL,
    volume VARCHAR(50) NULL,
    releaseDate DATE NULL,
    isbn VARCHAR(20) NULL,
    issn VARCHAR(20) NULL,
    language VARCHAR(50) NULL,
    pageCount INT NULL,
    subject VARCHAR(255) NULL,
    description VARCHAR(255) NULL,
    catalogStatus VARCHAR(30) NOT NULL,
    publisherId INT NULL,
    documentTypeId INT NOT NULL,
    INDEX ix_title_name (titleName),
    CONSTRAINT fk_title_publisher FOREIGN KEY (publisherId) REFERENCES tblPublisher(id),
    CONSTRAINT fk_title_type FOREIGN KEY (documentTypeId) REFERENCES tblDocumentType(id),
    CONSTRAINT ck_title_pages CHECK (pageCount IS NULL OR pageCount > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblAuthorship (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    contributionRole VARCHAR(100) NOT NULL,
    authorOrder INT NOT NULL,
    documentTitleId INT NOT NULL,
    authorId INT NOT NULL,
    CONSTRAINT uq_authorship UNIQUE (documentTitleId, authorId),
    CONSTRAINT fk_authorship_title FOREIGN KEY (documentTitleId) REFERENCES tblDocumentTitle(id),
    CONSTRAINT fk_authorship_author FOREIGN KEY (authorId) REFERENCES tblAuthor(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblSupplier (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    supplierName VARCHAR(255) NOT NULL,
    address VARCHAR(255) NULL,
    email VARCHAR(255) NULL,
    phoneNumber VARCHAR(20) NULL,
    contactPerson VARCHAR(255) NULL,
    cooperationStatus VARCHAR(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblGoodsReceipt (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    createdAt TIMESTAMP NOT NULL,
    confirmedAt TIMESTAMP NULL,
    status VARCHAR(30) NOT NULL,
    note VARCHAR(255) NULL,
    supplierId INT NOT NULL,
    librarianId INT NOT NULL,
    CONSTRAINT fk_goods_supplier FOREIGN KEY (supplierId) REFERENCES tblSupplier(id),
    CONSTRAINT fk_goods_staff FOREIGN KEY (librarianId) REFERENCES tblStaff(memberId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblGoodsReceiptDetail (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    unitPrice DECIMAL(15,2) NOT NULL,
    conditionAtReceipt VARCHAR(255) NOT NULL,
    note VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    goodsReceiptId INT NOT NULL,
    documentTitleId INT NOT NULL,
    -- Supporting key for the composite FK below; not a new business identifier.
    CONSTRAINT uq_goods_detail_title UNIQUE (id, documentTitleId),
    CONSTRAINT fk_goods_detail_receipt FOREIGN KEY (goodsReceiptId) REFERENCES tblGoodsReceipt(id),
    CONSTRAINT fk_goods_detail_title FOREIGN KEY (documentTitleId) REFERENCES tblDocumentTitle(id),
    CONSTRAINT ck_goods_detail_values CHECK (unitPrice >= 0 AND quantity > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblDocumentCopy (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    copyCode VARCHAR(255) NOT NULL,
    physicalCondition VARCHAR(255) NOT NULL,
    copyStatus VARCHAR(30) NOT NULL,
    note VARCHAR(255) NULL,
    deactivationReason VARCHAR(50) NULL,
    deactivatedAt TIMESTAMP NULL,
    usageType VARCHAR(50) NOT NULL,
    acquiredAt DATE NOT NULL,
    goodsReceiptDetailId INT NOT NULL,
    storageLocationId INT NULL,
    documentTitleId INT NOT NULL,
    CONSTRAINT uq_copy_code UNIQUE (copyCode),
    CONSTRAINT fk_copy_goods_title FOREIGN KEY (goodsReceiptDetailId, documentTitleId)
        REFERENCES tblGoodsReceiptDetail(id, documentTitleId),
    CONSTRAINT fk_copy_location FOREIGN KEY (storageLocationId) REFERENCES tblStorageLocation(id),
    CONSTRAINT fk_copy_title FOREIGN KEY (documentTitleId) REFERENCES tblDocumentTitle(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblLoanSlip (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    slipNumber VARCHAR(50) NOT NULL,
    borrowedAt TIMESTAMP NOT NULL,
    status VARCHAR(30) NOT NULL,
    libraryCardId INT NOT NULL,
    borrowingPolicyId INT NOT NULL,
    librarianId INT NOT NULL,
    CONSTRAINT uq_loan_number UNIQUE (slipNumber),
    CONSTRAINT fk_loan_card FOREIGN KEY (libraryCardId) REFERENCES tblLibraryCard(id),
    CONSTRAINT fk_loan_policy FOREIGN KEY (borrowingPolicyId) REFERENCES tblBorrowingPolicy(id),
    CONSTRAINT fk_loan_staff FOREIGN KEY (librarianId) REFERENCES tblStaff(memberId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblLoanDetail (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    dueDate DATE NOT NULL,
    conditionAtLoan VARCHAR(255) NOT NULL,
    returnedAt TIMESTAMP NULL,
    conditionAtReturn VARCHAR(255) NULL,
    loanStatus VARCHAR(30) NOT NULL,
    note VARCHAR(255) NULL,
    documentCopyId INT NOT NULL,
    loanSlipId INT NOT NULL,
    CONSTRAINT uq_loan_detail_copy UNIQUE (loanSlipId, documentCopyId),
    -- Functional index: one unfinished loan per copy; historical loans are allowed.
    UNIQUE INDEX uq_copy_open_loan ((CASE WHEN returnedAt IS NULL THEN documentCopyId ELSE NULL END)),
    CONSTRAINT fk_detail_copy FOREIGN KEY (documentCopyId) REFERENCES tblDocumentCopy(id),
    CONSTRAINT fk_detail_loan FOREIGN KEY (loanSlipId) REFERENCES tblLoanSlip(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblFineSlip (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    issuedAt TIMESTAMP NOT NULL,
    violationType VARCHAR(50) NOT NULL,
    violationDescription VARCHAR(50) NOT NULL,
    assessmentBasis VARCHAR(50) NULL,
    fineAmount DECIMAL(15,2) NOT NULL,
    status VARCHAR(30) NOT NULL,
    cancelledAt TIMESTAMP NULL,
    cancellationReason VARCHAR(255) NULL,
    note VARCHAR(255) NULL,
    loanDetailId INT NOT NULL,
    CONSTRAINT fk_fine_detail FOREIGN KEY (loanDetailId) REFERENCES tblLoanDetail(id),
    CONSTRAINT ck_fine_amount CHECK (fineAmount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS tblFinePaymentReceipt (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    paidAt TIMESTAMP NOT NULL,
    paidAmount DECIMAL(15,2) NOT NULL,
    paymentMethod VARCHAR(50) NOT NULL,
    note VARCHAR(255) NULL,
    fineSlipId INT NOT NULL,
    librarianId INT NOT NULL,
    CONSTRAINT uq_payment_fine UNIQUE (fineSlipId),
    CONSTRAINT fk_payment_fine FOREIGN KEY (fineSlipId) REFERENCES tblFineSlip(id),
    CONSTRAINT fk_payment_staff FOREIGN KEY (librarianId) REFERENCES tblStaff(memberId),
    CONSTRAINT ck_payment_amount CHECK (paidAmount > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
