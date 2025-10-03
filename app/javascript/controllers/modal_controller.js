import { Controller } from "@hotwired/stimulus"

// モーダルの開閉を管理するStimulusコントローラー
export default class extends Controller {
  static targets = ["container"]

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


  // Turbo Frame更新完了時（成功時のみモーダルを閉じる）
  closeOnSuccess() {
    // エラーがない場合のみ閉じる
    const errorDiv = this.containerTarget.querySelector("#modalErrors")
    if (!errorDiv || errorDiv.classList.contains("hidden")) {
      this.close()
    }
  }

  // フォーム送信エラー時
  handleError(event) {
    const [data, status, xhr] = event.detail
    const errorDiv = this.containerTarget.querySelector("#modalErrors")

    if (errorDiv && data.errors) {
      let errorHtml = '<ul class="list-disc list-inside">'
      Object.keys(data.errors).forEach(key => {
        data.errors[key].forEach(error => {
          errorHtml += `<li>${error}</li>`
        })
      })
      errorHtml += '</ul>'

      errorDiv.innerHTML = errorHtml
      errorDiv.classList.remove("hidden")
    }
  }
}
