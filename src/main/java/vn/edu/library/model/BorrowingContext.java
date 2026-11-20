package vn.edu.library.model;

import java.math.BigDecimal;
import java.text.Normalizer;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;

/** Fresh database values used by both the form and the final transaction validation. */
public class BorrowingContext {
    private final Reader2 reader;
    private final LibraryCard2 card;
    private final BorrowingPolicy2 policy;
    private final List<LoanDetail2> currentLoans;
    private final BigDecimal unpaidFine;
    private final LocalDate borrowDate;

    public BorrowingContext(Reader2 reader, LibraryCard2 card, BorrowingPolicy2 policy,
                           List<LoanDetail2> currentLoans, BigDecimal unpaidFine, LocalDate borrowDate) {
        this.reader = reader; this.card = card; this.policy = policy;
        this.currentLoans = List.copyOf(currentLoans); this.unpaidFine = unpaidFine; this.borrowDate = borrowDate;
    }

    public static LocalDate today() { return LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh")); }
    public Reader2 getReader() { return reader; }
    public LibraryCard2 getCard() { return card; }
    public BorrowingPolicy2 getPolicy() { return policy; }
    public List<LoanDetail2> getCurrentLoans() { return currentLoans; }
    public int getActiveCount() { return currentLoans.size(); }
    public int getRemaining() { return policy == null ? 0 : Math.max(0, policy.getMaximumCopies() - currentLoans.size()); }
    public BigDecimal getUnpaidFine() { return unpaidFine; }
    public String getUnpaidFineText() { return java.text.NumberFormat.getCurrencyInstance(Locale.forLanguageTag("vi-VN")).format(unpaidFine); }
    public LocalDate getDueDate() { return policy == null ? borrowDate : policy.dueDate(borrowDate); }
    public String getDueDateText() { return getDueDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")); }
    public boolean isEligible() { return getError().isEmpty(); }

    public String getError() {
        if (reader == null) return "Không tìm thấy bạn đọc.";
        if (!"Hoạt động".equals(reader.getReaderStatus())) return "Hồ sơ bạn đọc không được phép mượn.";
        if (card == null || !card.usableOn(borrowDate)) return "Bạn đọc chưa có thẻ còn hiệu lực hoặc thẻ đã bị khóa/hết hạn.";
        if (policy == null) return "Chưa có quy định mượn đang áp dụng cho nhóm bạn đọc.";
        if (getRemaining() == 0) return "Bạn đọc đã đạt giới hạn " + policy.getMaximumCopies() + " bản đang mượn.";
        String restriction = policy.getBorrowingRestriction();
        if (restriction != null && !restriction.isBlank()) {
            String rule = Normalizer.normalize(restriction, Normalizer.Form.NFD).replaceAll("\\p{M}", "")
                    .toLowerCase(Locale.ROOT).replace('đ', 'd');
            boolean blockOverdue = rule.contains("qua han") || rule.contains("block_overdue");
            boolean blockFine = rule.contains("phat") || rule.contains("block_unpaid_fine");
            if (!blockOverdue && !blockFine) return "Quy định hạn chế mượn chưa được hỗ trợ. Cần kiểm tra cấu hình quy định.";
            if (blockOverdue && currentLoans.stream().anyMatch(d -> d.getDueDate().isBefore(borrowDate))) return "Bạn đọc có tài liệu quá hạn theo quy định đang áp dụng.";
            if (blockFine && unpaidFine.signum() > 0) return "Bạn đọc còn tiền phạt chưa nộp theo quy định đang áp dụng.";
        }
        return "";
    }
}
