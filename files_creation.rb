class FilesCreation
  def createFile(fileName, string)
    File.open(fileName+".txt", 'a') {|f|
      f.write(string)
    }
  end
end