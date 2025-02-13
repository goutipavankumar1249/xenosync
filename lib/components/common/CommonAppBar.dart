PreferredSizeWidget buildCommonAppBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () => Navigator.pop(context),
    ),
    title: Text(
      "Shot OK",
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'Montserrat',
      ),
    ),
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.white,
  );
}
