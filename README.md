# OnlineWebForum / EAD2CourseWork

## Overview
This is a Java Web Application built for the EAD-2 CourseWork. It is an online forum and e-commerce-style platform that includes comprehensive features for user engagement, administration, and modern UI components.

## Features

- **User Authentication:** 
  - Secure login and registration system.
  - User profile management with session handling.
  
- **Admin Dashboard:**
  - View platform statistics (total users, active posts).
  - Manage users (ban/unban, delete accounts).
  - Administer platform content.

- **Product Review & Q&A System:**
  - Toggleable product review sections.
  - Display average ratings and review lists.
  - Fully functional Q&A interactive forms.

- **Commenting System:**
  - Users can post, view, and delete their own comments.
  - Administrators have elevated privileges to delete any comment.

- **Dynamic UI/UX:**
  - Persistent "Mini Sidebar" that expands on hover.
  - Real-time UI updates (e.g., displaying user data in the header after login).

## Technology Stack

- **Backend:** Java EE (Servlets, JSP)
- **Database:** Relational Database with JDBC (DAO Pattern)
- **Frontend:** HTML, CSS, JavaScript (Custom Responsive UI)
- **Build Tool:** Ant (`build.xml`)
- **IDE:** Compatible with NetBeans / Eclipse

## Getting Started

1. **Clone the repository.**
2. **Database Setup:** 
   Ensure your database is running and verify the credentials in `src/java/config.properties`.
3. **Build & Run:** 
   Open the project in your IDE (e.g., NetBeans) or use Ant to build the `EAD2CourseWork` project and deploy it to your local server (e.g., Apache Tomcat or GlassFish).
4. **Access the Application:** 
   Navigate to the local server URL (typically `http://localhost:8080/EAD2CourseWork`).

## Project Structure
- `src/java/`: Java source files including Servlets (`control`), Models (`model`), and DAOs.
- `web/`: Contains JSP files, CSS, JavaScript, and other web resources.
- `build.xml`: Ant build script.
