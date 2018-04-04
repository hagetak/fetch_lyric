
## How to use

This script can be searched lyric by http://search.j-lyric.net.

### Search with X


1. Search with artist
```
# search with article
ruby fetch_lyric.rb -a "Michael Jackson"
0: Michael Jackson THEY DON'T CARE ABOUT US 歌詞 (http://j-lyric.net/artist/a050575/l01c7a3.html)
1: Michael Jackson THIS IS IT 歌詞 (http://j-lyric.net/artist/a050575/l01c7a4.html)
2: Michael Jackson BLOOD ON THE DANCE FLOOR 歌詞 (http://j-lyric.net/artist/a050575/l017c54.html)
```

2. Choose number, if you want to see lyric.
```
# If you wanna "This is it", choose "1"
what do you want see? input number or exit => -1: 1
```

3. See lyric
```
<p id="Lyric">This is it, here I stand
I'm the light of the world, I feel grand
And this love I can feel
And I know, yes for sure, it is real
...
```

And also, you can be search with title or lyric.

```
# you wanna search with title
ruby fetch_lyric.rb -t "This is it"

# you wanna search with lyric
ruby fetch_lyric.rb -l "This is it, here I stand"
```

Finally, you can be search with multi keyword.
If you wanna search with title and artist, as follows.

```
ruby fetch_lyric.rb -t "This is it" -a "Michael"
```


