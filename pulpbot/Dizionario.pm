package Dizionario;
use Exporter;
@ISA = qw(Exporter);
@EXPORT_OK=qw(cerca);

sub cerca {
	#@temp= split /\ /, @_;
	$stringa = $_[0];
	$numero_lemma = $_[1]; 
	$numero_pagina=`curl http://www.demauroparavia.it/cerca?stringa=$stringa`; 
	if(!($numero_pagina =~ /Non ho trovato occorrenze/))
	{
		if($numero_pagina =~ /URL/)
		{
			#print("un solo lemma");
			@righe= split /\n/, $numero_pagina;
			foreach $linea (@righe)
			{
				if($linea =~ /URL/)
				{
					$inizio = index($linea , "URL")+4;
					$numero_lemma = substr($linea, $inizio,10);
					$numero_lemma =~ s/\D//gs;
		
				}
			}
		}
		else
		{
			$definizione="Ho trovato più di un lemma per $stringa\n";
			$inizio=index($numero_pagina, "Ricerca");
			$numero_pagina=substr($numero_pagina, $inizio);
			$inizio=index($numero_pagina, "<a href=\"http");
			$numero_pagina=substr($numero_pagina, 0, $inizio);
			$inizio=index($numero_pagina, "<table");
			$numero_pagina=substr($numero_pagina, $inizio);
			@lemmi = split /<\/td><\/tr>/, $numero_pagina;
			if(length($numero_lemma)>0)
			{
				foreach $lemma (@lemmi)
				{
					if($lemma =~ /<sup>$numero_lemma<\/sup>/)
					{
						$inizio=index($lemma, "href=")+5;
						$numero_lemma=substr($lemma, $inizio, 10);
						$numero_lemma =~ s/\D//gs;
					}
				}
			}
			else
			{
				foreach $lemma (@lemmi)
				{
					if($lemma =~/<sup>[0-9]<\/sup>/)
					{
						$inizio=index($lemma, "<sup>");
						$lemma=substr($lemma, $inizio);
						$lemma =~ s/&nbsp;/\ /g;
						$lemma =~ s/<[^<]*>/\ /g;
						#print $lemma."\n";
						$definizione=$lemma;
					}
				}
			}
	
		}
	}
	else
	{
		$definizione="Lemma $stringa non trovato\n";
	}
	
	if($numero_lemma)
	{
		$pagina=`curl http://www.demauroparavia.it/$numero_lemma | grep -a class=lemma`; 
		
		if(length($pagina)>1500)
		{
			$pagina=substr($pagina,0,1500);
			$cont=1;
		}
		@contenuto = split /<\/td><\/tr>/, $pagina;
		$pagina="";
		foreach $linea (@contenuto) {
			$linea =~ s/<\/td><\/tr>/\n/;
			$linea =~ s/&nbsp;/\ /g;
			$linea =~ s/<[^<]*>//g;
			if(length($linea)>0)
			{
				#print $linea."\n";
				$definizione=$linea
			}
		}
		if($cont)
		{
			$definizione="continua su http://www.demauroparavia.it/$numero_lemma\n";
		}
	}
	
	return $definizione;

}

1;
