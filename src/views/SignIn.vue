<template>
  <div class="home-wrapper">
    <!-- <card
      v-if="!address"
      title="It looks like you're not connected."
      subtitle="Please connect to use the app."
      :blue="true"
    >
    
      <collective-button :transparent="true" @click="connect">
        Connect
      </collective-button>
    </card> -->

    <card
      v-if="!address"
      title="Connexion"
      :blue="true"
    >
      <collective-button :transparent="true" @click="connect">
        Connect
      </collective-button>
    </card>

    <card v-if="address" title="You're connected!">
      <collective-button :transparent="true" @click="goToAccount">
        Go to account
      </collective-button>
    </card>

    <spacer :size="24" />

     <card v-if="address" title="Create a entreprise account">
      <collective-button :transparent="true" @click="goToAccountOrg">
        Go to creation entreprise account
      </collective-button>
    </card>

    <spacer :size="24" />


    <card v-if="address" title="Create a project">
      <collective-button :transparent="true" @click="goToNewProj">
        Go to creation project
      </collective-button>
    </card>

   <spacer :size="24" />

     <card v-if="address" title="Ajouter des membres a l'entreprise">
      <collective-button :transparent="true" @click="goToMembers">
        Add membres
      </collective-button>
    </card>
<spacer :size="24" />

    <card v-if="address" title="Ajouter un contributeur">
      <collective-button :transparent="true" @click="goToCount">
        Add contributors
      </collective-button>
    </card>



    <spacer :size="24" />
    <div class="home">
      <card
        v-for="(link, index) in links"
        :key="index"
        :title="link.title"
        subtitle="To never be lost"
      >
        <a class="card-body" :href="link.link"> Find it here </a>
      </card>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import CollectiveButton from '@/components/CollectiveButton.vue'
import Spacer from '@/components/Spacer.vue'

export default defineComponent({
  name: 'SignIn',
  components: { Card, CollectiveButton, Spacer },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const connect = () => store.dispatch('ethereumConnect')
    return { address, connect }
  },

  methods: {
    goToAccount() {
      this.$router.push({ name: 'Account' })
    },
    goToAccountOrg() {
      this.$router.push({ name: 'AccountOrg' })
    },
    goToNewProj() {
      this.$router.push({ name: 'NewProject' })
    },
    goToMembers() {
      this.$router.push({ name: 'AccountMembers' })
    },
    goToCount() {
      this.$router.push({ name: 'AccountContributor' })
    },
    
    
  },
})
</script>

<style lang="css" scoped>
.home-wrapper {
  margin: auto 24px auto 24px;
}

.home {
  display: grid;
  align-items: center;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  grid-gap: 24px;
}

.card-body {
  padding: 12px;
  display: block;
  font-family: inherit;
  font-size: 1.2rem;
  font-weight: inherit;
  text-align: center;
  color: inherit;
  text-decoration: none;
  font-variant: small-caps;
}
</style>
