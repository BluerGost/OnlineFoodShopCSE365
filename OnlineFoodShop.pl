:- discontiguous
        buy/3,
        product_type/2,
        product_price/3,
		product_serial/2.


main:-
format('Welcme To The Shop ~n'),start.

start :-
write('Press 1 : To See the Options'),nl,
write('Press 2 : To Exit Shop'),nl,
read(Ans),
(
	(Ans=1)->
	(
		write('Press 1 : To See the Product Lists'),nl,
		write('Press 2 : To Place Order'),nl,
		read(X),
		(
			(X = 1)-> %Product Lists
			(
				write('Here are  the type of Product available in our DB :-'),nl,
				write('Press 1 : To See Fruit List'),nl,
				write('Press 2 : To See Vegetable List'),nl,
				write('Press 3 : To See Fish'),nl,
				write('Press 4 : To See Meat'),nl,
				write('Press 5 : To See Sweet'),nl,
				read(SelectedList),
				(
					(SelectedList = 1 ) ->
					(
						listProduct('Fruit')
					);
					(SelectedList = 2 ) ->
					(
					listProduct('Vegetable')
					);
					
					(SelectedList = 3 ) ->
					(
					listProduct('Fish')
					);

					(SelectedList = 4 ) ->
					(
					listProduct('Meat')
					);

					(SelectedList = 5 ) ->
					(
					listProduct('Sweet')
					);
					(
						format('You have Inserted Invalid Number. ~n Please insert the Valid number for a type.')
					)
				)
			);
			(X = 2)-> % Place Order
			(
				placeOrder
			);
			(
				format('You have Selected Invalid Option. ~n Please Try Again ~n'),
				start
			)
		)
	);






	(Ans = 2)->
	(
		format('Thank You for Coming .  (You have exited the shop).')
	);
	(
		format('You have Selected Invalid Option. ~n Please Try Again ~n'),
		start
	)
).



/*								Place Order Functions      				*/
placeOrder:-
write('Press 1 : To Place Order'),nl,
write('Press 2 : To Exit From Ordering'),nl,
read(X),
(
	(X=1)->
	(
		placeOrderNew
	);
	(X=2)->
	(
		format('~n You have exited form Ordering ~n')
	);
	(
		format('~n Invalid option. Please Try again ~n'),
		placeOrder
	)
).

placeOrderNew:- %No file is created this function takes the 1st order
	format('Enter the Serial Number Of Product(1-54):'),
	read(SerialNo),
	format('Enter Quantity of the Product:'),
	read(ProQuantity),
	product_serial(SerialNo,ProName),
	product_type(ProName,ProType),
	product_price(ProName,PcsOrGm,PricePerUnit),
	Z is (ProQuantity*PricePerUnit),
	open('productOrder.txt', write, Stream),
	write(Stream, "SerialNo:"),write(Stream, SerialNo), nl(Stream),
	write(Stream, "Product Name:"),write(Stream, ProName), nl(Stream),
	write(Stream, "ProQuantity:"),write(Stream, ProQuantity), nl(Stream),
	write(Stream,"Total Amount: "),write(Stream,Z),
	write(Stream, "( in "),write(Stream, PcsOrGm),write(Stream,")"), nl(Stream),


	close(Stream),
	optionToAddItem.

optionToAddItem :-
format('~n Do you want to add another Item in your List? ~n'),
format('Press 1 : To Add New Item ~n'),
format('Press 2 : To Exit from Adding New Item ~n'),
read(Ans),
(
	(Ans = 1)->
	(
		placeOrderOld
	);
	(Ans = 2) ->
	(
		write('Exiting From Adding New Items')
	);
	(
		write('Invalid Option. Please Try Again'),
		optionToAddItem
	)
).


placeOrderOld:- %Adding new item to the existing chart
	format('Enter the Serial Number Of Product(1-54):'),
	read(SerialNo),
	format('Enter Quantity of the Product:'),
	read(ProQuantity),
	product_serial(SerialNo,ProName),
	product_type(ProName,ProType),
	product_price(ProName,PcsOrGm,PricePerUnit),
	Z is (ProQuantity*PricePerUnit),
	open('productOrder.txt', append, Stream),
	write(Stream, "SerialNo:"),write(Stream, SerialNo), nl(Stream),
	write(Stream, "Product Name:"),write(Stream, ProName), nl(Stream),
	write(Stream, "ProQuantity:"),write(Stream, ProQuantity), nl(Stream),
	write(Stream,"Total Amount: "),write(Stream,Z),
	write(Stream, "( in "),write(Stream, PcsOrGm),write(Stream,")"), nl(Stream),
	close(Stream),
	optionToAddItem.

/*								 End of Place Order Functions      				*/




/*                                  Listing of Products             */
% Print List of a Specific type of product in the database
listProduct(ProType):- %get the list
findall(X,product_type(X,ProType),ProNameList),
format('List of the ~w :- ~n',[ProType]),
maplist(printProduct, ProNameList).

printProduct(ProNameList):-
product_price(ProNameList,PcsOrGm,PricePerUnit),
product_serial(ProSerialNo,ProNameList),
format('~w) ~w =>  ~w (per ~w) ~n',[ProSerialNo,ProNameList,PricePerUnit,PcsOrGm]).
/*                                End of  Listing of Products             */





/*                    Product Purchase Method             */
buy_product(CustHave,ProSerialNo,ProName,ProQuantity):-
(

	product_serial(ProSerialNo,ProName),
	product_type(ProName,ProType),
	product_price(ProName,PcsOrGm,PricePerUnit),
	X is (PricePerUnit*ProQuantity), % Here, X is Total Cost of  A Product
	(
		(X > CustHave) ->
		(
			format('Your Order Cant Be Placed for ~w ~w ~n',[ProQuantity,ProName]),
			Z is (X-CustHave), %The amount the customer is short by
			format('Your Are Short with  ~2f Taka ~n',[Z])
		);

		(
			format('Your Order for ~w ~w Has Been Placed ~n',[ProQuantity,ProName]),
			format('Thank Your For Shopping :) ~n')
		)
	)

).
/*                    Product Purchase Method             */


/*									FRUIT								*/

product_serial(1,'Chompa Banana').
product_type('Chompa Banana','Fruit').
product_price('Chompa Banana','pcs',5).

product_serial(2,'Green Grapes').
product_type('Green Grapes','Fruit').
product_price('Green Grapes','gm',0.26).

product_serial(3,'Green Apple').
product_type('Green Apple','Fruit').
product_price('Green Apple','gm',0.168).

product_serial(4,'Malta').
product_type('Malta','Fruit').
product_price('Malta','gm',0.132).

product_serial(5,'Green Coconut').
product_type('Green Coconut','Fruit').
product_price('Green Coconut','pcs',55).

product_serial(6,'Black Grapes').
product_type('Black Grapes','Fruit').
product_price('Black Grapes','gm',0.32).

product_serial(7,'Guava Thai').
product_type('Guava Thai','Fruit').
product_price('Guava Thai','gm',0.125).

product_serial(8,'Pineapple').
product_type('Pineapple','Fruit').
product_price('Pineapple','pcs',55).

product_serial(9,'Per').
product_type('Per','Fruit').
product_price('Per','gm',0.18).

product_serial(10,'Pomegranate').
product_type('Pomegranate','Fruit').
product_price('Pomegranate','gm',0.29).

product_serial(11,'Paka Pape').
product_type('Paka Pape','Fruit').
product_price('Paka Pape','gm',0.105).

product_serial(12,'China Fuji Apple').
product_type('China Fuji Apple','Fruit').
product_price('China Fuji Apple','gm',0.168).

product_serial(13,'Orange').
product_type('Orange','Fruit').
product_price('Orange','pcs',20.83).

product_serial(14,'Banana Sagor').
product_type('Banana Sagor','Fruit').
product_price('Banana Sagor','pcs',10.42).

product_serial(15,'Coconut').
product_type('Coconut','Fruit').
product_price('Coconut','pcs',55).

product_serial(16,'Water Melon').
product_type('Water Melon','Fruit').
product_price('Water Melon','pcs',300).

product_serial(17,'Water Melon Thai').
product_type('Water Melon Thai','Fruit').
product_price('Water Melon Thai','pcs',320).

product_serial(18,'Green Mango').
product_type('Green Mango','Fruit').
product_price('Green Mango','gm',0.165).

product_serial(19,'Khurma Dry Dates').
product_type('Khurma Dry Dates','Fruit').
product_price('Khurma Dry Dates','gm',0.23).

product_serial(20,'Wood Apple Medium').
product_type('Wood Apple Medium','Fruit').
product_price('Wood Apple Medium','pcs',65).



/*							VEGETABLE							*/
product_serial(21,'Onion indian').
product_type('Onion indian','Vegetable').
product_price('Onion indian','gm',2.4).

product_serial(22,'Onion Bangladeshi').
product_type('Onion Bangladeshi','Vegetable').
product_price('Onion Bangladeshi','gm',3).

product_serial(23,'Garlic').
product_type('Garlic','Vegetable').
product_price('Garlic','gm',20).

product_serial(24,'Red Tomato').
product_type('Red Tomato','Vegetable').
product_price('Red Tomato','gm',2.8).

product_serial(25,'Potato').
product_type('Potato','Vegetable').
product_price('Potato','gm',1.8).


product_serial(27,'Green Chili').
product_type('Green Chili','Vegetable').
product_price('Green Chili','gm',6).

product_serial(28,'Coriander Leaves').
product_type('Coriander Leaves','Vegetable').
product_price('Coriander Leaves','gm',13).

product_serial(29,'Carrot').
product_type('Carrot','Vegetable').
product_price('Carrot','gm',3).

product_serial(30,'Ginger').
product_type('Ginger','Vegetable').
product_price('Ginger','gm',8).

product_serial(31,'Cucumber').
product_type('Cucumber','Vegetable').
product_price('Cucumber','gm',4.4).

product_serial(32,'Green Papaya').
product_type('Green Papaya','Vegetable').
product_price('Green Papaya','gm',3).

product_serial(33,'Lemon').
product_type('Lemon','Vegetable').
product_price('Lemon','pcs',5).

product_serial(34,'Green Capsicum').
product_type('Green Capsicum','Vegetable').
product_price('Green Capsicum','gm',16).

product_serial(35,'Ladies Finger').
product_type('Ladies Finger','Vegetable').
product_price('Ladies Finger','gm',6).

product_serial(36,'Sanke Gourd').
product_type('Sanke Gourd','Vegetable').
product_price('Sanke Gourd','gm',5.6).

product_serial(37,'Potol').
product_type('Potol','Vegetable').
product_price('Potol','gm',5.2).

product_serial(38,'Flat Beans').
product_type('Flat Beans','Vegetable').
product_price('Flat Beans','gm',5).

product_serial(39,'Spinach').
product_type('Spinach','Vegetable').
product_price('Spinach','gm',4.8).

product_serial(40,'Red Spinach').
product_type('Red Spinach','Vegetable').
product_price('Red Spinach','gm',6.5).

product_serial(41,'Brinjal').
product_type('Brinjal','Vegetable').
product_price('Brinjal','gm',6).

product_serial(42,'Sweet Pumpkin').
product_type('Sweet Pumpkin','Vegetable').
product_price('Sweet pumpkin','gm',4).

product_serial(43,'Water Spinach').
product_type('Water Spinach','Vegetable').
product_price('Water Spinach','gm',6).

product_serial(44,'Bitter Gourd').
product_type('Bitter Gourd','Vegetable').
product_price('Bitter Gourd','gm',6).

product_serial(45,'Water Pumpkin').
product_type('Water Pumpkin','Vegetable').
product_price('Water Pumpkin','pcs',40).

product_serial(46,'Green Banana').
product_type('Green Banana','Vegetable').
product_price('Green Banana','gm',7).

product_serial(47,'Mint Leaves').
product_type('Mint Leaves','Vegetable').
product_price('Mint Leaves','gm',14).

product_serial(48,'Pui Spinach').
product_type('Pui Spinach','Vegetable').
product_price('Pui Spinach','gm',5.4).

product_serial(49,'Ridge Gourd').
product_type('Ridge Gourd','Vegetable').
product_price('Ridge Gourd','gm',6.4).

product_serial(50,'Beetroot').
product_type('Beetroot','Vegetable').
product_price('Beetroot','gm',8).

product_serial(51,'Baby corn').
product_type('Baby corn','Vegetable').
product_price('Baby corn','gm',8).

product_serial(52,'Long Bean').
product_type('Long Bean','Vegetable').
product_price('Long Bean','gm',6).

product_serial(53,'Red Chili').
product_type('Red Chili','Vegetable').
product_price('Red Chili','gm',15).

product_serial(54,'Stolon of Taro').
product_type('Stolon of Taro','Vegetable').
product_price('Stolon of Taro','gm',7).

/*     Fish     */

product_serial(55,'Rui').
product_type('Rui','Fish').
product_price('Rui','gm',0.3).

product_serial(56,'Koi').
product_type('Koi','Fish').
product_price('Koi','gm',0.28).

product_serial(57,'Mola').
product_type('Mola','Fish').
product_price('Mola','gm',0.32).

product_serial(58,'Telapia').
product_type('Telapia','Fish').
product_price('Telapia','gm',0.22).

product_serial(59,'Kaski').
product_type('Kaski','Fish').
product_price('Kaski','gm',0.32).

product_serial(60,'Hilsha').
product_type('Hilsha','Fish').
product_price('Hilsha','gm',1.5).

/*   Meat    */

product_serial(61,'Broiler Chicken').
product_type('Broiler Chicken','Meat').
product_price('Broiler Chicken','gm',0.16).

product_serial(62,'Beef').
product_type('Beef','Meat').
product_price('Beef','gm',0.46).

product_serial(63,'Cock Chicken').
product_type('Cock Chicken','Meat').
product_price('Cock Chicken','gm',0.32).


/*     Sweet       */

product_serial(65,'Elish Petti').
product_type('Elish Petti','Sweet').
product_price('Elish Petti','gm',0.55).

product_serial(66,'Kata Vog').
product_type('Kata Vog','Sweet').
product_price('Kata Vog','gm',0.4).

product_serial(67,'Sagorika').
product_type('Sagorika','Sweet').
product_price('Sagorika','gm',0.48).

product_serial(68,'Obak Sondesh').
product_type('Obak Sondesh','Sweet').
product_price('Obak Sondesh','gm',0.5).

product_serial(70,'Lalmohon').
product_type('Lalmohon','Sweet').
product_price('Lalmohon','gm',0.37).

product_serial(71,'Rajvog').
product_type('Rajvog','Sweet').
product_price('Rajvog','gm',0.35).

product_serial(72,'Khirvog').
product_type('Khirvog','Sweet').
product_price('Khirvog','gm',0.5).

product_serial(73,'Chanar Gilapi').
product_type('Chanar Gilapi','Sweet').
product_price('Chanar Gilapi','gm',0.35).

product_serial(74,'Rasakadom').
product_type('Rasakadom','Sweet').
product_price('Rasakadom','gm',0.38).

product_serial(75,'Roshomalai').
product_type('Roshomalai','Sweet').
product_price('Roshomalai','gm',0.5).

product_serial(76,'Chomchom').
product_type('Chomchom','Sweet').
product_price('Chomchom','gm',0.36).












