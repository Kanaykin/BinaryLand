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
    QByteArrayData data[21];
    char stringdata0[245];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_ExplorerPanel_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_ExplorerPanel_t qt_meta_stringdata_ExplorerPanel = {
    {
QT_MOC_LITERAL(0, 0, 13), // "ExplorerPanel"
QT_MOC_LITERAL(1, 14, 13), // "sigSelectItem"
QT_MOC_LITERAL(2, 28, 0), // ""
QT_MOC_LITERAL(3, 29, 12), // "DiagramItem*"
QT_MOC_LITERAL(4, 42, 4), // "item"
QT_MOC_LITERAL(5, 47, 13), // "onCreateScene"
QT_MOC_LITERAL(6, 61, 13), // "DiagramScene*"
QT_MOC_LITERAL(7, 75, 5), // "scene"
QT_MOC_LITERAL(8, 81, 12), // "onCreateItem"
QT_MOC_LITERAL(9, 94, 9), // "movedItem"
QT_MOC_LITERAL(10, 104, 12), // "onDeleteItem"
QT_MOC_LITERAL(11, 117, 13), // "onItemPressed"
QT_MOC_LITERAL(12, 131, 16), // "QTreeWidgetItem*"
QT_MOC_LITERAL(13, 148, 6), // "column"
QT_MOC_LITERAL(14, 155, 12), // "onSelectItem"
QT_MOC_LITERAL(15, 168, 17), // "onIntValueChanged"
QT_MOC_LITERAL(16, 186, 11), // "QtProperty*"
QT_MOC_LITERAL(17, 198, 4), // "prop"
QT_MOC_LITERAL(18, 203, 3), // "val"
QT_MOC_LITERAL(19, 207, 18), // "onEnumValueChanged"
QT_MOC_LITERAL(20, 226, 18) // "onBoolValueChanged"

    },
    "ExplorerPanel\0sigSelectItem\0\0DiagramItem*\0"
    "item\0onCreateScene\0DiagramScene*\0scene\0"
    "onCreateItem\0movedItem\0onDeleteItem\0"
    "onItemPressed\0QTreeWidgetItem*\0column\0"
    "onSelectItem\0onIntValueChanged\0"
    "QtProperty*\0prop\0val\0onEnumValueChanged\0"
    "onBoolValueChanged"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_ExplorerPanel[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       9,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   59,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       5,    1,   62,    2, 0x08 /* Private */,
       8,    1,   65,    2, 0x08 /* Private */,
      10,    1,   68,    2, 0x08 /* Private */,
      11,    2,   71,    2, 0x08 /* Private */,
      14,    1,   76,    2, 0x08 /* Private */,
      15,    2,   79,    2, 0x08 /* Private */,
      19,    2,   84,    2, 0x08 /* Private */,
      20,    2,   89,    2, 0x08 /* Private */,

 // signals: parameters
    QMetaType::Void, 0x80000000 | 3,    4,

 // slots: parameters
    QMetaType::Void, 0x80000000 | 6,    7,
    QMetaType::Void, 0x80000000 | 3,    9,
    QMetaType::Void, 0x80000000 | 3,    9,
    QMetaType::Void, 0x80000000 | 12, QMetaType::Int,    4,   13,
    QMetaType::Void, 0x80000000 | 3,    9,
    QMetaType::Void, 0x80000000 | 16, QMetaType::Int,   17,   18,
    QMetaType::Void, 0x80000000 | 16, QMetaType::Int,   17,   18,
    QMetaType::Void, 0x80000000 | 16, QMetaType::Bool,   17,   18,

       0        // eod
};

void ExplorerPanel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        ExplorerPanel *_t = static_cast<ExplorerPanel *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->sigSelectItem((*reinterpret_cast< DiagramItem*(*)>(_a[1]))); break;
        case 1: _t->onCreateScene((*reinterpret_cast< DiagramScene*(*)>(_a[1]))); break;
        case 2: _t->onCreateItem((*reinterpret_cast< DiagramItem*(*)>(_a[1]))); break;
        case 3: _t->onDeleteItem((*reinterpret_cast< DiagramItem*(*)>(_a[1]))); break;
        case 4: _t->onItemPressed((*reinterpret_cast< QTreeWidgetItem*(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 5: _t->onSelectItem((*reinterpret_cast< DiagramItem*(*)>(_a[1]))); break;
        case 6: _t->onIntValueChanged((*reinterpret_cast< QtProperty*(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 7: _t->onEnumValueChanged((*reinterpret_cast< QtProperty*(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 8: _t->onBoolValueChanged((*reinterpret_cast< QtProperty*(*)>(_a[1])),(*reinterpret_cast< bool(*)>(_a[2]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (ExplorerPanel::*_t)(DiagramItem * );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&ExplorerPanel::sigSelectItem)) {
                *result = 0;
            }
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
        if (_id < 9)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 9)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 9;
    }
    return _id;
}

// SIGNAL 0
void ExplorerPanel::sigSelectItem(DiagramItem * _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_END_MOC_NAMESPACE
