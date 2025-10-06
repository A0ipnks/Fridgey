import { Controller } from "@hotwired/stimulus"

// モーダルの開閉を管理するStimulusコントローラー
export default class extends Controller {
  static targets = ["container"]

  connect() {
    // カスタムイベント 'modal:close' をリッスン
    this.closeListener = () => {
      this.close()
    }
    window.addEventListener('modal:close', this.closeListener)
  }

  disconnect() {
    // コントローラーが破棄される時にイベントリスナーを削除
    window.removeEventListener('modal:close', this.closeListener)
  }

  // モーダルを開く
  open() {
    this.containerTarget.classList.remove("hidden")
    this.containerTarget.style.display = "block"
    document.body.style.overflow = "hidden"

    // アニメーション用
    requestAnimationFrame(() => {
      const content = this.containerTarget.querySelector(".transform")
      if (content) {
        content.classList.remove("scale-95")
        content.classList.add("scale-100")
      }
    })
  }

  // モーダルを閉じる
  close() {
    const content = this.containerTarget.querySelector(".transform")
    if (content) {
      content.classList.remove("scale-100")
      content.classList.add("scale-95")
    }

    setTimeout(() => {
      this.containerTarget.classList.add("hidden")
      this.containerTarget.style.display = "none"
      document.body.style.overflow = "auto"

      // エラーメッセージをクリア
      const errorDiv = this.containerTarget.querySelector("#modalErrors")
      if (errorDiv) {
        errorDiv.classList.add("hidden")
        errorDiv.innerHTML = ""
      }
    }, 300)
  }

  // 背景クリックで閉じる
  closeOnBackground(event) {
    // クリックされた要素がモーダル背景自体の場合のみ閉じる
    if (event.target.id === 'editModal') {
      this.close()
    }
  }

  // ESCキーで閉じる（モーダルが表示されている時のみ）
  closeOnEscape(event) {
    if (event.key === "Escape" && !this.containerTarget.classList.contains("hidden")) {
      this.close()
    }
  }

  // フォーム送信完了時の処理
  handleSubmitEnd(event) {
    // 成功時（fetchResponseが200系）のみモーダルを閉じる
    if (event.detail.success) {
      this.close()

      // Toast通知を表示
      window.dispatchEvent(new CustomEvent('toast:show', {
        detail: {
          message: '冷蔵庫情報が更新されました',
          type: 'success'
        }
      }))
    }
  }
}
