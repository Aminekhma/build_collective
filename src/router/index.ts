import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import store from '@/store'
import SignIn from '@/views/SignIn.vue'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'SignIn',
    component: SignIn,
  },
  {
    path: '/account',
    name: 'Account',
    component: () => import('@/views/Account.vue'),
  },
  {
    path: '/accountOrg',
    name: 'AccountOrg',
    component: () => import('@/views/AccountOrg.vue'),
  },
  {
    path: '/newProject',
    name: 'NewProject',
    component: () => import('@/views/NewProject.vue'),
  },
  {
    path: '/accountMembers',
    name: 'AccountMembers',
    component: () => import('@/views/AccountMembers.vue'),
  },

  {
    path: '/accountContributor',
    name: 'AccountContributor',
    component: () => import('@/views/AccountContributor.vue'),
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})

router.beforeEach((to, _from, next) => {
  if (to.name !== 'SignIn' && !store.state.account.address) {
    next({ name: 'SignIn' })
  } else {
    next()
  }
})

export default router
