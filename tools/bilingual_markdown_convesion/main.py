import unicodedata
from pathlib import Path


def chang_zh_to_en(path):
    f = open(path, 'r', encoding='utf-8')
    old = f.read()
    new = unicodedata.normalize('NFKC', old)
    f1 = open(path, 'w', encoding='utf-8')
    f1.write(new)
    f.close()
    f1.close()
 
# 备份文件
def backup_file(oldpath):
    # 过滤不存在的文件路径
    if not Path(oldpath).is_file():
        msg = "{0} is not a file path!".format(oldpath)
        raise NameError()
    # 获取文件名
    dir_path, file_name = os.path.split(oldpath)
    # 拷贝文件
    copyfile(path， file_name+".bak")
    return SUCCESS

if __name__ == '__main__':
    path = 'test1.py'
    chang_zh_to_en(path)