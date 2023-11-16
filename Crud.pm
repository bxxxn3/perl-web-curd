package Crud;

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/";
use User;
use JSON;

use experimental qw( switch );
use Data::Dumper;
use 5.30.0;


my $sort_param;

sub new{
    my $class_name = shift;
    return bless({
        id => 0,
        age => 0,
        name => '',
    }, $class_name);

}

sub create_user {
    my ($name, $age) = @_;
    my $user = User->new();
    $user->{id}= 233;
    $user->{name}=$name;
    $user->{age}=$age;
    warn Dumper($user);
    return $user->write_db();
}


sub update_user {
    my ($id, $name,) = @_;
    my $user = User->new();
    $user->get_by_id($id);
    $user->{name}=$name;
}
 

sub delete_user {
    my $user = User->new();
    $user->get_by_id(shift);
    warn Dumper($user);
    return $user->delete();
}


# sub get_json {
#     my @jsonObjects;
#     foreach my $id (keys %user) {
#         my %json = (
#             id   => $user{$id}{id},
#             name => $user{$id}{name},
#             age  => $user{$id}{age}
#         );
#         push @jsonObjects, \%json;
#     }

#     open my $file, '>', 'user222.json' or die "Не удалось открыть файл: $!";
#     print $file to_json(\@jsonObjects);
#     close $file;
# }

# sub read_user {
#     given ($sort_param) {
#         {
#             when ('id:asc') {
#                 foreach $id (sort { lc $a <=> lc $b } keys %user) {
#                     printf("ID: %-5s Имя: %-20s Возраст: %s\n", $user{$id}{id}, $user{$id}{name}, $user{$id}{age});
#                 }
#             }
#             when ('id:desc') {
#                 foreach $id (reverse sort { lc $a <=> lc $b } keys %user) {
#                     printf("ID: %-5s Имя: %-20s Возраст: %s\n", $user{$id}{id}, $user{$id}{name}, $user{$id}{age});
#                 }
#             }
#             when ('name:asc') {
#                 foreach $id (sort { lc $user{$a}{name} cmp lc $user{$b}{name} } keys %user) {
#                     printf("ID: %-5s Имя: %-20s Возраст: %s\n", $user{$id}{id}, $user{$id}{name}, $user{$id}{age});
#                 }
#             }
#             when ('name:desc') {
#                 foreach $id (reverse sort { lc $user{$a}{name} cmp lc $user{$b}{name} } keys %user) {
#                     printf("ID: %-5s Имя: %-20s Возраст: %s\n", $user{$id}{id}, $user{$id}{name}, $user{$id}{age});
#                 }
#             }
#             when ('age:asc') {
#                 foreach $id (sort { lc $user{$a}{age} <=> lc $user{$b}{age} } keys %user) {
#                     printf("ID: %-5s Имя: %-20s Возраст: %s\n", $user{$id}{id}, $user{$id}{name}, $user{$id}{age});
#                 }
#             }
#             when ('age:desc') {
#                 foreach $id (reverse sort { lc $user{$a}{age} <=> lc $user{$b}{age} } keys %user) {
#                     printf("ID: %-5s Имя: %-20s Возраст: %s\n", $user{$id}{id}, $user{$id}{name}, $user{$id}{age});
#                 }
#             }
#             default {
#                 foreach $id (keys %user) {
#                     printf("ID: %-5s Имя: %-20s Возраст: %s\n", $user{$id}{id}, $user{$id}{name}, $user{$id}{age});
#                 }
#             };
#         }
#     }
# }

1;