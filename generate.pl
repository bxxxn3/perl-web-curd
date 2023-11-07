#!/usr/bin/perl

use strict;
use warnings;


sub generate_random_user {
    my @first_names = qw(Иван Анна Михаил Сара Петр София Даниил Ольга Роберт Екатерина Давид Юлия Кирилл Мария Александр Лариса Константин Андрей Лаура Юрий Людмила Тимур Елена Григорий
        John Anna Michael Sara Peter Sophia Daniel Olivia Robert Emily David Jessica Kevin Melissa Matthew Jennifer Andrew Lauren Christopher Amanda Richard Megan Brandon Heather);
    my @last_names = qw(Иванова Смирнова Кузнецова Попов Соколова Лебедева Козлова Новикова Морозова Петрова Волкова Соловьева Васильева Зайцева Павлова Семенова Голубева Виноградова Беляева Котова Орлова Макарова Захарова Матвеева
        Doe Smith Johnson Davis Thompson Martin Wilson Brown Miller Taylor Clark Anderson Harris Baker Walker Jackson Mitchell Young Lewis Turner Scott);
    my $first_name = $first_names[rand @first_names];
    my $last_name = $last_names[rand @last_names];
    my $age = int(rand(50)) + 20; 
    return {
        first_name => $first_name,
        last_name => $last_name,
        age => $age
    };
}


sub add_user {
    my ($user) = @_;
    my $name = "$user->{first_name} $user->{last_name}";
    my $age = $user->{age};
    system("~/data/www/crud.pl --add --name=\"$name\" --age $age");
}

# Генерация пользователей
for (1..10) {
    my $user = generate_random_user();
    add_user($user);
}