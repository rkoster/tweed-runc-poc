package main

import (
	"os"

	"github.com/opencontainers/runc/libcontainer"
	"github.com/opencontainers/runc/libcontainer/configs"
)

func main() {
	//	f, err := libcontainer.New("/tmp", libcontainer.RootlessCgroupfs)
	f, err := libcontainer.New("/tmp", nil)
	if err != nil {
		panic(err)
	}

	c, err := f.Create("test", &configs.Config{
		Rootfs:     "/rootfs",
		Readonlyfs: true,
		Mounts: []*configs.Mount{{
			Source:      "/data/test",
			Destination: "/test",
		}},
	})
	if err != nil {
		panic(err)
	}

	err = c.Run(&libcontainer.Process{
		Args:   []string{"safe", "--version"},
		Stdout: os.Stdout,
		Stderr: os.Stderr,
	})
	if err != nil {
		panic(err)
	}
}
