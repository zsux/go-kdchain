// Copyright 2016 The go-kdchain Authors
// This file is part of the go-kdchain library.
//
// The go-kdchain library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The go-kdchain library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the go-kdchain library. If not, see <http://www.gnu.org/licenses/>.

// Contains initialization code for the mbile library.

package gkdchain

import (
	"os"
	"runtime"

	"github.com/kdchain/go-kdchain/log"
)

func init() {
	// Initialize the logger
	log.Root().SetHandler(log.LvlFilterHandler(log.LvlInfo, log.StreamHandler(os.Stderr, log.TerminalFormat(false))))

	// Initialize the goroutine count
	runtime.GOMAXPROCS(runtime.NumCPU())
}
