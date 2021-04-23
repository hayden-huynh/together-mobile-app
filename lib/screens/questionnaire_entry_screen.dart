import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:together_app/models/questionnaire_entry_provider.dart';
import 'package:together_app/widgets/questionnaire_entry_widget.dart';

class QuestionnaireEntryScreen extends StatelessWidget {
  static const routeName = '/questionnaire-entry-screen';

  @override
  Widget build(BuildContext context) {
    final entries =
        Provider.of<QuestionnaireEntryProvider>(context, listen: false).entries;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Together',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: SafeArea(
        child: QuestionnaireEntryWidget(entries),
      ),
    );
  }
}
