#include <lua/lua.hpp>
#include <QtCore>
#include <QThread>

class CThread : public QThread
{
  public:
  QByteArray   m_charonPath;
  QByteArray   m_fileName;
  lua_State  * m_luaState;

  explicit CThread(CByteArray charonPath, CByteArray fileName);
  void run();
};
