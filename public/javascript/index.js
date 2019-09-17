new Vue({
  el: '#app',
  data: {
    selectedFrom: "USD",
    selectedTo: "CAD",
    currencies: [],
    amount: ""
  },
  mounted() {
    axios.get("http://localhost:9292/currencies/USD.json")
    .then(response => 
      { this.currencies = response.data.currencies });
  },
  methods: {
    calculate() {
      this.selectedTo = this.$refs.to.selectedOptions[0].label

      let rate = this.currencies[this.selectedTo]
      let result = parseFloat(rate) * parseFloat(this.amount)

      if (isNaN(result)) { 
        this.$refs.result.value = "" 
      } else {
        this.$refs.result.value = result.toFixed(3)
      }
    },
    changeSelectedFrom() {
      this.selectedFrom = this.$refs.from.selectedOptions[0].label
      let newFrom = this.selectedFrom

      axios.get("http://localhost:9292/currencies/" + newFrom + ".json").then(response =>
        { this.currencies = response.data.currencies });
    }
  }
});
