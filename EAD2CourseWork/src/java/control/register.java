/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package control;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.registerInsert;

/**
 *
 * @author gayan
 */
public class register extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet register</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet register at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
 @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirm_password");

    registerInsert pd = new registerInsert();

    // 1. Check Password Mismatch
    if (password == null || !password.equals(confirmPassword)) {
        sendToErrorPage(request, response, "Passwords do not match!", 400);
        return;
    }

    // 2. Check Duplicate Username
    if (pd.isUsernameExists(username)) {
        sendToErrorPage(request, response, "The username '" + username + "' is already taken.", 409);
        return;
    }

    // 3. Check Duplicate Email
    if (pd.isEmailExists(email)) {
        sendToErrorPage(request, response, "The email '" + email + "' is already registered.", 409);
        return;
    }

    // 4. Register the User
    boolean success = pd.register(username, email, password);

    if (success) {
        request.setAttribute("username", username);
        request.getRequestDispatcher("success.jsp").forward(request, response);
    } else {
        sendToErrorPage(request, response, pd.getLastError(), 500);
    }
}

// Helper method to keep the code clean
private void sendToErrorPage(HttpServletRequest request, HttpServletResponse response, String msg, int code) 
        throws ServletException, IOException {
    request.setAttribute("jakarta.servlet.error.status_code", code);
    request.setAttribute("jakarta.servlet.error.message", msg);
    request.setAttribute("jakarta.servlet.error.request_uri", request.getRequestURI());
    request.getRequestDispatcher("error.jsp").forward(request, response);
}  /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
