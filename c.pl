start:-
	create_file('username.txt',''),
	create_file('password.txt','').

user:-
	write('Are you new here? ( (Type y/n/exitwindow) '),nl,
	read(X),
	member_login(X).

member_login(exitwindow).

member_login(y):-
	write('Please enter user information :- '),nl,nl,
	write('Username : '),read(U),nl,
	write('Password : '),read(P),nl,
	read_from_userfile('username.txt',U,P,0,0,0,0,1).

member_login(n):-
	write('Please login with username and password :- '),nl,nl,
	write('Username : '),read(U),nl,
	write('Password : '),read(P),nl,
	read_from_userfile('username.txt',U,P,0,0,0,0,0).
	
member_login(X):-
	write('Invalid input. Please type again.'),nl,nl,
	user.

read_from_userfile(File,U,P,A,B,C,D,Z):-
    open(File, read, Str),
    read_file(Str,Lines,U,P,A,B,C,D,Z),
    close(Str).
										
read_file(Stream,Lines,U,P,A,B,C,D,Z):-
    at_end_of_stream(Stream),
	notMatched(U,P,A,Q,C,D,Z).
										
read_file(Stream,Lines,U,P,A,B,C,D,Z):-
    \+ at_end_of_stream(Stream),
(

    ( (A=:=0) ; (\+ (B = A))) ->
	(
		readLine(Stream,Lines),
		Q is B+1,
		(

			( (\+ (Lines = U))) ->
			(
				read_file(Stream,L,U,P,A,Q,C,D,Z)
			);
			( 
				( (Q =:= A) ; (D =:= 0) ) ->
				(
					matched(U,P,A,Q,1,D,Z)
				);
				(
					read_file(Stream,L,U,P,A,Q,C,D,Z)
				)
			)
		)
	);
	(
		notMatched(U,P,A,Q,C,D,Z)
	)
).

readLine(InStream,W):- 
    get_code(InStream,Char), 
    readC(Char,Chars,InStream), 
    atom_codes(W,Chars). 
    
readC(10,[],_):-  !. 
    
readC(32,[],_):-  !. 

readC(-1,[],_):-  !. 
    
readC(end_of_file,[],_):-  !. 
    
readC(Char,[Char|Chars],InStream):- 
	get_code(InStream,NextChar), 
	readC(NextChar,Chars,InStream).
		 
write_to_file(File,Text):-
	open(File,append,Stream), 
	write(Stream,Text),nl(Stream), 
	close(Stream).

create_file(File,Text):-
	open(File,write,Stream),
	write(Stream,Text),
	close(Stream).
	 
matched(U,P,A,B,C,D,0):-
(

    ( (D =:= 0)) ->
	(
		read_from_userfile('password.txt',P,U,B,0,D,C,Z)	
	);
    ( (D =:= 1),(C =:= 1) ) ->
	(
		logged_in(P)
	)
).

matched(U,P,A,B,C,D,1):-
	write('This username already exists. Please try another one.'),nl,nl,
	member_login(y).
	
notMatched(U,P,A,B,C,D,0):-
(
	( (D =:= 0) , (A =:= 0) ) ->
	(
		write('invalid username. Please try again.'),nl,nl,
		user
	);
	( (D =:= 1) ) ->
	(
		write('password incorrect. Please try again.'),nl,nl,
		user
	)
).

notMatched(U,P,A,B,C,D,1):-
	write_to_file('username.txt',U),
	write_to_file('password.txt',P),
	atomic_concat(U,'_D.txt',Za),
	atomic_concat(U,'_T.txt',Z),
	create_file(Z,''),
	create_file(Za,''),
	write('New account created.'),nl,nl,
	member_login(n).
	
logged_in(U):-
	write('Welcome '),write(U),nl,
	explore(U).
	
explore(U):-
	history_check(U),
	write('Do you want to explore more? (Type y if yes and n otherwise)'),nl,
	read(X),
(
	(X='y')-> 
	(
		explore(U)
	);
	(X='n')-> 
	(
		write('logged out'),nl
	);
	(
		logged_out(X)
	)
).

logged_out(X).

	
history_check(U):-
	atomic_concat(U,'_D.txt',Z),
	atomic_concat(U,'_T.txt',Y),
	read_history(Z,Y,0,0,0,U).
	
choice(T,D,U):-
(
	((D=:=0),(T=:=0))->
	(
		choose(U)
	);
	(
		write('You may visit these places regarding to your previous searches '),nl,
		write('If yes, then please enter your choice (enter the place_code correctly) and type no otherwise '),nl,
		read(X),
		( \+ (X='no') ) ->
		(	
			f(X)
		);
		(
			choose(U)
		)
	)

).

f(X):-
X.

read_history(Z,Y,D,T,A,U):-
    open(Z, read, Str),
    read_h_file(Str,Lines,Z,Y,D,T,A,U),
    close(Str).
																				
read_h_file(Stream,Lines,Z,Y,D,T,A,U):-
    \+ at_end_of_stream(Stream),
    readLine(Stream,Lines),
	ff(A,Lines),
	B is 1,
    read_h_file(Stream,L,Z,Y,B,T,A,U).
	read_h_file(Stream,Lines,Z,Y,D,T,A,U):-
    at_end_of_stream(Stream),
	(A=:=0)->	(read_history(Y,Z,T,D,1,U)); (choice(D,T,U)).
		
ff(A,B):-
show(A,B).

		
show(0,'1'):-

write('    dhaka'), nl,
write('			1. Lalbagh Fort	(lalbag_fort)			'), nl,
write('			2. Ahsan Manzil	(ahsan_manzil)			'), nl,
write('			3. Shaheed Minar	(shahid_minar)		'), nl,
write('			4. Jatiyo Smriti Soudho	(sriti_soudh)	'), nl,
write('			5. Jatiya Sangshad		(sangsad)		'), nl,nl.

show(0,'2'):-

write('    chittagong'), nl,
write('			1. Coxs Bazar	(coxs_bazar)			'), nl,
write('			2. St. Martin Island	(st_martin)		'), nl,
write('			3. Bandarban District (bandarban_district)	'), nl,
write('			4. Rangamati		(rangamati)				'), nl,
write('			5. Khagrachari District	(khagrachori)		'), nl,
write('			6. Patenga beach	(patenga_beach)			'), nl,
write('			7. Foys Lake		(foys_lake)				'), nl,
write('			8. Ethnological Museum of Chittagong(museum_ctg)'), nl,
write('			9. WWII cemetery and Circuit House(circuit_house)'), nl,nl.

show(0,'3'):-

write('    rajshahi'), nl,
write('			1. Somapura Mahavihara	(somapura)	'), nl,
write('			2. Mahasthangar	(mahasthangar)		'), nl,
write('			3. Kusumba Mosque	(kusumba_Mosque)'), nl.

show(0,'4'):-

write('    khulna'), nl,
write('			1. Sundarbans	(sundarbans)'), nl,
write('			2. Shatt Gambuz Mosque(shatt_gambuj_mosque)'), nl.

show(0,'5'):-

write('    barisal'), nl,
write('			1. Kuakata_Beach(kuakata_beach)'), nl.

show(0,'6'):-

write('    sylhet'), nl,
write('			1. Lawachara National Park	(lawachara)'), nl,
write('			2. Madhabkunda waterfall(madhabkunda)'), nl,
write('			3. Jaflong	  (jaflong)'), nl,
write('			4. Bisarakandi	(bisarakandi)	'), nl,
write('			5. Srimangal		(srimangal)	'), nl,nl.

show(0,'7'):-

write('    rangpur'), nl,
write('			1.Saidpur	(saidpur)			'), nl,
write('			2.Banglabandha	(banglabandha)	'), nl,
write('			3.Panchagarh	(panchagarh)	'), nl,
write('			4.Rangpur_city	(rangpur_city)	'), nl,
write('			5.Dinajpur		(dinajpur)	'), nl,nl.

show(1,'1'):-

write('    ecotourism'), nl,
write('			1. Sundarbans	(sundarbans)			'), nl,
write('			2. Nijhum Deep	(nijhum_Deep)			'), nl,
write('			3. Shatt Gambuz Mosque(shatt_gambuj_mosque)'), nl,
write('			4. Mahasthangar	(mahasthangar)			'), nl,
write('			5. Kusumba Mosque	(kusumba_Mosque)	'), nl.

show(1,'2'):-

write('    study_tour'), nl,
write('			1. JICA		(jica)	'), nl,
write('			2. world_bank	(world_bank)	'), nl,
write('			3. asian developsment bank(asian_developsment_bank)'), nl,
write('			4. Brac	(brac)	'), nl.

show(1,'3'):-

write('    adventure_tour'), nl,
write('			1.Bandarban	(bandarban_district)'), nl,
write('			2.Khagrachori	(khagrachori)	'), nl,
write('			3. Rangamati(rangamati)		'), nl,
write('			4. Jaflong	  (jaflong)'), nl,
write('			5. Srimangal		(srimangal)	'), nl,nl.

show(1,'4'):-

write('    natural_tour'), nl,
write('			1. Coxs Bazar	(coxs_bazar)		'), nl,
write('			2. St. Martin Island(st_martin)	'), nl,
write('			3. Foys Lake		(foys_lake)		'), nl,
write('			4. Patenga beach(patenga_beach)		'), nl.

show(1,'5'):-

write('    bicycle_tour'), nl,
write('			1.Sonargaon		(sonargaon)	'), nl,
write('			2. Lalbagh Fort	(lalbag_fort)			'), nl,
write('			3. Ahsan Manzil	(ahsan_manzil)			'), nl,
write('			4. Jatiya Sangshad		(sangsad)	'), nl,
write('			5. Jatiyo Smriti Soudho	(sriti_soudh)	'), nl.

show(X,Y).



history(1,Y,U):-
	atomic_concat(U,'_D.txt',Z),
	check_from_userfile(Z,Y).
history(2,Y,U):-
	atomic_concat(U,'_T.txt',Z),
	check_from_userfile(Z,Y).

check_from_userfile(File,U):-
    open(File, read, Str),
    check_file(Str,Lines,File,U),
    close(Str).
																				
check_file(Stream,Lines,File,U):-
    \+ at_end_of_stream(Stream),
    readLine(Stream,Lines),

	( (\+ (Lines = U))) ->
	(
		check_file(Stream,L,File,U)
	).

check_file(Stream,Lines,File,U):-
    at_end_of_stream(Stream),
	write_to_file(File,U).
	
	
	
	
	
	
	
	
	
	
	

choose(U):-

write('		Which way you want to choose a place for your tour?     '), nl,
write('		1. Division Wise  '), nl,
write('		2. Tourism type wise   '), nl,

write('	Enter your choice : '),

read(C), choose_type(C,U).

choose_type(C,U) :- C==1, division(U); C==2, tourism(U); C=\=1, C=\=2, write('  Something went wrong. Please try again.  '), nl, nl, choose(U).


tourism(U):-
write('  What type of tourism you want to take??  '), nl,
write('		1. Ecotourism		'), nl,
write('		2. Study tour	'), nl,
write('		3. Adventure tour		'), nl,
write('		4. Natural tour		'), nl,
write('		5. bicycle tour		'), nl,

write('	Enter your choice : '),nl,

read(Y), history(2,Y,U),
select_tour(Y,U).

select_tour(Y,U):-
Y==1, ecotourism;Y==2, study_tour; Y==3, adventure_tour; Y==4, natural_tour; Y==5, bicycle_tour;
Y=\=1 , Y=\=2, Y=\=3, Y=\=4, Y=\=5,
write('Something went wrong. Please try a valid number.'), nl, nl,  tourism(U).


division(U):-

write('  In which division you would like to have your tour?   '), nl,
write('		1. Dhaka		'), nl,
write('		2. Chittagong		'), nl,
write('		3. Rajshahi		'), nl,
write('		4. Khulna		'), nl,
write('		5. Barisal		'), nl,
write('		6. Sylhet		'), nl,
write('		7. Rangpur		'), nl,nl,

write('	Enter your choice : '),nl,

read(D), history(1,D,U),
select_div(D,U).

select_div(D,U) :- D==1, dhaka; D==2, chittagong; D==3, rajshahi; D==4, khulna; D==5, barisal; D==6, sylhet; D==7, rangpur;
D=\=1 , D=\=2, D=\=3, D=\=4, D=\=5, D=\=6, D=\=7, write('Something went wrong. Please try a valid number.'), nl, nl, division(U).

	
	
	
	
	


dhaka:-

write('    In which spot you would like to have your tour?     '), nl,
write('			1. Lalbagh Fort				'), nl,
write('			2. Ahsan Manzil				'), nl,
write('			3. Shaheed Minar			'), nl,
write('			4. Jatiyo Smriti Soudho		'), nl,
write('			5. Jatiya Sangshad			'), nl,nl,

write('	Enter your choice : '),nl,

read(P), select_dhaka(P).

select_dhaka(P) :-  P==1, lalbag_fort; P==2, ahsan_monjil; P==3, shahid_minar; P==4, sriti_soudh; P==5, sangsad;
P=\=1, P=\=2, P=\=3, P=\=4, P=\=5, write('                Something went wrong. Please try a valid number.           '), nl, nl, dhaka.



chittagong :-

write('    In which spot you would like to have your tour?     '), nl,
write('			1. Coxs Bazar				'), nl,
write('			2. St. Martin Island			'), nl,
write('			3. Bandarban District						'), nl,
write('			4. Rangamati								'), nl,
write('			5. Khagrachari District						'), nl,
write('			6. Patenga beach							'), nl,
write('			7. Foys Lake								'), nl,
write('			8. Ethnological Museum of Chittagong		'), nl,
write('			9. WWII cemetery and Circuit House			'), nl,nl,


write('	Enter your choice : '),nl,

read(H), select_chi(H).

select_chi(H) :-  H==1, coxs_bazar; H==2, st_martin; H==3, bandarban_district; H==4,rangamati ; H==5, khagrachori;
H==6,patenga_beach; H==7,foys_lake; H==8,museum_ctg;  H==9,circuit_house;
H=\=1, H=\=2, H=\=3, H=\=4, H=\=5,H=\=6,H=\=7,H=\=8,H=\=9, write('                Something went wrong. Please try a valid number.           '), nl, nl, chittagong.

barisal:-

write('    In which spot you would like to have your tour?     '), nl,
write('			1. Kuakata_Beach			'), nl,

write('	Enter your choice : '),

read(B), select_barisal(B).

select_barisal(B) :-  B==1,kuakata_beach ;
B=\=1, write('                Something went wrong. Please try a valid number.           '), nl, nl, barisal.


khulna :-
   write('    In which spot you would like to have your tour?     '), nl,
write('			1. Sundarbans				'), nl,
write('			2. Shatt Gambuz Mosque			'), nl,

write('	Enter your choice : '),

read(K), select_kh(K).

select_kh(K) :-  K==1,sundarbans ; K==2,shatt_gambuj_mosque;
K=\=1, K=\=2, write('                Something went wrong. Please try a valid number.           '), nl, nl, khulna.

rajshahi :-
    write('    In which spot you would like to have your tour?     '), nl,
write('			1. Somapura Mahavihara				'), nl,
write('			2. Mahasthangar					'), nl,
write('			3. Kusumba Mosque		'), nl,
 write('	Enter your choice : '),

read(Ra), select_raj(Ra).

select_raj(Ra) :-  Ra==1, somapura; Ra==2, mahasthangar	; Ra==3, kusumba_Mosque;
Ra=\=1, Ra=\=2, Ra=\=3, write('                Something went wrong. Please try a valid number.           '), nl, nl, rajshahi.

rangpur:-
 write('    In which spot you would like to have your tour?     '), nl,
write('			1.Saidpur				'), nl,
write('			2.Banglabandha				'), nl,
write('			3.Panchagarh			'), nl,
write('			4.Rangpur_city		'), nl,
write('			5.Dinajpur			'), nl,nl,

write('	Enter your choice : '),

read(R), select_rangpur(R).

select_rangpur(R) :-  R==1,saidpur ; R==2,banglabandha ; R==3,panchagarh ; R==4,rangpur_city ; R==5,dinajpur ;
R=\=1, R=\=2, R=\=3, R=\=4, R=\=5, write('                Something went wrong. Please try a valid number.           '), nl, nl, rangpur .

sylhet:-

write('    In which spot you would like to have your tour?     '), nl,
write('			1. Lawachara National Park				'), nl,
write('			2. Madhabkunda waterfall			'), nl,
write('			3. Jaflong	                           '), nl,
write('			4. Bisarakandi		'), nl,
write('			5. Srimangal			'), nl,nl,

write('	Enter your choice : '),

read(S), select_sl(S).

select_sl(S) :-  S==1, lawachara;S==2,madhabkunda  ; S==3,jaflong ; S==4,bisarakandi; S==5,srimangal;
S=\=1, S=\=2, S=\=3, S=\=4, S=\=5, write('                Something went wrong. Please try a valid number.           '), nl, nl, sylhet.

study_tour :-
 write('    In which spot you would like to have your tour?     '), nl,
write('			1. JICA				'), nl,
write('			2. world_bank			'), nl,
write('			3. asian developsment bank		'), nl,
write('			4. Brac		'), nl,

write('	Enter your choice : '),

read(St), select_study(St).

select_study(St) :-  St==1, jica; St==2, world_bank; St==3,asian_developsment_bank ; St==4, brac;
St=\=1, St=\=2, St=\=3, St=\=4,  write('                Something went wrong. Please try a valid number.           '), nl, nl, study_tour.

adventure_tour :-
    write('    In which spot you would like to have your tour?     '), nl,
write('			1.Bandarban			'), nl,
write('			2.Khagrachori			'), nl,
write('			3. Rangamati			'), nl,
write('			4. Jaflong		'), nl,
write('			5.Srimangal			'), nl,nl,

write('	Enter your choice : '),

read(Ad), select_ad(Ad).

select_ad(Ad) :-  Ad==1,bandarban_district ; Ad==2,khagrachori ; Ad==3,rangamati ; Ad==4,jaflong; Ad==5,srimangal ;
Ad=\=1, Ad=\=2, Ad=\=3, Ad=\=4, Ad=\=5, write('                Something went wrong. Please try a valid number.           '), nl, nl, adventure_tour.

bicycle_tour :-
 write('    In which spot you would like to have your tour?     '), nl,
write('			1.Sonargaon			'), nl,
write('			2.the Lalbag fort			'), nl,
write('			3.Ahsan Manzil			'), nl,
write('			4.Jatiya Sangshad		'), nl,
write('			5. Jatiyo Smriti Soudho			'), nl,nl,

write('	Enter your choice : '),

read(Bi), select_bi(Bi).

select_bi(Bi) :-  Bi==1,sonargaon ; Bi==2,lalbag_fort ; Bi==3,ahsan_monjil ; Bi==4,sangsad ; Bi==5,sriti_soudh ;
Bi=\=1, Bi=\=2, Bi=\=3, Bi=\=4, Bi=\=5, write('                Something went wrong. Please try a valid number.           '), nl, nl, bicycle_tour.

ecotourism :-
 write('    In which spot you would like to have your tour?     '), nl,
write('			1. Sundarbans				'), nl,
write('			2. Nijhum Deep				'), nl,
write('			3. Shatt Gambuz Mosque			'), nl,
write('			4. Mahasthangar		'), nl,
write('			5. Kusumba Mosque			'), nl,nl,

write('	Enter your choice : '),

read(Ec), select_eco(Ec).

select_eco(Ec) :-  Ec==1,sundarbans; Ec==2,nijhum_Deep ; Ec==3, shatt_gambuj_mosque ; Ec==4,mahasthangar ; Ec==5,kusumba_Mosque ;
Ec=\=1, Ec=\=2, Ec=\=3, Ec=\=4, Ec=\=5, write('                Something went wrong. Please try a valid number.           '), nl, nl,ecotourism .

natural_tour :-
write('    In which spot you would like to have your tour?     '), nl,
write('			1. Coxs Bazar			'), nl,
write('			2. St Martin Island			'), nl,
write('			3.Foys_lake		'), nl,
write('			4.Patenga sea beach	'), nl,

write('	Enter your choice : '),

read(Na), select_natural(Na).

select_natural(Na) :-  Na==1, coxs_Bazar; Na==2,st_martin ; Na==3,foys_lake; Na==4,patenga_beach ;
Na=\=1, Na=\=2, Na=\=3, Na=\=4,  write('                Something went wrong. Please try a valid number.           '), nl, nl, natural_tour.



















lalbag_fort:-
   write('Distance from dhaka to lalbag_fort is 12.9 km'),nl,nl,
   write(' It will take 49 min (12.9 km) via Dhaka - Mymensingh Hwy'),nl,nl,
   write(' It will take 48 min (14.6 km) via Hatir Jheel Link Rd'),nl,nl,
   write('It will take 49 min (13.6 km) via Shaheed Tajuddin Ahmed Ave'),nl.

ahsan_monjil :-
   write('Distance from dhaka to ahsan_monjil is 15.1 km'),nl,nl,
    write(' It will take 48 min (15.1 km) via Hatir Jheel Link Rd'),nl,nl,
   write(' It will take 50 min (14.1 km) via Shaheed Tajuddin Ahmed Ave'),nl,nl,
   write('It will take 52 min (15.0 km) via Kazi Nazrul Islam Ave'),nl.

shahid_minar:-
   write('Distance from dhaka to shahid_minar 13.1 is  km'),nl,nl,
    write(' It will take 39 min (13.1 km) via Hatir Jheel Link Rd '),nl,nl,
   write(' It will take 41 min (12.1 km) via Shaheed Tajuddin Ahmed Ave '),nl,nl,
   write('It will take 43 min (11.8 km) via Kazi Nazrul Islam Ave '),nl.
sriti_soudh :-
   write('Distance from dhaka to sriti_soudh  is 30.5  km'),nl,nl,
    write(' It will take 1 h 16 min (30.5 km) via Dhaka - Ashulia Hwy/N302  '),nl,nl,
   write(' It will take 1 h 27 min (36.6 km) via Dhaka - Aricha Hwy '),nl,nl.
sangsad:-
     write('Distance from dhaka to sangsad  is 8.9  km'),nl,nl,
    write(' It will take  31 min (8.9 km) via Dhaka - Mymensingh Hwy '),nl,nl,
   write(' It will take 40 min (13.2 km) via Hatir Jheel Link Rd '),nl,nl.
coxs_bazar :-
   write('Distance from dhaka to coxs_bazar is 306  km'),nl,nl,
   write('Distance from chittagong to coxs_bazar is 144.0  km'),nl,nl,
   write('It will take 3 h 41 min (144.0 km) via N1 '),nl.
st_martin :-
   write('Distance from dhaka to saint_martin is 501  km'),nl,nl,
   write('It will take 3h if you go by ship from teknaf '),nl.
bandarban_district :-
   write('Distance from dhaka to bandarban is 257  km'),nl,nl,
   write('Distance from chittagong to bandarban is 69.5  km'),nl,nl,
   write('It will take 4 h 15 min (129.9 km) via N1 and Bandarban - Thanchi Rd '),nl.
rangamati :-
    write('Distance from dhaka to rangamati is 303.7   km'),nl,nl,
   write('Distance from chittagong to rangamati is 42.1  km'),nl,nl,
   write('It will take 2 h 20 min (70.1 km) via Chittagong - Rangamati Rd '),nl.
khagrachori :-
 write('Distance from dhaka to khagrachari is 269.6  km'),nl,nl,
   write('Distance from chittagong to khagrachari is 61.6  km'),nl,nl,
   write('It will take  3 h 44 min (117.4 km) via R160'),nl.
patenga_beach :-
   write('Distance from dhaka to  potenga is 259.9 km'),nl,nl,
   write('Distance from chittagong to potenga  is 16.4  km'),nl,nl,
   write('It will take 51 min (16.4 km) via M. A Aziz Rd '),nl.

foys_lake :-
    write('Distance from dhaka to  foys_lake is 247.2   km'),nl,nl,
   write('Distance from chittagong to foys_lake  is  4.3  km'),nl,nl,
   write('It will take 15 min (4.3 km) via Ambagan Road and pahartoli road '),nl.
museum_ctg :-
   write('Distance from dhaka to museum_ctg is 252.6   km'),nl,nl,
   write('Distance from chittagong museum_ctg is 3.5  km'),nl,nl,
   write('It will take 13 min (3.5 km) via Sheikh Mujib Rd '),nl.
circuit_house:-
   write('Distance from dhaka to circuit_house is 249  km'),nl,nl,
   write('Distance from chittagong  is 4.3  km'),nl,nl,
   write('It will take 17 min (4.3 km)via CDA Ave Fastest route '),nl.

kuakata_beach :-
   write('Distance from dhaka to kuakata_beach is 374.2  km'),nl,nl,
   write('Distance from barishal to kuakata_beach  is 129  km'),nl,nl,
   write('It will take 4 h 24 min (129.0 km) via Dhaka - Patuakhali Hwy '),nl.
sundarbans :-
   write('Distance from dhaka to sundarbans is 242   km'),nl,nl,
   write('Distance from khulna to sundarbans  is 106  km'),nl,nl,
   write('you can use water transport to go there'),nl.
nijhum_Deep:-
  write('Distance from dhaka to nijhum deep is 371.2    km'),nl,nl,
   write('it will take 8 h 24 min (371.2 km) via Dhaka - Chittagong Hwy and N1 '),nl,nl.
shatt_gambuj_mosque:-
   write('Distance from dhaka to shatt_gambuj_mosque is 272.5   km'),nl,nl,
   write('Distance from khulna to shatt_gambuj_mosque  is 30.4   km'),nl,nl,
   write('it will take 1 h 16 min (30.4 km) via Khulna - Mongla Rd and R770'),nl.
somapura :-
    write('Distance from dhaka to samapura is  261.7 km'),nl,nl,
   write('Distance from rajshahi to samapura  is 104.8 km'),nl,nl,
   write('it will take 2 h 41 min (104.8 km) via R685 '),nl.
mahasthangar:-
   write('Distance from dhaka to mahastangar is 207  km'),nl,nl,
   write('Distance from rajshahi to mahastangar  is 123 km'),nl,nl.
kusumba_Mosque:-
   write('Distance from dhaka to Kusumba Mosque is 288.7  km'),nl,nl,
   write('Distance from rajshahi to Kusumba Mosque  is 47.9  km'),nl,nl,
   write('it will take 1 h 12 min (47.9 km) via R685 '),nl.
saidpur :-
   write('Distance from dhaka to saidpur is 752  km'),nl,nl,
   write('Distance from rangpur to saidpur  is 42.7  km'),nl,nl,
   write('it will take 1 h 9 min (42.7 km) via N5  '),nl.

banglabandha:-
 write('Distance from dhaka to Banglabandha is 465.7   km'),nl,nl,
   write('Distance from rangpur to Banglabandha   is 167.2   km'),nl,nl,
   write('it will take 3 h 45 min (167.2 km) via N5 '),nl.
panchagarh :-
 write('Distance from dhaka to Panchagarh  is 336    km'),nl,nl,
   write('Distance from rangpur to  Panchagarh is 116.2   km'),nl,nl,
   write('it will take 2 h 53 min (116.2 km) via Rangpur - Jaldhaka Rd'),nl.
rangpur_city :-
   write('Distance from dhaka to rangpur_city  is 255   km'),nl,nl,
   write('it will take 7 h 5 min (302.9 km) via Dhaka - Rangpur Hwy/N5'),nl.
dinajpur:-
   write('Distance from dhaka to Dinajpur is 173  km'),nl,nl,
   write('Distance from rangpur to Dinajpur  is 63 km'),nl,nl,
   write('it will take 2 h 4 min (82.5 km) via N5 '),nl.
lawachara :-
   write('Distance from dhaka to lawachara is 194   km'),nl,nl,
   write('Distance from sylhet to lawachara  is 82  km'),nl,nl,
   write('it will take 4 h 45 min via Dhaka-Srimangal Highway'),nl.
madhabkunda:-
   write('Distance from dhaka to madhabkunda is 273   km'),nl,nl,
   write('Distance from sylhet to madhabkunda  is 69.5   km'),nl,nl,
   write('it will take 6 h 30 min (267.6 km) via Dhaka - Sylhet Hwy'),nl.
jaflong :-
   write('Distance from dhaka to jaflong is 356 km'),nl,nl,
   write('Distance from sylhet to jaflong  is 60  km'),nl,nl,
   write('it will take 7 h 3 min (304.9 km) via Dhaka - Sylhet Hwy'),nl.
bisarakandi:-
   write('Distance from dhaka to bisnakandi is 365 km'),nl,nl,
   write('Distance from sylhet to bisnakandi  is 65.2   km'),nl,nl,
   write('it will take 7 h 58 min (311.8 km) via Dhaka - Sylhet Hwy'),nl.
srimangal :-
   write('Distance from dhaka to srimangal is 164   km'),nl,nl,
   write('Distance from sylhet to srimangal  is 87.2  km'),nl,nl,
   write('it will take 4 h 16 min (181.0 km) via Dhaka - Sylhet Hwy'),nl.

jica:-
  write(' japan international cooperation agency'),nl,nl,
   write(' you can go by bus there'),nl,nl.
world_bank:-
 write('world bank'),nl,nl,
 write('you can go there by bus'),nl.
asian_developsment_bank:-
  write(' asian development bank'),nl,nl,
   write(' you can go by bus there'),nl,nl.
brac:-
 write(' brac'),nl,nl,
   write(' you can visit everything that belongs to brac oraganization by bus'),nl,nl.
sonargaon :-
  write('Distance from dhaka to sonargaon is 31.9  km'),nl,nl,
   write('it will take 1 h 15 min (31.9 km) via N1'),nl,nl,
   write('it will take  1 h 22 min (37.3 km) via Mayor Mohammad Hanif Flyover and N1'),nl.







   
   
   
   
   
   
   
   



