package main

import (
	"fmt"

	"github.com/containers/libpod/libpod"
)

func main() {
	r, err := libpod.NewRuntime(contex.ToDo(), libpod.WithVolumePath("/tmp/volumes"))
	libpod.NewBoltState("/tmp/podman-state", r)
	fmt.Println("Hello, world.")
}
