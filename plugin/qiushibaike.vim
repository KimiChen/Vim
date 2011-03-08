"=============================================================================
"  Author:          DanteZhu - http://www.vimer.cn
"  Email:           dantezhu@vip.qq.com
"  FileName:        qiushibaike.vim
"  Description:     用VIM看糗事百科
"  Version:         1.0
"  LastChange:      2010-05-04 21:08:09
"  History:
"=============================================================================
function! SetBaiKeBuffer()
let bkbuffloaded=bufloaded("baike")
if !bkbuffloaded
    execute "sp baike"
    execute "normal \Z"
else
    while 1
        execute "normal \<c-w>w"
        let currBuff=bufname("%")
        if currBuff == "baike"
            execute "normal \Z"
            break
        endif
    endwhile

endif
endfunction

function! KanXiaoHua(url,page)
call SetBaiKeBuffer()
let b:baikeurl=a:url
let b:baikepage=a:page
if a:page == ""
    let b:currbkpage=1
    let b:baikeurl=b:baikeurl."/page/".b:currbkpage
else
    let b:currbkpage=b:currbkpage+1
    let b:baikeurl=b:baikeurl."/page/".b:currbkpage
endif
python << EOF

import vim
import time
import urllib
import urllib2
import re
from BeautifulSoup import BeautifulSoup,Tag,NavigableString
from BeautifulSoup import BeautifulStoneSoup

def recurTags(tag):
    if isinstance(tag,Tag):
        if tag.has_key('class') and tag['class'] == 'tags':
            return ''

        tmpStr = ''
        for t in tag.contents:
            tmpStr += '\n'
            tmpStr += recurTags(t)

        return tmpStr

    elif isinstance(tag,NavigableString):
        if tag.string is not None:
            return tag.string
        else:
            return ''
    else:
        return `tag`

def getBaiKe():
    url=vim.eval("b:baikeurl")
    user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'
    values = {'name' : 'DanteZhu',
        'location' : 'China',
        'language' : 'Python' }
    headers = { 'User-Agent' : user_agent }

    data = urllib.urlencode(values)
    req = urllib2.Request(url, data, headers)
    response = urllib2.urlopen(req)
    the_page = response.read()
    soup = BeautifulSoup(the_page,convertEntities=BeautifulStoneSoup.HTML_ENTITIES)

    allTags = soup.findAll('div',attrs={'class' : re.compile(r'\s*qiushi_body\s*article\s*')})

    for tag in allTags:
        for art in tag.contents:
            tmpStr = recurTags(art).encode(vim.eval("&encoding"))
            tmpStr=tmpStr.replace("\r\n",'')
            strList=tmpStr.split("\n")
            for line in strList:
                if len(line) > 0:
                    vim.current.buffer.append(line)
        vim.current.buffer.append("\n")
        vim.current.buffer.append('#=============================================================================')
        vim.current.buffer.append("\n")


vim.current.buffer[:]=None
getBaiKe()
EOF
exe "set wrap"
exe 'syn match      qbSplit "^\s*\zs#.*$"'
"exe 'syn match      qbSplit    "\s\zs#.*$"'
exe 'hi def link qbSplit        Comment'
endfunction

command! -nargs=0 JOKE :call KanXiaoHua("http://www.qiushibaike.com/groups/2/latest","")
command! -nargs=0 NEXTJOKE :call KanXiaoHua("http://www.qiushibaike.com/groups/2/latest","N")
command! -nargs=0 BESTJOKE :call KanXiaoHua("http://www.qiushibaike.com/groups/2/hottest/day","")
command! -nargs=0 NEXTBESTJOKE :call KanXiaoHua("http://www.qiushibaike.com/groups/2/hottest/day","N")
