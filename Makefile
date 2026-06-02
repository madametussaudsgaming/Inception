# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rpadasia <ryanpadasian@gmail.com>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/06/02 17:45:58 by rpadasia          #+#    #+#              #
#    Updated: 2026/06/02 17:46:16 by rpadasia         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all: up

up:
	mkdir -p /home/rpadasia/data/mariadb
	mkdir -p /home/rpadasia/data/wordpress
	docker compose -f srcs/docker-compose.yml up -d --build

down:
	docker compose -f srcs/docker-compose.yml down

clean:
	docker compose -f srcs/docker-compose.yml down -v

fclean: clean
	docker system prune -af
	sudo rm -rf /home/rpadasia/data/

re: fclean all

.PHONY: all up down clean fclean re