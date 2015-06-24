import std.conv;
import std.stdio;
import std.string;

int main()
{
    int num_rows = 50;
    int num_columns = 3;
    int number_word_gap = 2;
    int column_gap = 8;

    File fd = File("English/wordlist.txt", "r");

    struct Pair
    {
        int number;
        string word;
    }

    Pair[] page_contents;

    page_contents.length = num_rows * num_columns;

    int i = 0;

    for (i = 0; i < (num_rows * num_columns); ++i)
    {
        if (fd.eof())
        {
            break;
        }

        string line = squeeze(detab(chomp(fd.readln()), 1), " ");

        page_contents[i].number = to!int(line[0..5]);
        page_contents[i].word = line[6..$];
        writefln("%d -> %s", page_contents[i].number, page_contents[i].word);
    }

    fd.close();

    return 0;
}
