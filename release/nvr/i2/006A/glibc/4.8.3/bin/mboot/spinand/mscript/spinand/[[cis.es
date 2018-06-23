# <- this is for comment / total file size must be less than 4KB


tftp 0x21000000 SPINANDINFO.sni
tftp 0x21800000 PARTINFO.pni

writecis 0x21000000 0x21800000



#nand env.oob get



saveenv



% <- this is end of file symbol
