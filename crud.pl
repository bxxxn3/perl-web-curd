#!/usr/bin/env perl

use strict;
use warnings;
use Storable;
use Getopt::Long;
use Data::Dumper;
use 5.30.0;
# use Mojo::JSON qw( to_json);
use JSON;
use experimental qw( switch );

my $db = 'db.dat';
my %user;
my $id = 1;
my ($arg, $name, $age, $sort_param, $data);

create_or_load_db();

GetOptions(
    'add'           => sub { $arg = 'add' },
    'del'           => sub { $arg = 'del' },
    'upd'           => sub { $arg = 'upd' },
    'output'        => sub { $arg = 'output' },
    'help'          => sub { $arg = 'help' },
    'sort_param=s'  => \$sort_param,
    "name=s"        => \$name,
    "age=i"         => \$age,
    "id=i"          => \$id,
    # 'rights=s'    => \$rights,
    # 'settings=s'  => \$settings
) or die "Недопустимые параметры командной строки\n";
my $result = ' ';
if ($arg eq 'add') {
    $result = add_user($name, $age);
} elsif ($arg eq 'del') {
    $result = delete_user($id);
} elsif ($arg eq 'upd') {
    $result = update_user($id, $name);
} elsif ($arg eq 'help') {
    help();
} elsif ($arg eq 'output') {
    $result = output_user($sort_param);
} else {
    die "Некорректные параметры в команде. Для помощи используй ./crud_db.pl --help.\n";
}
print $result;


sub create_or_load_db {
    if (-e $db) {
        return load_db();
    } else {
        return create_db();
    }
}

sub create_db {
    my $data = { user => {}, id => 0 };
    store($data, $db) or die "Не удалось создать и сохранить базу данных: $!";
    return $data;
}


sub save_db {
    store({ user => \%user, id => $id }, $db) or die "Не удалось сохранить: $!";
    get_json(\%user);
}



sub load_db {
    if (-e $db) {
        my $data = retrieve($db);
        %user = %{ $data->{user} };
        $id = $data->{id};
        get_json(\%user);
        return $data;
    } else {
        die "Не удалось открыть: $!";
    }
}

# sub get_json {
#     my $jsonObj = shift;
#     my $json = to_json (\%user);
#     open my $file, '>', 'user.json' or die "Не удалось открыть файл: $!";
#     print $file $json;
#     close $file;
# }



sub get_json {
    my %json_gay;
    open my $file_gay, '>', 'user_gays.json' or die "Не удалось открыть файл: $!";
    foreach $id (keys %user){
        %json_gay = (
            id      =>      $user{$id}{id},
            name    =>      $user{$id}{name},
            age     =>      $user{$id}{age});
            my $json1 = to_json(\%json_gay);
            print $file_gay $json1;
            }
    close $file_gay;
}

sub add_user {
    my $id = 0;
    my ($name, $age, $rights, $settings) = @_;
    if (0 < $age && $age <= 150) {
        $id = generate_id();
        $id++;
        $user{$id} = {
            id        => $id,
            name      => $name,
            age       => $age
            # 'rights=s'   => \$rights,
            # 'settings=s' => \$settings
        };
        save_db();
        return "Запись создана.";
    } else {
        return "Нужно ввести реальный возраст.";
    }
}

sub delete_user {
    if (exists $user{$id}) {
        delete $user{$id};
        save_db();
        print "Запись удалена.\n";
    } else {
        print "Запись не найдена\n";
    }
}

sub update_user {
    my ($id, $name) = @_;
    if (exists $user{$id}) {
        $user{$id}->{name} = $name;
        save_db();
        print "\n";
    } else {
        print "Запись не найдена\n";
    }
}

sub output_user {
    given ($sort_param) {
        {
            when ('id:asc') {
                foreach $id (sort { lc $a <=> lc $b } keys %user) {
                    printf("ID: %-5s Имя: %-20s Возраст: %s\n", $user{$id}{id}, $user{$id}{name}, $user{$id}{age});
                }
            }
            when ('id:desc') {
                foreach $id (reverse sort { lc $a <=> lc $b } keys %user) {
                    printf("ID: %-5s Имя: %-20s Возраст: %s\n", $user{$id}{id}, $user{$id}{name}, $user{$id}{age});
                }
            }
            when ('name:asc') {
                foreach $id (sort { lc $user{$a}{name} cmp lc $user{$b}{name} } keys %user) {
                    printf("ID: %-5s Имя: %-20s Возраст: %s\n", $user{$id}{id}, $user{$id}{name}, $user{$id}{age});
                }
            }
            when ('name:desc') {
                foreach $id (reverse sort { lc $user{$a}{name} cmp lc $user{$b}{name} } keys %user) {
                    printf("ID: %-5s Имя: %-20s Возраст: %s\n", $user{$id}{id}, $user{$id}{name}, $user{$id}{age});
                }
            }
            when ('age:asc') {
                foreach $id (sort { lc $user{$a}{age} <=> lc $user{$b}{age} } keys %user) {
                    printf("ID: %-5s Имя: %-20s Возраст: %s\n", $user{$id}{id}, $user{$id}{name}, $user{$id}{age});
                }
            }
            when ('age:desc') {
                foreach $id (reverse sort { lc $user{$a}{age} <=> lc $user{$b}{age} } keys %user) {
                    printf("ID: %-5s Имя: %-20s Возраст: %s\n", $user{$id}{id}, $user{$id}{name}, $user{$id}{age});
                }
            }
            default {
                foreach $id (keys %user) {
                    printf("ID: %-5s Имя: %-20s Возраст: %s\n", $user{$id}{id}, $user{$id}{name}, $user{$id}{age});
                }
            };
        }
    }
}

sub generate_id {
     my $max_id = 0; 
        foreach $id (keys %user){
            if ($id > $max_id){
                $max_id = $id;
            }
        }
        return $max_id;
}

sub help {
    printf "Создание - ./crud_db.pl  --add —name=\"Ivan Ivanovich Ivanov\" --age 25 \n";
    printf "Удаление - ./crud_db.pl --del --id=;\n";
    printf "Обновить - ./crud_db.pl  --upd --name=\"New name\" --id= \n";
    printf "Вывод без сортировки - ./crud_db.pl --output\n";
    printf "Вывод с сортировкой - ./crud_db.pl --output --sort=\"[id/name/age/]:[asc/desc]\"\n";
}