CC = gcc
FLAGS = -W
OPTIONS = -g

OUT = bin

OBJDIR = objects
TESTDIR = test
FNCTTEST = Fnct_test

WORKDIR = sub1 sub2

MAINFILE = main
SRC = source
INC = include

TESTS = $(notdir $(foreach folder, $(WORKDIR), $(foreach elem, $(wildcard $(folder)/$(TESTDIR)/*.c), $(elem:.c=))))

$(OUT): $(MAINFILE) $(WORKDIR) run
	@$(CC) $(FLAGS) $(OPTIONS) -o $(OUT)/$(MAINFILE).exe $(OBJDIR)/$(MAINFILE).o $(foreach file, $(notdir $(wildcard $(foreach folder, $(WORKDIR), $(folder)/$(SRC)/*.c))), $(OBJDIR)/$(file:.c=.o))

$(MAINFILE): $(MAINFILE).c run
	@$(CC) $(FLAGS) $(OPTIONS) -o $(OBJDIR)/$(MAINFILE).o -c $(MAINFILE).c $(foreach folder, $(WORKDIR), -I $(folder)/$(INC))

$(WORKDIR): $(wildcard $(@)/$(SRC)/*.c) $(wildcard $(@)/$(INC)/*.h) run
	@for i in $(notdir $(foreach file, $(wildcard $(@)/$(SRC)/*.c), $(file))); do $(CC) $(FLAGS) $(OPTIONS) -o $(join $(OBJDIR)/, $${i%c}o) -c $(join $(@)/$(SRC)/, $$i) -I $(@)/$(INC); done

Alltest : $(TESTS) run
	@for i in $(foreach file, $(notdir $(foreach folder, $(WORKDIR), $(foreach elem, $(wildcard $(folder)/$(TESTDIR)/*.c), $(elem:.c=.exe)))), $(OUT)/$(file)); do $$i; done;

$(TESTS): $(FNCTTEST) $(WORKDIR) run
	@$(CC) $(FLAGS) $(OPTIONS) -o $(OBJDIR)/$(@).o -c $(filter %/$(@), $(foreach folder, $(WORKDIR), $(foreach elem, $(wildcard $(folder)/$(TESTDIR)/*.c), $(elem:.c=)))).c -I$(subst $(TESTDIR),$(INC), $(dir $(filter %/$(@), $(foreach folder, $(WORKDIR), $(foreach elem, $(wildcard $(folder)/$(TESTDIR)/*.c), $(elem:.c=)))))) -I $(FNCTTEST)/$(INC)
	@$(CC) $(FLAGS) $(OPTIONS) -o $(OUT)/$(@).exe $(foreach fileo, $(notdir $(foreach fileh, $(wildcard $(subst $(TESTDIR),$(INC), $(dir $(filter %/$(@), $(foreach folder, $(WORKDIR), $(foreach elem, $(wildcard $(folder)/$(TESTDIR)/*.c), $(elem:.c=))))))*.h), $(fileh:.h=.o))), $(OBJDIR)/$(fileo)) $(OBJDIR)/$(@).o $(OBJDIR)/$(FNCTTEST).o

$(FNCTTEST): run
	@$(CC) $(FLAGS) $(OPTIONS) -o $(OBJDIR)/$(@).o -c $(wildcard $(FNCTTEST)/$(SRC)/*.c) -I $(FNCTTEST)/$(INC)

run:

clean:
	rm $(wildcard $(OBJDIR)/*.o)