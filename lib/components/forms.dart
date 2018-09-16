part of com.newt.components;


class FormConfig {
  final Widget separator;
  // all values: InputBorder.none, UnderlineInputBorder(), OutlineInputBorder
  final InputBorder inputBorder;
  final bool filled;
  final TextStyle prefixStyle;
  final TextStyle suffixStyle;
  final Brightness keyboardAppearance;

  const FormConfig({
    this.separator = const SizedBox(height: 8.0),
    this.inputBorder = const UnderlineInputBorder(),
    this.filled = false,
    this.prefixStyle,
    this.suffixStyle,
    this.keyboardAppearance = Brightness.light,
  });

}

enum FieldType {
  /// default TextInput type
  text,
  multiline,
  number,
  phone,
  datetime,
  emailAddress,
  url,

  /// custom type
  password,
  datePicker,
  timePicker,
  imagePicker,
}

class EditForm extends StatefulWidget {

  EditForm({
    this.fields,
    this.config = const FormConfig(),
  });

  final List<Map> fields;
  final FormConfig config;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool validate() {
    return _formKey.currentState.validate();
  }

  @override
  State<StatefulWidget> createState() => _EditFromState();
}


class _EditFromState extends State<EditForm> {

  Widget _buildField(Map field, TextInputType type, {bool last = false}) {
    /// binding text editing controller, focus node, auto validate
    field['__textEditingController'] = field['textEditingController']??
        TextEditingController(
          text: field['value'] == null ? '' : '${field['value']}',
        );

    field['__textEditingController'].addListener(() {
      if (field['onChange'] != null) {
        field['onChange'](field['__textEditingController']);
      }
    });
    field['__focusNode'] = field['focusNode']?? FocusNode();
    field['__autoValidate'] = field['autoValidate']?? false;
    field['__focusNode'].addListener(() {
      if (!field['__autoValidate']) {
        setState(() {
          field['__autoValidate'] = true;
        });
      }
    });

    // for password
    field['__obscure'] = field['__obscure']?? field['type'] == FieldType.password;

    return TextFormField(
      controller: field['__textEditingCOntroller'],
      textInputAction: field['textInputAction']??
          (last ? TextInputAction.done : TextInputAction.next),
      keyboardAppearance: widget.config.keyboardAppearance,
      maxLength: field['maxLength'],
      autovalidate: field['__autoValidate'],
      focusNode: field['__focusNode'],
      // inputFormatters: ...,
      enabled: field['enabled']?? true,
      obscureText: field['__obscure'],
      decoration: InputDecoration(
        border: field['inputBorder']?? widget.config.inputBorder,
        prefix: field['prefix'],
        prefixText: field['prefixText'],
        prefixStyle: field['prefixStyle']?? widget.config.prefixStyle,
        prefixIcon: field['prefixIcon'],
        icon: field['icon'],
        filled: field['filled']?? widget.config.filled?? false,
        suffixIcon: () {
          if (field['type'] == FieldType.password) {
            var icons = field['suffixIcon'];
            return InkWell(
              child: field['__obscure']
                ? (icons == null ? Icon(Icons.visibility) : icons[0])
                : (icons == null ? Icon(Icons.visibility_off) : icons[1]),
              onTap: () {
                setState(() {
                  field['__obscure'] = !field['__obscure'];
                });
              },
            );
          }
          return field['suffixIcon'];
        }(),
        suffix: field['suffix'],
        suffixText: field['suffixText'],
        suffixStyle: widget.config.suffixStyle,
      ),
    );
  }

  Widget _buildFields() {
    List<Widget> widgets = <Widget>[];
    for (Map field in widget.fields) {
      // add separator if filed is null
      if (field == null) {
        widgets.add(widget.config.separator);
        continue;
      }

      // builder widget by field['builder']
      if (field['builder'] is WidgetBuilder) {
        widgets.add(field['builder'](context));
        continue;
      }

      if (field['type'] == null) {
        field['type'] = FieldType.text;
      }

      switch (field['type']) {
        case FieldType.password:
        case FieldType.text:
          widgets.add(_buildField(field, TextInputType.text));
          break;

        case FieldType.number:
      }
    }

    return Column(
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildFields();
  }
}