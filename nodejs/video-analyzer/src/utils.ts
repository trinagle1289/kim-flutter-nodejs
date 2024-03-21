import * as fs from "node:fs";
import * as pathLib from "node:path";

/** 暫存資料夾 (位於 tmp/) */
export class TmpDir {
  private path: string;
  public constructor(_path: string = "./tmp") {
    this.path = _path;
    fs.mkdir(this.path, (err) => console.log("Finish Creating TMP Directory."));
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
