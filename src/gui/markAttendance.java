/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
package gui;

import com.fazecast.jSerialComm.SerialPort;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Scanner;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;
import model.MySQL2;

/**
 *
 * @author Acer
 */
public class markAttendance extends javax.swing.JFrame {

    private volatile boolean keepRunning = false;
    private SerialPort arduinoPort = null;
    private Thread rfidThread = null;

    /**
     * Creates new form markAttendance
     */
    public markAttendance() {
        initComponents();
        markAttendance();
        loadAttendance();
    }

    private void markAttendance() {
        keepRunning = true;

        rfidThread = new Thread(() -> {
            arduinoPort = SerialPort.getCommPort("COM5");
            arduinoPort.setComPortParameters(9600, 8, 1, 0);
            arduinoPort.setComPortTimeouts(SerialPort.TIMEOUT_SCANNER, 0, 0);

            if (arduinoPort.openPort()) {
                System.out.println("Connected to Arduino!");
                jLabel2.setText("Successfully Connected");
            } else {
                System.out.println("Failed to connect to Arduino.");
                jLabel2.setText("Failed To Create Connection");
                return;
            }

            try (Scanner scanner = new Scanner(arduinoPort.getInputStream())) {
                while (keepRunning) {
                    if (scanner.hasNextLine()) {
                        String rfidData = scanner.nextLine();
                        if (rfidData.startsWith("UID:")) {
                            String extractedRFID = rfidData.replace("UID:", "").trim();
                            System.out.println("Scanned RFID Tag: " + extractedRFID);

                            LocalDateTime now = LocalDateTime.now();
                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                            String formattedDateTime = now.format(formatter);

                            try {
                                ResultSet rs = MySQL2.executeSearch("SELECT * FROM `attendance` WHERE `check_out` IS NULL AND `employee_nic` = '" + extractedRFID + "';");
                                if (rs.next()) {
                                    String check_in = rs.getString("check_in");

                                    DateTimeFormatter formatter1 = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                                    LocalDateTime checkInTime = LocalDateTime.parse(check_in, formatter1);

                                    LocalDateTime checkOutTime = LocalDateTime.now();

                                    long workHours = Duration.between(checkInTime, checkOutTime).toHours();
                                    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                                    String formattedDate = now.format(dtf);

                                    MySQL2.executeIUD("UPDATE attendance SET `check_out` = '" + formattedDateTime + "',`worktime` = '" + workHours + "' WHERE `employee_nic` = '" + rs.getString("employee_nic") + "' "
                                            + "AND `check_in` LIKE '" + formattedDate + "%' ");
                                    loadAttendance();
                                    System.out.println("Successfully updated.");

                                } else {

                                    ResultSet rs1 = MySQL2.executeSearch("SELECT * FROM `attendance` WHERE `employee_nic` = '" + extractedRFID + "' AND `check_in` LIKE '%" + LocalDate.now() + "%'");

                                    if (rs1.next()) {
                                        JOptionPane.showMessageDialog(rootPane, "This employee alrady marked the attendance", "Warning", JOptionPane.WARNING_MESSAGE);
                                    } else {

                                        MySQL2.executeIUD("INSERT INTO `attendance` (`check_in`,`check_out`,`employee_nic`,`worktime`)"
                                                + "VALUES('" + formattedDateTime + "',NULL,'" + extractedRFID + "',NULL)");
                                        loadAttendance();
                                        System.out.println("Successfully marked.");

                                    }
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                Logger loggerFile = SplashScreen.getLoggerFile();
                                loggerFile.log(Level.SEVERE, "markAttendance1", e);
                            }

                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                Logger loggerFile = SplashScreen.getLoggerFile();
                loggerFile.log(Level.SEVERE, "getKeyCode", e);
            } finally {
                if (arduinoPort != null && arduinoPort.isOpen()) {
                    arduinoPort.closePort();
                    System.out.println("Port closed.");
                }
            }
        });

        rfidThread.start();
    }

    public void loadAttendance() {
        try {
            ResultSet rs = MySQL2.executeSearch("SELECT * FROM `attendance` INNER JOIN `employee` ON"
                    + "`attendance`.`employee_nic` = `employee`.`nic` WHERE `check_in` LIKE '%" + LocalDate.now() + "%'");
            DefaultTableModel model = (DefaultTableModel) jTable1.getModel();
            model.setRowCount(0);
            while (rs.next()) {

                Vector<String> vector = new Vector<>();
                vector.add(rs.getString("employee_nic"));
                vector.add(rs.getString("first_name") + " " + rs.getString("last_name"));
                vector.add(rs.getString("check_in"));
                vector.add(rs.getString("check_out"));

                model.addRow(vector);
            }

        } catch (Exception e) {
            e.printStackTrace();
            Logger loggerFile = SplashScreen.getLoggerFile();
            loggerFile.log(Level.SEVERE, "loadAttendance", e);
        }
    }

    public void stopMarkAttendance() {
        keepRunning = false;

        if (rfidThread != null && rfidThread.isAlive()) {
            try {
                rfidThread.join(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        if (arduinoPort != null && arduinoPort.isOpen()) {
            arduinoPort.closePort();
            System.out.println("Port  closed.");
        }
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosed(java.awt.event.WindowEvent evt) {
                formWindowClosed(evt);
            }
        });

        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "Employee Id", "Employee Name", "Check-In", "Check-out"
            }
        ) {
            boolean[] canEdit = new boolean [] {
                false, false, true, false
            };

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        jScrollPane1.setViewportView(jTable1);

        jLabel1.setText("Mark Your Attendance By tag your Card");

        jLabel2.setForeground(new java.awt.Color(153, 0, 0));

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(16, 16, 16)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 475, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 756, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 461, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(23, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGap(14, 14, 14)
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 70, Short.MAX_VALUE)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 355, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(29, 29, 29))
        );

        pack();
        setLocationRelativeTo(null);
    }// </editor-fold>//GEN-END:initComponents

    private void formWindowClosed(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowClosed
        stopMarkAttendance();
    }//GEN-LAST:event_formWindowClosed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(markAttendance.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(markAttendance.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(markAttendance.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(markAttendance.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new markAttendance().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTable jTable1;
    // End of variables declaration//GEN-END:variables

}
