#include "dialog.h"
#include <iostream>
#include <QApplication>
#include <QDebug>


int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    Dialog w;
    w.setParams(argc, argv);
    w.show();
    return a.exec();
}
