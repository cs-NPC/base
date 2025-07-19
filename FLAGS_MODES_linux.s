;FLAGS
%define O_RDONLY    0        ; open for reading only
%define O_WRONLY    1        ; open for writing only
%define O_RDWR      2        ; open for reading and writing
%define O_CREAT     0x40     ; create file if it does not exist
%define O_EXCL      0x80     ; error if O_CREAT and the file exists
%define O_NOCTTY    0x100    ; do not assign controlling terminal
%define O_TRUNC     0x200    ; truncate file to zero length
%define O_APPEND    0x400    ; append on each write
%define O_NONBLOCK  0x800    ; non-blocking mode
%define O_DSYNC     0x1000   ; write according to synchronized I/O data integrity completion
%define O_SYNC      0x101000 ; write according to synchronized I/O file integrity completion
%define O_RSYNC     0x401000 ; synchronized read I/O
%define O_DIRECTORY 0x20000  ; must be a directory
%define O_NOFOLLOW  0x40000  ; do not follow symbolic links
%define O_CLOEXEC   0x80000  ; set close-on-exec
;MODES
%define S_IRUSR     0o400   ; owner has read permission
%define S_IWUSR     0o200   ; owner has write permission
%define S_IXUSR     0o100   ; owner has execute permission
%define S_RWOGO     0O644   ; OWNER READ/WRITE  OTHER/GROUP READ
%define S_RWEVR     0o666   ; everyone read/write
%define S_RWEEVR    0o777   ; everyone read/write/execute
%define S_IRGRP     0o40    ; group has read permission
%define S_IWGRP     0o20    ; group has write permission
%define S_IXGRP     0o10    ; group has execute permission
%define S_IROTH     0o4     ; others have read permission
%define S_IWOTH     0o2     ; others have write permission
%define S_IXOTH     0o1     ; others have execute permission
;PROTECTION FLAGS
%define PROT_NONE   0x0
%define PROT_READ   0x1
%define PROT_WRITE  0x2
%define PROT_EXEC   0x4
;MAPPING FLAGS
%define MAP_SHARED    0x01
%define MAP_PRIVATE   0x02
%define MAP_FIXED     0x10
%define MAP_ANONYMOUS 0x20
;LSEEK WHENCE VALUE
%define SEEK_SET    0
%define SEEK_CUR    1
%define SEEK_END    2
;FD FOR FCNTL
%define FD_CLOEXEC  1    ; Close-on-exec flag
;STATUS FLAG FOR FCNTL
%define O_APPEND    0x400    ; Writes done at end of file
%define O_NONBLOCK  0x800    ; Non-blocking I/O
%define O_SYNC      0x101000 ; Synchronous writes
%define O_DSYNC     0x1000   ; Synchronous data writes
%define O_RSYNC     0x401000 ; Synchronous reads
;FCNTL COMMANDS
%define F_DUPFD     0      ; Duplicate file descriptor
%define F_GETFD     1      ; Get file descriptor flags
%define F_SETFD     2      ; Set file descriptor flags
%define F_GETFL     3      ; Get file status flags
%define F_SETFL     4      ; Set file status flags
;OPEN FLAGS
%define O_RDONLY    0        ; open for reading only
%define O_WRONLY    1        ; open for writing only
%define O_RDWR      2        ; open for reading and writing
%define O_CREAT     0x40     ; create file if it does not exist
%define O_TRUNC     0x200    ; truncate file to zero length
%define O_APPEND    0x400    ; append on each write
%define O_NONBLOCK  0x800    ; non-blocking mode
;STDIO FLAGS
%define STDIN   0
%define STDOUT  1
%define STDERR  2
