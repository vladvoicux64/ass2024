cmd_/home/vladvoicux64/ass2024/kmod/Module.symvers :=  sed 's/ko$$/o/'  /home/vladvoicux64/ass2024/kmod/modules.order | scripts/mod/modpost -m      -o /home/vladvoicux64/ass2024/kmod/Module.symvers -e -i Module.symvers -T - 
