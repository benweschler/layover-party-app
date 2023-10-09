import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:layover_party/commands/sign_up_command.dart';
import 'package:layover_party/models/app_model.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:layover_party/utils/validators.dart';
import 'package:layover_party/widgets/buttons/async_action_button.dart';
import 'package:layover_party/widgets/custom_back_button.dart';
import 'package:layover_party/widgets/custom_input_decoration.dart';
import 'package:layover_party/widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';

import 'field_names.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();
  final GlobalKey<AsyncActionButtonState> _signUpButtonKey = GlobalKey();

  SignUpScreen({Key? key}) : super(key: key);

  Future<void> signUp(AppModel appModel) {
    final formData = _formKey.currentState!.value;

    return SignUpCommand.run(
      name: formData[SignUpFieldNames.name],
      email: formData[SignUpFieldNames.email],
      password: formData[SignUpFieldNames.password],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leading: const CustomBackButton(),
      child: Center(
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyles.h2,
                    ),
                  ),
                  const SizedBox(height: Insets.xl),
                  FormBuilderTextField(
                    name: SignUpFieldNames.name,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    autofillHints: const [AutofillHints.givenName],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validators.required(
                      errorText: 'Enter your preferred name',
                    ),
                    decoration: CustomInputDecoration(
                      AppColors.of(context),
                      hintText: 'Preferred Name',
                    ),
                  ),
                  const SizedBox(height: Insets.xl),
                  FormBuilderTextField(
                    name: SignUpFieldNames.email,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    autofillHints: const [AutofillHints.email],
                    validator: Validators.email(
                      errorText: 'Enter a valid email',
                    ),
                    decoration: CustomInputDecoration(
                      AppColors.of(context),
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: Insets.xl),
                  FormBuilderTextField(
                    name: SignUpFieldNames.password,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validators.required(
                      errorText: 'Enter a password',
                    ),
                    decoration: CustomInputDecoration(
                      AppColors.of(context),
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(height: Insets.lg),
                  FormBuilderTextField(
                    name: SignUpFieldNames.confirmPassword,
                    obscureText: true,
                    textInputAction: TextInputAction.go,
                    autofillHints: const [AutofillHints.newPassword],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSubmitted: (_) =>
                        _signUpButtonKey.currentState!.executeAction(),
                    // Wrap the validator inside of the callback to pass an
                    // up-to-date password value.
                    validator: (value) {
                      return Validators.confirmPassword(
                        _formKey.currentState
                            ?.fields[SignUpFieldNames.password]!.value,
                        errorText: 'Passwords do not match',
                      ).call(value);
                    },
                    decoration: CustomInputDecoration(
                      AppColors.of(context),
                      hintText: 'Confirm Password',
                    ),
                  ),
                  /*
                  //TODO: implement error handling
                  ValueListenableBuilder<String?>(
                    valueListenable: _errorNotifier,
                    builder: (_, error, __) => Column(
                      children: error == null ? [] : [
                        const SizedBox(height: Insets.lg),
                        ErrorCard(error),
                      ],
                    ),
                  ),
                   */
                  const SizedBox(height: Insets.xl),
                  //TODO: implement error handling
                  AsyncActionButton/*<FirebaseAuthException>*/(
                    key: _signUpButtonKey,
                    label: 'Sign Up',
                    action: () async {
                      if (!_formKey.currentState!.saveAndValidate()) {
                        return;
                      }
                      final pop = context.pop;
                      await signUp(context.read<AppModel>());
                      pop();
                    },
                    //TODO: implement error handling
                    catchError: (_) {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
