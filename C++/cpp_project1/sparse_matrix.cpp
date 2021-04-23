#include <cassert>
#include <iostream>
#include <vector>
#include <iomanip>
using namespace std;
//以下代码改写自谭老师上传至群文件中的Matrix.cpp
/*
2* 定义一个矩阵类Matrix, 数据成员包括:数组double *data，矩阵的行nRows，矩阵的列nColumns; 函数成员包括：
（1） 构造函数，析构函数，（深度）复制构造函数，（深度）赋值运算符，
（2） nElems()函数返回矩阵元素个数, size()返回矩阵所占存储空间大小
（3） set/get矩阵某行某列的值，输出矩阵某一行，输出矩阵某一列，打印矩阵的所有值。
（4） 定义矩阵相加/相减函数add/sub，如m1.add(m2)，修改m1本身的值
（5） 重载+/-运算符，实现比如m3=m1+m2语法，这里+运算符返回一个新的Matric对象
（6） 编写主函数测试所有功能。注意：矩阵操作要检查矩阵的大小匹配
*/
class SparseMatrix;//声明稀疏矩阵类 便于添加友元类
class Matrix {
public:
    Matrix(int rows, int cols) : nRows(rows), nColumns(cols) {
        assert(rows > 0 && cols > 0);
        nElems = nRows * nColumns;
        data = new double[nElems];
        memset(data, 0, sizeof(double) * nElems);
    }
    ~Matrix() {
        delete[] data;
    }
    Matrix(const Matrix& m) {
        nRows = m.nRows;
        nColumns = m.nColumns;
        nElems = m.nElems;
        data = new double[nElems];
        memcpy(data, m.data, size());
    }
    Matrix& operator=(const Matrix& m) {
        if (this == &m)
            return *this;
        delete[] data;
        data = new double[nElems];
        memcpy(data, m.data, size());
        return *this;
    }
    int noZeroCount()const
    {
        int i;
        int count = 0;
        for (i = 0; i < nElems; i++)
            if (data[i] != 0)
                count++;
        return count;
    }
    int nElements() const { return nElems; }
    int size() const { return nElems * sizeof(double); }
    int getNumRows() const { return nRows; }
    int getNumColumns() const { return nColumns; }
    bool sizeMatch(const Matrix& m) const {
        return nRows == m.getNumRows() && nColumns == m.getNumColumns();
    }
    int flatIndex(int rowIdx, int colIdx) const {
        assert(rowIdx >= 0 && rowIdx < nRows&& colIdx >= 0 && colIdx < nColumns);
        return rowIdx * nColumns + colIdx;
    }
    double get(int rowIdx, int colIdx) const {
        assert(rowIdx >= 0 && rowIdx < nRows&& colIdx >= 0 && colIdx < nColumns);
        return data[flatIndex(rowIdx, colIdx)];
    }
    double get2(int i) const {
        return data[i];
    }
    Matrix set(int rowIdx, int colIdx, double val) {
        assert(rowIdx >= 0 && rowIdx < nRows&& colIdx >= 0 && colIdx < nColumns);
        this->data[flatIndex(rowIdx, colIdx)] = val;
        return *this;
    }
    void getRow(int rowIdx, std::vector<double>& vec) const {
        for (int i = 0; i < nColumns; i++)
            vec.push_back(get(rowIdx, i));
        //a faster implementation is to use memory copy:
        //double* startIdx = data + rowIdx * nColumns;
        //vec.assign(startIdx, startIdx + nColumns);
    }
    void getColumn(int colIdx, std::vector<double>& vec) const {
        for (int i = 0; i < nRows; i++)
            vec.push_back(get(i, colIdx));
    }
    //returning a referene type instead of void enables
    //operations like m1 + m2 + m3. That is, (m1 + m2) returns 
    //an object's reference, so (m1 + m2) + m3 is valid.
    //The same goes with operator=, <<
    Matrix& add(const Matrix& m) {
        assert(sizeMatch(m));
        for (int i = 0; i < nElems; i++)
            data[i] += m.data[i];
        return *this;
    }
    Matrix& sub(const Matrix& m) {
        assert(sizeMatch(m));
        for (int i = 0; i < nElems; i++)
            data[i] -= m.data[i];
        return *this;
    }
    friend Matrix operator+(const Matrix& m1, const Matrix& m2) {
        Matrix m(m1);
        return m.add(m2);
    }
    friend Matrix operator-(const Matrix& m1, const Matrix& m2) {
        Matrix m(m1);
        return m.sub(m2);
    }
    //returning ostream & enables operations like cout << m << m1
    friend ostream& operator<<(std::ostream& os, const Matrix& m) {
        for (int i = 0; i < m.nElems; i++) {
            cout << setw(5) << setprecision(2) << m.data[i] << " ";
            if ((i + 1) % m.nColumns == 0)
                cout << endl;
        }
        return os;
    }
    void show() const
    {
        for (int i = 0; i < this->nColumns; i++)
        {
            for (int j = 0; j < this->nRows; j++)
                cout << this->data[i] << " ";
            cout << endl;
        }
    }
private:
    int nRows;
    int nColumns;
    int nElems;
    double* data;
    friend SparseMatrix;
};
class SparseMatrix
{
private:
    friend Matrix;
    int nRows, nColumns, nElems;
    struct NonzeroElement
    {
        int row;
        int col;
        double value;
    } *data;

public:
    SparseMatrix()
    {
        nRows = 0;
        nColumns = 0;
        nElems = 0;
        data[0] = { -1, -1, 0 };
    }
    SparseMatrix(const int r, const int c) : nRows(r), nColumns(c)
    {
        data = new NonzeroElement[1];
        this->nElems = 0;
        this->data[0] = { -1, -1, 0 };
    }
    SparseMatrix(const Matrix& m) : nRows(m.nRows), nColumns(m.nColumns)
    {
        int count = 0;
        for (int i = 0; i < nRows * nColumns; ++i)
            if (m.data[i] != 0)
                count++;
        this->nElems = count;
        data = new NonzeroElement[32];
        int j = 0;
        for (int i = 0; i < nRows * nColumns; ++i)
        {
            if (m.data[i] != 0)
            {
                this->data[j].row = j / m.nColumns;
                this->data[j].col = j % m.nColumns;
                this->data[j].value = m.data[i];
                j++;
            }
        }
    }
    SparseMatrix(const SparseMatrix& m)
    {
        this->nRows = m.nRows;
        this->nColumns = m.nColumns;
        this->nElems = m.nElems;
        this->data = new NonzeroElement[this->nElems];
        for (int i = 0; i < nElems; ++i)
            data[i] = m.data[i];
    }
    ~SparseMatrix()
    {
        delete[] data;
    }
    Matrix to_Matrix()const
    {
        Matrix result(nRows, nColumns);
        for (int i = 0; i < nElems; i++)
            result.set(data[i].row, data[i].col, data[i].value);
        return result;
    };
    int getRow() const
    {
        return nRows;
    }
    int getCol() const
    {
        return nColumns;
    }
    int nElements()
    {
        return nElems;
    }
    double getVals(int r, int c)
    {
        for (int i = 0; i < this->nElems; ++i)
            if ((this->data[i].row == r) && (this->data[i].col == c))
                return this->data[i].value;
        return 0;
    }
    bool setVals(int r, int c, double val)
    {
        for (int i = 0; i < this->nElems; ++i)
            if ((this->data[i].row == r) && (this->data[i].col == c))
            {
                data[i].value = val;
                return true;
            }
        SparseMatrix temp = *this;
        delete[] data;
        this->data = new NonzeroElement[++this->nElems];
        int i = 0;
        for (; i < this->nElems; ++i)
            this->data[i] = temp.data[i];
        this->data[i] = { r, c, val };
        return true;
    }
    SparseMatrix operator=(const SparseMatrix& m)
    {
        if (this == &m)
            return *this;

        delete[] data;

        this->nRows = m.nRows;
        this->nColumns = m.nColumns;
        this->nElems = m.nElems;
        this->data = new NonzeroElement[this->nElems];
        for (int i = 0; i < nElems; ++i)
            data[i] = m.data[i];
        return *this;
    }
    SparseMatrix operator+(const SparseMatrix& m1);
    SparseMatrix operator-(const SparseMatrix& m1);
    Matrix to_matrix() const;
    SparseMatrix add(const SparseMatrix& m1);
    SparseMatrix subtract(const SparseMatrix& m1);
    void show();
};



Matrix SparseMatrix::to_matrix() const
{
    Matrix result(this->getRow(), this->getCol());
    for (int i = 0; i < this->nElems; i++)
        result.set(this->data[i].row, this->data[i].col, this->data[i].value);
    return result;
}
void SparseMatrix::show()
{
    this->to_matrix().show();
}

SparseMatrix SparseMatrix::operator+(const SparseMatrix& m1)
{
    return SparseMatrix(this->to_matrix() + m1.to_matrix());
}
SparseMatrix SparseMatrix::add(const SparseMatrix& m1)
{
    return SparseMatrix(this->to_matrix() + m1.to_matrix());
}
SparseMatrix SparseMatrix::operator-(const SparseMatrix& m1)
{
    return SparseMatrix(this->to_matrix() - m1.to_matrix());
}
SparseMatrix SparseMatrix::subtract(const SparseMatrix& m1)
{
    return SparseMatrix(this->to_matrix() - m1.to_matrix());
}
int main()
{
    Matrix a(5, 6);
    Matrix b(a);
    a = a.set(1, 3, 3);
    a = a.set(1, 5, 4);
    a = a.set(2, 3, 5);
    a = a.set(2, 4, 7);
    a = a.set(4, 2, 2);
    a = a.set(4, 3, 6);
    a.show();
    b.set(1, 1, 3);
    b.set(2, 1, 4);
    b.set(3, 3, 1);
    b.set(4, 3, 2);
    SparseMatrix sm1(a);
    SparseMatrix sm2(b);
    SparseMatrix sm3 = sm1 + sm2;
    cout << "a矩阵为" << endl;
    sm1.show();
    cout << "b矩阵为" << endl;
    sm2.show();
    cout << "a+b:" << endl;
    sm3.show();
    SparseMatrix m1 = sm1;
    cout << "Columns:" << m1.getCol() << endl;
    cout << "Rows:" << m1.getRow() << endl;
    cout << "Elements:" << m1.nElements() << endl;
    return 0;
}