import 'package:flutter/material.dart';

import '../Styles/colors.dart';




Widget defaultFormField({
  required TextEditingController controller,
  required IconData prefix,
  required String label,
  required Function validate,
  TextInputType? type,
  Function? onChange,
  Function? onSubmit,
  Function? onTap,
  Function? suffixPressed,
  bool isPassword = false,
  bool isClickable = true,
  IconData? suffix,
}) =>
    TextFormField(
      style: const TextStyle(
        color: defaultColor,
      ),
      cursorHeight: 25.0,
      cursorColor: defaultColor,
      controller: controller,
      enabled: isClickable,
      keyboardType: type,
      decoration: InputDecoration(
        prefixIcon: Icon(prefix),
        prefixIconColor: defaultColor,
        suffixIcon: suffix != null ? Icon(suffix) : null,
        suffixIconColor: defaultColor,
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Caveat',
        ),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: defaultColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: defaultColor,
          ),
        ),
      ),
      onChanged: (value) {
        onChange!(value);
      },
      obscureText: isPassword,
      onFieldSubmitted: (value) {
        onSubmit!(value);
      },
      onTap: () {
        onTap!();
      },
      validator: (value) => validate(value),
    );

Widget defaultButton({
  double width = double.infinity,
  Color background = defaultColor,
  bool isUpperCase = true,
  double radius = 3.0,
  void Function()? function,
  required String text,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius,),
        color: background,
      ),
    );

Widget defaultTextButton({
  required Function function,
  required String text,
}) =>
    TextButton(
      onPressed: () {
        function;
      },
      child: Text(
        text.toUpperCase(),
        style: TextStyle(fontFamily: 'Caveat'),
      ),
    );



// Widget buildArticleItem(articles , context) =>  InkWell(
//   onTap: ()
//   {
//     navigateTo(
//         context,
//         WebViewScreen(articles['url']),
//     );
//   },
//   child:   Padding(
//     padding: const EdgeInsets.all(20.0),
//     child: Row(
//       children: [
//         Container(
//           width: 120.0,
//           height: 120.0,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10.0,),
//             image: DecorationImage(
//               image: NetworkImage('${articles['urlToImage']}'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         const SizedBox(
//           width: 20.0,
//         ),
//         Expanded(
//           child: Container(
//             height: 120.0,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children:
//               [
//                 Expanded(
//                   child: Text(
//                     '${articles['title']}',
//                     style: Theme.of(context).textTheme.bodyText1,
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Text(
//                   '${articles['publishedAt']}',
//                   style: const TextStyle(
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// );

// Widget articleBuilder(list , context, {isSearch = false}) => AnimatedConditionalBuilder(
// condition: list.length > 0,
// builder: (context) => ListView.separated(
// physics: const BouncingScrollPhysics(),
// itemBuilder: (context , index) => buildArticleItem(list[index] , context),
// separatorBuilder: (context , index) => myDivider() ,
// itemCount: 10),
// fallback: (context) => isSearch ? Container() : const Center(child: CircularProgressIndicator()),
// );


// void showToast({
//   required String text,
//   required ToastStates state,
// }) => Fluttertoast.showToast(
//     msg: text,
//     toastLength: Toast.LENGTH_LONG,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 5,
//     backgroundColor: chooseToastColor(state),
//     textColor: Colors.white,
//     fontSize: 16.0
// );


/// Login Register
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: defaultColor,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}


class ChatBubble extends StatelessWidget {
  final String message;

  const ChatBubble({
    super.key,
    required this.message
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: defaultColor,
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}


