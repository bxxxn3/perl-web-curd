package Crud;

use strict;
use warnings;
use JSON;
use experimental qw( switch );
use Data::Dumper;
use Storable;
use 5.30.0;

my $db = 'db.dat';
my %user;
my $id = 1;
my $sort_param;

sub new{
    my $class_name = shift;
    return bless({
        id => 0,
        age => 0,
        name => '',
    }, $class_name);
 
}

create_or_load_db();

sub create_user {
    my $id = 0;
    my ($name, $age) = @_;
    if (0 < $age && $age <= 150) {
        $id = generate_id();
        $id++;
        $user{$id} = {
            id        => $id,
            name      => $name,
            age       => $age
        };
        save_db();
        return 1;
    } else {
        return 0;
    }
}

sub create_user {
    my ($id, $name, $age) = @_;
    my $user = User->new();
    $user->{id}=$id;
    $user->{name}=$name;
    $user->{age}=$age;
    
}


sub update_user {
   my $user = User->new();
   $user->get_by_id(shift);
   $user->set_name(shift);
}
 

sub delete_user {
    my $user = User->new();
    $user->get_by_id(shift);
    return $user->delete();
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
        foreach my $id (keys %user){
            if ($id > $max_id){
                $max_id = $id;
            }
        }
        return $max_id;
}

sub get_json {
    my @jsonObjects;
    foreach my $id (keys %user) {
        my %json = (
            id   => $user{$id}{id},
            name => $user{$id}{name},
            age  => $user{$id}{age}
        );
        push @jsonObjects, \%json;
    }

    open my $file, '>', 'user1.json' or die "Не удалось открыть файл: $!";
    print $file to_json(\@jsonObjects);
    close $file;
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

1;