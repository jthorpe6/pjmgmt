import Foundation
import ArgumentParser
import ZIPFoundation

func makeProjectDirectory(projectid: String) -> URL {
    let projectDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Projects").appendingPathComponent(projectid)
    
    let folders = ["Screenshots", "Logs", "Documents", "Reporting"]
    
    if !FileManager.default.fileExists(atPath: projectDirectoryURL.path) {
        do {
            try FileManager.default.createDirectory(atPath: projectDirectoryURL.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    for folder in folders {
        let folderPath = projectDirectoryURL.appendingPathComponent(folder)
        if !FileManager.default.fileExists(atPath: folderPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return projectDirectoryURL
}

@available(macOS 10.11, *)
func generateNotes(projectid: String) {
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

    let projectDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Projects").appendingPathComponent(projectid)
    let notesURL = URL(fileURLWithPath: "notes", relativeTo: projectDirectoryURL).appendingPathExtension("org")
    
    do {
        try content.write(to: notesURL)
    } catch {
        print(error.localizedDescription)
    }
}

func archiveProject(projectid: String) {
    let projectDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Projects").appendingPathComponent(projectid)
    let projectArchiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Projects").appendingPathComponent("\(projectid).zip")

    do {
        try FileManager.default.zipItem(at: projectDirectoryURL, to: projectArchiveURL)
    } catch {
        print(error.localizedDescription)
    }

    do {
        try FileManager.default.removeItem(at: projectDirectoryURL)
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
        let _ = makeProjectDirectory(projectid: id)

        if #available(macOS 10.11, *) {
            generateNotes(projectid: id)
        } else {
            print("it only works in osx 10.11 and newer")
        }
        if archive == true {
            archiveProject(projectid: id)
        }
    }
}
Project.main()
