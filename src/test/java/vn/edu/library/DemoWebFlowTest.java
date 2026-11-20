package vn.edu.library;

import java.net.*;
import java.net.http.*;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;
import org.apache.catalina.startup.Tomcat;
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

/** Real HTTP/JSP checks use separate guest, reader and librarian sessions. */
class DemoWebFlowTest {
    private static Tomcat tomcat;
    private static String base;
    private static final HttpClient READER = client();
    private static final HttpClient STAFF = client();
    private static final HttpClient GUEST = HttpClient.newHttpClient();
    private static final Set<String> STAFF_PATHS = Set.of("/nhan-vien","/tim-ban-doc","/cho-muon-tai-lieu","/tim-ban-tai-lieu","/phieu-muon");
    private static boolean readerSignedIn, staffSignedIn;

    private static HttpClient client() {
        return HttpClient.newBuilder().cookieHandler(new CookieManager(null,CookiePolicy.ACCEPT_ALL)).build();
    }

    @BeforeAll static void start() throws Exception {
        tomcat=Application.start(0); base="http://localhost:"+tomcat.getConnector().getLocalPort();
        String password=System.getenv("LIBMAN_TEST_PASSWORD");
        if(password!=null) {
            signIn(STAFF,System.getenv().getOrDefault("LIBMAN_TEST_USERNAME","NV001"),password,"/nhan-vien");
            staffSignedIn=true;
            signIn(READER,"BD0101",System.getenv().getOrDefault("LIBMAN_TEST_READER_PASSWORD",password),"/ban-doc");
            readerSignedIn=true;
        }
    }
    @AfterAll static void stop() throws Exception { if(tomcat!=null){tomcat.stop();tomcat.destroy();} }

    private static HttpResponse<String> request(HttpClient client,String path) throws Exception {
        return client.send(HttpRequest.newBuilder(URI.create(base+path)).GET().build(),HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
    }
    private static void signIn(HttpClient client,String username,String password,String home) throws Exception {
        var form=request(client,"/dang-nhap");
        var token=Pattern.compile("name=\"csrf\" value=\"([^\"]+)\"").matcher(form.body());assertTrue(token.find());
        String data="csrf="+token.group(1)+"&username="+URLEncoder.encode(username,StandardCharsets.UTF_8)+"&password="+URLEncoder.encode(password,StandardCharsets.UTF_8);
        var result=client.send(HttpRequest.newBuilder(URI.create(base+"/dang-nhap")).header("Content-Type","application/x-www-form-urlencoded").POST(HttpRequest.BodyPublishers.ofString(data)).build(),HttpResponse.BodyHandlers.ofString());
        assertEquals(302,result.statusCode(),result.body());assertTrue(result.headers().firstValue("Location").orElse("").endsWith(home));
    }
    private boolean staffPath(String path) { return STAFF_PATHS.contains(path.split("\\?")[0]); }
    private boolean signedIn(String path) { return staffPath(path)?staffSignedIn:readerSignedIn; }
    private HttpResponse<String> get(String path) throws Exception { return request(staffPath(path)?STAFF:READER,path); }

    @Test void allEightViewsUseTheCorrectSignedInRole() throws Exception {
        var pages=Map.of("/ban-doc","home-title","/tim-tai-lieu","book-query","/chi-tiet-tai-lieu","document-name",
                "/nhan-vien","start-lending","/tim-ban-doc","reader-query","/cho-muon-tai-lieu","draft-rows",
                "/tim-ban-tai-lieu","loan-condition-note","/phieu-muon","print-slip");
        for(var entry:pages.entrySet()) {
            var response=get(entry.getKey());
            if(!signedIn(entry.getKey())) { assertEquals(302,response.statusCode()); continue; }
            assertEquals(200,response.statusCode(),entry.getKey()+": "+response.body());
            assertTrue(response.body().contains("id=\""+entry.getValue()+"\""));
        }
    }

    @Test void guestsCannotOpenReaderOrLibrarianAliases() throws Exception {
        for(String path:new String[]{"/","/trang-chu","/ban-doc","/tim-tai-lieu?keyword=java","/chi-tiet-tai-lieu?titleId=1","/nhan-vien","/tim-ban-doc","/cho-muon-tai-lieu","/tim-ban-tai-lieu","/phieu-muon?loanId=7"}) {
            var response=request(GUEST,path); assertEquals(302,response.statusCode(),path);
            assertTrue(response.headers().firstValue("Location").orElse("").endsWith("/dang-nhap"));
            assertFalse(response.body().contains("id=\"result-rows\""));
        }
    }

    @Test void rootAndOldHomeAddressUseReaderHomeAfterSignIn() throws Exception {
        for(String path:new String[]{"/","/trang-chu","/ban-doc"}) {
            var response=get(path);
            if(!readerSignedIn){assertEquals(302,response.statusCode());continue;}
            assertEquals(200,response.statusCode());assertTrue(response.body().contains("Trang bạn đọc"));
            assertTrue(response.body().contains("data-role=\"reader\""));
        }
    }

    @Test void readerAndStaffCannotUseEachOthersPages() throws Exception {
        if(readerSignedIn) {
            assertEquals(403,request(READER,"/nhan-vien").statusCode());
            assertEquals(403,request(READER,"/phieu-muon?loanId=7").statusCode());
        }
        if(staffSignedIn) {
            assertEquals(403,request(STAFF,"/ban-doc").statusCode());
            assertEquals(403,request(STAFF,"/tim-tai-lieu?keyword=java").statusCode());
            assertEquals(403,request(STAFF,"/chi-tiet-tai-lieu?titleId=1").statusCode());
        }
    }

    @Test void registrationGetAndPostAreRemoved() throws Exception {
        assertEquals(404,request(GUEST,"/dang-ky").statusCode());
        var post=GUEST.send(HttpRequest.newBuilder(URI.create(base+"/dang-ky")).POST(HttpRequest.BodyPublishers.ofString("username=should-not-register")).build(),HttpResponse.BodyHandlers.ofString());
        assertEquals(404,post.statusCode());
        var login=request(GUEST,"/dang-nhap"); assertEquals(200,login.statusCode());
        assertFalse(login.body().contains("/dang-ky"));assertFalse(login.body().contains("Đăng ký"));
        assertFalse(login.body().contains("href=\"/ban-doc\""));
        assertTrue(login.body().contains("name=\"password\""));assertTrue(login.body().contains("/assets/css/auth.css"));
        assertEquals(405,request(GUEST,"/dang-xuat").statusCode());
    }

    @Test void headersReflectSignedInAccount() throws Exception {
        if(readerSignedIn) assertTrue(get("/ban-doc").body().contains("id=\"account-role\">Bạn đọc</span>"));
        if(staffSignedIn) assertTrue(get("/nhan-vien").body().contains("id=\"account-role\">Nhân viên</span>"));
    }

    @Test void sharedAssetsAndUiScriptAreServed() throws Exception {
        for(String asset:new String[]{"/assets/css/style.css","/assets/css/auth.css","/assets/js/libman-ui.js"}) assertEquals(200,request(GUEST,asset).statusCode());
        if(readerSignedIn) {
            var body=get("/tim-tai-lieu").body();assertTrue(body.contains("/assets/js/libman-ui.js"));assertFalse(body.contains("/assets/js/demo-data.js"));
        }
        if(staffSignedIn) assertTrue(get("/cho-muon-tai-lieu").body().contains("/assets/js/libman-ui.js"));
    }

    @Test void queryStringsDoNotBecomeRawHtml() throws Exception {
        String input="\"><script>alert(1)</script>";
        var response=get("/tim-tai-lieu?keyword="+URLEncoder.encode(input,StandardCharsets.UTF_8));
        assertEquals(readerSignedIn?200:302,response.statusCode());assertFalse(response.body().contains("<script>alert(1)</script>"));
    }

    @Test void confirmationDialogIsOnlyIncludedWhereTheActionNeedsIt() throws Exception {
        var lend = get("/cho-muon-tai-lieu");
        var copies = get("/tim-ban-tai-lieu");
        if (!staffSignedIn) {
            assertEquals(302, lend.statusCode()); assertEquals(302, copies.statusCode()); return;
        }
        assertEquals(200, lend.statusCode()); assertEquals(200, copies.statusCode());
        assertTrue(lend.body().contains("id=\"exit-dialog\""));
        assertTrue(lend.body().contains("Tiếp tục lập phiếu"));
        assertFalse(lend.body().contains("Tiá"));
        assertFalse(copies.body().contains("id=\"exit-dialog\""));
    }

    @Test void allDemoPagesHaveValidVietnameseText() throws Exception {
        for(String path:new String[]{"/ban-doc","/tim-tai-lieu","/chi-tiet-tai-lieu","/nhan-vien","/tim-ban-doc","/cho-muon-tai-lieu","/tim-ban-tai-lieu","/phieu-muon"}) {
            var response=get(path);if(!signedIn(path)){assertEquals(302,response.statusCode());continue;}
            assertEquals(200,response.statusCode());
            for(String broken:new String[]{"áº","á»","Ã","Æ","Ä",String.valueOf((char)0xfffd)}) assertFalse(response.body().contains(broken),path+": "+broken);
        }
    }

    @Test void unknownPagesAndPrivateJspStayProtected() throws Exception {
        for(String path:new String[]{"/not-a-page","/WEB-INF/views/ReaderHome.jsp","/WEB-INF/views/LendDocument.jsp","/WEB-INF/views/Register.jsp"}) assertEquals(404,request(GUEST,path).statusCode());
    }
}
