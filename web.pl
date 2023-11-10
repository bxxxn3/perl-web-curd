use Mojolicious::Lite;
use Storable;
use Encode;
use Data::Dumper;
use FindBin;
use lib "$FindBin::Bin/";

use Crud;



my $global_link =$0;
$global_link =~ s#(\w|\.)+$##;
my $crud_link = $global_link.'crud.pl';
my $json_link = $global_link.'user1.json';
# warn Dumper($crud_link);
# warn Dumper($json_link);


get '/' => sub {
    my $c = shift;
    $c->redirect_to('/index');
};

get '/index' => sub {
    my $c = shift;
    $c->reply->static('index.html');
};



post '/add_user' => sub {
    my $c = shift;
    my $user_name = $c->param('user_name');
    my $user_age = $c->param('user_age');
    my $result = Crud::add_user($user_name, $user_age);
    if ($result > 0) {
        # $c->reply->static('index.html');
        $c->redirect_to('/index');
    }   
    else {
        $c->render(text => 'Запись не создана. Введите корректный возраст', status => 400);
    }
    
};

post '/delete_user' => sub {
    my $c = shift;
    my $user_id = $c->param('user_id');
    my $result = 
    if ($result > 0){
        $c->redirect_to('/index')
    }
    else{
        $c->render(text => ' Введите корректныe данные', status => 400);
    }
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
    my $aboba = '"'.$json_link.'"';
    warn Dumper($aboba);
    if (-e $json_link) {
         $c->res->headers->access_control_allow_origin('*');
         $c->res->headers->cache_control('private, max-age=1, no-cache');
         $c->reply->file($json_link);
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





