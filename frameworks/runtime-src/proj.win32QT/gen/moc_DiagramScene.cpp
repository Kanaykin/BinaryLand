/****************************************************************************
** Meta object code from reading C++ file 'DiagramScene.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.5.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../DiagramScene.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'DiagramScene.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.5.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_DiagramScene_t {
    QByteArrayData data[13];
    char stringdata0[155];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_DiagramScene_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_DiagramScene_t qt_meta_stringdata_DiagramScene = {
    {
QT_MOC_LITERAL(0, 0, 12), // "DiagramScene"
QT_MOC_LITERAL(1, 13, 9), // "itemMoved"
QT_MOC_LITERAL(2, 23, 0), // ""
QT_MOC_LITERAL(3, 24, 12), // "DiagramItem*"
QT_MOC_LITERAL(4, 37, 9), // "movedItem"
QT_MOC_LITERAL(5, 47, 17), // "movedFromPosition"
QT_MOC_LITERAL(6, 65, 14), // "sigCreateScene"
QT_MOC_LITERAL(7, 80, 13), // "DiagramScene*"
QT_MOC_LITERAL(8, 94, 5), // "scene"
QT_MOC_LITERAL(9, 100, 13), // "sigCreateItem"
QT_MOC_LITERAL(10, 114, 13), // "sigDeleteItem"
QT_MOC_LITERAL(11, 128, 13), // "sigSelectItem"
QT_MOC_LITERAL(12, 142, 12) // "onSelectItem"

    },
    "DiagramScene\0itemMoved\0\0DiagramItem*\0"
    "movedItem\0movedFromPosition\0sigCreateScene\0"
    "DiagramScene*\0scene\0sigCreateItem\0"
    "sigDeleteItem\0sigSelectItem\0onSelectItem"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_DiagramScene[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       5,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    2,   44,    2, 0x06 /* Public */,
       6,    1,   49,    2, 0x06 /* Public */,
       9,    1,   52,    2, 0x06 /* Public */,
      10,    1,   55,    2, 0x06 /* Public */,
      11,    1,   58,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
      12,    1,   61,    2, 0x09 /* Protected */,

 // signals: parameters
    QMetaType::Void, 0x80000000 | 3, QMetaType::QPointF,    4,    5,
    QMetaType::Void, 0x80000000 | 7,    8,
    QMetaType::Void, 0x80000000 | 3,    4,
    QMetaType::Void, 0x80000000 | 3,    4,
    QMetaType::Void, 0x80000000 | 3,    4,

 // slots: parameters
    QMetaType::Void, 0x80000000 | 3,    4,

       0        // eod
};

void DiagramScene::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        DiagramScene *_t = static_cast<DiagramScene *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->itemMoved((*reinterpret_cast< DiagramItem*(*)>(_a[1])),(*reinterpret_cast< const QPointF(*)>(_a[2]))); break;
        case 1: _t->sigCreateScene((*reinterpret_cast< DiagramScene*(*)>(_a[1]))); break;
        case 2: _t->sigCreateItem((*reinterpret_cast< DiagramItem*(*)>(_a[1]))); break;
        case 3: _t->sigDeleteItem((*reinterpret_cast< DiagramItem*(*)>(_a[1]))); break;
        case 4: _t->sigSelectItem((*reinterpret_cast< DiagramItem*(*)>(_a[1]))); break;
        case 5: _t->onSelectItem((*reinterpret_cast< DiagramItem*(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 1:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< DiagramScene* >(); break;
            }
            break;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (DiagramScene::*_t)(DiagramItem * , const QPointF & );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&DiagramScene::itemMoved)) {
                *result = 0;
            }
        }
        {
            typedef void (DiagramScene::*_t)(DiagramScene * );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&DiagramScene::sigCreateScene)) {
                *result = 1;
            }
        }
        {
            typedef void (DiagramScene::*_t)(DiagramItem * );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&DiagramScene::sigCreateItem)) {
                *result = 2;
            }
        }
        {
            typedef void (DiagramScene::*_t)(DiagramItem * );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&DiagramScene::sigDeleteItem)) {
                *result = 3;
            }
        }
        {
            typedef void (DiagramScene::*_t)(DiagramItem * );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&DiagramScene::sigSelectItem)) {
                *result = 4;
            }
        }
    }
}

const QMetaObject DiagramScene::staticMetaObject = {
    { &QGraphicsScene::staticMetaObject, qt_meta_stringdata_DiagramScene.data,
      qt_meta_data_DiagramScene,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *DiagramScene::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *DiagramScene::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_DiagramScene.stringdata0))
        return static_cast<void*>(const_cast< DiagramScene*>(this));
    return QGraphicsScene::qt_metacast(_clname);
}

int DiagramScene::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QGraphicsScene::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    }
    return _id;
}

// SIGNAL 0
void DiagramScene::itemMoved(DiagramItem * _t1, const QPointF & _t2)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void DiagramScene::sigCreateScene(DiagramScene * _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void DiagramScene::sigCreateItem(DiagramItem * _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void DiagramScene::sigDeleteItem(DiagramItem * _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}

// SIGNAL 4
void DiagramScene::sigSelectItem(DiagramItem * _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 4, _a);
}
QT_END_MOC_NAMESPACE
