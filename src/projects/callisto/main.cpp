// Copyright 2016 The Charon Platform Authors.
// All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include "dialog.h"
#include <QApplication>
#include <callisto.h>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    Callisto callisto(argc, argv);
    return app.exec();
}
