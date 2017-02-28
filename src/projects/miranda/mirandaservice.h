// Copyright 2016 The Charon Platform Authors.
// All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <lua/lua.hpp>
#include <QtCore>
#include <QRunnable>
#include <QThread>
#include <QMutex>
#include <charon/base>

class MirandaService : public QThread, public QRunnable
{

  private:
  static QMutex s_mutex;
  QByteArray m_fileName;
  QByteArray m_uuid;
  bool   m_shutdown;
  bool   m_service;
  double m_time;

  public:
  MirandaService(QByteArray fileName);
  MirandaService(QByteArray fileName, QByteArray uuid);
  ~MirandaService();
  bool loop(int secs);
  void shutdown();
  bool isShutdown();
  void run();
  double time();

};
