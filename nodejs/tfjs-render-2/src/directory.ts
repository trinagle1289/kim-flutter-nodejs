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

  /** 清除資料夾所有內容
   * @param showLog 顯示輸出資訊
   */
  public cleanFolder(showLog: boolean = false): void {
    let files = fs.readdirSync(this._path);
    files.forEach((_file) => {
      let path = path_lib.normalize(path_lib.join(this._path, _file));
      fs.rmSync(path, { recursive: true });
      if (showLog) console.log(`Delete ${path}`);
    });
  }

  /** 刪除包含資料夾的所有檔案
   * @param showLog 顯示輸出資訊
   */
  public deleteSelf(showLog: boolean = false): void {
    fs.rmSync(this._path, { recursive: true, force: true });
    if (showLog) console.log(`Finish deleting ${this._path} Folder.`);
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
      fs.mkdirSync(this._path, { recursive: true });
      if (showLog)
        console.log(`Finish Creating TMP Directory in ${this._path}.`);
    }
    if (toClean) this.cleanFolder(showLog);
  }
  /** 刪除資料夾內容 */
  public cleanFolder(showLog: boolean = false): void {
    if (showLog) console.log("Deleting All TMP Files.");
    super.cleanFolder(showLog);
  }
}

/** 資源資料夾 */
export class ResourceDir extends BaseDirectory {
  public cleanFolder(showLog?: boolean): void {
    if (showLog) console.log("The resource folder will not delete its files.");
  }
  public deleteSelf(showLog?: boolean): void {
    if (showLog) console.log("The resource folder will not delete itself.");
  }
}
