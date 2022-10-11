#include "base.h"
#include <cstring>
#include<algorithm>
using namespace std;

void CreateMemory()
{
//从1-50块,把奇数块号的模拟主存块每个字节都设为0x55，把偶数块号的模拟主存块每个字节都设为0xAA
    string x55 = "01010101";
    string xAA = "10101010";
    std::bitset<8> tmp1(x55);
    std::bitset<8> tmp2(xAA);
    for(i=0; i<50; i++)
    {
        if(i%2==0)
        {
            for(j=0; j<i_cache_line_size; j++)
            {
                memory_item[i][j] = tmp1;
            }
        }
        else
        {
            for(j=0; j<i_cache_line_size; j++)
            {
                memory_item[i][j] = tmp2;
            }
        }
    }
    //输出分割线
    cout<<"--------------------------------------------------"<<endl;
    //打印块号为28和29中第一字节的内容
    cout << "The first byte of block 28 is: " << memory_item[27][0] << endl;
    cout << "The first byte of block 29 is: " << memory_item[28][0] << endl;
    //输出分割线
    cout<<"--------------------------------------------------"<<endl;
    //将块号为29的模拟主存块装入模拟Cache，打印按函数映射的Cache组号，打印其对应的标记字段。
    cout << "The block 29 is loaded into the cache." << endl;
    
    
    //将29转换为二进制，块号+块内地址=主存物理地址=标记+组号+块内地址
    string x29 = "11101"; 
    //std::size_t len =bit_tag+bit_set; //=7
    std::bitset<7> tmp3(x29);
    //打印tmp3的后bit_set位，bit_set=4以及10进制形式
    //转为10进制
    int n = 0;
    for (int i = 0; i < bit_set; i++)
    {
        n += tmp3[i] * pow(2, i);
    }
    cout << "The set number of block 29 is: " << tmp3.to_string().substr(bit_tag,bit_set) << " (" << n << ")" << endl;
    //将第29块memory_item随机放到第n块cache_data的前8位或者后8位
    int x = rand()%2;
    for(i=0; i<i_cache_line_size; i++)
    {
        //cache_data[n-1][i]有16位，memory_item[28][i]有8位，随机放到前8位或者后8位
        
        if(x==0)
        {
            for(j=0; j<8; j++)
            {
                cache_data[n-1][i][j] = memory_item[28][i][j];
            }
        }
        else
        {
            for(j=8; j<16; j++)
            {
                cache_data[n-1][i][j] = memory_item[28][i][j-8];
            }
        }
    }
    //打印tmp3的前bit_tag位，bit_tag=3
    cout<<"The tag of block 29 is: "<<tmp3.to_string().substr(0,bit_tag)<<endl;
    
}
