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
    my ($self, $id) = @_;
    return 0 unless $id;


}

sub delete {
    my ($self, @id) = @_;
    $self->{deleted} = 1;
    return $self->store();
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


retrieve()
store()

1;



# my $user = Uesr->new();
# $user->get_by_id(15);
# $user->{age} = 