#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use FindBin;

use Getopt::Long;

use lib "$FindBin::Bin/";

use Crud;

my $crud = Crud->new();
$crud->update_user();


warn Dumper($crud);



exit;

my ($arg, $id, $user_name, $user_age, $sort_param, $data );

GetOptions(
    'add'           => sub { $arg = 'add' },
    'del'           => sub { $arg = 'del' },
    'upd'           => sub { $arg = 'upd' },
    'output'        => sub { $arg = 'output' },
    'help'          => sub { $arg = 'help' },
    'sort_param=s'  => \$sort_param,
    "name=s"        => \$user_name,
    "age=i"         => \$user_age,
    "id=i"          => \$id,
) or die "Недопустимые параметры командной строки\n";

my $result = '';
if ($arg eq 'add') {
    $result = Crud::add_user($user_name, $user_age);
} elsif ($arg eq 'del') {
    $result = Crud::delete_user($id);
} elsif ($arg eq 'upd') {
    $result = Crud::update_user($id, $user_name);
} elsif ($arg eq 'output') {
    $result = Crud::output_user($sort_param);
} elsif ($arg eq 'help') {
   $result = help();
} else {
    die "Некорректные параметры в команде. Для помощи используй ./crud_db.pl --help.\n";
}
print $result;

sub help {
    return 
    "Создание - ./crud_db.pl  --add —name=\"Ivan Ivanovich Ivanov\" --age 25 \n".
    "Удаление - ./crud_db.pl --del --id=;\n".
    "Обновить - ./crud_db.pl  --upd --name=\"New name\" --id= \n".
    "Вывод без сортировки - ./crud_db.pl --output\n".
    "Вывод с сортировкой - ./crud_db.pl --output --sort=\"[id/name/age/]:[asc/desc]\"\n";
}

