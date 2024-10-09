#include <stdio.h>

int main()
{
    int n, sum = 0;

    // 提示用户输入
    printf("Please input a number between 1 and 100, ended with `enter` : ");
    scanf("%d", &n);

    // 检查输入范围
    if (n >= 1 && n <= 100)
    {
        // 计算从 1 到 n 的和
        for (int i = 1; i <= n; i++)
        {
            sum += i;
        }
        // 打印结果
        printf("%d\n", sum);
    }
    else
    {
        printf("Wrong input!\n");
    }

    return 0;
}
