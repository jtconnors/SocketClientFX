/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

module SocketClientFX {
    requires com.jtconnors.socket;
    requires java.base;
    requires java.logging;
    requires javafx.base;
    requires javafx.controls;
    requires javafx.fxml;
    requires javafx.graphics;
    exports socketclientfx;
    opens socketclientfx to javafx.fxml;
}
