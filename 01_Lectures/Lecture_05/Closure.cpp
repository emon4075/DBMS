#include <bits/stdc++.h>
using namespace std;

struct FD
{
    set<char> L;
    set<char> R;
};

set<char> attrClosure(vector<FD> V, set<char> A)
{
    set<char> Result = A;
    int oldSize;
    while (1)
    {
        oldSize = Result.size();
        for (auto i : V)
        {
            bool isSubSet = true;
            for (auto j : i.L)
            {
                if (Result.find(j) == Result.end())
                {
                    isSubSet = false;
                    break;
                }
            }
            if (isSubSet)
            {
                Result.insert(i.R.begin(), i.R.end());
            }
        }
        if (oldSize == Result.size())
        {
            break;
        }
    }
    return Result;
}

int main()
{
    vector<FD> V;
    int N;
    cout << "Enter The Number of FDs: ";
    cin >> N;

    for (int i = 0; i < N; i++)
    {
        FD fd;
        int leftSize, rightSize;

        cout << "Enter number of attributes on left side of FD " << (i + 1) << ": ";
        cin >> leftSize;

        cout << "Enter left side attributes: ";
        for (int j = 0; j < leftSize; j++)
        {
            char attr;
            cin >> attr;
            fd.L.insert(attr);
        }

        cout << "Enter number of attributes on right side of FD " << (i + 1) << ": ";
        cin >> rightSize;

        cout << "Enter right side attributes: ";
        for (int j = 0; j < rightSize; j++)
        {
            char attr;
            cin >> attr;
            fd.R.insert(attr);
        }

        V.push_back(fd);
    }

    set<char> A;
    int attrCount;
    cout << "Enter number of attributes for closure computation: ";
    cin >> attrCount;

    cout << "Enter attributes: ";
    for (int i = 0; i < attrCount; i++)
    {
        char attr;
        cin >> attr;
        A.insert(attr);
    }

    set<char> Result = attrClosure(V, A);

    cout << "Closure: {";
    for (auto i : Result)
    {
        cout << i << " ";
    }
    cout << "}" << endl;
    return 0;
}