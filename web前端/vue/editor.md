# 富文本编辑器

## 主流富文本编辑器对比

+ wangEditor（国产，基于javascript和css开发的web富文本编辑器，开源免费）优势：轻量简介，最重要的是开源且中文文档齐全。缺点：更新不及时。没有强大的开发团队支撑。

![test](2020-07-22-18-04-04.png)

+ UEditor（百度）优势：插件多，基本曼度各种需求，由百度web前端研发部开发。缺点：插件提交较大，网页加载速度相对就慢了些。使用复杂。属于前后端不分离插件。在使用时需要配置后端的一些东西，使用不便。
+ Kindeditor 优势：文档齐全，为中文，阅读方便。缺点：图片上传存在问题，上传历史过多，会全部加载，导致浏览器卡顿。
补充
+ Tinymce是一款功能强大的富文本编辑器，文档为英文, 访问需梯子.
![test](2020-07-22-18-03-29.png)

+ vue-quill-editor 容易上手,简约

## vue-quill-editor

`npm install vue-quill-editor -S`

`npm install quill -S`

gitee地址
[https://gitee.com/jeffka/vue-quill-editor](https://gitee.com/jeffka/vue-quill-editor)

![test](2020-07-2218-09-30的屏幕截图.png)

下面代码在quill本身的基础上增加了以下功能

+ 查找内容, 并将找到的内容高亮显示,可以向上向下翻阅找到的其它内容
+ 行号跳转, 支持跳转至制定行

```js

<template>
  <div>
    <el-row>
      <el-col :span=6>
        <el-input
        placeholder="请输入内容"
        prefix-icon="el-icon-search"
        size="mini"
        @change="searchEnter"
        v-model="search" clearable>
        </el-input>
      </el-col>
      <el-col :span=2>
        <el-button-group>
          <el-button size="mini" icon="el-icon-top" @click="FollowingHeightlight(false)"></el-button>
          <el-button size="mini" icon="el-icon-bottom" @click="FollowingHeightlight()"></el-button>
        </el-button-group>
      </el-col>
      <el-col :span=2>
        <el-input
          placeholder="跳转行"
          size="mini"
          @change="jumpLineEnter"
          v-model="jumpLine" clearable>
        </el-input>
      </el-col>
    </el-row>
    <el-row>
      <el-col :span="10">
        <!-- 图片上传组件辅助-->
      <el-upload
        class='avatar-uploader'
        :action='serverUrl'
        name='file'
        :headers='header'
        :show-file-list='false'
        list-type='picture'
        :multiple='false'
        :on-success='uploadSuccess'
        :on-error='uploadError'
        :before-upload='beforeUpload'
      ></el-upload>
      <quill-editor
        class='editor'
        v-model='content'
        ref='myQuillEditor'
        :options='editorOption'
        @blur='onEditorBlur($event)'
        @focus='onEditorFocus($event)'
        @change='onEditorChange($event)'
      >
      </quill-editor>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { quillEditor } from 'vue-quill-editor'
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'

// 工具栏配置
const toolbarOptions = [
  ['bold', 'italic', 'underline', 'strike'], // 加粗 斜体 下划线 删除线
  ['blockquote', 'code-block'], // 引用  代码块
  [{ header: 1 }, { header: 2 }], // 1、2 级标题
  [{ list: 'ordered' }, { list: 'bullet' }], // 有序、无序列表
  [{ script: 'sub' }, { script: 'super' }], // 上标/下标
  [{ indent: '-1' }, { indent: '+1' }], // 缩进
  // [{'direction': 'rtl'}],                         // 文本方向
  [{ size: ['small', false, 'large', 'huge'] }], // 字体大小
  [{ header: [1, 2, 3, 4, 5, 6, false] }], // 标题
  [{ color: [] }, { background: [] }], // 字体颜色、字体背景颜色
  [{ font: [] }], // 字体种类
  [{ align: [] }], // 对齐方式
  ['clean'], // 清除文本格式
  ['link', 'image', 'video'] // 链接、图片、视频
]

export default {
  props: {
    /* 编辑器的内容 */
    value: {
      type: String
    },
    /* 图片大小 */
    maxSize: {
      type: Number,
      default: 4000 // kb
    }
  },

  components: {
    quillEditor
  },

  data () {
    return {
      content: this.value,
      quillUpdateImg: false, // 根据图片上传状态来确定是否显示loading动画，刚开始是false,不显示
      editorOption: {
        theme: 'snow', // or 'bubble'
        // placeholder: '您想说点什么？',
        modules: {
          toolbar: {
            container: toolbarOptions,
            // container: '#toolbar',
            handlers: {
              image: function (value) {
                if (value) {
                  // 触发input框选择图片文件
                  document.querySelector('.avatar-uploader input').click()
                } else {
                  this.quill.format('image', false)
                }
              }
              // link: function(value) {
              //   if (value) {
              //     var href = prompt('请输入url')
              //     this.quill.format('link', href)
              //   } else {
              //     this.quill.format('link', false)
              //   }
              // },
            }
          }
        }
      },
      serverUrl:
        'https://testihospitalapi.ebaiyihui.com/oss/api/file/store/v1/saveFile', // 这里写你要上传的图片服务器地址
      header: {
        // token: sessionStorage.token
      }, // 有的图片服务器要求请求头需要有token
      search: '',
      searchElem: null,
      searchObj: {
        li: [],
        index: null,
        preNode: null
      },
      jumpLine: ''
    }
  },
  watch: {
  },
  mounted () {
  },

  updated () {
  },

  methods: {
    onEditorBlur () {
      // 失去焦点事件
    },
    onEditorFocus () {
      // 获得焦点事件
    },
    onEditorChange () {
      // 内容改变事件
      this.$emit('input', this.content)
    },

    // 富文本图片上传前
    beforeUpload () {
      // 显示loading动画
      this.quillUpdateImg = true
    },

    uploadSuccess (res, file) {
      // res为图片服务器返回的数据
      // 获取富文本组件实例
      let quill = this.$refs.myQuillEditor.quill
      // 如果上传成功
      if (res.code === 200) {
        // 获取光标所在位置
        let length = quill.getSelection().index
        // 插入图片  res.url为服务器返回的图片地址
        quill.insertEmbed(length, 'image', res.result.url)
        // 调整光标到最后
        quill.setSelection(length + 1)
      } else {
        this.$message.error('图片插入失败')
      }
      // loading动画消失
      this.quillUpdateImg = false
    },
    // 富文本图片上传失败
    uploadError () {
      // loading动画消失
      this.quillUpdateImg = false
      this.$message.error('图片插入失败')
    },

    cleanHightlight () {
      let reg = new RegExp(`<strong class="normal-bg" name="searchItem">(.+?)</strong>`, 'g')
      let qlEditor = document.getElementsByClassName('ql-editor')[0]
      qlEditor.innerHTML = qlEditor.innerHTML.replace(reg, '$1')
      this.searchObj = {
        li: [],
        index: null,
        preNode: null
      }
    },

    searchEnter () {
      this.cleanHightlight()
      if (this.search === '') {
        return false
      }
      let reg = new RegExp(`(${this.search})`, 'g')
      let qlEditor = document.getElementsByClassName('ql-editor')[0]
      qlEditor.innerHTML = qlEditor.innerHTML.replace(reg, '<strong class="normal-bg" name="searchItem">$1</strong>')
      this.searchObj.li = [...document.getElementsByName('searchItem')]
      this.FollowingHeightlight()
      this.searchObj.preNode = this.searchObj.li[0] // 储存上一个节点
    },

    FollowingHeightlight (isFollowing = true) {
      if (this.searchObj.index !== null) {
        this.searchObj.index += isFollowing ? 1 : -1
        let max = this.searchObj.li.length - 1
        if (this.searchObj.index < 0) this.searchObj.index = max
        if (this.searchObj.index > max) this.searchObj.index = 0
      } else {
        this.searchObj.index = 0
      }
      let elemNode = this.searchObj.li[this.searchObj.index]
      this.jumpNodePos(elemNode) // 让这个元素显示在窗口中央
      let preNode = this.searchObj.preNode
      this.deepNextBackground(elemNode, preNode) // 加深这个元素的背景颜色
      this.searchObj.preNode = elemNode // 储存上一个节点
    },

    jumpNodePos (elemNode) {
      let qlEditor = document.getElementsByClassName('ql-editor')[0]
      qlEditor.scrollTop = elemNode.offsetTop - qlEditor.offsetHeight / 2
    },

    deepNextBackground (elemNode, preNode) {
      elemNode.className = 'deep-bg'
      if (preNode !== null) {
        preNode.className = 'normal-bg'
      }
    },

    jumpLineEnter () {
      if (this.jumpLine === '') {
        return false
      }
      if (!(/^[1-9]+[0-9]*$/.test(this.jumpLine))) { // 不是正整数字符串
        this.$message('请输入正确的行号')
        this.jumpLine = ''
        return false
      }
      const qlEditor = document.getElementsByClassName('ql-editor')[0]
      let scrollHeight = 0
      for (let i = 0; i < this.jumpLine; i++) {
        if (qlEditor.childNodes[i] === undefined) {
          this.$message('没那么多行')
          this.jumpLine = ''
          return false
        }
        scrollHeight += qlEditor.childNodes[i].offsetHeight
      }
      // 让这行滚到中间
      qlEditor.scrollTop = scrollHeight - qlEditor.offsetHeight / 2
      return true
    },
    searchChange () {
      console.log(this.$refs.searchInput)
    },

    hightLight () {
      // this.value
    }
  }
}
</script>

<style>
.editor {
  line-height: normal !important;
  height: 400px;
}
.ql-snow .ql-tooltip[data-mode='link']::before {
  content: '请输入链接地址:';
}
.ql-snow .ql-tooltip.ql-editing a.ql-action::after {
  border-right: 0px;
  content: '保存';
  padding-right: 0px;
}

.ql-snow .ql-tooltip[data-mode='video']::before {
  content: '请输入视频地址:';
}

.ql-snow .ql-picker.ql-size .ql-picker-label::before,
.ql-snow .ql-picker.ql-size .ql-picker-item::before {
  content: '14px';
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value='small']::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value='small']::before {
  content: '10px';
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value='large']::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value='large']::before {
  content: '18px';
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value='huge']::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value='huge']::before {
  content: '32px';
}

.ql-snow .ql-picker.ql-header .ql-picker-label::before,
.ql-snow .ql-picker.ql-header .ql-picker-item::before {
  content: '文本';
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value='1']::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value='1']::before {
  content: '标题1';
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value='2']::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value='2']::before {
  content: '标题2';
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value='3']::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value='3']::before {
  content: '标题3';
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value='4']::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value='4']::before {
  content: '标题4';
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value='5']::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value='5']::before {
  content: '标题5';
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value='6']::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value='6']::before {
  content: '标题6';
}

.ql-snow .ql-picker.ql-font .ql-picker-label::before,
.ql-snow .ql-picker.ql-font .ql-picker-item::before {
  content: '标准字体';
}
.ql-snow .ql-picker.ql-font .ql-picker-label[data-value='serif']::before,
.ql-snow .ql-picker.ql-font .ql-picker-item[data-value='serif']::before {
  content: '衬线字体';
}
.ql-snow .ql-picker.ql-font .ql-picker-label[data-value='monospace']::before,
.ql-snow .ql-picker.ql-font .ql-picker-item[data-value='monospace']::before {
  content: '等宽字体';
}

.avatar-uploader {
  display: none;
}

.icon-reg::after {
  content:".*";
  height: 100%;
  width: 5px;
  margin-right: 8px;
  margin-top: 5px;
  display: inline-block;
  vertical-align: middle;
  pointer-events: all;
}

.deep-bg {
  background-color: #FFFF99 ;
}

.normal-bg {
  color: red ;
}
</style>

```

## vue-tinymce

`cnpm i tinymce @packy-tang/vue-tinymce`

拷贝`src/utils/tinymce/langs/zh_CN.js`

参考链接
[Full featured examples | Docs | TinyMCE](https://www.tiny.cloud/docs/demo/full-featured/)
[vue-tinymce - A simple vue-based tinymce component](http://lpreterite.github.io/vue-tinymce/#/README)
[vue-tinymce-example/vue at master · lpreterite/vue-tinymce-example](https://github.com/lpreterite/vue-tinymce-example/tree/master/vue)

简单使用

```js
// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'

import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import 'font-awesome/css/font-awesome.min.css'

import tinymce from 'tinymce'
import VueTinymce from '@packy-tang/vue-tinymce'

// 样式
import 'tinymce/skins/content/default/content.min.css'
import 'tinymce/skins/ui/oxide/skin.min.css'
import 'tinymce/skins/ui/oxide/content.min.css'

// 主题
import 'tinymce/themes/silver'

// 插件
import 'tinymce/plugins/link' // 链接插件
import 'tinymce/plugins/image' // 图片插件
import 'tinymce/plugins/media' // 媒体插件
import 'tinymce/plugins/table' // 表格插件
import 'tinymce/plugins/lists' // 列表插件
import 'tinymce/plugins/quickbars' // 快速栏插件
import 'tinymce/plugins/fullscreen' // 全屏插件

/**
 * 注：
 * 5.3.x版本需要额外引进图标，没有所有按钮就会显示not found
 */
import 'tinymce/icons/default/icons'

// 本地化
import './utils/tinymce/langs/zh_CN.js'

Vue.use(ElementUI)
Vue.prototype.$tinymce = tinymce
Vue.use(VueTinymce)

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})

```

```js
<template>
  <div>
    <div id="logo">
      <img alt="Vue+Tinymce" src="https://raw.githubusercontent.com/lpreterite/vue-tinymce/HEAD/docs/assets/vu-tinymce-logo.png">
    </div>
    <vue-tinymce
      v-model="content"
      :setting="setting" />
  </div>
</template>

<script>
export default {
  name: 'KOTinymce',
  data () {
    return {
      content: '<h1 style="text-align: center;">长恨歌</h1><p style="text-align: center;">汉皇重色思倾国，御宇多年求不得。<br />杨家有女初长成，养在深闺人未识。<br />天生丽质难自弃，一朝选在君王侧。<br />回眸一笑百媚生，六宫粉黛无颜色。<br />春寒赐浴华清池，温泉水滑洗凝脂。<br />侍儿扶起娇无力，始是新承恩泽时。<br />云鬓花颜金步摇，芙蓉帐暖度春宵。<br />春宵苦短日高起，从此君王不早朝。<br />承欢侍宴无闲暇，春从春游夜专夜。<br />后宫佳丽三千人，三千宠爱在一身。<br />金屋妆成娇侍夜，玉楼宴罢醉和春。<br />姊妹弟兄皆列土，可怜光彩生门户。<br />遂令天下父母心，不重生男重生女。<br />骊宫高处入青云，仙乐风飘处处闻。<br />缓歌慢舞凝丝竹，尽日君王看不足。<br />渔阳鼙鼓动地来，惊破霓裳羽衣曲。</p><p style="text-align: center;">九重城阙烟尘生，千乘万骑西南行。<br />翠华摇摇行复止，西出都门百余里。<br />六军不发无奈何，宛转蛾眉马前死。<br />花钿委地无人收，翠翘金雀玉搔头。<br />君王掩面救不得，回看血泪相和流。<br />黄埃散漫风萧索，云栈萦纡登剑阁。<br />峨嵋山下少人行，旌旗无光日色薄。<br />蜀江水碧蜀山青，圣主朝朝暮暮情。<br />行宫见月伤心色，夜雨闻铃肠断声。<br />天旋日转回龙驭，到此踌躇不能去。<br />马嵬坡下泥土中，不见玉颜空死处。<br />君臣相顾尽沾衣，东望都门信马归。<br />归来池苑皆依旧，太液芙蓉未央柳。<br />芙蓉如面柳如眉，对此如何不泪垂。<br />春风桃李花开夜，秋雨梧桐叶落时。<br />西宫南苑多秋草，落叶满阶红不扫。<br />梨园弟子白发新，椒房阿监青娥老。<br />夕殿萤飞思悄然，孤灯挑尽未成眠。<br />迟迟钟鼓初长夜，耿耿星河欲曙天。<br />鸳鸯瓦冷霜华重，翡翠衾寒谁与共。<br />悠悠生死别经年，魂魄不曾来入梦。</p><p style="text-align: center;">临邛道士鸿都客，能以精诚致魂魄。<br />为感君王辗转思，遂教方士殷勤觅。<br />排空驭气奔如电，升天入地求之遍。<br />上穷碧落下黄泉，两处茫茫皆不见。<br />忽闻海上有仙山，山在虚无缥缈间。<br />楼阁玲珑五云起，其中绰约多仙子。<br />中有一人字太真，雪肤花貌参差是。<br />金阙西厢叩玉扃，转教小玉报双成。<br />闻道汉家天子使，九华帐里梦魂惊。<br />揽衣推枕起徘徊，珠箔银屏迤逦开。<br />云鬓半偏新睡觉，花冠不整下堂来。</p><p style="text-align: center;">风吹仙袂飘飖举，犹似霓裳羽衣舞。<br />玉容寂寞泪阑干，梨花一枝春带雨。<br />含情凝睇谢君王，一别音容两渺茫。<br />昭阳殿里恩爱绝，蓬莱宫中日月长。<br />回头下望人寰处，不见长安见尘雾。<br />惟将旧物表深情，钿合金钗寄将去。<br />钗留一股合一扇，钗擘黄金合分钿。<br />但令心似金钿坚，天上人间会相见。</p><p style="text-align: center;">临别殷勤重寄词，词中有誓两心知。<br />七月七日长生殿，夜半无人私语时。<br />在天愿作比翼鸟，在地愿为连理枝。<br />天长地久有时尽，此恨绵绵无绝期。</p>',
      setting: {
        menubar: true,
        toolbar: 'undo redo | fullscreen | formatselect alignleft aligncenter alignright alignjustify | link unlink | numlist bullist | image media table | fontselect fontsizeselect forecolor backcolor | bold italic underline strikethrough | indent outdent | superscript subscript | removeformat |',
        toolbar_drawer: 'sliding',
        quickbars_selection_toolbar: 'removeformat | bold italic underline strikethrough | fontsizeselect forecolor backcolor',
        plugins: 'link image media table lists fullscreen quickbars',
        language: 'zh_CN',
        height: 350
      }
    }
  }
}
</script>

<style>
#logo{
  text-align: center;
}
</style>

```
