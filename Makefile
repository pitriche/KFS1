src_path :=		src/
obj_path :=		obj/
kern_path :=	iso/boot/

src_files := \
header.asm \
main.asm

src :=			$(addprefix $(src_path), $(src_files))
obj :=			$(addprefix $(obj_path), $(src_files:.asm=.o))
kernel_bin :=	$(addprefix $(kern_path), kernel.bin)
kernel_iso :=	kernel.iso

# ##############################################################################

all : $(kernel_iso)

# create the bootable iso
$(kernel_iso): $(kernel_bin)
	grub-mkrescue -o $(kernel_iso) --compress=xz iso
# grub-mkrescue /usr/lib/grub/i386-pc -o $(kernel_iso) iso

# compile the kernel
$(kernel_bin): $(obj_path) $(obj)
	x86_64-elf-ld -n -o $(kernel_bin) -T linker.ld $(obj)

# create build directory
$(obj_path) :
	mkdir -p $(obj_path)

# build object files
obj/%.o : src/%.asm
	nasm -f elf64 $< -o $@

clean:
	rm -rf $(obj_path)

fclean: clean
	rm -rf $(kernel_iso) $(kernel_bin)

re: fclean all


.PHONY: all clean fclean re
