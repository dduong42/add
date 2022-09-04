.POSIX:
.SUFFIXES: .o .s

NAME=add
OBJS=print.o main.o
LD=ld
RM=rm -f

all: $(NAME)

.s.o:
	nasm -f elf64 -o $@ $<

$(NAME): $(OBJS)
	$(LD) -o $@ $(OBJS)

main.o: main.s

print.o: print.s

main.s: source
	./compile < $< > $@

clean:
	$(RM) $(OBJS)

fclean: clean
	$(RM) $(NAME)

re: clean all

container:
	docker build -t $(NAME):latest .

run: container
	docker run $(NAME):latest
