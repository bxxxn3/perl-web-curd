package User;

sub new {
    my $class_name = shift;
    return bless({
        id => undef,
        user_name => undef,
        age => undef,
        deleted => undef,
    }, $class_name);

}


sub get_by_id{

}

sub delete {
    my $self = shift;
    $self->{deleted} = 1;
    return $self->store();
}

retrieve()
store()

1;



# my $user = Uesr->new();
# $user->get_by_id(15);
# $user->{age} = 