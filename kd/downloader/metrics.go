// Copyright 2015 The go-kdchain Authors
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

// Contains the metrics collected by the downloader.

package downloader

import (
	"github.com/kdchain/go-kdchain/metrics"
)

var (
	headerInMeter      = metrics.NewRegisteredMeter("kd/downloader/headers/in", nil)
	headerReqTimer     = metrics.NewRegisteredTimer("kd/downloader/headers/req", nil)
	headerDropMeter    = metrics.NewRegisteredMeter("kd/downloader/headers/drop", nil)
	headerTimeoutMeter = metrics.NewRegisteredMeter("kd/downloader/headers/timeout", nil)

	bodyInMeter      = metrics.NewRegisteredMeter("kd/downloader/bodies/in", nil)
	bodyReqTimer     = metrics.NewRegisteredTimer("kd/downloader/bodies/req", nil)
	bodyDropMeter    = metrics.NewRegisteredMeter("kd/downloader/bodies/drop", nil)
	bodyTimeoutMeter = metrics.NewRegisteredMeter("kd/downloader/bodies/timeout", nil)

	receiptInMeter      = metrics.NewRegisteredMeter("kd/downloader/receipts/in", nil)
	receiptReqTimer     = metrics.NewRegisteredTimer("kd/downloader/receipts/req", nil)
	receiptDropMeter    = metrics.NewRegisteredMeter("kd/downloader/receipts/drop", nil)
	receiptTimeoutMeter = metrics.NewRegisteredMeter("kd/downloader/receipts/timeout", nil)

	stateInMeter   = metrics.NewRegisteredMeter("kd/downloader/states/in", nil)
	stateDropMeter = metrics.NewRegisteredMeter("kd/downloader/states/drop", nil)
)
