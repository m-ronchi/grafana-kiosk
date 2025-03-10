package kiosk

import (
	"context"
	"log"

	"github.com/chromedp/cdproto/inspector"
	"github.com/chromedp/cdproto/runtime"
	"github.com/chromedp/chromedp"
)

type chromeEvents int

const (
	consoleAPICall chromeEvents = 1 << iota
	targetCrashed
)

func listenChromeEvents(taskCtx context.Context, events chromeEvents) {
	chromedp.ListenTarget(taskCtx, func(ev interface{}) {
		switch ev := ev.(type) {
		case *runtime.EventConsoleAPICalled:
			if events&consoleAPICall != 0 {
				log.Printf("console.%s call:\n", ev.Type)
				for _, arg := range ev.Args {
					log.Printf("	%s - %s\n", arg.Type, arg.Value)
				}
			}
		case *inspector.EventTargetCrashed:
			if events&targetCrashed != 0 {
				log.Printf("target crashed, reload...")
				go func() {
					chromedp.Run(taskCtx, chromedp.Reload())
				}()
			}
		}
	})
}
