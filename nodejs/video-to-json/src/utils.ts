import * as fs from "node:fs";
import * as path_lib from "node:path";

/** 基底資料夾類別 */
class BaseDirectory {
  /** 資料夾路徑 */
  protected _path: string;
  /** 設定物件
   * @param _path 資料夾路徑
   */
  public constructor(_path: string) {
    this._path = path_lib.normalize(_path + "/");
  }

  /** 取得資料夾路徑 */
  public get DirPath(): string {
    return this._path;
  }

  /** 取得全部檔案名稱 */
  public get AllFiles(): string[] {
    return fs.readdirSync(this._path);
  }

  /** 處理全部檔案
   * @param callback 對單個檔案的操作
   * _fullPath: 檔案完整路徑
   * _parsedPath: 經由 path.parse 轉換過的路徑，有著更多資訊
   * _idx: 索引值
   */
  public async handleAllFiles(
    callback: (
      _fullPath: string,
      _parsedPath: path_lib.ParsedPath,
      _idx: number
    ) => Promise<void>
  ): Promise<void> {
    let _files = fs.readdirSync(this._path);
    for (let _idx = 0; _idx < _files.length; _idx++) {
      let f = _files[_idx];
      let _path = path_lib.join(this._path, f); // 組合資料夾和檔案路徑
      let _parsedPath = path_lib.parse(_path);
      await callback(_path, _parsedPath, _idx);
    }
  }

  /** 刪除資料夾內容
   * @param showLog 顯示輸出資訊
   */
  public deleteAllFiles(showLog: boolean = false): void {
    let files = fs.readdirSync(this._path);
    files.forEach((_file) => {
      fs.unlinkSync(path_lib.join(this._path, _file));
      if (showLog) console.log(`Delete ${_file}`);
    });
  }

  /** 強制移除所有檔案 */
  public forceRemoveAllFiles(showLog: boolean = false): void {
    fs.rmSync(this._path, { recursive: true, force: true });
    if (showLog) console.log("Finish Force Remove All Files.");
  }
}

/** 暫存資料夾 (位於 tmp/) */
export class TmpDir extends BaseDirectory {
  /** 建立暫存資料夾
   * @param _path 資料夾路徑
   * @param toClean 是否清理資料夾
   * @param showLog 是否顯示輸出資訊
   */
  public constructor(
    _path: string = "./tmp",
    toClean: boolean = false,
    showLog: boolean = false
  ) {
    super(_path);
    if (!fs.existsSync(this._path)) {
      fs.mkdirSync(this._path);
      if (showLog)
        console.log(`Finish Creating TMP Directory in ${this._path}.`);
    }
    if (toClean) this.forceRemoveAllFiles(showLog);
  }
  /** 刪除資料夾內容 */
  public deleteAllFiles(showLog: boolean = false): void {
    if (showLog) console.log("Deleting All TMP Files.");
    super.deleteAllFiles(showLog);
  }
}

/** 資源資料夾 */
export class ResourceDir extends BaseDirectory {
  public deleteAllFiles(showLog?: boolean): void {
    console.log("The resource folder will not delete its files");
  }
  public forceRemoveAllFiles(showLog?: boolean): void {
    console.log("The resource folder will not delete its files");
  }
}
