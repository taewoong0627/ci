// Copyright 2016 Ben Lau
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// File adapted and modified from the following examples
// https://github.com/benlau/qtci/blob/master/bin/extract-qt-installer
// Modified from shell script to .qs file, and adapted to specific ros2/ci use

function Controller() {
    installer.installationFinished.connect(function() {
        gui.clickButton(buttons.NextButton);
    });
    installer.setMessageBoxAutomaticAnswer("OverwriteTargetDirectory", QMessageBox.Yes);
    installer.setMessageBoxAutomaticAnswer("installationErrorWithRetry", QMessageBox.Ignore);
}
Controller.prototype.WelcomePageCallback = function() {
    console.log("Welcome Page");
    // Connects with Qt over internet
    gui.clickButton(buttons.NextButton, 3000);
}
Controller.prototype.CredentialsPageCallback = function() {
    gui.clickButton(buttons.CommitButton);
}
Controller.prototype.ComponentSelectionPageCallback = function() {
    console.log("Select components");
    var widget = gui.currentPageWidget();
    if (widget != null) {
        widget.deselectAll();
        widget.selectComponent("qt.qt5.5126.win64_msvc2017_64");
    }
     gui.clickButton(buttons.NextButton);
}
Controller.prototype.IntroductionPageCallback = function() {
    console.log("Introduction Page");
    console.log("Retrieving meta information from remote repository");
    gui.clickButton(buttons.NextButton);
}
Controller.prototype.TargetDirectoryPageCallback = function() {
    // Default location is C:\Qt\Qt5.12.6
    gui.clickButton(buttons.NextButton);
}
Controller.prototype.LicenseAgreementPageCallback = function() {
    console.log("Accept license agreement");
    var widget = gui.currentPageWidget();
    if (widget != null) {
        widget.AcceptLicenseRadioButton.setChecked(true);
    }
    gui.clickButton(buttons.NextButton);
}
Controller.prototype.ReadyForInstallationPageCallback = function() {
    console.log("Ready to install");
    gui.clickButton(buttons.CommitButton);
}
Controller.prototype.FinishedPageCallback = function() {
    var widget = gui.currentPageWidget();
    if (widget.LaunchQtCreatorCheckBoxForm) {
        // No this form for minimal platform
        widget.LaunchQtCreatorCheckBoxForm.launchQtCreatorCheckBox.setChecked(false);
    }
    gui.clickButton(buttons.FinishButton);
}

// Telemetry disabled
Controller.prototype.DynamicTelemetryPluginFormCallback = function()
{
    var page = gui.pageWidgetByObjectName("DynamicTelemetryPluginForm");
    page.statisticGroupBox.disableStatisticRadioButton.setChecked(true);
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.StartMenuDirectoryPageCallback = function() {
  gui.clickButton(buttons.NextButton);
}
