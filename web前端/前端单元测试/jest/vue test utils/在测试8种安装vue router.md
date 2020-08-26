# 在测试中安装vue router

```js
import { shallowMount, createLocalVue } from '@vue/test-utils'
import VueRouter from 'vue-router'

const localVue = createLocalVue()
localVue.use(VueRouter)
const router = new VueRouter()

shallowMount(Component, {
  localVue,
  router
})
```

## 使用存根

```js
import { shallowMount } from '@vue/test-utils'

shallowMount(Component, {
  stubs: ['router-link', 'router-view']
})
```

## 为 localVue 安装 Vue Router

```js
import { shallowMount, createLocalVue } from '@vue/test-utils'
import VueRouter from 'vue-router'

const localVue = createLocalVue()
localVue.use(VueRouter)

shallowMount(Component, {
  localVue
})
```

## 伪造 $route 和 $router

有的时候你想要测试一个组件在配合 $route 和 $router 对象的参数时的行为。这时候你可以传递自定义假数据给 Vue 实例。

```js
import { shallowMount } from '@vue/test-utils'

const $route = {
  path: '/some/path'
}

const wrapper = shallowMount(Component, {
  mocks: {
    $route
  }
})

wrapper.vm.$route.path // /some/path
```

