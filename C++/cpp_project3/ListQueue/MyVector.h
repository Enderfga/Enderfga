#pragma once
#include <iostream>//防止几个误报错的提示
#pragma warning(disable:6385)
#pragma warning(disable:6386)
#pragma warning(disable:4819)
template <typename T>
class MyVector
{
private:
    T* _items;
    unsigned int _capacity;//分配的空间大小（包括预留空间）
    unsigned int _size;//元素个数
    static const unsigned int _defaultCapacity = 4;//默认容量大小

    void set_capacity(unsigned int newCapacity)//通过ensure_capacity，set_capacity两个私有函数来设置容量大小
    {
        if (newCapacity != this->_capacity)
        {
            if (newCapacity > 0)
            {
                T* newItems = new T[newCapacity];
                for (unsigned int i = 0; i < this->_size; ++i)
                    newItems[i] = _items[i];
                delete[] _items;
                _items = newItems;
                _capacity = newCapacity;
            }
            else
            {
                _items = new T[_defaultCapacity];
                _capacity = _defaultCapacity;
            }
        }
    }

    void ensure_capacity(unsigned int min)
    {
        if (this->_capacity < min)
        {
            unsigned int newCapacity = (this->_size == 0 ? _defaultCapacity : this->_capacity * 2);
            if (newCapacity < min)
                newCapacity = min;
            set_capacity(newCapacity);
        }
    }

public:
    MyVector()
    {
        _items = new T[_defaultCapacity];
        this->_capacity = _defaultCapacity;
        this->_size = 0;//以默认容量开辟空间，元素个数为0
    }

    MyVector(int Get_capacity)
    {
        if (Get_capacity <= _defaultCapacity)//如果参数容量小于等于默认容量 以默认容量开辟空间
            Get_capacity = _defaultCapacity;

        _items = new T[Get_capacity];
        this->_capacity = Get_capacity;
        this->_size = 0;
    }

    MyVector(const MyVector<T>& other)//深度复制构造函数
    {
        copy_from(other);
    }

    T& operator[](unsigned int idx) const
    {
        return at(idx);//利用写好的at函数
    }

    void copy_from(const MyVector<T>& other)
    {
        ensure_capacity(other.Get_size());//通过该函数确认容量大小
        for (unsigned int i = 0; i < other.Get_size(); ++i)
            _items[i] = other.at(i);
        _size = other.Get_size();
    }

    MyVector<T>& operator=(const MyVector<T>& other)
    {
        if (this == &other)//检测自我赋值
            return *this;
        else copy_from(other);
    }
    bool operator==(const MyVector<T>& other)
    {
        if (this->_items == other._items)
            return true;
        else return false;
    }
    MyVector<T> operator+(const MyVector<T>& other)
    {
        MyVector<T> result;//声明一个新的对象来存放结果
        for (unsigned int i = 0; i < this->_size; ++i)
            result.push_back(_items[i]);
        for (unsigned int i = 0; i < other._size; ++i)
            result.push_back(other.at(i));
        return result;
    }
    unsigned int Get_size() const
    {
        return this->_size;
    }
    unsigned int Get_capacity() const
    {
        return this->_capacity;
    }
    void clear()
    {
        delete[] _items;//将原内容清空
        _items = new T[this->_capacity];//开辟新的空间
        this->_size = 0;//现元素为0
    }
    void push_back(const T& item)//向量尾部增加一个元素X
    {
        ensure_capacity(this->_size + 1);
        _items[this->_size++] = item;
    }
    T& at(unsigned int idx) const
    {
        if (idx < this->_size)
            return _items[idx];
        throw std::exception();
    }
    void pop_back()//删除向量中最后一个元素
    {
        if (this->_size > 0)
        {
            this->_size--;
        }
    }
    bool empty()//判断向量是否为空
    {
        return this->_size == 0;
    }
    T& front()//返回首元素的值，否则抛出异常
    {
        if (this->_size > 0)
            return _items[0];
        throw std::exception();
    }
    T& back()//返回末元素的值，否则抛出异常
    {
        if (this->_size > 0)
            return _items[this->_size - 1];
        throw std::exception();
    }
    bool insert(unsigned int pos, const T& item)//在指定位置增加元素
    {
        if (pos >= this->_size)
            return false;

        ensure_capacity(this->_size + 1);
        for (unsigned int i = this->_size; i > pos; --i)
            _items[i] = _items[i - 1];
        _items[pos] = item;
        ++(this->_size);
        return true;
    }
    bool erase(unsigned int pos)//删除指定位置元素
    {
        if (pos >= this->_size || empty())
            return false;
        --(this->_size);
        for (unsigned int i = pos; i < this->_size; ++i)
            _items[i] = _items[i + 1];
        return true;
    }
    ~MyVector()//析构函数，释放内存
    {
        delete[] _items;
    }
    friend std::ostream& operator<<(std::ostream& out, const MyVector<T>& P)
    {
        out << "[ ";
        for (unsigned i = 0; i < P.Get_size(); )
        {
            out << P.at(i++);
            if (i != P.Get_size())
                out << ", ";
        }
        out << " ]" << std::endl;
        return out;
    }
};
