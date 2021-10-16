import UIKit
import Firebase
import SDWebImage
import AVFoundation
import PKHUD

class OtherPersonListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, URLSessionDownloadDelegate {
        
    @IBOutlet weak var favTableView: UITableView!

    var musicDataModelArray = [MusicDataModel]()
    var artworkUrl = ""
    var previewUrl = ""
    var artistName = ""
    var trackCensoredName = ""
    var imageString = ""
    var userID = ""
    var userName = ""

    var favRef = Database.database().reference()

    var player:AVAudioPlayer?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //セルの選択可能の有無
        favTableView.allowsSelection = true
        favTableView.delegate = self
        favTableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "\(userName)' S MusicList"
        //インディケーターを回す
        HUD.show(.progress)
        favRef.child("users").child(userID).observe(.value) {
            (snapshot) in
            self.musicDataModelArray.removeAll()

            for child in snapshot.children{
                let childSnapshot = child as! DataSnapshot
                let musicData = MusicDataModel(snapshot: childSnapshot)
                self.musicDataModelArray.insert(musicData, at: 0)
                self.favTableView.reloadData()
            }

            HUD.hide()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicDataModelArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.isHighlighted = false
        let musicDataModel = musicDataModelArray[indexPath.row]
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let labell1 =  cell.contentView.viewWithTag(2) as! UILabel
        let labell2 =  cell.contentView.viewWithTag(3) as! UILabel
        labell1.text = musicDataModel.artistName
        labell2.text = musicDataModel.musicName
        imageView.sd_setImage(with:  URL(string: musicDataModel.imageString), placeholderImage: UIImage(named: "noImage"), options: .continueInBackground, context: nil, progress: nil, completed: nil)
        
        //再生ボタン
        let playButton = PlayMusicButton(frame: CGRect(x : view.frame.size.width - 60, y: 50, width: 60, height: 60))
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTap(_ :)), for: .touchUpInside)
        playButton.params["value"] = indexPath.row
        cell.accessoryView = playButton

        return cell
    }
    
    @objc func playButtonTap(_ sender: PlayMusicButton) {
        //音楽を一旦止める
        if player?.isPlaying == true {
            player!.stop()
        }
        //sender　＝　playButton
        let indexNumber:Int = sender.params["value"] as! Int
        let urlString = musicDataModelArray[indexNumber].preViewURL
        let url = URL(string: urlString)
        print(url!)
        //ダウンロード
        downloadMusicURL(url: url!)
    }
    
    func downloadMusicURL(url:URL) {
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (url, response, error) in
            //再生
            self.play(url:url!)
        })
        downloadTask.resume()
    }

    func play(url:URL) {
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.volume = 1.0
            player?.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    @IBAction func back(_ sender: Any) {
        if player?.isPlaying == true {
            player!.stop()
        }
        self.navigationController?.popViewController(animated: true)
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("download done")
    }
    
    
}
