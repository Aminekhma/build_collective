<template lang="html">
  <div class="home">
    <form id="signup-from" style="border:1px solid #ccc">
      <div class="container">
            <h1> Création d'entreprise </h1>
            <p> veuillez saisir les informations </p>

            <label for="name"><b>Name</b></label>
            <input type="text" v-model="nameOrg" placeholder = "Organisation name" name="name"/>

            <label for="balance"><b>Balance</b></label>
            <input type="number" v-model="balanceOrg" min=0 placeholder = "Balance default" balance = "balance"/>

            <div class="clearfix">
                <button type="button" class="cancel" @click="goBack()">Cancel</button>
                <button type="button" class="SignUp" @click="submit()">Sign Up</button>
            </div>

            
            <button type="button" class="SignUp" @click="printUsers()">aaaa</button>


          
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
    const nameOrg = ''
    const balanceOrg = 0
    const members :any[] = []
    const a : any[] = []
    return { account, nameOrg, balanceOrg, members, a }
  },
  methods: {
    async updateAccount() {
      const {contract, address } = this
      this.account = await contract.methods.getUser(address).call()
    },
    async printUsers() {
      const {contract, address } = this
      var m = await contract.methods.getProjectRefs(address);
      for(var i= 0; i < m.length; i++){
        console.log(m[i])
        console.log("z")
      }

    },
    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
    },
    async goBack() {
      this.$router.push({name : "SignIn"})
    },
    async submit() {
      const {contract, address  } = this
      const nameO = this.nameOrg.trim().replace(/ /g, '_')
      const balanceO = (!this.balanceOrg)? 0 : this.balanceOrg;
      this.members.push(address)



      await contract.methods.orgSignUp(nameO, address,this.members,balanceO).send()
      this.nameOrg = ''
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