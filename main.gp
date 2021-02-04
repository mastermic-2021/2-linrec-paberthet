\\reflexions apres le source

u27 = ffgen(('x^3-'x+1)*Mod(1,3),'u); \\construction generateur
codf27(s) = [if(x==32,0,u27^(x-97))|x<-Vec(Vecsmall(s)),x==32||x>=97&&x<=122]; \\encodage

c2 = read("input.txt")[2]; \\on prend le bon chiffre
n = read("input.txt")[3]; \\on prend la valeur n qu Adele a revele par megarde

ch = codf27(c2); \\encodage du chiffre

M = matrix(40,40,i,j,if(j == i+1, 1 ,if(i==40&&j==1,-u27,if(i==40&&j==2,-1,0)))); \\on va passer par la methode matricielle. initialisation
M = M^-1; \\comme on veut dechiffrer et non chiffrer on prend l inverse

\\fonction de decodage. Inspiree de celle de Marc. on cree un dictionnaire de decodage puis on l applique et affiche le clair
decodf27(s) = { 
	table=[0..26];
	for(i=1,26,table[i] = u27^(table[i]));
	table[27] = 0;
	for(i=1,#s,
		j=1;
		while(j <=27, 
				if( s[i] == table[j],
					s[i] = j %27;
					break 
				)
		;j++
		)			
	);
	for(i=1,#s,
		if(s[i] == 0, 
			s[i]=32,
		s[i] = 96 + s[i])
	);
	print(Strchr(s));
}

\\exponentiation rapide pour les matrices
FastPowMat(Matr,pow) = {
	if(pow ==0,
		return (matid(matsize(Matr)[1]))
	);
	if(pow == 1,
		return (Matr)
	);
	if(pow %2 == 0, 
		return (FastPowMat(Matr^2,pow/2)), 
		return (Matr*FastPowMat(Matr^2,(pow-1)/2))
	);
}

\\PARI gp a du mal avec les grandes puissances donc on l eclate en prenant les diviseurs de n
BigFPM(Matr,pow) = 
{
	fa = factor(pow);
	for(i = 1, matsize(fa)[1],
		Matr = (FastPowMat(Matr,fa[i,1]^fa[i,2]));
	);
	return (Matr);
}

\\usage des fonctions et resultat
ch = ch~;
M = BigFPM(M,n);
cl = M*ch;
cl = cl~;
decodf27(cl);

\\Adele a revele n
\\cela a considerablement affaibli la securite de son message
\\on a alors pu retrouver le message initial en faisant un LFSR inverse
\\neanmoins
\\je me demande s il y a un moyen de faire une attaque a l aide de deux chiffres contigus sans connaitre n
\\en me documentant je n ai trouve que des attaques de type KPA (know plaintext attack) mais pas d attaque directe
\\ la seule possibilite serait de faire un systeme a 80 equations et 40 inconnues (si n connu)
\\en effet comme l on dispose de deux chiffres contigus
\\tous les elements du second chiffre peuvent s ecrire comme combinaison lineaire des elements du premier selon un modulo connu
\\reste a voir si cela est plus ou moins complique que juste faire le LFSR inverse