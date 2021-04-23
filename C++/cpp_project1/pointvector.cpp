#include <iostream>
using namespace std;
struct Point
{
    Point(int x = 0, int y = 0) : x(x), y(y) {}
    void print()//按点的样式（x，y）输出
    {
        cout << "(" << x << "," << y << ")";
    }
    int x;
    int y;
};
class PointVector
{
public:
    PointVector() {
        data = new Point[_defaultCapacity];
    }
    
    PointVector(int capacity)
    {
        if (capacity <= _defaultCapacity)//如果参数容量小于等于默认容量 以默认容量开辟空间
            capacity = _defaultCapacity;

        data = new Point[capacity];
        this->capacity = capacity;
        this->size = 0;
    }
    PointVector(int nSize, const Point p)//参考vector(int nSize,const t& t):创建一个vector，元素个数为nSize,且值均为t
    {
        capacity = nSize;
        if (nSize <= _defaultCapacity)
            capacity = _defaultCapacity;
        size = nSize;
        data = new Point[capacity * 2];
        for (int i = 0; i < nSize; i++)
            data[i] = p;
    }
    PointVector(const PointVector& other)//深度复制构造函数
    {
        ensure_capacity(other.Get_size());//通过该函数确认容量大小
        for (unsigned int i = 0; i < other.Get_size(); ++i)
            data[i] = other.data[i];
        size = other.Get_size();
    }
    ~PointVector()//析构函数，清理内存
    {
        delete[] data;
    }
    unsigned int Get_size() const //带保护的元素个数获取
    {
        return this->size;
    }
    unsigned int Get_capacity() const//带保护的容量大小获取
    {
        return this->capacity;
    }
    PointVector& operator=(const PointVector& x)
    {
        if (this == &x)//检测自我赋值
            return *this;
        ensure_capacity(x.Get_size());
        for (unsigned int i = 0; i < x.Get_size(); ++i)
            data[i] = x.data[i];
        size = x.Get_size();
    }
    friend PointVector operator+(const PointVector& x, const PointVector& y)
    {
        PointVector result;//声明一个新的对象来存放结果
        result.size = y.size + x.size;
        for (unsigned int i = 0; i < y.size; ++i)
            result.push_back(y.data[i]);
        for (unsigned int i = 0; i < x.size; ++i)
            result.push_back(x.at(i));
        return result;
    }
    Point& operator[](int i)
    {
        return at(i);//利用写好的at函数
    }
    friend std::ostream& operator<<(std::ostream& cout, const PointVector& P);//输出流重载声明
    void clear()
    {
        delete[] data;//将原内容清空
        data = new Point[this->capacity];//开辟新的空间
        this->size = 0;//现元素为0
    }
    void push_back(const Point& item)//向量尾部增加一个元素X
    {
        ensure_capacity(this->size + 1);
        data[this->size++] = item;
    }
    void pop_back()//删除向量中最后一个元素
    {
        if (this->size > 0)
            data[this->size--] = Point();
    }
    bool empty()//判断向量是否为空
    {
        return this->size == 0;
    }
    Point& front()//返回首元素的值，否则抛出异常
    {
        if (this->size > 0)
            return this->data[0];
        throw exception("Warning!");
    }
    Point& back()//返回末元素的值，否则抛出异常
    {
        if (this->size > 0)
            return this->data[this->size - 1];
        throw exception("Warning!");
    }
    bool insert(unsigned int pos, const Point& item)//在指定位置增加元素
    {
        if (pos >= this->size)
            return false;

        ensure_capacity(this->size + 1);
        for (unsigned int i = this->size; i > pos; --i)
            data[i] = data[i - 1];
        data[pos] = item;
        ++(this->size);
        return true;
    }
    bool erase(unsigned int pos)//删除指定位置元素
    {
        if (pos >= this->size || empty())
            return false;
        --(this->size);
        for (unsigned int i = pos; i < this->size; ++i)
            data[i] = data[i + 1];
        return true;
    }
    Point& at(unsigned int idx) const //返回idx位置元素的引用
    {
        if (idx < this->size)
            return data[idx];
        throw exception("Warning!!");
    }
private:
    Point* data;
    unsigned size; //元素个数
    unsigned capacity;//分配的空间大小（包括预留空间）
    static const unsigned int _defaultCapacity = 4;//默认容量大小
    void set_capacity(unsigned int newCapacity)//通过ensure_capacity，set_capacity两个私有函数来设置容量大小
    {
        if (newCapacity != this->capacity)
        {
            if (newCapacity > 0)
            {
                Point* newItems = new Point[newCapacity * 2];
                for (unsigned int i = 0; i < this->size; ++i)
                    newItems[i] = data[i];
                delete[] data;
                data = newItems;
                capacity = newCapacity;
            }
            else
            {
                data = new Point[_defaultCapacity];
                capacity = _defaultCapacity;
            }
        }
    }

    void ensure_capacity(unsigned int min)
    {
        if (this->capacity < min)
        {
            unsigned int newCapacity = (this->size == 0 ? _defaultCapacity : this->capacity * 2);
            if (newCapacity < min)
                newCapacity = min;
            set_capacity(newCapacity);
        }
    }
};
ostream& operator<<(ostream& out, const PointVector& P)
{
    out << "[";
    for (unsigned i = 0; i < P.Get_size(); )
    {
        P.at(i++).print();
        if (i != P.Get_size())
            out << ", ";
    }
    out << "]" << endl;
    return out;
}
int main()
{
    PointVector pvec;
    if (pvec.empty()) printf("empty point vector!\n");
    for (int i = 0; i < 20; i++)
    {
        pvec.push_back(Point(i, i));
        std::cout << "size = " << pvec.Get_size() << ", capacity = " << pvec.Get_capacity() << std::endl;
    }
    pvec.front().print();
    pvec.back().print();
    PointVector pvec1(pvec);
    std::cout << pvec1;
    PointVector pvec2;
    pvec2 = pvec1;
    for (unsigned j = 0; j < pvec2.Get_size(); j++)
    {
        std::cout << pvec2.at(j).x << " " << pvec2[j].y << std::endl;
    }
    pvec.insert(0, Point(100, 100));
    std::cout << pvec << std::endl;;
    pvec.erase(pvec.Get_size() / 2);
    std::cout << pvec << std::endl;
    PointVector pvec3 = pvec1 + pvec2;
    std::cout << pvec1 + pvec2 << std::endl;
    return 0;
}