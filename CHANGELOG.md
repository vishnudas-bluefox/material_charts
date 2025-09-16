# Changelog

All notable changes to this project will be documented in this file.

## [0.0.37] - 2025-01-XX

### Added

- **Gantt Chart JSON Integration** - Comprehensive JSON support for Gantt charts with Plotly compatibility
- **Multiple Factory Constructors for Gantt Charts** - Added `fromJson()`, `fromJsonString()`, `fromData()`, and `fromPlotlyFigureFactory()` constructors
- **Advanced JSON Configuration for Gantt Charts** - Support for complex styling, animations, and layout via JSON
- **Plotly Compatibility for Gantt Charts** - Seamless conversion from Plotly JSON configurations to Gantt charts
- **Enhanced Data Parsing for Gantt Charts** - Support for multiple data formats including Plotly trace objects
- **Interactive Features via JSON for Gantt Charts** - Configure tooltips, animations, and styling through JSON
- **Comprehensive Color Support** - Multiple color formats including hex, RGB, and RGBA parsing for Gantt styling

### Features

- **JSON Format Support for Gantt Charts**:
  - Plotly-compatible format for existing configurations
  - Support for task objects with Start/Finish dates
  - Advanced format with full customization options
  - Support for multiple field name variations (Task, Start, Finish, Resource, etc.)
- **Factory Constructors for Gantt Charts**:
  - `MaterialGanttChart.fromJson()` - Create from JSON map
  - `MaterialGanttChart.fromJsonString()` - Create from JSON string
  - `MaterialGanttChart.fromData()` - Quick creation from arrays
  - `MaterialGanttChart.fromPlotlyFigureFactory()` - Direct Plotly data conversion
- **Styling via JSON for Gantt Charts**:
  - Colors, animations, and layout configuration
  - Individual task colors and styling properties
  - Grid lines, padding, and interactive options
  - Tooltip styling and hover configuration
  - Customizable connection lines and timeline styling
- **Data Format Flexibility for Gantt Charts**:
  - Support for multiple date formats (ISO, MM/dd/yyyy, dd/MM/yyyy, etc.)
  - Support for Plotly figure factory format
  - Automatic color parsing from hex, RGB, and RGBA formats
  - Support for task descriptions, icons, and tap content
- **Interactive Gantt Chart Features**:
  - Animated timeline rendering with customizable curves
  - Interactive task points with hover effects
  - Detailed task information dialogs on tap
  - Configurable connection lines between tasks
  - Time grid and axis customization
  - Responsive design for various screen sizes

### Changed

- **Gantt Chart Architecture** - Enhanced for comprehensive JSON integration
- **Data Parsing System** - Improved to handle Plotly JSON data formats for Gantt charts
- **Style Configuration** - Extended to support full JSON-based customization for Gantt charts
- **Factory Constructor System** - Added convenient constructors for Plotly data conversion
- **Validation System** - Enhanced JSON validation with detailed error reporting

### Technical Details

- **Performance**: Optimized JSON parsing and Gantt chart rendering pipeline
- **Compatibility**: Fully backward compatible with existing Gantt chart implementations
- **Migration**: Easy conversion from Plotly JSON configurations to Gantt charts
- **Error Handling**: Comprehensive validation for JSON inputs with graceful fallbacks
- **Project Management Support**: Enhanced support for project timeline visualization and task scheduling

## [0.0.36] - 2025-01-XX

### Added

- **Candlestick Chart JSON Integration** - Comprehensive JSON support for candlestick charts with Plotly compatibility
- **Multiple Factory Constructors for Candlestick Charts** - Added `fromPlotlyJson()` and `fromPlotlyMap()` constructors
- **Advanced JSON Configuration for Candlestick Charts** - Support for complex styling, animations, and layout via JSON
- **Plotly Compatibility for Candlestick Charts** - Seamless conversion from Plotly JSON configurations to candlestick charts
- **Enhanced Data Parsing for Candlestick Charts** - Support for multiple data formats including Plotly trace objects
- **Interactive Features via JSON for Candlestick Charts** - Configure tooltips, animations, and styling through JSON
- **Comprehensive Color Support** - Multiple color formats including hex, RGB, and RGBA parsing for candlestick styling

### Features

- **JSON Format Support for Candlestick Charts**:
  - Plotly-compatible format for existing configurations
  - Support for OHLC (Open, High, Low, Close) data arrays
  - Advanced format with full customization options
  - Volume data support for enhanced financial analysis
- **Factory Constructors for Candlestick Charts**:
  - `MaterialCandlestickChart.fromPlotlyJson()` - Create from JSON string
  - `MaterialCandlestickChart.fromPlotlyMap()` - Create from JSON map
- **Styling via JSON for Candlestick Charts**:
  - Colors, animations, and layout configuration
  - Individual bullish/bearish candlestick colors
  - Grid lines, padding, and interactive options
  - Tooltip styling and hover configuration
  - Customizable wick and body styling
- **Data Format Flexibility for Candlestick Charts**:
  - Support for x/open/high/low/close arrays (Plotly format)
  - Support for volume data arrays
  - Automatic date parsing from strings, DateTime objects, and timestamps
  - Automatic color parsing from hex, RGB, and RGBA formats
  - Support for increasing/decreasing color configuration

### Changed

- **Candlestick Chart Architecture** - Enhanced for comprehensive JSON integration
- **Data Parsing System** - Improved to handle Plotly JSON data formats for candlestick charts
- **Style Configuration** - Extended to support full JSON-based customization for candlestick charts
- **Factory Constructor System** - Added convenient constructors for Plotly data conversion
- **Validation System** - Enhanced JSON validation with detailed error reporting

### Technical Details

- **Performance**: Optimized JSON parsing and candlestick chart rendering pipeline
- **Compatibility**: Fully backward compatible with existing candlestick chart implementations
- **Migration**: Easy conversion from Plotly JSON configurations to candlestick charts
- **Error Handling**: Comprehensive validation for JSON inputs with graceful fallbacks
- **Financial Data Support**: Enhanced support for financial data formats and volume information

## [0.0.35] - 2025-09-01

### Added

- **Area Chart JSON Integration** - Comprehensive JSON support for area charts with Plotly compatibility
- **Multiple Factory Constructors for Area Charts** - Added `fromPlotlyJson()` and `fromPlotlyMap()` constructors
- **Advanced JSON Configuration for Area Charts** - Support for complex styling, animations, and layout via JSON
- **Plotly Compatibility for Area Charts** - Seamless conversion from Plotly JSON configurations to area charts
- **Enhanced Data Parsing for Area Charts** - Support for multiple data formats including Plotly trace objects
- **Interactive Features via JSON for Area Charts** - Configure tooltips, animations, and styling through JSON

### Features

- **JSON Format Support for Area Charts**:
  - Plotly-compatible format for existing configurations
  - Support for scatter traces with fill properties
  - Advanced format with full customization options
- **Factory Constructors for Area Charts**:
  - `MaterialAreaChart.fromPlotlyJson()` - Create from JSON string
  - `MaterialAreaChart.fromPlotlyMap()` - Create from JSON map
- **Styling via JSON for Area Charts**:
  - Colors, animations, and layout configuration
  - Individual series colors and gradient effects
  - Grid lines, padding, and interactive options
  - Tooltip styling and hover configuration
- **Data Format Flexibility for Area Charts**:
  - Support for x/y arrays (Plotly format)
  - Support for scatter traces with fill properties
  - Automatic color parsing from hex, RGB, and RGBA formats
  - Gradient color support for area fills

### Changed

- **Area Chart Architecture** - Enhanced for comprehensive JSON integration
- **Data Parsing System** - Improved to handle Plotly JSON data formats for area charts
- **Style Configuration** - Extended to support full JSON-based customization for area charts
- **Factory Constructor System** - Added convenient constructors for Plotly data conversion

### Technical Details

- **Performance**: Optimized JSON parsing and area chart rendering pipeline
- **Compatibility**: Fully backward compatible with existing area chart implementations
- **Migration**: Easy conversion from Plotly JSON configurations to area charts
- **Error Handling**: Comprehensive validation for JSON inputs with graceful fallbacks

## [0.0.34] - 2025-09-01

### Added

- **Pie Chart JSON Integration** - Comprehensive JSON support for pie charts with Plotly compatibility
- **Multiple Factory Constructors** - Added `fromJson()`, `fromJsonString()`, and `fromData()` constructors for pie charts
- **Advanced JSON Configuration** - Support for complex styling, animations, and layout via JSON
- **Plotly Compatibility** - Seamless conversion from Plotly JSON configurations to pie charts
- **Enhanced Interactive Features** - Configurable hover effects, label visibility, and chart radius via JSON
- **Comprehensive Color Support** - Multiple color formats including hex, RGB, and RGBA parsing

### Features

- **JSON Format Support**:
  - Simple format for basic pie charts
  - Plotly-compatible format for existing configurations
  - Advanced format with full customization options
- **Factory Constructors**:
  - `MaterialPieChart.fromJson()` - Create from JSON map
  - `MaterialPieChart.fromJsonString()` - Create from JSON string
  - `MaterialPieChart.fromData()` - Quick creation from arrays
- **Styling via JSON**:
  - Colors, animations, and layout configuration
  - Individual slice colors and styling properties
  - Chart alignment, legend positioning, and interactive options
  - Label positioning (inside/outside) and connector line styling
- **Interactive Features**:
  - Configurable hover effects with segment highlighting
  - Label visibility controls (show only on hover)
  - Customizable chart radius and padding
  - Tap callbacks for individual segments
- **Data Format Flexibility**:
  - Support for value/label arrays (simple format)
  - Support for Plotly values/labels arrays format
  - Automatic color parsing from hex, RGB, and RGBA formats
  - Support for minimal size percentage configuration

### Changed

- **Pie Chart Architecture** - Enhanced for comprehensive JSON integration
- **Data Parsing System** - Improved to handle multiple JSON data formats
- **Style Configuration** - Extended to support full JSON-based customization
- **Factory Constructor System** - Added multiple convenient constructors for different use cases
- **Interactive System** - Enhanced hover detection and visual feedback

### Technical Details

- **Performance**: Optimized JSON parsing and chart rendering pipeline
- **Compatibility**: Fully backward compatible with existing pie chart implementations
- **Migration**: Easy conversion from existing pie chart implementations
- **Error Handling**: Comprehensive validation for JSON inputs with graceful fallbacks
- **Chart Alignment**: Support for 9 different chart alignment positions
- **Legend Positioning**: Configurable legend placement (right/bottom)

## [0.0.33] - 2025-01-XX

### Added

- **MultiLine Chart JSON Integration** - Comprehensive JSON support for multi-line charts with Plotly compatibility
- **Multiple Factory Constructors** - Added `fromJson()`, `fromJsonString()`, `fromData()`, and `fromPlotlyData()` constructors
- **Advanced JSON Configuration** - Support for complex styling, animations, and layout via JSON
- **Plotly Compatibility** - Seamless conversion from Plotly JSON configurations to multi-line charts
- **Enhanced Data Parsing** - Support for multiple data formats including arrays and object-based series
- **Interactive Features via JSON** - Configure zoom, pan, and callback functions through JSON

### Features

- **JSON Format Support**:
  - Simple format for basic multi-line charts
  - Plotly-compatible format for existing configurations
  - Advanced format with full customization options
- **Factory Constructors**:
  - `MultiLineChart.fromJson()` - Create from JSON map
  - `MultiLineChart.fromJsonString()` - Create from JSON string
  - `MultiLineChart.fromData()` - Quick creation from arrays
  - `MultiLineChart.fromPlotlyData()` - Direct Plotly data conversion
- **Styling via JSON**:
  - Colors, animations, and layout configuration
  - Individual series colors and line properties
  - Grid lines, padding, and interactive options
  - Tooltip styling and crosshair configuration
- **Data Format Flexibility**:
  - Support for x/y arrays (Plotly format)
  - Support for dataPoints arrays (simple format)
  - Support for data arrays (alternative format)
  - Automatic color parsing from hex, RGB, and RGBA formats

### Changed

- **MultiLine Chart Architecture** - Enhanced for comprehensive JSON integration
- **Data Parsing System** - Improved to handle multiple JSON data formats
- **Style Configuration** - Extended to support full JSON-based customization
- **Factory Constructor System** - Added multiple convenient constructors for different use cases

### Technical Details

- **Performance**: Optimized JSON parsing and chart rendering pipeline
- **Compatibility**: Fully backward compatible with existing multi-line chart implementations
- **Migration**: Easy conversion from existing multi-line chart implementations
- **Error Handling**: Comprehensive validation for JSON inputs with graceful fallbacks

## [0.0.32] - 2025-01-XX

### Added

- **Enhanced Line Chart Interactive Features** - Advanced hover functionality with vertical line indicators
- **Customizable Vertical Hover Lines** - Support for solid, dashed, and dotted vertical hover line styles
- **Advanced Tooltip System** - Improved tooltip positioning, styling, and point highlighting
- **Enhanced Point Highlighting** - Visual feedback with enlarged points and white borders on hover
- **Improved Curve Rendering** - Better bezier curve algorithms for smoother line connections
- **Line Style Enumeration** - New `LineStyle` enum supporting solid, dashed, and dotted line styles

### Features

- **Interactive Hover System**:
  - Vertical hover line with customizable color, width, style, and opacity
  - Smart tooltip positioning to prevent off-screen display
  - Point highlighting with 1.5x size increase and white border
  - Configurable hover detection distance (20px threshold)
- **Enhanced Line Rendering**:
  - Improved curved line path generation with better control points
  - Better handling of rounded points for different line types
  - Smoother bezier curve interpolation with intensity control
  - Optimized stroke cap and join handling for curved vs straight lines
- **Advanced Tooltip Features**:
  - Customizable background, border, and text styling
  - Automatic positioning adjustment to stay within chart bounds
  - Configurable padding and border radius

### Changed

- **Line Chart Architecture** - Enhanced painter system for better hover interaction handling
- **Curve Generation** - Improved cubic bezier curve algorithms for smoother line rendering
- **Tooltip Positioning** - Smart positioning system to prevent tooltip overflow
- **Point Rendering** - Better visual feedback system for hovered data points

### Fixed

- **Curved Line Rendering** - Fixed handling of rounded points with curved lines for better visual consistency
- **Bezier Curve Smoothness** - Improved control point generation for more natural curve transitions
- **Tooltip Overflow** - Fixed tooltip positioning to prevent display outside chart boundaries
- **Hover Detection** - Enhanced point detection accuracy with configurable distance thresholds

### Technical Details

- **Performance**: Optimized hover detection and rendering pipeline
- **Compatibility**: Fully backward compatible with existing line chart implementations
- **Architecture**: Enhanced painter system with better separation of concerns
- **Styling**: Comprehensive styling options for all interactive elements

## [0.0.31] - 2025-09-04

### Added

- **Enhanced Stacked Bar Chart JSON Support** - Comprehensive JSON integration for MaterialStackedBarChart
- **Factory Constructors for Stacked Bar Charts** - Added `fromJson()`, `fromJsonString()`, and `fromData()` constructors
- **Interactive Hover Functionality** - Enhanced user experience with hover effects on stacked bar charts
- **Improved Color Parsing** - Better color validation and parsing utilities for JSON configurations
- **Plotly Format Support** - Seamless conversion from Plotly JSON configurations to stacked bar charts

### Features

- **JSON Format Support**:
  - Simple format for basic stacked bar charts
  - Plotly-compatible format for existing configurations
  - Advanced format with full customization options
- **Factory Constructors**:
  - `MaterialStackedBarChart.fromJson()` - Create from JSON map
  - `MaterialStackedBarChart.fromJsonString()` - Create from JSON string
  - `MaterialStackedBarChart.fromData()` - Quick creation from arrays
- **Interactive Features**:
  - Hover effects with detailed segment information
  - Smooth animations and transitions
  - Responsive design for various screen sizes
- **Enhanced Error Handling**:
  - Comprehensive validation for JSON inputs
  - Better error messages and debugging support
  - Graceful fallbacks for malformed data

### Changed

- Enhanced stacked bar chart architecture for better JSON integration
- Improved color parsing and validation system
- Better error handling and validation for JSON inputs
- Enhanced documentation and examples for JSON usage

### Technical Details

- **Performance**: Optimized JSON parsing and chart rendering
- **Compatibility**: Fully backward compatible with previous versions
- **Migration**: Easy conversion from existing stacked bar chart implementations

## [0.0.30] - 2025-08-20

### Fixed

- **Dart Analyzer Warnings** - Resolved deprecated API usage and code quality issues
  - Fixed deprecated `Color.value` usage by replacing with `Color.toARGB32()`
  - Removed unused `chartArea` variable in bar chart hover handler
  - Applied `dart format` to improve code readability and consistency
  - Updated `pubspec.lock` dependencies to latest compatible versions

### Changed

- **Code Quality Improvements** - Enhanced code maintainability and standards compliance
  - Improved code formatting and consistency across all chart components
  - Enhanced error handling and validation for better stability
  - Updated development dependencies for better tooling support

### Technical Details

- **Resolved Issues**:
  - `warning: unused_local_variable` in `widgets.dart:200`
  - `info: deprecated_member_use` in `models.dart:79`
- **Performance**: No performance impact, only code quality improvements
- **Compatibility**: Fully backward compatible with previous versions

## [0.0.29] - 2025-08-18

### Added

- **Bar Chart JSON Integration** - Comprehensive Plotly-like JSON support for bar charts
- **Multiple Factory Constructors** - Added `fromJson()`, `fromJsonString()`, and `fromData()` constructors
- **Plotly Compatibility** - Seamless conversion from Plotly JSON configurations
- **Advanced JSON Configuration** - Support for complex styling, animations, and layout via JSON
- **Color Format Support** - Multiple color formats including hex, RGB, and RGBA
- **Gradient Effects via JSON** - Configure gradient effects and colors through JSON
- **Dynamic Data Loading** - Load charts from JSON strings or maps with error handling
- **Comprehensive Documentation** - New dedicated README for JSON integration features

### Features

- **JSON Format Support**:
  - Simple format for basic charts
  - Plotly-compatible format for existing configurations
  - Advanced format with full customization options
- **Factory Constructors**:
  - `MaterialBarChart.fromJson()` - Create from JSON map
  - `MaterialBarChart.fromJsonString()` - Create from JSON string
  - `MaterialBarChart.fromData()` - Quick creation from arrays
- **Styling via JSON**:
  - Colors, animations, and layout configuration
  - Individual bar colors and gradient effects
  - Grid lines, padding, and interactive options
- **Migration Support**:
  - Easy conversion from Plotly JSON
  - Compatibility mapping and examples
  - Best practices for data transformation

### Changed

- Enhanced bar chart architecture for JSON integration
- Improved error handling and validation for JSON inputs
- Better documentation and examples for JSON usage

## [0.0.28] - 2024-12-20

### Added

- **Tooltip Functionality** - Added interactive tooltip support to line charts
- **Shared Tooltip Model** - Moved tooltip model to shared space for extensibility and reusability
- Enhanced user interaction with detailed data point information

### Changed

- **Line Chart Enhancement** - Replaced sharp edges with smooth rounded edges for better visual appeal
- Improved line chart rendering with curved line segments
- Enhanced visual aesthetics across all line chart variants
- **Tooltip Architecture** - Refactored tooltip system for better code organization and maintainability

### Features

- Smooth curved line rendering instead of sharp angular connections
- Better visual flow and modern appearance
- Maintained performance while improving aesthetics
- Interactive tooltips showing data point details on hover
- Reusable tooltip components across different chart types
- Improved code maintainability through shared tooltip models

## [0.0.27] - 2024-12-19

### Added

- Enhanced documentation and examples
- Improved chart performance optimizations
- Better error handling across all chart types

### Changed

- Updated dependencies to latest stable versions
- Improved code documentation and comments
- Enhanced accessibility features

### Fixed

- Minor bug fixes and stability improvements

## [0.0.26] - 2024-12-18

### Added

- Comprehensive documentation updates
- Interactive documentation website at materialcharts.netlify.app
- Live editor for visual chart design

### Changed

- Enhanced pie chart center calculation and radius calculation
- Improved chart styling and customization options
- Better responsive design across all chart types

### Fixed

- Pie chart rendering issues
- Chart alignment problems
- Animation performance optimizations

## [0.0.25] - 2024-12-17

### Added

- Enhanced chart customization options
- Improved animation curves and durations
- Better tooltip implementations

### Changed

- Updated chart styling system
- Improved performance across all chart types
- Enhanced error handling

## [0.0.24] - 2024-12-16

### Added

- **Area Chart** - New chart type for quantitative data visualization over continuous intervals
- Enhanced pie chart calculations and rendering
- Improved chart responsiveness

### Changed

- Updated pie chart center calculation algorithm
- Enhanced radius calculation for better accuracy
- Improved chart scaling and positioning

### Fixed

- Pie chart rendering issues on different screen sizes
- Chart alignment problems in various layouts

## [0.0.23] - 2024-12-15

### Added

- **Pie Chart** - Interactive pie/donut charts with customizable segments
- Support for both pie and donut chart variants
- Customizable colors, labels, and animations
- Legend support with configurable positioning

### Features

- Animated pie chart segments
- Customizable hole radius for donut charts
- Interactive hover effects
- Configurable label positioning (inside/outside)
- Connector lines for better readability

## [0.0.22] - 2024-12-14

### Added

- Enhanced candlestick chart features
- Improved financial data visualization
- Better tooltip implementations

### Changed

- Updated candlestick chart styling
- Enhanced chart interactions

## [0.0.21] - 2024-12-13

### Added

- **CandleStick Chart** - Financial data visualization for stock market analysis
- Support for OHLC (Open, High, Low, Close) data
- Interactive tooltips with price information
- Scrollable chart view for large datasets
- Customizable colors for bullish/bearish patterns

### Features

- Animated candlestick rendering
- Grid lines and axis labels
- Hover effects with detailed information
- Responsive design for various screen sizes

## [0.0.20] - 2024-12-12

### Added

- **MultiLine Chart** - Multiple line series with interactive features
- Support for multiple data series on the same chart
- Interactive legend with series toggling
- Crosshair functionality for precise data point selection
- Zoom and pan capabilities

### Features

- Animated line rendering for each series
- Customizable colors and styles per series
- Grid lines and axis customization
- Tooltip support with series information

## [0.0.19] - 2024-12-11

### Added

- **Gantt Chart** - Project timeline visualization with interactive features
- Support for task scheduling and dependencies
- Interactive timeline with date-based navigation
- Connection lines between related tasks
- Customizable task colors and labels

### Features

- Animated timeline rendering
- Date range filtering capabilities
- Task grouping and sorting
- Responsive design for various screen sizes

## [0.0.18] - 2024-12-10

### Added

- **Hollow Semi Circle Chart** - Progress indicators in semi-circular format
- Customizable progress visualization
- Animated progress updates
- Configurable colors and styling

### Features

- Smooth progress animations
- Customizable stroke width and colors
- Responsive design

## [0.0.17] - 2024-12-09

### Added

- Enhanced stacked bar chart features
- Improved chart interactions
- Better performance optimizations

### Changed

- Updated chart styling system
- Enhanced error handling

## [0.0.16] - 2024-12-08

### Added

- **Stacked Bar Chart** - Versatile stacked bars for comparative data visualization
- Support for multiple segments per bar
- Interactive hover effects
- Customizable colors and styling

### Features

- Animated stacked bar rendering
- Grid lines and axis labels
- Value labels on segments
- Responsive design

## [0.0.15] - 2024-12-07

### Added

- Enhanced line chart features
- Improved chart animations
- Better tooltip implementations

### Changed

- Updated line chart styling
- Enhanced chart interactions

## [0.0.14] - 2024-12-06

### Added

- **Line Chart** - Animated line charts for trend visualization
- Smooth curve interpolation
- Interactive data point selection
- Customizable grid and axis

### Features

- Animated line rendering
- Grid lines and axis labels
- Hover effects with tooltips
- Responsive design

## [0.0.13] - 2024-12-05

### Added

- Enhanced bar chart features
- Improved chart interactions
- Better performance optimizations

### Changed

- Updated chart styling system
- Enhanced error handling

## [0.0.12] - 2024-12-04

### Added

- **Bar Chart** - Beautiful, interactive bar charts for discrete data visualization
- Animated bar rendering
- Interactive hover effects
- Customizable colors and styling

### Features

- Smooth bar animations
- Grid lines and axis labels
- Value labels on bars
- Responsive design

## [0.0.11] - 2024-12-03

### Added

- Initial chart framework
- Basic chart styling system
- Animation support

### Changed

- Improved code structure
- Enhanced documentation

## [0.0.10] - 2024-12-02

### Added

- Chart base classes and interfaces
- Common chart utilities
- Basic styling framework

## [0.0.9] - 2024-12-01

### Added

- Initial project structure
- Basic Flutter package setup
- Development environment configuration

## [0.0.8] - 2024-11-30

### Added

- Project initialization
- Basic documentation structure
- License and contribution guidelines

## [0.0.7] - 2024-11-29

### Added

- Repository setup
- Basic project configuration
- Development tools integration

## [0.0.6] - 2024-11-28

### Added

- Initial commit structure
- Basic project files
- Development environment setup

## [0.0.5] - 2024-11-27

### Added

- Project foundation
- Basic file structure
- Development configuration

## [0.0.4] - 2024-11-26

### Added

- Initial project setup
- Basic documentation
- Development tools

## [0.0.3] - 2024-11-25

### Added

- Repository initialization
- Basic project structure
- Development environment

## [0.0.2] - 2024-11-24

### Added

- Project foundation
- Basic configuration
- Development setup

## [0.0.1] - 2024-11-23

### Added

- Initial release of Material Charts library
- Basic Flutter package structure
- Foundation for chart development
- MIT License
- Basic documentation and README

### Features

- Flutter SDK compatibility
- Material Design aesthetics foundation
- Animation support framework
- Responsive design principles
- Accessibility support structure

---

## Version History Summary

This changelog covers the development of Material Charts from version 0.0.1 to 0.0.30, documenting the addition of various chart types and features:

- **0.0.1-0.0.11**: Foundation and basic framework
- **0.0.12**: Bar Chart implementation
- **0.0.14**: Line Chart implementation
- **0.0.16**: Stacked Bar Chart implementation
- **0.0.18**: Hollow Semi Circle Chart implementation
- **0.0.19**: Gantt Chart implementation
- **0.0.20**: MultiLine Chart implementation
- **0.0.21**: CandleStick Chart implementation
- **0.0.23**: Pie Chart implementation
- **0.0.24**: Area Chart implementation
- **0.0.26-0.0.27**: Documentation and performance improvements
- **0.0.29**: JSON integration and Plotly compatibility
- **0.0.30**: Code quality improvements and bug fixes

Each version builds upon the previous, adding new chart types and enhancing existing functionality with better performance, styling options, and user experience improvements.

## Migration Guide

### From 0.0.29 to 0.0.30

No breaking changes. This is a maintenance release focused on code quality improvements.

### From 0.0.28 to 0.0.29

The JSON integration feature is fully backward compatible. Existing code will continue to work without any changes.

### From 0.0.27 to 0.0.28

The tooltip system has been refactored for better maintainability. Existing tooltip implementations will continue to work.

## Contributing

When contributing to this project, please ensure your changes are documented in this changelog following the established format:

- Use clear, descriptive language
- Group changes by type (Added, Changed, Fixed, Removed)
- Include technical details when relevant
- Maintain chronological order (newest first)
- Follow semantic versioning principles
