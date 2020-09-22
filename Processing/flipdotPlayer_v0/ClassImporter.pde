import java.util.Date;
class Importer {
  //StringList filenames = new StringList();
  String path;
  StringList folders = new StringList();
  StringList files = new StringList();
  
  String[] legalFiles = {"jpg", "JPG", "jpeg", "JPEG", "png", "PNG"};

  Importer(String _root) {
    // Using just the path of this sketch to demonstrate,
    // but you can list any directory you like.
    path = sketchPath(_root);
    loadFolders();
    for(int i = 0; i<folders.size(); i++) {
      println("\t["+ i +"] " + folders.get(i));
    }
  }

  void loadFolders() {
    println("\nListing info about all files in a directory: ");
    File[] files = listFiles(path);
    for (int i = 0; i < files.length; i++) {
      File f = files[i];    
      if (f.isDirectory()) folders.append(f.getName());
    }
    println(folders.size() + " subfolder(s) found");
  }

  void loadFiles(String folder) {
    println("\nListing info about all files in a directory and all subdirectories: ");
    ArrayList<File> allFiles = listFilesRecursive(path+"/"+folder);

    for (File f : allFiles) {
      if (!f.isDirectory()) {
        boolean okayFile = false;
        String[] split = split(f.getName(), ".");
        for(int i = 0; i<legalFiles.length; i++) {
          if(legalFiles[i].equals(split[1])) {
            okayFile = true;
            break;
          }
        }
        /*
        println("Name: " + f.getName());
         println("Full path: " + f.getAbsolutePath());
         println("Is directory: " + f.isDirectory());
         println("Size: " + f.length());
         String lastModified = new Date(f.lastModified()).toString();
         println("Last Modified: " + lastModified);
         println("-----------------------");
         */
        if(okayFile) files.append(f.getAbsolutePath());
      }
    }
    println(files.size() + " file(s) found");
  }

  StringList getFolders() {
    return folders;
  }
  StringList getFiles() {
    return files;
  }

  // This function returns all the files in a directory as an array of Strings  
  String[] listFileNames(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      String names[] = file.list();
      return names;
    } else {
      // If it's not a directory
      return null;
    }
  }

  // This function returns all the files in a directory as an array of File objects
  // This is useful if you want more info about the file
  File[] listFiles(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      File[] files = file.listFiles();
      return files;
    } else {
      // If it's not a directory
      return null;
    }
  }

  // Function to get a list of all files in a directory and all subdirectories
  ArrayList<File> listFilesRecursive(String dir) {
    ArrayList<File> fileList = new ArrayList<File>(); 
    recurseDir(fileList, dir);
    return fileList;
  }

  // Recursive function to traverse subdirectories
  void recurseDir(ArrayList<File> a, String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      // If you want to include directories in the list
      a.add(file);  
      File[] subfiles = file.listFiles();
      for (int i = 0; i < subfiles.length; i++) {
        // Call this function on all files in this directory
        recurseDir(a, subfiles[i].getAbsolutePath());
      }
    } else {
      a.add(file);
    }
  }

  void originalExample() {
    // Original example by Dan Shiffman
    // https://processing.org/examples/directorylist.html
    println("Listing all filenames in a directory: ");
    String[] filenames = listFileNames(path);
    printArray(filenames);

    println(" * * * * * ");
    println("\nListing info about all files in a directory: ");
    File[] files = listFiles(path);
    for (int i = 0; i < files.length; i++) {
      File f = files[i];    
      println("Name: " + f.getName());
      println("Is directory: " + f.isDirectory());
      println("Size: " + f.length());
      String lastModified = new Date(f.lastModified()).toString();
      println("Last Modified: " + lastModified);
      println("-----------------------");
    }

    println(" * * * * * ");
    println("\nListing info about all files in a directory and all subdirectories: ");
    ArrayList<File> allFiles = listFilesRecursive(path);

    for (File f : allFiles) {
      println("Name: " + f.getName());
      println("Full path: " + f.getAbsolutePath());
      println("Is directory: " + f.isDirectory());
      println("Size: " + f.length());
      String lastModified = new Date(f.lastModified()).toString();
      println("Last Modified: " + lastModified);
      println("-----------------------");
    }
  }
}
