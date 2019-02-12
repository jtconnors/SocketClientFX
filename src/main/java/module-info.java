/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

module socketclientfx {
    requires com.jtconnors.socket;
    requires java.base;
    requires java.logging;
    requires javafx.base;
    requires javafx.controls;
    requires javafx.fxml;
    requires javafx.graphics;
    exports com.jtconnors.socketclientfx;
    opens com.jtconnors.socketclientfx to javafx.fxml;
}
