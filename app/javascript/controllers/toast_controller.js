import { Controller } from "@hotwired/stimulus"

// Toast通知を管理するStimulusコントローラー
export default class extends Controller {
  static targets = ["container"]

  connect() {
    // カスタムイベントをリッスン
    this.showListener = (event) => {
      this.show(event.detail.message, event.detail.type || 'success')
    }
    window.addEventListener('toast:show', this.showListener)
  }

  disconnect() {
    window.removeEventListener('toast:show', this.showListener)
  }

  // Toast通知を表示
  show(message, type = 'success') {
    // 既存のToastがあれば削除
    const existingToast = this.containerTarget.querySelector('.toast-notification')
    if (existingToast) {
      existingToast.remove()
    }

    // Toast要素を作成
    const toast = document.createElement('div')
    toast.className = `toast-notification fixed top-4 right-4 px-6 py-4 rounded-lg shadow-lg transition-all duration-300 z-50 flex items-center space-x-3 ${this.getTypeClasses(type)}`
    toast.style.transform = 'translateX(400px)'
    toast.style.opacity = '0'

    // アイコン
    const icon = this.getIcon(type)
    toast.innerHTML = `
      ${icon}
      <span class="font-medium">${message}</span>
    `

    // DOMに追加
    this.containerTarget.appendChild(toast)

    // アニメーション: スライドイン
    requestAnimationFrame(() => {
      toast.style.transform = 'translateX(0)'
      toast.style.opacity = '1'
    })

    // 3秒後に自動で消す
    setTimeout(() => {
      this.hide(toast)
    }, 3000)
  }

  // Toast通知を非表示
  hide(toast) {
    toast.style.transform = 'translateX(400px)'
    toast.style.opacity = '0'

    setTimeout(() => {
      toast.remove()
    }, 300)
  }

  // タイプに応じたCSSクラスを返す
  getTypeClasses(type) {
    const classes = {
      success: 'bg-green-500 text-white',
      error: 'bg-red-500 text-white',
      warning: 'bg-yellow-500 text-white',
      info: 'bg-blue-500 text-white'
    }
    return classes[type] || classes.success
  }

  // タイプに応じたアイコンを返す
  getIcon(type) {
    const icons = {
      success: '<svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>',
      error: '<svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path></svg>',
      warning: '<svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path></svg>',
      info: '<svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"></path></svg>'
    }
    return icons[type] || icons.success
  }
}
