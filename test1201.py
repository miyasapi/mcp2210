import os
import win32com.client

# 変換元・変換先フォルダ
DWG_DIR = r"C:\dwg\in"
PDF_DIR = r"C:\dwg\pdf"

# 出力フォルダがなければ作成
os.makedirs(PDF_DIR, exist_ok=True)

def dwg_to_pdf():
    # AutoCAD アプリケーション起動（既に起動していればそれにアタッチされることも）
    acad = win32com.client.Dispatch("AutoCAD.Application")
    acad.Visible = False  # True にすると動作が見える

    # Documents コレクション
    docs = acad.Documents

    # フォルダ内の DWG をループ
    for fname in os.listdir(DWG_DIR):
        if not fname.lower().endswith(".dwg"):
            continue

        dwg_path = os.path.join(DWG_DIR, fname)
        pdf_name = os.path.splitext(fname)[0] + ".pdf"
        pdf_path = os.path.join(PDF_DIR, pdf_name)

        print(f"変換中: {dwg_path} -> {pdf_path}")

        # 図面を開く
        doc = docs.Open(dwg_path)

        try:
            # ModelSpace もしくは Layout "Layout1" / "Model" を指定
            # ここではアクティブレイアウトを PDF にする例
            layout = doc.ActiveLayout

            # ここでプロッタ名やスタイルを設定することも可能
            # layout.ConfigName = "DWG To PDF.pc3" など

            # Plot オブジェクト取得
            plot = acad.Plot

            # プロット設定の開始
            if plot.PlotToFile:  # 古いバージョン対策で存在確認する場合もあり
                pass

            # 一時的に PlotDevice などを設定したい場合ここで

            # Model空間を PDF に出力（名前とパスを指定）
            # ※バージョンによりメソッド名・引数が違う場合があります
            #   うまくいかない場合は .PlotToFile の使い方を AutoCAD VBAヘルプで確認
            layout.ConfigName = "DWG To PDF.pc3"   # AutoCAD 標準のPDFプロッタ
            layout.PlotType = 0  # 0: Layout, 1: Window, 2: Extents, etc

            # プロット開始
            # ここでは、専用メソッドを使わず、ActiveLayout.PlotToFile を呼ぶ例
            layout.PlotType = 0  # Layout 全体
            layout.PlotRotation = 0  # 回転なし

            # 実際の PDF 出力
            doc.Plot.PlotToFile(pdf_path)

        except Exception as e:
            print(f"エラー: {dwg_path} -> {e}")

        finally:
            # 図面を保存せず閉じる
            doc.Close(False)

    # AutoCAD を終了したい場合
    acad.Quit()

if __name__ == "__main__":
    dwg_to_pdf()
