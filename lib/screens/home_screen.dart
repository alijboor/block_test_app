import 'package:block_test_app/cubits/product/orders_cubit.dart';
import 'package:block_test_app/cubits/product/orders_state.dart';
import 'package:block_test_app/db/shared_helper.dart';
import 'package:block_test_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    SharedHelper.init();
    BlocProvider.of<ProductCubit>(context).loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        // leading: IconButton(
        //   onPressed: () {
        //     BlocProvider.of<ProductCubit>(context).loadData();
        //   },
        //   icon: Icon(Icons.download),
        // ),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
        if (state is LoadingProductState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EmptyProductState) {
          return const Center(child: Text('No Data to show'));
        }

        final provider = BlocProvider.of<ProductCubit>(context);

        return ListView.separated(
            shrinkWrap: true,
            itemBuilder: (_, index) =>
                _buildColumn(provider.products.elementAt(index), provider),
            separatorBuilder: (_, index) => const SizedBox(width: 20),
            itemCount: provider.products.length);
      }),
    );
  }

  Widget _buildColumn(ProductModule item, ProductCubit provider) {
    return Card(
      shadowColor: Colors.grey,
      elevation: 3.5,
      shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: SizedBox(
            height: 120,
            child: Image.network(
              item.images?.first ??
                  'https://www.tea-tron.com/antorodriguez/blog/wp-content/uploads/2016/04/image-not-found-4a963b95bf081c3ea02923dceaeb3f8085e1a654fc54840aac61a57a60903fef.png',
              fit: BoxFit.fill,
            )),
        title: Text(item.title ?? '', overflow: TextOverflow.visible),
        subtitle: Row(
          children: [
            Text('${item.price}'),
            const Spacer(),
            IconButton(
                onPressed: () => provider.toggleFavorite(item),
                icon: Icon(
                  (item.isFavorite)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.deepPurpleAccent,
                  size: 18,
                ))
          ],
        ),
      ),
    );
  }
}
