<template>
    <b-container id="app">
        <b-row align-h="between" align-v="center" class="pb-4 mb-2">
            <b-col>
                <h3 class="h2">Register for the AWESOME Event!</h3>
            </b-col>
        </b-row>
        <b-row align-v="center" class="mb-2">
            <b-col>
                <b-input-group>
                    <template #prepend>
                        <b-input-group-text>First Name</b-input-group-text>
                    </template>
                    <b-form-input v-model.trim="firstName"></b-form-input>
                </b-input-group>
            </b-col>
            <b-col>
                <b-input-group>
                    <template #prepend>
                        <b-input-group-text>Last Name</b-input-group-text>
                    </template>
                    <b-form-input v-model.trim="lastName"></b-form-input>
                </b-input-group>
            </b-col>
        </b-row >
        <b-row align-v="center" class="mb-2">
            <b-input-group>
                <template #prepend>
                    <b-input-group-text>Email</b-input-group-text>
                </template>
                <b-form-input v-model.trim="emailAddr"></b-form-input>
            </b-input-group>
        </b-row>
        <b-row align-v="center" class="mb-2">
            <b-input-group>
                <template #prepend>
                    <b-input-group-text>Company</b-input-group-text>
                </template>
                <b-form-input v-model.trim="companyName"></b-form-input>
            </b-input-group>
        </b-row>
        <b-row class="justify-content-md-center mb-2" align-v="center">
            <b-col col lg="2"></b-col>
            <b-col cols="12" md="auto">
                <b-button @click.stop="register" variant="primary" class="float-right" >Register</b-button>
            </b-col>
            <b-col col lg="2"></b-col>
        </b-row>
    </b-container>
</template>

<script>
    export default {
        name: "App",
        data() {
            return {
                firstName: "",
                lastName: "",
                emailAddr: "",
                companyName: ""
            }
        },
        methods: {
            register() {
                const axios = require('axios').default;

                console.log("Register button pressed");
                console.log(" - firstName: " + this.firstName + " lastName: " + this.lastName);
                console.log(" - email: " + this.emailAddr + " company: " + this.companyName);
                
                let apiRoot = 'http://localhost:5000';

                axios.post(apiRoot + '/register', {
                    'firstname': this.firstName,
                    'lastname': this.lastName,
                    'company': this.company,
                    'email': this.emailAddr
                })
                .then(function(response) {
                    console.log('User added OK');
                    console.log(response);
                })
                .catch(function(error) {
                    console.log('ERROR adding user');
                    console.log(error);
                })
            }
        },
    }

</script>