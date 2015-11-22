/****************************************************************************
** Meta object code from reading C++ file 'ExplorerPanel.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.5.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../ExplorerPanel.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'ExplorerPanel.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.5.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_ExplorerPanel_t {
    QByteArrayData data[9];
    char stringdata0[98];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_ExplorerPanel_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_ExplorerPanel_t qt_meta_stringdata_ExplorerPanel = {
    {
QT_MOC_LITERAL(0, 0, 13), // "ExplorerPanel"
QT_MOC_LITERAL(1, 14, 13), // "onCreateScene"
QT_MOC_LITERAL(2, 28, 0), // ""
QT_MOC_LITERAL(3, 29, 13), // "DiagramScene*"
QT_MOC_LITERAL(4, 43, 5), // "scene"
QT_MOC_LITERAL(5, 49, 12), // "onCreateItem"
QT_MOC_LITERAL(6, 62, 12), // "DiagramItem*"
QT_MOC_LITERAL(7, 75, 9), // "movedItem"
QT_MOC_LITERAL(8, 85, 12) // "onDeleteItem"

    },
    "ExplorerPanel\0onCreateScene\0\0DiagramScene*\0"
    "scene\0onCreateItem\0DiagramItem*\0"
    "movedItem\0onDeleteItem"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_ExplorerPanel[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       3,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    1,   29,    2, 0x08 /* Private */,
       5,    1,   32,    2, 0x08 /* Private */,
       8,    1,   35,    2, 0x08 /* Private */,

 // slots: parameters
    QMetaType::Void, 0x80000000 | 3,    4,
    QMetaType::Void, 0x80000000 | 6,    7,
    QMetaType::Void, 0x80000000 | 6,    7,

       0        // eod
};

void ExplorerPanel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        ExplorerPanel *_t = static_cast<ExplorerPanel *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->onCreateScene((*reinterpret_cast< DiagramScene*(*)>(_a[1]))); break;
        case 1: _t->onCreateItem((*reinterpret_cast< DiagramItem*(*)>(_a[1]))); break;
        case 2: _t->onDeleteItem((*reinterpret_cast< DiagramItem*(*)>(_a[1]))); break;
        default: ;
        }
    }
}

const QMetaObject ExplorerPanel::staticMetaObject = {
    { &QWidget::staticMetaObject, qt_meta_stringdata_ExplorerPanel.data,
      qt_meta_data_ExplorerPanel,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *ExplorerPanel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ExplorerPanel::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_ExplorerPanel.stringdata0))
        return static_cast<void*>(const_cast< ExplorerPanel*>(this));
    return QWidget::qt_metacast(_clname);
}

int ExplorerPanel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 3)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 3)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 3;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
