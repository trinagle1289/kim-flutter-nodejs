import * as fs from "node:fs";
import * as pathLib from "node:path";

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
    callback: (_name: string, _path: string) => Promise<void>
  ): Promise<void> {
    let _files = fs.readdirSync(this.path);

    for (let _file of _files)
      await callback(_file, pathLib.join(this.path, _file));
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
