package com.restaurant.ui;

import com.restaurant.algorithm.*;
import com.restaurant.dao.OrderDAO;
import com.restaurant.model.Order;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;

import java.net.URL;
import java.util.*;

/**
 * Controller for the Restaurant Order Management UI
 * 
 * This class handles all user interactions and coordinates between
 * the UI, database, and scheduling algorithms.
 */
public class RestaurantController implements Initializable {
    
    @FXML private ComboBox<String> algorithmComboBox;
    @FXML private Button applyAlgorithmButton;
    @FXML private Button refreshButton;
    @FXML private Label algorithmDescriptionLabel;
    @FXML private Label statisticsLabel;
    @FXML private Label statusLabel;
    
    // Original orders table
    @FXML private TableView<Order> originalOrdersTable;
    @FXML private TableColumn<Order, String> originalOrderNumberCol;
    @FXML private TableColumn<Order, Integer> originalTableCol;
    @FXML private TableColumn<Order, Integer> originalPriorityCol;
    @FXML private TableColumn<Order, Integer> originalTimeCol;
    @FXML private TableColumn<Order, Double> originalAmountCol;
    @FXML private TableColumn<Order, String> originalStatusCol;
    
    // Optimized orders table
    @FXML private TableView<Order> optimizedOrdersTable;
    @FXML private TableColumn<Order, String> optimizedOrderNumberCol;
    @FXML private TableColumn<Order, Integer> optimizedTableCol;
    @FXML private TableColumn<Order, Integer> optimizedPriorityCol;
    @FXML private TableColumn<Order, Integer> optimizedTimeCol;
    @FXML private TableColumn<Order, Double> optimizedAmountCol;
    @FXML private TableColumn<Order, String> optimizedStatusCol;
    
    private OrderDAO orderDAO;
    private List<SchedulingAlgorithm> algorithms;
    private ObservableList<Order> originalOrders;
    private ObservableList<Order> optimizedOrders;
    
    /**
     * Initializes the controller
     * Called automatically when the FXML is loaded
     */
    @Override
    public void initialize(URL location, ResourceBundle resources) {
        orderDAO = new OrderDAO();
        originalOrders = FXCollections.observableArrayList();
        optimizedOrders = FXCollections.observableArrayList();
        
        // Initialize algorithms
        initializeAlgorithms();
        
        // Setup UI components
        setupAlgorithmComboBox();
        setupTables();
        
        // Don't load orders automatically - let user click refresh after checking database
        // Set initial status with helpful instructions
        statusLabel.setText("⚠️ Database setup required! Click 'Refresh Orders' to see setup instructions.");
        statisticsLabel.setText("📋 SETUP REQUIRED: Run database/schema.sql in MySQL to create database and sample data (5 orders). See SETUP_INSTRUCTIONS.txt for details.");
    }
    
    /**
     * Public initialize method called from Main class
     * This ensures database connection is tested (non-blocking)
     */
    public void initialize() {
        // Test database connection in background (don't block UI)
        // User will see error when they try to refresh orders
        // This allows the UI to load even if database is not set up yet
    }
    
    /**
     * Initializes available scheduling algorithms
     */
    private void initializeAlgorithms() {
        algorithms = new ArrayList<>();
        algorithms.add(new ShortestProcessingTime());
        algorithms.add(new PriorityQueueScheduling());
        algorithms.add(new RoundRobinScheduling());
    }
    
    /**
     * Sets up the algorithm selection combo box
     */
    private void setupAlgorithmComboBox() {
        List<String> algorithmNames = new ArrayList<>();
        for (SchedulingAlgorithm algorithm : algorithms) {
            algorithmNames.add(algorithm.getAlgorithmName());
        }
        
        algorithmComboBox.setItems(FXCollections.observableArrayList(algorithmNames));
        algorithmComboBox.getSelectionModel().selectFirst();
        
        // Update description when selection changes
        algorithmComboBox.getSelectionModel().selectedItemProperty().addListener(
            (observable, oldValue, newValue) -> updateAlgorithmDescription()
        );
        
        updateAlgorithmDescription();
    }
    
    /**
     * Updates the algorithm description label
     */
    private void updateAlgorithmDescription() {
        String selected = algorithmComboBox.getSelectionModel().getSelectedItem();
        if (selected != null) {
            for (SchedulingAlgorithm algorithm : algorithms) {
                if (algorithm.getAlgorithmName().equals(selected)) {
                    algorithmDescriptionLabel.setText(algorithm.getDescription());
                    break;
                }
            }
        }
    }
    
    /**
     * Sets up the table views with columns
     */
    private void setupTables() {
        // Setup original orders table
        originalOrderNumberCol.setCellValueFactory(new PropertyValueFactory<>("orderNumber"));
        originalTableCol.setCellValueFactory(new PropertyValueFactory<>("tableId"));
        originalPriorityCol.setCellValueFactory(new PropertyValueFactory<>("priority"));
        originalTimeCol.setCellValueFactory(new PropertyValueFactory<>("estimatedTime"));
        originalAmountCol.setCellValueFactory(new PropertyValueFactory<>("totalAmount"));
        originalStatusCol.setCellValueFactory(cellData -> 
            new javafx.beans.property.SimpleStringProperty(cellData.getValue().getStatus().toString()));
        
        // Format amount column
        originalAmountCol.setCellFactory(column -> new TableCell<Order, Double>() {
            @Override
            protected void updateItem(Double amount, boolean empty) {
                super.updateItem(amount, empty);
                if (empty || amount == null) {
                    setText(null);
                } else {
                    setText(String.format("$%.2f", amount));
                }
            }
        });
        
        originalOrdersTable.setItems(originalOrders);
        
        // Setup optimized orders table
        optimizedOrderNumberCol.setCellValueFactory(new PropertyValueFactory<>("orderNumber"));
        optimizedTableCol.setCellValueFactory(new PropertyValueFactory<>("tableId"));
        optimizedPriorityCol.setCellValueFactory(new PropertyValueFactory<>("priority"));
        optimizedTimeCol.setCellValueFactory(new PropertyValueFactory<>("estimatedTime"));
        optimizedAmountCol.setCellValueFactory(new PropertyValueFactory<>("totalAmount"));
        optimizedStatusCol.setCellValueFactory(cellData -> 
            new javafx.beans.property.SimpleStringProperty(cellData.getValue().getStatus().toString()));
        
        // Format amount column
        optimizedAmountCol.setCellFactory(column -> new TableCell<Order, Double>() {
            @Override
            protected void updateItem(Double amount, boolean empty) {
                super.updateItem(amount, empty);
                if (empty || amount == null) {
                    setText(null);
                } else {
                    setText(String.format("$%.2f", amount));
                }
            }
        });
        
        optimizedOrdersTable.setItems(optimizedOrders);
    }
    
    /**
     * Refreshes the orders from the database
     */
    @FXML
    private void refreshOrders() {
        try {
            List<Order> orders = orderDAO.getAllPendingOrders();
            originalOrders.clear();
            originalOrders.addAll(orders);
            
            // Clear optimized table
            optimizedOrders.clear();
            
            statusLabel.setText("Loaded " + orders.size() + " pending order(s) from database.");
            updateStatistics(orders, null);
        } catch (Exception e) {
            String errorMessage = e.getMessage();
            String detailedMessage = "Failed to load orders: " + errorMessage;
            
            // Provide helpful message for database errors
            if (errorMessage != null && errorMessage.contains("Unknown database")) {
                detailedMessage = "❌ Database 'restaurant_db' does not exist!\n\n" +
                                 "QUICK SETUP (Choose one):\n\n" +
                                 "Option 1 - Command Line:\n" +
                                 "  mysql -u root -proot < database\\schema.sql\n\n" +
                                 "Option 2 - MySQL Workbench:\n" +
                                 "  1. Open database/schema.sql\n" +
                                 "  2. Click Execute (Ctrl+Shift+Enter)\n\n" +
                                 "Option 3 - Manual:\n" +
                                 "  Copy/paste contents of database/schema.sql into MySQL\n\n" +
                                 "After setup, restart the app and click 'Refresh Orders' again.\n\n" +
                                 "See SETUP_INSTRUCTIONS.txt for detailed steps.\n\n" +
                                 "Error: " + errorMessage;
            } else if (errorMessage != null && (errorMessage.contains("Access denied") || errorMessage.contains("password"))) {
                detailedMessage = "Database connection failed. Please check:\n" +
                                 "1. MySQL is running\n" +
                                 "2. Username and password in DatabaseConnection.java are correct\n" +
                                 "3. User has proper permissions\n\n" +
                                 "Error: " + errorMessage;
            }
            
            showAlert("Database Error", detailedMessage, Alert.AlertType.ERROR);
            statusLabel.setText("ERROR: Database connection failed. Please check database setup.");
        }
    }
    
    /**
     * Applies the selected scheduling algorithm
     */
    @FXML
    private void applyAlgorithm() {
        if (originalOrders.isEmpty()) {
            showAlert("No Orders", "Please load orders first by clicking 'Refresh Orders'.", 
                     Alert.AlertType.INFORMATION);
            return;
        }
        
        String selectedAlgorithm = algorithmComboBox.getSelectionModel().getSelectedItem();
        if (selectedAlgorithm == null) {
            showAlert("No Algorithm Selected", "Please select a scheduling algorithm.", 
                     Alert.AlertType.WARNING);
            return;
        }
        
        try {
            // Find the selected algorithm
            SchedulingAlgorithm algorithm = null;
            for (SchedulingAlgorithm alg : algorithms) {
                if (alg.getAlgorithmName().equals(selectedAlgorithm)) {
                    algorithm = alg;
                    break;
                }
            }
            
            if (algorithm == null) {
                throw new Exception("Algorithm not found");
            }
            
            // Convert ObservableList to regular List for algorithm
            List<Order> ordersToSchedule = new ArrayList<>(originalOrders);
            
            // Apply the scheduling algorithm
            List<Order> scheduledOrders = algorithm.schedule(ordersToSchedule);
            
            // Update optimized table
            optimizedOrders.clear();
            optimizedOrders.addAll(scheduledOrders);
            
            // Update statistics
            updateStatistics(originalOrders, scheduledOrders);
            
            statusLabel.setText("Applied " + algorithm.getAlgorithmName() + " algorithm successfully. " +
                              "Note: Status remains PENDING - algorithms only optimize display order.");
            
        } catch (Exception e) {
            showAlert("Error", "Failed to apply algorithm: " + e.getMessage(), Alert.AlertType.ERROR);
            statusLabel.setText("ERROR: Failed to apply algorithm!");
            e.printStackTrace();
        }
    }
    
    /**
     * Updates the statistics label with order information
     * 
     * @param original Original order list
     * @param optimized Optimized order list (can be null)
     */
    private void updateStatistics(List<Order> original, List<Order> optimized) {
        if (original == null || original.isEmpty()) {
            statisticsLabel.setText("No orders to display.");
            return;
        }
        
        // Calculate statistics for original orders
        int totalOrders = original.size();
        int totalTime = original.stream().mapToInt(Order::getEstimatedTime).sum();
        double totalAmount = original.stream().mapToDouble(Order::getTotalAmount).sum();
        double avgTime = totalTime / (double) totalOrders;
        
        StringBuilder stats = new StringBuilder();
        stats.append(String.format("Original: %d orders | Total Time: %d min | Avg Time: %.1f min | Total Amount: $%.2f", 
                                  totalOrders, totalTime, avgTime, totalAmount));
        
        if (optimized != null && !optimized.isEmpty()) {
            // Calculate statistics for optimized orders
            int optTotalTime = optimized.stream().mapToInt(Order::getEstimatedTime).sum();
            double optAvgTime = optTotalTime / (double) optimized.size();
            
            // Calculate cumulative waiting time (for comparison)
            int cumulativeWait = 0;
            int currentTime = 0;
            for (Order order : optimized) {
                cumulativeWait += currentTime;
                currentTime += order.getEstimatedTime();
            }
            
            stats.append(String.format(" | Optimized Avg Time: %.1f min | Cumulative Wait: %d min", 
                                      optAvgTime, cumulativeWait));
        }
        
        statisticsLabel.setText(stats.toString());
    }
    
    /**
     * Shows an alert dialog
     * 
     * @param title Alert title
     * @param message Alert message
     * @param alertType Type of alert
     */
    private void showAlert(String title, String message, Alert.AlertType alertType) {
        Alert alert = new Alert(alertType);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }
}

