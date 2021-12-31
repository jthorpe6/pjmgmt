import Foundation
import ArgumentParser
import ZIPFoundation

func makeProjectDirectory(projectid: String, projectPath: URL) {
    let folders = ["Screenshots", "Logs", "Documents", "Reporting"]
    
    if !FileManager.default.fileExists(atPath: projectPath.path) {
        do {
            try FileManager.default.createDirectory(atPath: projectPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    for folder in folders {
        let folderPath = projectPath.appendingPathComponent(folder)
        if !FileManager.default.fileExists(atPath: folderPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

@available(macOS 10.11, *)
func generateNotes(projectid: String, projectPath: URL) {
    let org = """
    #+OPTIONS: num:nil
    #+PROPERTY: header-args :tangle yes :exports both :eval no-export :results output
    #+SETUPFILE: https://raw.githubusercontent.com/fniessen/org-html-themes/master/org/theme-readtheorg.setup
    #+HTML_HEAD: <style> #content{max-width:1800px;}</style>
    #+HTML_HEAD: <style> p{max-width:800px;}</style>
    #+HTML_HEAD: <style> li{max-width:800px;}</style>
    #+TITLE: \(projectid)
    * PoC
    * Scope
    * Day Diary
    * Testing Activities
    
    """
    guard let content = org.data(using: .utf8) else {
        return
    }

    let notesURL = URL(fileURLWithPath: "\(projectPath)/notes", relativeTo: projectPath).appendingPathExtension("org")
    
    do {
        try content.write(to: notesURL)
    } catch {
        print(error.localizedDescription)
    }
}

func archiveProject(projectid: String, projectPath: URL) {
    // there could be a better way to get this
    let projectArchiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Projects").appendingPathComponent("\(projectid).zip")

    do {
        try FileManager.default.zipItem(at: projectPath, to: projectArchiveURL)
    } catch {
        print(error.localizedDescription)
    }

    do {
        try FileManager.default.removeItem(at: projectPath)
    } catch {
        print(error.localizedDescription)
    }
}

struct Project: ParsableCommand {
    @Argument(help: "project identifier")
    var id: String
    
    @Flag(help: "archive project")
    var archive = false
    
    func run() throws {
        let projectsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Projects/\(id)/")
        
        let _ = makeProjectDirectory(projectid: id, projectPath: projectsDirectoryURL)

        if #available(macOS 10.11, *) {
            generateNotes(projectid: id, projectPath: projectsDirectoryURL)
        } else {
            print("it only works in osx 10.11 and newer")
        }
        if archive == true {
            archiveProject(projectid: id, projectPath: projectsDirectoryURL)
        }
    }
}
Project.main()
