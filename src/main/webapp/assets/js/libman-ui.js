/* UI only. Search results, draft and saved slips are rendered by JSP from MySQL. */
(() => {
  "use strict";
  const context = document.body.dataset.context;
  const home = context + (document.body.dataset.role === "librarian" ? "/nhan-vien" : "/ban-doc");
  document.querySelectorAll("[data-url]").forEach(button => button.addEventListener("click", () => location.assign(button.dataset.url)));
  document.querySelectorAll("[data-home]").forEach(button => button.addEventListener("click", event => {
    if (button.tagName === "A") return;
    event.preventDefault(); location.assign(home);
  }));
  document.getElementById("start-search")?.addEventListener("click", () => location.assign(context + "/tim-tai-lieu"));
  document.getElementById("start-lending")?.addEventListener("click", () => location.assign(context + "/tim-ban-doc"));
  document.getElementById("print-slip")?.addEventListener("click", () => window.print());
  document.querySelectorAll("form[data-confirm]").forEach(form => form.addEventListener("submit", event => {
    if (form.dataset.approved === "true") return;
    event.preventDefault();
    const dialog = document.getElementById("exit-dialog");
    document.getElementById("exit-title").textContent = form.dataset.confirm;
    document.getElementById("exit-description").textContent = "Danh sách đang chọn sẽ được bỏ. Phiếu chưa được lưu.";
    document.getElementById("exit-confirm").textContent = form.dataset.confirm;
    dialog.addEventListener("close", () => {
      if (dialog.returnValue === "discard") { form.dataset.approved = "true"; form.requestSubmit(); }
    }, {once: true});
    dialog.showModal();
  }));
  document.querySelectorAll('[data-password]').forEach(button => button.addEventListener('click', () => {
    const input = document.getElementById(button.dataset.password);
    const visible = input.type === 'password';
    input.type = visible ? 'text' : 'password';
    button.textContent = visible ? 'Ẩn' : 'Hiện';
    button.setAttribute('aria-pressed', String(visible));
  }));
  // Returning via browser history must reload availability from the server.
  window.addEventListener("pageshow", event => { if (event.persisted) location.reload(); });
})();
