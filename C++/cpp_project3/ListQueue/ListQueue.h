#pragma once
template<typename T>
struct Node
{
    T data_;
    Node<T>* pre_;
    Node<T>* next_;
    //之后要用new 创造Node
    Node(const T& item = T(), Node* p = nullptr, Node* n = nullptr) : data_(item), pre_(p), next_(n) {}

};
template<typename T>
class Iterator
{
public:
    Node<T>* cur_;

    //构造函数
    Iterator() : cur_(nullptr) {}
    Iterator(Node<T>* c) : cur_(c) {}
    Iterator(const Iterator& itr) : cur_(itr.cur_) {}


    //重载函数
    Iterator& operator ++()
    {
        cur_ = cur_->next_;
        return *this;
    }
    //前缀++
    Iterator& operator --()
    {
        cur_ = cur_->pre_;
        return *this;
    }
    //前缀--
    Iterator& operator ++(int n)
    {
        cur_ = cur_->next_;
        return *this;
    }
    //后缀++
    Iterator& operator --(int n)
    {
        cur_ = cur_->pre_;
        return *this;
    }
    //后缀--
    T& operator *()
    {
        return cur_->data_;
    }
    const T& operator *() const
    {
        return cur_->data_;
    }
    //*重载
    bool operator ==(const Iterator& itr)
    {
        return (cur_ == itr.cur_);
    }
    bool operator !=(const Iterator& itr)
    {
        return (cur_ != itr.cur_);
    }
    //判断
};

template<typename T>
class ListQueue
{
    Node<T>* head_;//头指针
    Node<T>* tail_;//尾指针
    int size_;//元素个数
public:

    typedef Iterator<T> iterator;
    typedef const Iterator<T> const_iterator;
    ListQueue()
    {
        size_ = 0;
        head_ = new Node<T>();
        tail_ = new Node<T>();
        head_->next_ = tail_;//双向链表，但不循环
        head_->pre_ = nullptr;
        tail_->pre_ = head_;
        tail_->next_ = nullptr;
    }
    ~ListQueue()
    {
        clear();
        delete head_;
        delete tail_;
    }
    ListQueue(const ListQueue& l)
    {
        size_ = l.size_;
        head_ = new Node<T>();
        tail_ = new Node<T>();
        head_->next_ = tail_;
        head_->pre_ = nullptr;
        tail_->pre_ = head_;
        tail_->next_ = nullptr;
        for (iterator temp = l.begin(); temp != l.end(); temp++)
            push_back(*temp);//一个一个节点复制


    }
    void clear()
    {
        iterator temp = begin();
        while (temp != end())
            temp = erase(temp);
    }

    iterator begin()
    {
        return iterator(head_->next_);
    }
    const_iterator  begin() const
    {
        return iterator(head_->next_);
    }

    iterator end()
    {
        return iterator(tail_);
    }
    const_iterator end()const
    {
        return iterator(tail_);
    }

    T& front()
    {
        return *begin();
    }
    const T& front()const
    {
        return *begin();
    }

    T& back()
    {
        return  *(--end());
    }
    const T& back()const
    {
        return *(--end());
    }
    //检测是否越界再返在特定位置元素的引用
    T& at(int idx) const
    {
        iterator temp = this->begin();
        if (idx < this->size_)
        {
            while (idx)
            {
                temp++;
                idx--;
            }
            return *temp;
        }
        throw std::exception();
    }
    /*T& operator[](int idx) const
    {
        return at(idx);//利用写好的at函数,这是最初的版本，但题目要求[]是随机访问
    }*/
    T& operator[](int idx) const
    {
        if (idx == -1)
        {
            int number = rand() % this->size_;
            return at(number);//设定[-1]为随机访问
        }
        else return at(idx);
    }
    //将随机访问到的值删除
    void FindforErase(const T& d)
    {
        auto it1 = this->begin();
        auto it2 = this->end();
        while (it1 != it2)
        {
            it2--;//前后同时开始遍历，提高效率
            if (*it1 == d)
            {
                this->erase(it1);
                break;
            }
            else if (*it2 == d)
            {
                this->erase(it2);
                break;
            }
            else it1++;
            if (it1 == it2)
                break;
        }
    }
    ListQueue& operator =(const ListQueue& l)
    {
        if (this != &l)
        {
            clear();
            size_ = l.size_;

            for (iterator temp = l.begin(); temp != l.end(); temp++)
                push_back(*temp);
            return *this;

        }
        return *this;

    }

    void push_front(const T& item)
    {
        insert(begin(), item);
    }
    void push_back(T& item)
    {

        insert(end(), item);
    }

    void pop_front()
    {
        erase(begin());
    }
    void pop_back()
    {
        erase(--end());
    }

    int size()const
    {
        return size_;
    }
    bool empty()
    {
        return this->size_ == 0;
    }

    iterator insert(const  iterator itr, const T& item)
    {
        Node<T>* n = itr.cur_;
        Node<T>* newnode = new Node<T>(item, n->pre_, n);
        n->pre_->next_ = newnode;
        n->pre_ = newnode;
        size_++;

        return iterator(newnode);
    }

    iterator erase(iterator itr)
    {
        Node<T>* temp = itr.cur_;
        temp->pre_->next_ = temp->next_;
        temp->next_->pre_ = temp->pre_;
        size_--;
        Node<T>* p = temp->next_;
        delete temp;

        return iterator(p);
    }
    friend std::ostream& operator<<(std::ostream& out, const ListQueue<T>& l)
    {
        iterator first = l.begin();
        iterator last = l.end();
        for (; first != last; ++first)
            out << *first << ' ';
        out << std::endl;
        return out;
    }
};
