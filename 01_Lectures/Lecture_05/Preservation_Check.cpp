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

set<char> Intersection(set<char> S1, set<char> S2)
{
    set<char> Result;
    for (auto i : S1)
    {
        if (S2.find(i) != S2.end())
        {
            Result.insert(i);
        }
    }
    return Result;
}

set<char> attrClosureD(vector<FD> F, set<char> A, vector<set<char>> decomposition)
{
    set<char> Result = A;
    set<char> oldResult;

    while (1)
    {
        oldResult = Result;

        for (auto Ri : decomposition)
        {
            set<char> intersection = Intersection(oldResult, Ri);
            set<char> closureOfIntersection = attrClosure(F, intersection);
            set<char> t = Intersection(closureOfIntersection, Ri);

            Result.insert(t.begin(), t.end());
        }

        if (oldResult == Result)
        {
            break;
        }
    }

    return Result;
}

int main()
{
    vector<FD> F;
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

        F.push_back(fd);
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

    vector<set<char>> decomposition;
    int numRelations;
    cout << "Enter number of relations in decomposition: ";
    cin >> numRelations;

    for (int i = 0; i < numRelations; i++)
    {
        set<char> relation;
        int relSize;
        cout << "Enter number of attributes in relation " << (i + 1) << ": ";
        cin >> relSize;

        cout << "Enter attributes for relation " << (i + 1) << ": ";
        for (int j = 0; j < relSize; j++)
        {
            char attr;
            cin >> attr;
            relation.insert(attr);
        }
        decomposition.push_back(relation);
    }

    set<char> Result = attrClosureD(F, A, decomposition);

    cout << "\nOriginal attrClosure Result: ";
    set<char> originalResult = attrClosure(F, A);
    for (auto i : originalResult)
    {
        cout << i << " ";
    }
    cout << endl;

    cout << "attrClosureD Result: ";
    for (auto i : Result)
    {
        cout << i << " ";
    }
    cout << endl;

    if (originalResult == Result)
    {
        cout << "Dependency preservation: YES" << endl;
    }
    else
    {
        cout << "Dependency preservation: NO" << endl;
    }

    return 0;
}