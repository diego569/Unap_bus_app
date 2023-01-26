import 'package:bus_ticket_unap/constants/routes.dart';
import 'package:bus_ticket_unap/utilities/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Bus Ticket UNAP'),
      ),
      body: Column(
              children: [
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Please enter your Email',
                  ),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Please enter your Password',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                      
                    final email = _email.text;
                    final password = _password.text;
                    try{
                      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email, 
                      password: password,
                      );
                      devtools.log(userCredential.toString());
                      Navigator.of(context).pushNamed(verifyEmailRoute);
                      final user = FirebaseAuth.instance.currentUser;
                      await user?.sendEmailVerification();
                    } on FirebaseAuthException catch (e){
                      if(e.code == 'weak-password'){
                        await showErrorDialog(context, 'Weak password');
                        devtools.log('Weak Password!!');
                      }else if(e.code == 'email-already-in-use'){
                        await showErrorDialog(context, 'Email already in use');
                        devtools.log('Email is already in use!!!!!!');
                      }else if(e.code == 'invalid-email'){
                        await showErrorDialog(context, 'Invalid Email address');
                        devtools.log('Invalid Email');
                      } else{
                        await showErrorDialog(context, 'Error: ${e.code}');
                      }
                    } catch(e){
                      await showErrorDialog(context, e.toString());
                    }                                
                  },
                  child: const Text('Register'),
          
                ),
                TextButton(onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute, 
                    (route) => false,
                  );
                }, 
                child: const Text('Already registered? Login here!'),
                ),
                
              ],
            ),
    );
  }
}