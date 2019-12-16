package main

import (
	"log"
	"os"

	"github.com/opencontainers/runc/libcontainer"
	"github.com/opencontainers/runc/libcontainer/specconv"
)

func main() {
	f, err := libcontainer.New("/tmp", libcontainer.RootlessCgroupfs)
	// f, err := libcontainer.New("/tmp", nil)
	if err != nil {
		log.Fatal(err)
	}

	spec := specconv.Example()
	specconv.ToRootless(spec)

	spec.Process.Args = []string{"safe", "--version"}

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

	c, err := f.Create("foo", conf)
	if err != nil {
		log.Fatal(err)
	}

	// out, _ := json.Marshal(spec)
	// fmt.Println(string(out))

	err = c.Start(&libcontainer.Process{
		Args:   []string{"safe", "--version"},
		Stdout: os.Stdout,
		Stderr: os.Stderr,
	})
	if err != nil {
		log.Fatal(err)
	}
}
