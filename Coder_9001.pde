// Coder_9000 recoded from python to... Whatever the heck Processing is //
// Developed by Jason Foster, jf727@nau.edu, June 2019 //

// To anyone wanting to do future work on this the codes.txt file //
// uses a X:Name:path1,path2,.... format. If the taxonomy changes //
// place the single value string in place of X. The name you want //
// prompted on screen goes in Name. All possible paths the taxonomy //
// can go from here is a list seperated by a "," . If there is no path //
// Type END. You must use ":" to seperate thirds and "," to seperate path //


// Import stuff Goes here //

import java.io.File;
import java.io.FileWriter;
import java.io.*;
import java.io.LineNumberReader;

// Every major variable will be defined here. Hopefully my //
// Amazing variable names will make knowing what's what easy //

boolean IsOnStartScreen = false;
boolean GetNewSubjectID = false;
boolean GetExistingSubjectID = false;
boolean NewCodeSheet = false;
boolean IsEnteringStartTime = true;
boolean IsEnteringEndTime = false;
boolean IsEnteringComments = false;
boolean CodingSheet = false;
boolean EnterCode = false;

String SubjectID = "";
String StartTime = "";
String EndTime = "";
String Comments = "";
String CodeInProgress = "";
String LastEnteredCode = "";

String[] CodeValue = new String[75];
String[] CodeName = new String[75];
String NextPossibleCode = "";
String[] codeLine = new String[3];
String[] PossiblePath = new String[75];

String LEC = "";

FileWriter csvWriter;
BufferedReader buffread;

// Create the initial window that the coder will rest on //

void setup() {
  size(367, 125);
  surface.setResizable(true);
  IsOnStartScreen = true;
}

// check which state Im in and draw the necessary stuff //

void draw() {
  background(0);
  // Create my start screen //
  if (IsOnStartScreen) {
    text("Coder_9000 Developed By Jason Foster, jf727@nau.edu", 20, 20);
    text("To create a new sheet, press 1", 40, 40);
    text("To update an existing sheet, press 5", 40, 60);
  }
  // check to ensure this is actually a new sheet, then create it //
  else if (GetNewSubjectID) {
    text("Creating New Sheet, If this Is not intended press Spacebar", 20, 20);
    text("Enter EFI_ID_YourName, EX: EFI200Jason", 20, 40);
    text(SubjectID, 120, 60);
    text("Press enter when you are ready", 20, 80);
  }
  // Check to ensure the sheet exists, then open it
  else if (GetExistingSubjectID) {
    text("Loading existing Sheet, If this Is \nnot intended press Spacebar", 20, 20);
    text("Enter filename, no extension EX: EFI200Jason", 20, 60);
    text(SubjectID, 20, 80);
    text("Press enter when you are ready", 20, 100);
  }
  else if (NewCodeSheet) {
    surface.setSize(675, 550);
    text("Start Time (mm.ss.fff): ", 20, 10);
    text(StartTime, 175, 10);
    text("End Time (mm.ss.fff): ", 20, 35);
    text(EndTime, 175, 35);
    text("Enter comment:  ", 20, 60);
    text(Comments, 175, 60);
    text("Code:  ", 20, 100);
    CodeInProgress = "0";
    text(CodeInProgress, 175, 100);
    text("type to enter stuff. \nHitting Enter will change where you enter stuff", 20, 150);
    text("click screen to enter code", 20, 180);
  }
  else if (CodingSheet) {
    surface.setSize(675, 550); //<>//
    text("Start Time (mm.ss.fff): ", 20, 10);
    text(StartTime, 175, 10);
    text("End Time (mm.ss.fff): ", 20, 35);
    text(EndTime, 175, 35);
    text("Enter comment:  ", 20, 60);
    text(Comments, 175, 60);
    text("Code:  ", 20, 100);
    text(CodeInProgress, 175, 100);
    text("Type the number next to the Code to build it. \n EX: 1 Eating Behaviors means push 1", 20, 150);
    text("press tab if you entered the wrong code \n to go back one", 20, 190);
    text("Last Entered Code is:", 20, 330);
    text(LEC, 20, 350);
    // add my taxonomy //
    if (CodeInProgress.length() == 0 || LastEnteredCode.length() == 0) {
      File CodesFile = new File(sketchPath() + File.separator + "codes.txt");
      try {
        buffread = new BufferedReader(new FileReader(CodesFile));
        String readString;
        codeLine = new String[3];
        CodeValue = new String[75];
        CodeName = new String[75];
        readString = buffread.readLine();
        codeLine = readString.split(":", 0);
        NextPossibleCode = codeLine[2];
        PossiblePath[0] = codeLine[2];
        CodeValue[0] = codeLine[0];
        CodeName[0] = codeLine[1];
        text(codeLine[0], 350, 20);
        text(codeLine[1], 450, 20);
      }
      catch (FileNotFoundException e) {
      }
      catch (IOException ee) {
      }
    }
    // The Hard Coded part of the taxononmy, Future Developer If your reading //
    // this, This else if is what you wanna remove if the taxonmy changes //
    else if (CodeInProgress.length() == 6) {
      PossiblePath = new String[75]; //<>//
      String twoBefore = CodeInProgress.substring(CodeInProgress.length()-2, CodeInProgress.length()-1);
      if (twoBefore.equals("7")) {
        CodeValue[0] = "M";
        CodeValue[1] = "m";
        CodeValue[2] = "S";
        CodeValue[3] = "e";
        CodeValue[4] = "T";
        CodeValue[5] = "Z";
        CodeValue[6] = "r";
        CodeValue[7] = "W";
        CodeValue[8] = "C";
        CodeValue[9] = "c";
        CodeValue[10] = "s";
        CodeValue[11] = "Y";
        CodeValue[12] = "B";
        CodeValue[13] = "G";
        CodeValue[14] = "X";
        CodeValue[15] = "V";
        CodeName[0] = "Mug";
        CodeName[1] = "Mason";
        CodeName[2] = "Stein";
        CodeName[3] = "Espresso";
        CodeName[4] = "Teacup";
        CodeName[5] = "Pitcher";
        CodeName[6] = "Red_Wine";
        CodeName[7] = "White_Wine";
        CodeName[8] = "Champagne";
        CodeName[9] = "Cognac";
        CodeName[10] = "Shot";
        CodeName[11] = "Can";
        CodeName[12] = "Bottle";
        CodeName[13] = "Glass";
        CodeName[14] = "Cup";
        CodeName[15] = "Carton";
        PossiblePath[0] = "To,Near,From,Hover";
        PossiblePath[1] = "To,Near,From,Hover";
        PossiblePath[2] = "To,Near,From,Hover";
        PossiblePath[3] = "To,Near,From,Hover";
        PossiblePath[4] = "To,Near,From,Hover";
        PossiblePath[5] = "To,Near,From,Hover";
        PossiblePath[6] = "To,Near,From,Hover";
        PossiblePath[7] = "To,Near,From,Hover";
        PossiblePath[8] = "To,Near,From,Hover";
        PossiblePath[9] = "To,Near,From,Hover";
        PossiblePath[10] = "To,Near,From,Hover";
        PossiblePath[11] = "To,Near,From,Hover";
        PossiblePath[12] = "To,Near,From,Hover";
        PossiblePath[13] = "To,Near,From,Hover";
        PossiblePath[14] = "To,Near,From,Hover";
        PossiblePath[15] = "To,Near,From,Hover";
        text(CodeValue[0], 350, 20);
        text(CodeName[0], 450, 20);
        text(CodeValue[1], 350, 40);
        text(CodeName[1], 450, 40);
        text(CodeValue[2], 350, 60);
        text(CodeName[2], 450, 60);
        text(CodeValue[3], 350, 80);
        text(CodeName[3], 450, 80);
        text(CodeValue[4], 350, 100);
        text(CodeName[4], 450, 100);
        text(CodeValue[5], 350, 120);
        text(CodeName[5], 450, 120);
        text(CodeValue[6], 350, 140);
        text(CodeName[6], 450, 140);
        text(CodeValue[7], 350, 160);
        text(CodeName[7], 450, 160);
        text(CodeValue[8], 350, 180);
        text(CodeName[8], 450, 180);
        text(CodeValue[9], 350, 200);
        text(CodeName[9], 450, 200);
        text(CodeValue[10], 350, 220);
        text(CodeName[10], 450, 220);
        text(CodeValue[11], 350, 240);
        text(CodeName[11], 450, 240);
        text(CodeValue[12], 350, 260);
        text(CodeName[12], 450, 260);
        text(CodeValue[13], 350, 280);
        text(CodeName[13], 450, 280);
        text(CodeValue[14], 350, 300);
        text(CodeName[14], 450, 300);
        text(CodeValue[15], 350, 320);
        text(CodeName[15], 450, 320);
      }
      else if (twoBefore.equals("8")) {
        CodeValue[0] = "F";
        CodeValue[1] = "D";
        CodeValue[2] = "K";
        CodeValue[3] = "d";
        CodeValue[4] = "A";
        CodeName[0] = "Fork";
        CodeName[1] = "Spoon";
        CodeName[2] = "Knife";
        CodeName[3] = "Spork";
        CodeName[4] = "Chopsticks";
        PossiblePath[0] = "To,Near,From,Hover";
        PossiblePath[1] = "To,Near,From,Hover";
        PossiblePath[2] = "To,Near,From,Hover";
        PossiblePath[3] = "To,Near,From,Hover";
        PossiblePath[4] = "To,Near,From,Hover";
        text(CodeValue[0], 350, 20);
        text(CodeName[0], 450, 20);
        text(CodeValue[1], 350, 40);
        text(CodeName[1], 450, 40);
        text(CodeValue[2], 350, 60);
        text(CodeName[2], 450, 60);
        text(CodeValue[3], 350, 80);
        text(CodeName[3], 450, 80);
        text(CodeValue[4], 350, 100);
        text(CodeName[4], 450, 100);
      }
      else {
        CodeValue[0] = "U";
        CodeValue[1] = "O";
        CodeValue[2] = "b";
        CodeName[0] = "Thumb_Under";
        CodeName[1] = "Thumb_Over";
        CodeName[2] = "Thumb_Sideways";
        PossiblePath[0] = "Direct,Inversion";
        PossiblePath[1] = "Direct,Inversion";
        PossiblePath[2] = "Direct,Inversion";
        text(CodeValue[0], 350, 20);
        text(CodeName[0], 450, 20);
        text(CodeValue[1], 350, 40);
        text(CodeName[1], 450, 40);
        text(CodeValue[2], 350, 60);
        text(CodeName[2], 450, 60);
      }
      noLoop();
    }
    else { 
      // recover my previously entered code line in taxnomy //
      for (int i = 0; i < 75; i++) {
        try {
          File CodesFile = new File(sketchPath() + File.separator + "codes.txt");
          buffread = new BufferedReader(new FileReader(CodesFile));
          String readString = buffread.readLine();
          while(readString != null) {
            codeLine = readString.split(":", 0);
            // Do we have a Match? //
            String CL0 = codeLine[0];
            if (CL0.equals(LastEnteredCode)) {
              // We found it! Now we need to gather the final third of this line //
              NextPossibleCode = codeLine[2];
              break;
            }
            readString = buffread.readLine();
          }
          break;
        }
        catch (FileNotFoundException e) {
        }
        catch (IOException ee) {
        }
      }
      // now lets get all of our possible paths //
      PossiblePath = NextPossibleCode.split(",", 0);
      // Now lets find them in the taxonomy so we can recover the first //
      // 2/3's of info //
      // First get my next code to search //
      for (int i = 0; i < PossiblePath.length; i++) {
        try {
          File CodesFile = new File(sketchPath() + File.separator + "codes.txt");
          buffread = new BufferedReader(new FileReader(CodesFile));
          String readString = buffread.readLine();
          while(readString != null) {
            codeLine = readString.split(":", 0);
            // Do we have a Match? //
            String CL1 = codeLine[1];
            if (CL1.equals(PossiblePath[i])) {
              // We found it! Now we need to gather the final third of this line //
              CodeValue[i] = codeLine[0];
              CodeName[i] = codeLine[1];
              PossiblePath[i] = codeLine[2];
              text(CodeValue[i], 350, 40+(20*(i-1)));
              text(CodeName[i], 450, 40+(20*(i-1)));
              break;
            }
            readString = buffread.readLine();
          }
        }
        catch (FileNotFoundException e) {
        }
        catch (IOException ee) {
        }
      }
      noLoop();
    }  
  }
  else if (EnterCode) {
    text("Start Time (mm.ss.fff): ", 20, 10);
    text(StartTime, 175, 10);
    text("End Time (mm.ss.fff): ", 20, 35);
    text(EndTime, 175, 35);
    text("Enter comment:  ", 20, 60);
    text(Comments, 175, 60);
    text("Code:  ", 20, 100);
    text(CodeInProgress, 175, 100);
    text("type to enter stuff. \nHitting Enter will change where you enter stuff", 20, 150);
    text("click screen to enter code", 20, 180);
    text("press tab if you entered the wrong code \n to go back one", 20, 200);
  }
}

// Handle Mouse inputs //

void mousePressed() {
  if (NewCodeSheet || EnterCode) {
    // Are my times the proper length? //
    if (StartTime.length() != 9 || EndTime.length() != 9) {
      StartTime = "";
      EndTime = "";
    }
    else if (StartTime.charAt(2) != '.' || StartTime.charAt(5) != '.' || EndTime.charAt(2) != '.' || EndTime.charAt(5) != '.') {
      StartTime = "";
      EndTime = "";
    }
    else {
      try {
      csvWriter = new FileWriter(sketchPath() + File.separator + SubjectID + ".csv", true);
      csvWriter.append(StartTime);
      csvWriter.append(",");
      csvWriter.append(EndTime);
      csvWriter.append(",");
      csvWriter.append(CodeInProgress);
      csvWriter.append(",");
      csvWriter.append(Comments);
      csvWriter.append("\n");
      csvWriter.flush();
      csvWriter.close();
      LEC = StartTime + " " + EndTime + " " + CodeInProgress + " " + Comments;
      StartTime = "";
      EndTime = "";
      CodeInProgress = "";
      Comments = "";
      CodingSheet = true; //<>//
      NewCodeSheet = false;
      EnterCode = false;
      loop();
      }
      catch (IOException e) {
      }
    }
  }
}

// Handle Keyboard entries //

void keyPressed() {
  // Did the user decide new/Update? //
  if (IsOnStartScreen) {
    if (key == '1') {
      GetNewSubjectID = true;
      IsOnStartScreen = false;
    }
    else if (key == '5') {
      GetExistingSubjectID = true;
      IsOnStartScreen = false;
    }
  }
  // Validate new sheet creation //
  else if (GetNewSubjectID) {
    SubjectID = SubjectID + key;
    // Ooops, go back //
    if (key == ' ') {
      GetNewSubjectID = false;
      SubjectID = "";
      IsOnStartScreen = true;
    }
    else if (key == BACKSPACE) {
      SubjectID = SubjectID.substring(0, max(0, SubjectID.length()-2));
    }
    else if (key == ENTER || key == RETURN) {
      SubjectID = SubjectID.substring(0, max(0, SubjectID.length()-1));
      if (SubjectID.length() == 0) {
        // Do nothing //
      }
      else {
        File IsNewSheet = new File(sketchPath() + File.separator + SubjectID + ".csv");
        if (IsNewSheet.exists()) {
          // Well obviously our New sheet isnt really new //
          SubjectID = "";
        }
        else {
          GetNewSubjectID = false;
          NewCodeSheet = true;
          try {
          csvWriter = new FileWriter(sketchPath() + File.separator + SubjectID + ".csv");
          csvWriter.append("Start_Time (mm.ss.fff)");
          csvWriter.append(",");
          csvWriter.append("End_Time (mm.ss.fff)");
          csvWriter.append(",");
          csvWriter.append("Code");
          csvWriter.append(",");
          csvWriter.append("Comments");
          csvWriter.append("\n");
          csvWriter.flush();
          csvWriter.close();
          }
          catch (IOException e) {
          }
        }
      }
    }
    // the filename is valid... R-right? //
    else if (!SubjectID.matches("[a-zA-Z0-9]+")) {
      SubjectID = SubjectID.substring(0, max(0, SubjectID.length()-1));
    }
  }
  // Validate Load of Existing Sheet //
  else if (GetExistingSubjectID) {
    SubjectID = SubjectID + key;
    // Ooops, go back //
    if (key == ' ') {
      GetExistingSubjectID = false;
      SubjectID = "";
      IsOnStartScreen = true;
    }
    else if (key == BACKSPACE) {
      SubjectID = SubjectID.substring(0, max(0, SubjectID.length()-2));
    }
    else if (key == ENTER || key == RETURN) {
      SubjectID = SubjectID.substring(0, max(0, SubjectID.length()-1));
      File IsUpdatingSheet = new File(sketchPath() + File.separator + SubjectID + ".csv");
      if (!IsUpdatingSheet.exists()) {
        SubjectID = "";
      }
      else {
        GetExistingSubjectID = false;
        // This sheet is calibrated... R-Right? //
        try{
          FileReader fr = new FileReader(sketchPath() + File.separator + SubjectID + ".csv");
          LineNumberReader lnr = new LineNumberReader(fr);
          int linenumber = 0;
          while (lnr.readLine() != null) {
            linenumber++;
          }
          if (linenumber <= 1) {
            NewCodeSheet = true;
          }
          else {
            CodingSheet = true;
          }
          lnr.close();
        }
        catch (FileNotFoundException e) {
        }
        catch (IOException ee) {
        }
        
      }
    }
    // the filename is valid... R-right? //
    else if (!SubjectID.matches("[a-zA-Z0-9]+")) {
      SubjectID = SubjectID.substring(0, max(0, SubjectID.length()-1));
    }
  }
  // Handle the code entering screen //
  else if (NewCodeSheet || EnterCode) {
    if (EnterCode && key == TAB) {
      EnterCode = false;
      CodingSheet = true;
      LastEnteredCode = CodeInProgress.substring(CodeInProgress.length()-2, CodeInProgress.length()-1);
      CodeInProgress = CodeInProgress.substring(0, max(0, CodeInProgress.length()-1));
    }
    else if (IsEnteringStartTime) {
      if (key == ENTER || key == RETURN) {
        IsEnteringStartTime = false;
        IsEnteringEndTime = true;
      }
      else if (key == BACKSPACE) {
        StartTime = StartTime.substring(0, max(0, StartTime.length()-1));
      }
      else {
        StartTime = StartTime + key;
        if (!StartTime.matches("[0-9.]+") || StartTime.length() == 10) {
          StartTime = StartTime.substring(0, max(0, StartTime.length()-1));
        }
      }
    }
    else if (IsEnteringEndTime){
      if (key == ENTER || key == RETURN) {
        IsEnteringEndTime = false;
        IsEnteringComments = true;
      }
      else if (key == BACKSPACE) {
        EndTime = EndTime.substring(0, max(0, EndTime.length()-1));
      }
      else {
        EndTime = EndTime + key;
        if (!EndTime.matches("[0-9.]+") || EndTime.length() == 10) {
          EndTime = EndTime.substring(0, max(0, EndTime.length()-1));
        }
      }
    }
    else {
      if (key == ENTER || key == RETURN) {
        IsEnteringComments = false;
        IsEnteringStartTime = true;
      }
      else if (key == BACKSPACE) {
        Comments = Comments.substring(0, max(0, Comments.length()-1));
      }
      else{
        Comments = Comments + key;
        if(!Comments.matches("[a-zA-Z ]+") || (Comments.length() == 1 && key == ' ')) {
          Comments = Comments.substring(0, max(0, Comments.length()-1));
        }
      }
    }
  }
  // Handle Code building //
  else if (CodingSheet) {
    if (key == TAB) {
      if (CodeInProgress.length() == 1 || CodeInProgress.length() == 0) {
        CodeInProgress = "";
      }
      else {
        LastEnteredCode = CodeInProgress.substring(CodeInProgress.length()-2, CodeInProgress.length()-1);
        CodeInProgress = CodeInProgress.substring(0, max(0, CodeInProgress.length()-1));
      }
      loop();
    }
    else {
      for (int i = 0; i < CodeValue.length; i++) {
        String X = String.valueOf(key);
        if (X.equals(CodeValue[i])) {
          CodeInProgress = CodeInProgress + CodeValue[i];
          NextPossibleCode = PossiblePath[i];
          LastEnteredCode = CodeValue[i];
          if (NextPossibleCode.equals("END")) {
            CodingSheet = false;
            EnterCode = true;
          }
          loop();
          break;        
        }
      }
    }
  }
}
