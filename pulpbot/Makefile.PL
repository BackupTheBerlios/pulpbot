use 5.008;
use ExtUtils::MakeMaker;
use strict;

WriteMakefile(
    'NAME' => 'PulpBot',
    'EXE_FILES' => [ 'bot' ],
    'PREREQ_PM' => { 'POE' => '0.29',
		     'POE::Component::IRC' => '2.9',
		     'HTTP::Request::Common' => '1.23',
		     'LWP::UserAgent' => '2.032',
		     'XML::Simple' => '2.12',
		   },
    'AUTHOR' => 'Coviello Giuseppe <slash@crux-it.org>, Stefano Esposito <yankeegohome@email.it>',
    'clean' => { FILES => '' },
);
