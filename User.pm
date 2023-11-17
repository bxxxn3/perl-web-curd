package User;

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/";
use Storable;
use Data::Dumper;

my $user_db = 'user_db.dat';
my $users = [];

if (-e $user_db) {
    _read_db();
} else {
    _write_db();
}

sub _read_db{
    $users = retrieve($user_db);

    for (my $i=0; $i < scalar @$users; $i++) {
        $users->[$i]{_id} = $i+1;
    }
};

sub _write_db{
    store($users, $user_db) or die "Не удалось сохранить: $!";
};

sub new {
    my $class_name = shift;
    return bless({
        _id => undef,
        name => undef,
        age => undef,
        deleted => undef,
    }, $class_name);
}

sub get_by_id{
    my ($self, $id) = @_;
    return 0 unless $id;
}

sub save {
    my $self = shift;
    _read_db();

    if (defined $self->{_id} && $users->[$self->{_id} - 1]) {

        $users->[$self->{_id} - 1] = {
            _id => $self->{_id},
            name => $self->{name},
            age => $self->{age},
            deleted => $self->{deleted},
        };
    } else {
        push (@$users, {
            _id => (scalar @$users)+1,
            name => $self->{name},
            age => $self->{age},
            deleted => $self->{deleted},
        });
    }
    _write_db();
    warn Dumper($users);
}

sub delete {
    my ($self, @id) = @_;
    $self->{deleted} = 1;
    _write_db();
}

1;



# my $user = Uesr->new();
# $user->get_by_id(15);
# $user->{age} =



# sub generate_id {
#     my $max_id = 1;
#     foreach my $id (keys @user){
#         if ($user{id} > $max_id){
#             $max_id = $user{id};
#         }
#     }
#     return $max_id++;
# }
