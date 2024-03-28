import * as fs from "node:fs";
import * as pathLib from "node:path";

/** 基底資料夾類別 */
class BaseDirectory {
  /** 資料夾路徑 */
  protected _path: string;
  /** 設定物件
   * @param _path 資料夾路徑
   */
  public constructor(_path: string) {
    this._path = _path;
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
   */
  public async handleAllFiles(
    callback: (_file: string, _path: string, _idx: number) => Promise<void>
  ): Promise<void> {
    let _files = fs.readdirSync(this._path);
    for (let _idx = 0; _idx < _files.length; _idx++) {
      let _file = _files[_idx];
      let _path = pathLib.join(this._path, _file);
      await callback(_file, _path, _idx);
    }
  }

  /** 刪除資料夾內容
   * @param showLog 顯示輸出資訊
   */
  public deleteAllFiles(showLog: boolean = false): void {
    let files = fs.readdirSync(this._path);
    files.forEach((_file) => {
      fs.unlinkSync(pathLib.join(this._path, _file));
      if (showLog) console.log(`Delete ${_file}`);
    });
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
      if (showLog) console.log("Finish Creating TMP Directory.");
    }
    if (toClean) this.deleteAllFiles(showLog);
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
}
