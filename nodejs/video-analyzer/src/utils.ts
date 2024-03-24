import * as fs from "node:fs";
import * as pathLib from "node:path";

/** 基底資料夾類別 */
class BaseDirectory {
  /** 資料夾路徑 */
  protected _path: string;
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

  /** 刪除資料夾內容 */
  public deleteAllFiles(showLog: boolean = false): void {
    let files = fs.readdirSync(this._path);
    files.forEach((_file) => {
      fs.unlinkSync(pathLib.join(this._path, _file));
      if (showLog) console.log(`Delete ${_file}`);
    });
  }
}

/** 暫存資料夾 (位於 tmp/) */
export class TmpDir {
  private path: string;
  /** 建立暫存資料夾
   * @param _path 建立路徑
   * @param toClean 是否清理資料夾
   */
  public constructor(_path: string = "./tmp", toClean: boolean = false) {
    this.path = _path;
    if (!fs.existsSync(this.path)) {
      fs.mkdir(this.path, (_err) =>
        console.log("Finish Creating TMP Directory.")
      );
    }
    if (toClean) this.deleteAllFiles();
  }

  /** 資料夾路徑 */
  public get DirPath(): string {
    return this.path;
  }

  /** 取得全部檔案名稱 */
  public get AllFiles(): string[] {
    return fs.readdirSync(this.path);
  }

  /** 處理全部檔案
   * @param callback 對單個檔案的操作
   */
  public async handleAllFiles(
    callback: (_file: string, _path: string, _idx: number) => Promise<void>
  ): Promise<void> {
    let _files = fs.readdirSync(this.path);
    for (let _idx = 0; _idx < _files.length; _idx++) {
      let _file = _files[_idx];
      let _path = pathLib.join(this.path, _file);
      await callback(_file, _path, _idx);
    }
  }

  /** 刪除資料夾內容 */
  public deleteAllFiles(): void {
    console.log("Deleting All TMP Files.");
    let files = fs.readdirSync(this.path);
    files.forEach((_file) => {
      fs.unlinkSync(pathLib.join(this.path, _file));
      console.log(`Delete ${_file}`);
    });
  }
}
