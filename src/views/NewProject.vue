<template lang="html">
  <div class="home">
    <div class="wrapper">
      <div class="title">
        Création d'un projet
      </div>
      <div class="social_media">
        <div class="item">
          <i class="fab fa-facebook-f"></i>
        </div>
        <div class="item">
          <i class="fab fa-twitter"></i>
        </div>
        <div class="item">
          <i class="fab fa-google-plus-g"></i>
        </div>
      </div>
      
      <div class="form">
        <div class="input_field">
          <input type="text" v-model="ProjectName" placeholder = "Nom du projet" name="name" class="input">
          <i class="fas fa-user"></i>
        </div>
        <div class="input_field">
          <input class="input" type="number" v-model="balanceOrg" min=0 placeholder = "Balance default" balance = "balance">
          <i class="far fa-envelope"></i>
        </div>
        <div class="btn" @click="submit()">
          <a href="#">Create</a>
        </div>
      </div>
    </div>

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
    const ProjectName = ''
    const balanceOrg = 0
    const contributors : any[] = []
    return { account, ProjectName, balanceOrg, contributors}
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.project(address).call()
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
      const {contract, address } = this
      const nameO = this.ProjectName.trim().replace(/ /g, '_')
      const balanceO = (!this.balanceOrg)? 0 : this.balanceOrg;
      await contract.methods.addProject(nameO, address,this.contributors,balanceO).send()
      this.ProjectName = ''
    },
  },

})
</script>
<style lang="css" scoped>
  *{
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    outline: none;
    text-decoration: none;
    font-family: 'Josefin Sans', sans-serif;
  }

  body{
    background: #3aaf9f;
  }

  .wrapper{
    max-width: 350px;
    width: 100%;
    height: auto;
    background: #fff;
    padding: 60px 45px;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%,-50%);
    border-radius: 20px;
  }

  .wrapper .title{
    margin-bottom: 20px;
    text-align: center;
    font-size: 26px;
    font-weight: bold;
    color: #3aaf9f;
  }

  .wrapper .social_media{
    display: flex;
    justify-content: center;
    margin-bottom: 20px;
  }

  .wrapper .social_media .item{
    margin: 0 5px;
    width: 35px;
    height: 35px;
    line-height: 35px;
    text-align: center;
    border: 2px solid #eeeeee;
    border-radius: 50%;
    cursor: pointer;
    color: #eeeeee;
    transition: all 0.5s ease;
  }

  .wrapper .social_media .item:hover{
    border: 2px solid #3aaf9f;
    color: #3aaf9f;
  }

  .wrapper .form .input_field{
    position: relative;
    margin-bottom: 10px;
  }

  .wrapper .form .input_field .input{
    width: 100%;
    padding: 12px;
    padding-left: 30px;
    border: none;
    background: #eeeeee;
  }

  .wrapper .form .btn{
    width: 70%;
    margin: 20px auto 0;
    background: #3aaf9f;
    text-align: center;
    padding: 12px;
    border-radius: 25px;
  }

  .wrapper .form .btn a{
    color: #fff;
  }

  .wrapper .form .input_field i{
    position: absolute;
    top: 10px;
    left: 10px;
    font-size: 14px;
    color: #1d2120;
  }

  ::-webkit-input-placeholder { /* Chrome/Opera/Safari */
    color: #1d2120;
  }
  ::-moz-placeholder { /* Firefox 19+ */
  color: #1d2120;
  }
  :-ms-input-placeholder { /* IE 10+ */
    color: #1d2120;
  }
</style>