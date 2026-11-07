package vn.edu.library;

import java.nio.file.Files;
import java.nio.file.Path;
import org.apache.catalina.Context;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

/** Chạy project từ Maven mà không cần cài Tomcat riêng. */
public class Application {
    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(System.getProperty("port", "8080"));
        Tomcat tomcat = start(port);
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            try {
                tomcat.stop();
                tomcat.destroy();
            } catch (Exception exception) {
                exception.printStackTrace();
            }
        }));
        System.out.println("LIBMAN: http://localhost:" + port);
        tomcat.getServer().await();
    }

    public static Tomcat start(int port) throws Exception {
        Path base = Path.of("target", "tomcat").toAbsolutePath();
        Files.createDirectories(base);
        Tomcat tomcat = new Tomcat();
        tomcat.setBaseDir(base.toString());
        tomcat.setPort(port);
        tomcat.getConnector().setURIEncoding("UTF-8");

        Context context = tomcat.addWebapp("", Path.of("src/main/webapp").toAbsolutePath().toString());
        context.setParentClassLoader(Application.class.getClassLoader());
        // Đưa các class đã biên dịch vào WEB-INF/classes của webapp khi chạy cục bộ.
        StandardRoot resources = new StandardRoot(context);
        resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                Path.of("target/classes").toAbsolutePath().toString(), "/"));
        context.setResources(resources);
        tomcat.start();
        return tomcat;
    }
}
