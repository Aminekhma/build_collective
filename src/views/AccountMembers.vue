<template lang="html">
  <div class="home">
    <form id="signup-from" style="border:1px solid #ccc">
      <div class="container">
            <h1> Ajouter des members </h1>
            <p> veuillez saisir les informations </p>

            <label for="name"><b>Name</b></label>
            <input type="text" v-model="nameMembers" placeholder = "Members name" name="name"/>

            <div class="clearfix">
                <button type="button" class="cancel" @click="goBack()">Cancel</button>
                <button type="button" class="SignUp" @click="submit()">Sign Up</button>
            </div>



          
     </div>
    </form>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'

export default defineComponent({
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const account = null
    const nameMembers = ''
    return { account, nameMembers }
  },
  methods: {
    async updateAccount() {
      const {contract, address } = this
      this.account = await contract.methods.org(address).call()
    },
    async goBack() {
      this.$router.push({name : "SignIn"})
    },
    async submit() {
      const {contract, address  } = this
      const nameO = this.nameMembers.trim().replace(/ /g, '_')
      await contract.methods.addMember(contract.methods.getUniqueId()).send()
      this.nameMembers = ''
    },
  },


})
</script>

<style lang="css" scoped>
.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 500px;
  margin: auto;
}

.explanations {
  padding: 12px;
}

.button-link {
  display: inline;
  appearance: none;
  border: none;
  background: none;
  color: inherit;
  text-decoration: underline;
  font-family: inherit;
  font-size: inherit;
  font-weight: inherit;
  padding: 0;
  margin: 0;
  cursor: pointer;
}

.input-username {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}
</style>