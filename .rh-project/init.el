;; -*- coding: utf-8 -*-

(require 'cl)
(require 'hydra)
(require 'vterm)
(require 'flycheck)
(require 'lsp-mode)
(require 'lsp-javascript)
(require 'clang-format)

;;; gcc-bazel-init common command
;;; /b/{

(defvar frpc-poc/build-buffer-name
  "*gcc-bazel-init-build*")

(defun frpc-poc/lint ()
  (interactive)
  (rh-project-compile
   "yarn-run app:lint"
   frpc-poc/build-buffer-name))

(defun frpc-poc/build ()
  (interactive)
  (rh-project-compile
   "yarn-run app:build"
   frpc-poc/build-buffer-name))

(defun frpc-poc/clean ()
  (interactive)
  (rh-project-compile
   "yarn-run app:clean"
   frpc-poc/build-buffer-name))

;;; /b/}

;;; gcc-bazel-init
;;; /b/{

(defun frpc-poc/hydra-define ()
  (defhydra gcc-bazel-init-hydra (:color blue :columns 5)
    "@gcc-bazel-init workspace commands"
    ("l" frpc-poc/lint "lint")
    ("b" frpc-poc/build "build")
    ("c" frpc-poc/clean "clean")))

(frpc-poc/hydra-define)

(define-minor-mode gcc-bazel-init-mode
  "gcc-bazel-init project-specific minor mode."
  :lighter " gcc-bazel-init"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "<f9>") #'gcc-bazel-init-hydra/body)
            map))

(add-to-list 'rm-blacklist " gcc-bazel-init")

(defun frpc-poc/lsp-deps-providers-path (path)
  (concat (expand-file-name (rh-project-get-root))
          "node_modules/.bin/"
          path))

(defvar frpc-poc/lsp-clients-clangd-args '())

(defun frpc-poc/config-lsp-clangd ()
  (setq frpc-poc/lsp-clients-clangd-args
        (copy-sequence lsp-clients-clangd-args))
  ;; (add-to-list
  ;;  'frpc-poc/lsp-clients-clangd-args
  ;;  "--query-driver=/usr/bin/g*-11,/usr/bin/clang*-14"
  ;;  t)

  ;; (add-hook
  ;;  'lsp-after-open-hook
  ;;  #'frpc-poc/company-capf-c++-local-disable)

  ;; (add-hook
  ;;  'lsp-after-initialize-hook
  ;;  #'frpc-poc/company-capf-c++-local-disable)
  )

;; (defun frpc-poc/company-capf-c++-local-disable ()
;;   (when (eq major-mode 'c++-mode)
;;     (setq-local company-backends
;;                 (remq 'company-capf company-backends))))

(defun frpc-poc/config-lsp-javascript ()
  (plist-put
   lsp-deps-providers
   :local (list :path #'frpc-poc/lsp-deps-providers-path))

  (lsp-dependency 'typescript-language-server
                  '(:local "typescript-language-server"))

  (lsp--require-packages)

  (lsp-dependency 'typescript '(:local "tsserver"))

  (add-hook
   'lsp-after-initialize-hook
   #'frpc-poc/flycheck-add-eslint-next-to-lsp))

(defun frpc-poc/flycheck-add-eslint-next-to-lsp ()
  (when (seq-contains-p '(js2-mode typescript-mode web-mode) major-mode)
    (flycheck-add-next-checker 'lsp 'javascript-eslint)))

(defun frpc-poc/flycheck-after-syntax-check-hook-once ()
  (remove-hook
   'flycheck-after-syntax-check-hook
   #'frpc-poc/flycheck-after-syntax-check-hook-once
   t)
  (flycheck-buffer))

;; (eval-after-load 'lsp-javascript #'frpc-poc/config-lsp-javascript)
(eval-after-load 'lsp-mode #'frpc-poc/config-lsp-javascript)
(eval-after-load 'lsp-mode #'frpc-poc/config-lsp-clangd)

(defun gcc-bazel-init-setup ()
  (when buffer-file-name
    (let ((project-root (rh-project-get-root))
          file-rpath ext-js)
      (when project-root
        (setq file-rpath (expand-file-name buffer-file-name project-root))
        (cond
         ;; This is required as tsserver does not work with files in archives
         ((bound-and-true-p archive-subfile-mode)
          (company-mode 1))

         ((seq-contains '(c++-mode c-mode) major-mode)
          (when (rh-clangd-executable-find)
            (when (featurep 'lsp-mode)
              (setq-local
               lsp-clients-clangd-args
               (copy-sequence frpc-poc/lsp-clients-clangd-args))

              (add-to-list
               'lsp-clients-clangd-args
               (concat "--compile-commands-dir="
                       (expand-file-name (rh-project-get-root)))
               t)

              (setq-local lsp-modeline-diagnostics-enable nil)
              ;; (lsp-headerline-breadcrumb-mode 1)

              (setq-local flycheck-idle-change-delay 3)
              (setq-local flycheck-check-syntax-automatically
                          ;; '(save mode-enabled)
                          '(idle-change save mode-enabled))))

          (add-hook 'before-save-hook #'clang-format-buffer nil t)
          (company-mode 1)
          (lsp 1))

         ((or (setq
               ext-js
               (string-match-p "\\.ts\\'\\|\\.tsx\\'\\|\\.js\\'\\|\\.jsx\\'"
                               file-rpath))
              (string-match-p "^#!.*node"
                              (or (save-excursion
                                    (goto-char (point-min))
                                    (thing-at-point 'line t))
                                  "")))

          (when (boundp 'rh-js2-additional-externs)
            (setq-local rh-js2-additional-externs
                        (append rh-js2-additional-externs
                                '("require" "exports" "module" "process"
                                  "__dirname"))))

          (setq-local flycheck-idle-change-delay 3)
          (setq-local flycheck-check-syntax-automatically
                      ;; '(save mode-enabled)
                      '(save idle-change mode-enabled))
          (setq-local flycheck-javascript-eslint-executable
                      (concat (expand-file-name project-root)
                              "node_modules/.bin/eslint"))

          (setq-local lsp-enabled-clients '(ts-ls))
          ;; (setq-local lsp-headerline-breadcrumb-enable nil)
          (setq-local lsp-before-save-edits nil)
          (setq-local lsp-modeline-diagnostics-enable nil)
          (add-hook
           'flycheck-after-syntax-check-hook
           #'frpc-poc/flycheck-after-syntax-check-hook-once
           nil t)
          (lsp 1)
          ;; (lsp-headerline-breadcrumb-mode -1)
          (prettier-mode 1)))))))

;;; /b/}
