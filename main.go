package main

import (
	"log"
	"os"
	"runtime"

	"github.com/opencontainers/runc/libcontainer"
	_ "github.com/opencontainers/runc/libcontainer/nsenter"
	"github.com/opencontainers/runc/libcontainer/specconv"
)

func main() {
	if len(os.Args) > 1 && os.Args[1] == "init" {
		runtime.GOMAXPROCS(1)
		runtime.LockOSThread()
		factory, _ := libcontainer.New("")
		if err := factory.StartInitialization(); err != nil {
			log.Fatal(err)
		}
		panic("--this line should have never been executed, congratulations--")
	}

	factory, err := libcontainer.New("/tmp", libcontainer.RootlessCgroupfs)
	if err != nil {
		log.Fatal(err)
	}

	spec := specconv.Example()
	specconv.ToRootless(spec)

	conf, err := specconv.CreateLibcontainerConfig(&specconv.CreateOpts{
		CgroupName:      "foo",
		Spec:            spec,
		RootlessEUID:    os.Geteuid() != 0,
		RootlessCgroups: true,
	})
	if err != nil {
		log.Fatal(err)
	}

	conf.Rootfs = "/rootfs"
	conf.Readonlyfs = true
	// Mounts: []*configs.Mount{{
	// 	Source:      "/data/test",
	// 	Destination: "/test",
	// }},

	c, err := factory.Create("foo", conf)
	if err != nil {
		log.Fatal(err)
	}

	err = c.Run(&libcontainer.Process{
		Args:   []string{"/usr/bin/safe", "--version"},
		Stdout: os.Stdout,
		Stderr: os.Stderr,
		Init:   true,
	})
	if err != nil {
		log.Fatal(err)
	}
}
