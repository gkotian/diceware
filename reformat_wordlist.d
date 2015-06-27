import std.stdio;
import std.string;

int main()
{
    int num_rows = 50;
    int num_columns = 3;
    int number_word_gap = 2;
    int column_gap = 8;
    int chars_per_row = 100;

    int chars_per_column = chars_per_row / num_columns;

    int number_width = 5 + number_word_gap;
    int word_width = chars_per_column - number_width;

    auto entries_per_page = num_rows * num_columns;

    File file_in = File("English/wordlist.txt", "r");
    File file_out = File("English/wordlist_reformatted.txt", "w");

    struct Pair
    {
        string number;
        string word;
    }

    Pair[] page_contents;

    page_contents.length = entries_per_page;

    int page_num = 0;

    while (!file_in.eof())
    {
        int i;

        for (i = 0; (i < entries_per_page) && !file_in.eof(); ++i)
        {
            string line = strip(squeeze(detab(chomp(file_in.readln()), 1), " "));

            if ( line.length == 0 )
            {
                --i;
                continue;
            }

            page_contents[i].number = line[0..5];
            page_contents[i].word = line[6..$];
        }

        // writefln("i = %d, Page %d : '%s' to '%s'", i, page_num++,
        //     page_contents[0], page_contents[i-1]);
        auto entries_in_cur_page = i - 1;

        int entries_shown = 0;

        for (auto row = 0; row < num_rows; ++row)
        {
            int index_of_entry;
            int col;

            bool done = false;

            for (col = 0; col < num_columns - 1; ++col)
            {
                index_of_entry = (col * num_rows) + row;

                file_out.writef("%s%s",
                    leftJustify(page_contents[index_of_entry].number, number_width),
                    leftJustify(page_contents[index_of_entry].word, word_width));

                ++entries_shown;

                if ( entries_shown == entries_in_cur_page )
                {
                    done = true;
                    break;
                }
            }

            if ( done )
            {
                break;
            }

            index_of_entry = (col * num_rows) + row;

            file_out.writef("%s%s\n",
                leftJustify(page_contents[index_of_entry].number, number_width),
                page_contents[index_of_entry].word);

            ++entries_shown;

            if ( entries_shown == entries_in_cur_page )
            {
                break;
            }
        }

        file_out.writeln();
    }

    file_in.close();
    file_out.close();

    return 0;
}
