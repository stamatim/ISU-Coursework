/*
AUTHOR: STAMATI MORELLAS
CLASS: COM S 363
PROFESSOR: GADIA
DUE DATE: MONDAY, MAR 4, 2019
*/
package JDBC;

import javax.xml.transform.Result;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.sql.*;
import java.io.File;

public class JDBC_Students {
    public static void main(String[] args) throws Exception {
        // Load and register a JDBC driver
        try {
            // Load the driver (registers itself)
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception E) {
            System.err.println("Unable to load driver.");
            E.printStackTrace();
        }
        try {
            // Connect to the database
            Connection conn1;
            String dbUrl = "jdbc:mysql://csdb.cs.iastate.edu:3306/db363morellas";
            String user = "dbu363morellas";
            String password = "BchC4160";
            conn1 = DriverManager.getConnection(dbUrl, user, password);
            System.out.println("*** Connected to the database ***");

            //////////////////////////////////////////////// PART A /////////////////////////////////////////////////
            ///////////////////////////// Update credit hours, classification, and GPAs /////////////////////////////
            ResultSet rs1;
            ResultSet rs2;
            Statement statement1 = conn1.createStatement();
            Statement statement2 = conn1.createStatement();

            // Use a prepared statement with things to update in the student table
            PreparedStatement ps = conn1.prepareStatement( "UPDATE Student" + " " + "SET CreditHours=? , Classification=?, GPA=?");

            // Execute the query that selects the information from the student table
            rs1 = statement1.executeQuery("SELECT * FROM Student s");
            // Execute the query that
            rs2 = statement2.executeQuery("SELECT e.StudentID, e.Grade FROM Enrollment e");

            // Variables to use
            int ch; // The credit hours to update
            String eid; // The enrollment id of the student in a class
            String sid = ""; // The student id
            String classi = ""; // The classification to update
            double GPA; // The total gpa
            double grade; // The grade that the student got in a class

            // For each student, update the credit hours, classification, and the GPA, taking into account the current GPA and grades in the courses the student is currently enrolled in. All the courses are 3 credit courses
            System.out.println("Updating student information...");
            while (rs1.next()) {

                // Parse the current row of the student and enrollment tables
                ch = rs1.getInt("CreditHours");
                eid = rs2.getString("StudentID");
                sid = rs1.getString("StudentID");
                classi = rs1.getString("Classification");
                GPA = rs1.getDouble("GPA");
                grade = rs2.getDouble("Grade");

                // Update the credit hours
                ch += ch;

                // Update the classification
                if (ch <= 29) {
                    classi = "Freshman";
                } else if (ch > 29 && ch <= 59) {
                    classi = "Sophomore";
                } else if (ch > 59 && ch <=80) {
                    classi = "Junior";
                } else {
                    classi = "Senior";
                }
                ps.setString(2, classi);
                ps.executeUpdate();

                // Note: Did not finish


                // TODO Update the GPA
            } // End Part A

            //////////////////////////////////////////////// PART B ////////////////////////////////////////////////
            //////////////////////////////////// List top five or more seniors /////////////////////////////////////
            ResultSet rs3;
            Statement statement3 = conn1.createStatement();
            // Execute query that selects the names of seniors, names of their mentors, and GPA in descending order of GPA values
            rs3 = statement3.executeQuery("SELECT s.StudentID, s.Classification, s.MentorID, s.GPA, s.CreditHours FROM Student s ORDER BY GPA DESC");

            // Variables
            int i = 0; // starting length
            int j = 5; // increases if more than 1 student have the same gpa
            String studentId = "";
            String classification = "";
            double gpa = -1.0;
            double gpaPrev = -1.0; // The previous student's gpa
            String mentorId = "";

            // Create and link the output file
            File file = new File("JDBC_StudentsOutput.txt");
            FileWriter fw = new FileWriter(file);
            PrintWriter pw = new PrintWriter(fw);

            // Go through the result set of the previously executed query and print the names of the students, names of their mentors, and their GPA,
            // for top 5 or more seniors.
            //
            // Note: This list may contain less than 5 distinct GPA-values and more than 5 students. This is because some students may have the same GPA.
            // After having taken top 5 students into account, you should include those students who have the same GPA as the 5th student.
            System.out.println("Printing the top 5 students based on GPA...\n\n");
            while (rs3.next()) {

                // Parse the current row of the student table
                studentId = rs3.getString("StudentID");
                classification = rs3.getString("Classification");
                gpa = rs3.getDouble("GPA");
                mentorId = rs3.getString("MentorID");

                // Print the info of the top 5 seniors to the output file
                if (classification.equals("Senior")) { // check to make sure student is a senior
                    // If the there haven't been 5 seniors selected yet
                    if (i < j) {
                        pw.println("Student: " + studentId + " Classification: " + classification + " GPA: " + gpa + " Mentor: " + mentorId);
                    }
                    // Include the students that have the same GPA as the 5th student
                    if (i >= j && gpaPrev == gpa) {
                        j++;
                        pw.println("Student: " + studentId + " Classification: " + classification + " GPA: " + gpa + " Mentor: " + mentorId);
                    }
                    i++; // Increment the number of seniors that have been added to the output file
                }
            } // End Part B

            // Close all statements and connections
            System.out.println("Closing all connections...\n\n");
            pw.close();
            fw.close();
            statement1.close();
            statement2.close();
            statement3.close();
            ps.close();
            rs1.close();
            rs2.close();
            rs3.close();
            conn1.close();
        } // End of try
        catch (SQLException e) {
            System.out.println("SQLException: " + e.getMessage());
            System.out.println("SQLState: " + e.getSQLState());
            System.out.println("VendorError: " + e.getErrorCode());
        } // End of catch
    }
}