use Mojolicious::Lite;
use Storable;
use Encode;
use Data::Dumper;

my $crud_link = '/home/programmer2/data/perl-web-crud/crud.pl';
my $json_link = '/home/programmer2/data/perl-web-crud/user.json';

get '/' => sub {
    my $c = shift;
    warn Dumper(app->static);
    $c->reply->static('index.html');
};

post '/add_user' => sub {
    my $c = shift;
    my $user_name = $c->param('user_name');
    my $user_age = $c->param('user_age');
    my $command = "$crud_link --add --name=\"$user_name\" --age $user_age ";
    my $result = qx($command);
    $result = decode('utf-8', $result);
    $result =~ s/\n/<br>/g;
    $c->render(text => $result);
};

post '/delete_user' => sub {
    my $c = shift;
    my $user_id = $c->param('user_id');
    my $command = "$crud_link --del --id=$user_id ";
    my $result = qx($command);
    $result = decode('utf-8', $result);
    $result =~ s/\n/<br>/g;
    $c->render(text => $result );
};

post '/update_user' => sub {
    my $c = shift;
    my $user_name = $c->param('user_name');
    my $user_id = $c->param('user_id');  
    my $command = "$crud_link --upd --name=\"$user_name\" --id=$user_id";
    my $result = qx($command);
    $result = decode('utf-8', $result);
    $result =~ s/\n/<br>/g;
    $c->render(text => $result );
};

post '/get_user' => sub {
    my $c = shift;
    my $sort_field = $c->param('sort_field');
    my $sort_type = $c->param('sort_type');
    my $ddd = '"'.$sort_field.':'.$sort_type.'"';
    my $command = $crud_link.' --output --sort='.$ddd;
    my $result = qx($command);
    $result = decode('utf-8', $result);
    $result =~ s/\n/<br>/g;
    $c->render(text => $result );
};

get '/get_json' => sub {
    my $c = shift;
    my $json_path = $json_link;
    if (-e $json_path) {
         $c->reply->file($json_path);
    } else {
         $c->render(text => 'Файл не найден', status => 404);
    }
};

 get '/help' => sub {
    my $c = shift;
    my $command = "$crud_link --help";
    my $result = qx($command); 
    $c->req->text;
    $result = decode('utf-8', $result);
    $result =~ s/\n/<br>/g;
    $c->render(text => $result );
};

app->start;





