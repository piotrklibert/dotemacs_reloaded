FROM alpine:3.8

RUN apk add emacs make git curl jq openssh-client
RUN echo "(add-to-list 'load-path \"/lcdocs/lisp/org-mode/lisp\")" >>/root/.emacs
RUN echo "(customize-set-value 'enable-local-variables :all)" >>/root/.emacs
