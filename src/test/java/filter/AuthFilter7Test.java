package filter;

import java.lang.reflect.Proxy;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.junit.Test;
import static org.junit.Assert.*;

public class AuthFilter7Test {
    @Test public void guestCannotOpenManagerJspDirectly() throws Exception {
        Exchange exchange = new Exchange("/view/manager/ManagerMainUI7.jsp", "GET");
        exchange.run();
        assertFalse(exchange.allowed);
        assertEquals("/CineMan7/login", exchange.redirect);
        assertEquals("/view/manager/ManagerMainUI7.jsp", exchange.sessionData.get("afterLogin"));
    }

    @Test public void customerAndSalesCannotUseStatisticsEndpoints() throws Exception {
        for (String role : new String[]{"CUSTOMER", "SALES"}) {
            Exchange exchange = new Exchange("/customerTransaction", "GET");
            exchange.sessionData.put("currentUser", new Object());
            exchange.sessionData.put("role", role);
            exchange.run();
            assertFalse(exchange.allowed);
            assertEquals(403, exchange.status);
        }
    }

    @Test public void managerPostRequiresMatchingCsrfToken() throws Exception {
        Exchange exchange = new Exchange("/statView", "POST");
        exchange.sessionData.put("currentUser", new Object());
        exchange.sessionData.put("role", "MANAGER");
        exchange.sessionData.put("csrfToken", "valid-token");
        exchange.run();
        assertFalse(exchange.allowed);
        assertEquals(403, exchange.status);
        exchange.token = "valid-token";
        exchange.status = 200;
        exchange.run();
        assertTrue(exchange.allowed);
        assertEquals("no-store", exchange.headers.get("Cache-Control"));
    }

    @Test public void publicSearchDoesNotRequireLoginAndSetsUtf8() throws Exception {
        Exchange exchange = new Exchange("/searchMovie", "GET");
        exchange.run();
        assertTrue(exchange.allowed);
        assertEquals("UTF-8", exchange.requestEncoding);
        assertNotNull(exchange.sessionData.get("csrfToken"));
    }

    private static class Exchange {
        final Map<String,Object> sessionData = new HashMap<>();
        final Map<String,String> headers = new HashMap<>();
        final String path, method;
        boolean allowed;
        int status = 200;
        String token, redirect, requestEncoding;

        Exchange(String path, String method) { this.path = path; this.method = method; }

        void run() throws Exception {
            HttpSession session = (HttpSession) Proxy.newProxyInstance(getClass().getClassLoader(),
                    new Class[]{HttpSession.class}, (p,m,a) -> {
                        if (m.getName().equals("getAttribute")) return sessionData.get(a[0]);
                        if (m.getName().equals("setAttribute")) sessionData.put((String)a[0], a[1]);
                        return null;
                    });
            HttpServletRequest request = (HttpServletRequest) Proxy.newProxyInstance(getClass().getClassLoader(),
                    new Class[]{HttpServletRequest.class}, (p,m,a) -> {
                        switch (m.getName()) {
                            case "getSession": return session;
                            case "getServletPath": return path;
                            case "getMethod": return method;
                            case "getParameter": return "csrfToken".equals(a[0]) ? token : null;
                            case "getContextPath": return "/CineMan7";
                            case "setCharacterEncoding": requestEncoding = (String)a[0]; break;
                            default: break;
                        }
                        return null;
                    });
            HttpServletResponse response = (HttpServletResponse) Proxy.newProxyInstance(getClass().getClassLoader(),
                    new Class[]{HttpServletResponse.class}, (p,m,a) -> {
                        switch (m.getName()) {
                            case "sendError": status = (Integer)a[0]; break;
                            case "sendRedirect": redirect = (String)a[0]; break;
                            case "setHeader": headers.put((String)a[0], (String)a[1]); break;
                            default: break;
                        }
                        return null;
                    });
            new AuthFilter7().doFilter(request, response, (req,res) -> allowed = true);
        }
    }
}
