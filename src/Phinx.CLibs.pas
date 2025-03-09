{===============================================================================
   ___ _    _
  | _ \ |_ (_)_ _ __ __™
  |  _/ ' \| | ' \\ \ /
  |_| |_||_|_|_||_/_\_\

  A High-Performance AI
  Inference Library for
     ONNX and Phi-4

 Copyright © 2025-present tinyBigGAMES™ LLC
 All Rights Reserved.

 https://github.com/tinyBigGAMES/Phinx

 See LICENSE file for license information
===============================================================================}

unit Phinx.CLibs;

{$I Phinx.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  WinApi.Windows;

const
  SQLITE_OMIT_LOAD_EXTENSION = 1;
  SQLITE_CORE = 1;
  SQLITE_ENABLE_COLUMN_METADATA = 1;
  SQLITE_VERSION = '3.49.1';
  SQLITE_VERSION_NUMBER = 3049001;
  SQLITE_SOURCE_ID = '2025-02-18 13:38:58 873d4e274b4988d260ba8354a9718324a1c26187a4ab4c1cc0227c03d0f10e70';
  SQLITE_OK = 0;
  SQLITE_ERROR = 1;
  SQLITE_INTERNAL = 2;
  SQLITE_PERM = 3;
  SQLITE_ABORT = 4;
  SQLITE_BUSY = 5;
  SQLITE_LOCKED = 6;
  SQLITE_NOMEM = 7;
  SQLITE_READONLY = 8;
  SQLITE_INTERRUPT = 9;
  SQLITE_IOERR = 10;
  SQLITE_CORRUPT = 11;
  SQLITE_NOTFOUND = 12;
  SQLITE_FULL = 13;
  SQLITE_CANTOPEN = 14;
  SQLITE_PROTOCOL = 15;
  SQLITE_EMPTY = 16;
  SQLITE_SCHEMA = 17;
  SQLITE_TOOBIG = 18;
  SQLITE_CONSTRAINT = 19;
  SQLITE_MISMATCH = 20;
  SQLITE_MISUSE = 21;
  SQLITE_NOLFS = 22;
  SQLITE_AUTH = 23;
  SQLITE_FORMAT = 24;
  SQLITE_RANGE = 25;
  SQLITE_NOTADB = 26;
  SQLITE_NOTICE = 27;
  SQLITE_WARNING = 28;
  SQLITE_ROW = 100;
  SQLITE_DONE = 101;
  SQLITE_ERROR_MISSING_COLLSEQ = (SQLITE_ERROR or (1 shl 8));
  SQLITE_ERROR_RETRY = (SQLITE_ERROR or (2 shl 8));
  SQLITE_ERROR_SNAPSHOT = (SQLITE_ERROR or (3 shl 8));
  SQLITE_IOERR_READ = (SQLITE_IOERR or (1 shl 8));
  SQLITE_IOERR_SHORT_READ = (SQLITE_IOERR or (2 shl 8));
  SQLITE_IOERR_WRITE = (SQLITE_IOERR or (3 shl 8));
  SQLITE_IOERR_FSYNC = (SQLITE_IOERR or (4 shl 8));
  SQLITE_IOERR_DIR_FSYNC = (SQLITE_IOERR or (5 shl 8));
  SQLITE_IOERR_TRUNCATE = (SQLITE_IOERR or (6 shl 8));
  SQLITE_IOERR_FSTAT = (SQLITE_IOERR or (7 shl 8));
  SQLITE_IOERR_UNLOCK = (SQLITE_IOERR or (8 shl 8));
  SQLITE_IOERR_RDLOCK = (SQLITE_IOERR or (9 shl 8));
  SQLITE_IOERR_DELETE = (SQLITE_IOERR or (10 shl 8));
  SQLITE_IOERR_BLOCKED = (SQLITE_IOERR or (11 shl 8));
  SQLITE_IOERR_NOMEM = (SQLITE_IOERR or (12 shl 8));
  SQLITE_IOERR_ACCESS = (SQLITE_IOERR or (13 shl 8));
  SQLITE_IOERR_CHECKRESERVEDLOCK = (SQLITE_IOERR or (14 shl 8));
  SQLITE_IOERR_LOCK = (SQLITE_IOERR or (15 shl 8));
  SQLITE_IOERR_CLOSE = (SQLITE_IOERR or (16 shl 8));
  SQLITE_IOERR_DIR_CLOSE = (SQLITE_IOERR or (17 shl 8));
  SQLITE_IOERR_SHMOPEN = (SQLITE_IOERR or (18 shl 8));
  SQLITE_IOERR_SHMSIZE = (SQLITE_IOERR or (19 shl 8));
  SQLITE_IOERR_SHMLOCK = (SQLITE_IOERR or (20 shl 8));
  SQLITE_IOERR_SHMMAP = (SQLITE_IOERR or (21 shl 8));
  SQLITE_IOERR_SEEK = (SQLITE_IOERR or (22 shl 8));
  SQLITE_IOERR_DELETE_NOENT = (SQLITE_IOERR or (23 shl 8));
  SQLITE_IOERR_MMAP = (SQLITE_IOERR or (24 shl 8));
  SQLITE_IOERR_GETTEMPPATH = (SQLITE_IOERR or (25 shl 8));
  SQLITE_IOERR_CONVPATH = (SQLITE_IOERR or (26 shl 8));
  SQLITE_IOERR_VNODE = (SQLITE_IOERR or (27 shl 8));
  SQLITE_IOERR_AUTH = (SQLITE_IOERR or (28 shl 8));
  SQLITE_IOERR_BEGIN_ATOMIC = (SQLITE_IOERR or (29 shl 8));
  SQLITE_IOERR_COMMIT_ATOMIC = (SQLITE_IOERR or (30 shl 8));
  SQLITE_IOERR_ROLLBACK_ATOMIC = (SQLITE_IOERR or (31 shl 8));
  SQLITE_IOERR_DATA = (SQLITE_IOERR or (32 shl 8));
  SQLITE_IOERR_CORRUPTFS = (SQLITE_IOERR or (33 shl 8));
  SQLITE_IOERR_IN_PAGE = (SQLITE_IOERR or (34 shl 8));
  SQLITE_LOCKED_SHAREDCACHE = (SQLITE_LOCKED or (1 shl 8));
  SQLITE_LOCKED_VTAB = (SQLITE_LOCKED or (2 shl 8));
  SQLITE_BUSY_RECOVERY = (SQLITE_BUSY or (1 shl 8));
  SQLITE_BUSY_SNAPSHOT = (SQLITE_BUSY or (2 shl 8));
  SQLITE_BUSY_TIMEOUT = (SQLITE_BUSY or (3 shl 8));
  SQLITE_CANTOPEN_NOTEMPDIR = (SQLITE_CANTOPEN or (1 shl 8));
  SQLITE_CANTOPEN_ISDIR = (SQLITE_CANTOPEN or (2 shl 8));
  SQLITE_CANTOPEN_FULLPATH = (SQLITE_CANTOPEN or (3 shl 8));
  SQLITE_CANTOPEN_CONVPATH = (SQLITE_CANTOPEN or (4 shl 8));
  SQLITE_CANTOPEN_DIRTYWAL = (SQLITE_CANTOPEN or (5 shl 8));
  SQLITE_CANTOPEN_SYMLINK = (SQLITE_CANTOPEN or (6 shl 8));
  SQLITE_CORRUPT_VTAB = (SQLITE_CORRUPT or (1 shl 8));
  SQLITE_CORRUPT_SEQUENCE = (SQLITE_CORRUPT or (2 shl 8));
  SQLITE_CORRUPT_INDEX = (SQLITE_CORRUPT or (3 shl 8));
  SQLITE_READONLY_RECOVERY = (SQLITE_READONLY or (1 shl 8));
  SQLITE_READONLY_CANTLOCK = (SQLITE_READONLY or (2 shl 8));
  SQLITE_READONLY_ROLLBACK = (SQLITE_READONLY or (3 shl 8));
  SQLITE_READONLY_DBMOVED = (SQLITE_READONLY or (4 shl 8));
  SQLITE_READONLY_CANTINIT = (SQLITE_READONLY or (5 shl 8));
  SQLITE_READONLY_DIRECTORY = (SQLITE_READONLY or (6 shl 8));
  SQLITE_ABORT_ROLLBACK = (SQLITE_ABORT or (2 shl 8));
  SQLITE_CONSTRAINT_CHECK = (SQLITE_CONSTRAINT or (1 shl 8));
  SQLITE_CONSTRAINT_COMMITHOOK = (SQLITE_CONSTRAINT or (2 shl 8));
  SQLITE_CONSTRAINT_FOREIGNKEY = (SQLITE_CONSTRAINT or (3 shl 8));
  SQLITE_CONSTRAINT_FUNCTION = (SQLITE_CONSTRAINT or (4 shl 8));
  SQLITE_CONSTRAINT_NOTNULL = (SQLITE_CONSTRAINT or (5 shl 8));
  SQLITE_CONSTRAINT_PRIMARYKEY = (SQLITE_CONSTRAINT or (6 shl 8));
  SQLITE_CONSTRAINT_TRIGGER = (SQLITE_CONSTRAINT or (7 shl 8));
  SQLITE_CONSTRAINT_UNIQUE = (SQLITE_CONSTRAINT or (8 shl 8));
  SQLITE_CONSTRAINT_VTAB = (SQLITE_CONSTRAINT or (9 shl 8));
  SQLITE_CONSTRAINT_ROWID = (SQLITE_CONSTRAINT or (10 shl 8));
  SQLITE_CONSTRAINT_PINNED = (SQLITE_CONSTRAINT or (11 shl 8));
  SQLITE_CONSTRAINT_DATATYPE = (SQLITE_CONSTRAINT or (12 shl 8));
  SQLITE_NOTICE_RECOVER_WAL = (SQLITE_NOTICE or (1 shl 8));
  SQLITE_NOTICE_RECOVER_ROLLBACK = (SQLITE_NOTICE or (2 shl 8));
  SQLITE_NOTICE_RBU = (SQLITE_NOTICE or (3 shl 8));
  SQLITE_WARNING_AUTOINDEX = (SQLITE_WARNING or (1 shl 8));
  SQLITE_AUTH_USER = (SQLITE_AUTH or (1 shl 8));
  SQLITE_OK_LOAD_PERMANENTLY = (SQLITE_OK or (1 shl 8));
  SQLITE_OK_SYMLINK = (SQLITE_OK or (2 shl 8));
  SQLITE_OPEN_READONLY = $00000001;
  SQLITE_OPEN_READWRITE = $00000002;
  SQLITE_OPEN_CREATE = $00000004;
  SQLITE_OPEN_DELETEONCLOSE = $00000008;
  SQLITE_OPEN_EXCLUSIVE = $00000010;
  SQLITE_OPEN_AUTOPROXY = $00000020;
  SQLITE_OPEN_URI = $00000040;
  SQLITE_OPEN_MEMORY = $00000080;
  SQLITE_OPEN_MAIN_DB = $00000100;
  SQLITE_OPEN_TEMP_DB = $00000200;
  SQLITE_OPEN_TRANSIENT_DB = $00000400;
  SQLITE_OPEN_MAIN_JOURNAL = $00000800;
  SQLITE_OPEN_TEMP_JOURNAL = $00001000;
  SQLITE_OPEN_SUBJOURNAL = $00002000;
  SQLITE_OPEN_SUPER_JOURNAL = $00004000;
  SQLITE_OPEN_NOMUTEX = $00008000;
  SQLITE_OPEN_FULLMUTEX = $00010000;
  SQLITE_OPEN_SHAREDCACHE = $00020000;
  SQLITE_OPEN_PRIVATECACHE = $00040000;
  SQLITE_OPEN_WAL = $00080000;
  SQLITE_OPEN_NOFOLLOW = $01000000;
  SQLITE_OPEN_EXRESCODE = $02000000;
  SQLITE_OPEN_MASTER_JOURNAL = $00004000;
  SQLITE_IOCAP_ATOMIC = $00000001;
  SQLITE_IOCAP_ATOMIC512 = $00000002;
  SQLITE_IOCAP_ATOMIC1K = $00000004;
  SQLITE_IOCAP_ATOMIC2K = $00000008;
  SQLITE_IOCAP_ATOMIC4K = $00000010;
  SQLITE_IOCAP_ATOMIC8K = $00000020;
  SQLITE_IOCAP_ATOMIC16K = $00000040;
  SQLITE_IOCAP_ATOMIC32K = $00000080;
  SQLITE_IOCAP_ATOMIC64K = $00000100;
  SQLITE_IOCAP_SAFE_APPEND = $00000200;
  SQLITE_IOCAP_SEQUENTIAL = $00000400;
  SQLITE_IOCAP_UNDELETABLE_WHEN_OPEN = $00000800;
  SQLITE_IOCAP_POWERSAFE_OVERWRITE = $00001000;
  SQLITE_IOCAP_IMMUTABLE = $00002000;
  SQLITE_IOCAP_BATCH_ATOMIC = $00004000;
  SQLITE_IOCAP_SUBPAGE_READ = $00008000;
  SQLITE_LOCK_NONE = 0;
  SQLITE_LOCK_SHARED = 1;
  SQLITE_LOCK_RESERVED = 2;
  SQLITE_LOCK_PENDING = 3;
  SQLITE_LOCK_EXCLUSIVE = 4;
  SQLITE_SYNC_NORMAL = $00002;
  SQLITE_SYNC_FULL = $00003;
  SQLITE_SYNC_DATAONLY = $00010;
  SQLITE_FCNTL_LOCKSTATE = 1;
  SQLITE_FCNTL_GET_LOCKPROXYFILE = 2;
  SQLITE_FCNTL_SET_LOCKPROXYFILE = 3;
  SQLITE_FCNTL_LAST_ERRNO = 4;
  SQLITE_FCNTL_SIZE_HINT = 5;
  SQLITE_FCNTL_CHUNK_SIZE = 6;
  SQLITE_FCNTL_FILE_POINTER = 7;
  SQLITE_FCNTL_SYNC_OMITTED = 8;
  SQLITE_FCNTL_WIN32_AV_RETRY = 9;
  SQLITE_FCNTL_PERSIST_WAL = 10;
  SQLITE_FCNTL_OVERWRITE = 11;
  SQLITE_FCNTL_VFSNAME = 12;
  SQLITE_FCNTL_POWERSAFE_OVERWRITE = 13;
  SQLITE_FCNTL_PRAGMA = 14;
  SQLITE_FCNTL_BUSYHANDLER = 15;
  SQLITE_FCNTL_TEMPFILENAME = 16;
  SQLITE_FCNTL_MMAP_SIZE = 18;
  SQLITE_FCNTL_TRACE = 19;
  SQLITE_FCNTL_HAS_MOVED = 20;
  SQLITE_FCNTL_SYNC = 21;
  SQLITE_FCNTL_COMMIT_PHASETWO = 22;
  SQLITE_FCNTL_WIN32_SET_HANDLE = 23;
  SQLITE_FCNTL_WAL_BLOCK = 24;
  SQLITE_FCNTL_ZIPVFS = 25;
  SQLITE_FCNTL_RBU = 26;
  SQLITE_FCNTL_VFS_POINTER = 27;
  SQLITE_FCNTL_JOURNAL_POINTER = 28;
  SQLITE_FCNTL_WIN32_GET_HANDLE = 29;
  SQLITE_FCNTL_PDB = 30;
  SQLITE_FCNTL_BEGIN_ATOMIC_WRITE = 31;
  SQLITE_FCNTL_COMMIT_ATOMIC_WRITE = 32;
  SQLITE_FCNTL_ROLLBACK_ATOMIC_WRITE = 33;
  SQLITE_FCNTL_LOCK_TIMEOUT = 34;
  SQLITE_FCNTL_DATA_VERSION = 35;
  SQLITE_FCNTL_SIZE_LIMIT = 36;
  SQLITE_FCNTL_CKPT_DONE = 37;
  SQLITE_FCNTL_RESERVE_BYTES = 38;
  SQLITE_FCNTL_CKPT_START = 39;
  SQLITE_FCNTL_EXTERNAL_READER = 40;
  SQLITE_FCNTL_CKSM_FILE = 41;
  SQLITE_FCNTL_RESET_CACHE = 42;
  SQLITE_FCNTL_NULL_IO = 43;
  SQLITE_GET_LOCKPROXYFILE = SQLITE_FCNTL_GET_LOCKPROXYFILE;
  SQLITE_SET_LOCKPROXYFILE = SQLITE_FCNTL_SET_LOCKPROXYFILE;
  SQLITE_LAST_ERRNO = SQLITE_FCNTL_LAST_ERRNO;
  SQLITE_ACCESS_EXISTS = 0;
  SQLITE_ACCESS_READWRITE = 1;
  SQLITE_ACCESS_READ = 2;
  SQLITE_SHM_UNLOCK = 1;
  SQLITE_SHM_LOCK = 2;
  SQLITE_SHM_SHARED = 4;
  SQLITE_SHM_EXCLUSIVE = 8;
  SQLITE_SHM_NLOCK = 8;
  SQLITE_CONFIG_SINGLETHREAD = 1;
  SQLITE_CONFIG_MULTITHREAD = 2;
  SQLITE_CONFIG_SERIALIZED = 3;
  SQLITE_CONFIG_MALLOC = 4;
  SQLITE_CONFIG_GETMALLOC = 5;
  SQLITE_CONFIG_SCRATCH = 6;
  SQLITE_CONFIG_PAGECACHE = 7;
  SQLITE_CONFIG_HEAP = 8;
  SQLITE_CONFIG_MEMSTATUS = 9;
  SQLITE_CONFIG_MUTEX = 10;
  SQLITE_CONFIG_GETMUTEX = 11;
  SQLITE_CONFIG_LOOKASIDE = 13;
  SQLITE_CONFIG_PCACHE = 14;
  SQLITE_CONFIG_GETPCACHE = 15;
  SQLITE_CONFIG_LOG = 16;
  SQLITE_CONFIG_URI = 17;
  SQLITE_CONFIG_PCACHE2 = 18;
  SQLITE_CONFIG_GETPCACHE2 = 19;
  SQLITE_CONFIG_COVERING_INDEX_SCAN = 20;
  SQLITE_CONFIG_SQLLOG = 21;
  SQLITE_CONFIG_MMAP_SIZE = 22;
  SQLITE_CONFIG_WIN32_HEAPSIZE = 23;
  SQLITE_CONFIG_PCACHE_HDRSZ = 24;
  SQLITE_CONFIG_PMASZ = 25;
  SQLITE_CONFIG_STMTJRNL_SPILL = 26;
  SQLITE_CONFIG_SMALL_MALLOC = 27;
  SQLITE_CONFIG_SORTERREF_SIZE = 28;
  SQLITE_CONFIG_MEMDB_MAXSIZE = 29;
  SQLITE_CONFIG_ROWID_IN_VIEW = 30;
  SQLITE_DBCONFIG_MAINDBNAME = 1000;
  SQLITE_DBCONFIG_LOOKASIDE = 1001;
  SQLITE_DBCONFIG_ENABLE_FKEY = 1002;
  SQLITE_DBCONFIG_ENABLE_TRIGGER = 1003;
  SQLITE_DBCONFIG_ENABLE_FTS3_TOKENIZER = 1004;
  SQLITE_DBCONFIG_ENABLE_LOAD_EXTENSION = 1005;
  SQLITE_DBCONFIG_NO_CKPT_ON_CLOSE = 1006;
  SQLITE_DBCONFIG_ENABLE_QPSG = 1007;
  SQLITE_DBCONFIG_TRIGGER_EQP = 1008;
  SQLITE_DBCONFIG_RESET_DATABASE = 1009;
  SQLITE_DBCONFIG_DEFENSIVE = 1010;
  SQLITE_DBCONFIG_WRITABLE_SCHEMA = 1011;
  SQLITE_DBCONFIG_LEGACY_ALTER_TABLE = 1012;
  SQLITE_DBCONFIG_DQS_DML = 1013;
  SQLITE_DBCONFIG_DQS_DDL = 1014;
  SQLITE_DBCONFIG_ENABLE_VIEW = 1015;
  SQLITE_DBCONFIG_LEGACY_FILE_FORMAT = 1016;
  SQLITE_DBCONFIG_TRUSTED_SCHEMA = 1017;
  SQLITE_DBCONFIG_STMT_SCANSTATUS = 1018;
  SQLITE_DBCONFIG_REVERSE_SCANORDER = 1019;
  SQLITE_DBCONFIG_ENABLE_ATTACH_CREATE = 1020;
  SQLITE_DBCONFIG_ENABLE_ATTACH_WRITE = 1021;
  SQLITE_DBCONFIG_ENABLE_COMMENTS = 1022;
  SQLITE_DBCONFIG_MAX = 1022;
  SQLITE_DENY = 1;
  SQLITE_IGNORE = 2;
  SQLITE_CREATE_INDEX = 1;
  SQLITE_CREATE_TABLE = 2;
  SQLITE_CREATE_TEMP_INDEX = 3;
  SQLITE_CREATE_TEMP_TABLE = 4;
  SQLITE_CREATE_TEMP_TRIGGER = 5;
  SQLITE_CREATE_TEMP_VIEW = 6;
  SQLITE_CREATE_TRIGGER = 7;
  SQLITE_CREATE_VIEW = 8;
  SQLITE_DELETE = 9;
  SQLITE_DROP_INDEX = 10;
  SQLITE_DROP_TABLE = 11;
  SQLITE_DROP_TEMP_INDEX = 12;
  SQLITE_DROP_TEMP_TABLE = 13;
  SQLITE_DROP_TEMP_TRIGGER = 14;
  SQLITE_DROP_TEMP_VIEW = 15;
  SQLITE_DROP_TRIGGER = 16;
  SQLITE_DROP_VIEW = 17;
  SQLITE_INSERT = 18;
  SQLITE_PRAGMA = 19;
  SQLITE_READ = 20;
  SQLITE_SELECT = 21;
  SQLITE_TRANSACTION = 22;
  SQLITE_UPDATE = 23;
  SQLITE_ATTACH = 24;
  SQLITE_DETACH = 25;
  SQLITE_ALTER_TABLE = 26;
  SQLITE_REINDEX = 27;
  SQLITE_ANALYZE = 28;
  SQLITE_CREATE_VTABLE = 29;
  SQLITE_DROP_VTABLE = 30;
  SQLITE_FUNCTION = 31;
  SQLITE_SAVEPOINT = 32;
  SQLITE_COPY = 0;
  SQLITE_RECURSIVE = 33;
  SQLITE_TRACE_STMT = $01;
  SQLITE_TRACE_PROFILE = $02;
  SQLITE_TRACE_ROW = $04;
  SQLITE_TRACE_CLOSE = $08;
  SQLITE_LIMIT_LENGTH = 0;
  SQLITE_LIMIT_SQL_LENGTH = 1;
  SQLITE_LIMIT_COLUMN = 2;
  SQLITE_LIMIT_EXPR_DEPTH = 3;
  SQLITE_LIMIT_COMPOUND_SELECT = 4;
  SQLITE_LIMIT_VDBE_OP = 5;
  SQLITE_LIMIT_FUNCTION_ARG = 6;
  SQLITE_LIMIT_ATTACHED = 7;
  SQLITE_LIMIT_LIKE_PATTERN_LENGTH = 8;
  SQLITE_LIMIT_VARIABLE_NUMBER = 9;
  SQLITE_LIMIT_TRIGGER_DEPTH = 10;
  SQLITE_LIMIT_WORKER_THREADS = 11;
  SQLITE_PREPARE_PERSISTENT = $01;
  SQLITE_PREPARE_NORMALIZE = $02;
  SQLITE_PREPARE_NO_VTAB = $04;
  SQLITE_PREPARE_DONT_LOG = $10;
  SQLITE_INTEGER = 1;
  SQLITE_FLOAT = 2;
  SQLITE_BLOB = 4;
  SQLITE_NULL = 5;
  SQLITE_TEXT = 3;
  SQLITE3_TEXT = 3;
  SQLITE_UTF8 = 1;
  SQLITE_UTF16LE = 2;
  SQLITE_UTF16BE = 3;
  SQLITE_UTF16 = 4;
  SQLITE_ANY = 5;
  SQLITE_UTF16_ALIGNED = 8;
  SQLITE_DETERMINISTIC = $000000800;
  SQLITE_DIRECTONLY = $000080000;
  SQLITE_SUBTYPE = $000100000;
  SQLITE_INNOCUOUS = $000200000;
  SQLITE_RESULT_SUBTYPE = $001000000;
  SQLITE_SELFORDER1 = $002000000;
  SQLITE_WIN32_DATA_DIRECTORY_TYPE = 1;
  SQLITE_WIN32_TEMP_DIRECTORY_TYPE = 2;
  SQLITE_TXN_NONE = 0;
  SQLITE_TXN_READ = 1;
  SQLITE_TXN_WRITE = 2;
  SQLITE_INDEX_SCAN_UNIQUE = $00000001;
  SQLITE_INDEX_SCAN_HEX = $00000002;
  SQLITE_INDEX_CONSTRAINT_EQ = 2;
  SQLITE_INDEX_CONSTRAINT_GT = 4;
  SQLITE_INDEX_CONSTRAINT_LE = 8;
  SQLITE_INDEX_CONSTRAINT_LT = 16;
  SQLITE_INDEX_CONSTRAINT_GE = 32;
  SQLITE_INDEX_CONSTRAINT_MATCH = 64;
  SQLITE_INDEX_CONSTRAINT_LIKE = 65;
  SQLITE_INDEX_CONSTRAINT_GLOB = 66;
  SQLITE_INDEX_CONSTRAINT_REGEXP = 67;
  SQLITE_INDEX_CONSTRAINT_NE = 68;
  SQLITE_INDEX_CONSTRAINT_ISNOT = 69;
  SQLITE_INDEX_CONSTRAINT_ISNOTNULL = 70;
  SQLITE_INDEX_CONSTRAINT_ISNULL = 71;
  SQLITE_INDEX_CONSTRAINT_IS = 72;
  SQLITE_INDEX_CONSTRAINT_LIMIT = 73;
  SQLITE_INDEX_CONSTRAINT_OFFSET = 74;
  SQLITE_INDEX_CONSTRAINT_FUNCTION = 150;
  SQLITE_MUTEX_FAST = 0;
  SQLITE_MUTEX_RECURSIVE = 1;
  SQLITE_MUTEX_STATIC_MAIN = 2;
  SQLITE_MUTEX_STATIC_MEM = 3;
  SQLITE_MUTEX_STATIC_MEM2 = 4;
  SQLITE_MUTEX_STATIC_OPEN = 4;
  SQLITE_MUTEX_STATIC_PRNG = 5;
  SQLITE_MUTEX_STATIC_LRU = 6;
  SQLITE_MUTEX_STATIC_LRU2 = 7;
  SQLITE_MUTEX_STATIC_PMEM = 7;
  SQLITE_MUTEX_STATIC_APP1 = 8;
  SQLITE_MUTEX_STATIC_APP2 = 9;
  SQLITE_MUTEX_STATIC_APP3 = 10;
  SQLITE_MUTEX_STATIC_VFS1 = 11;
  SQLITE_MUTEX_STATIC_VFS2 = 12;
  SQLITE_MUTEX_STATIC_VFS3 = 13;
  SQLITE_MUTEX_STATIC_MASTER = 2;
  SQLITE_TESTCTRL_FIRST = 5;
  SQLITE_TESTCTRL_PRNG_SAVE = 5;
  SQLITE_TESTCTRL_PRNG_RESTORE = 6;
  SQLITE_TESTCTRL_PRNG_RESET = 7;
  SQLITE_TESTCTRL_FK_NO_ACTION = 7;
  SQLITE_TESTCTRL_BITVEC_TEST = 8;
  SQLITE_TESTCTRL_FAULT_INSTALL = 9;
  SQLITE_TESTCTRL_BENIGN_MALLOC_HOOKS = 10;
  SQLITE_TESTCTRL_PENDING_BYTE = 11;
  SQLITE_TESTCTRL_ASSERT = 12;
  SQLITE_TESTCTRL_ALWAYS = 13;
  SQLITE_TESTCTRL_RESERVE = 14;
  SQLITE_TESTCTRL_JSON_SELFCHECK = 14;
  SQLITE_TESTCTRL_OPTIMIZATIONS = 15;
  SQLITE_TESTCTRL_ISKEYWORD = 16;
  SQLITE_TESTCTRL_GETOPT = 16;
  SQLITE_TESTCTRL_SCRATCHMALLOC = 17;
  SQLITE_TESTCTRL_INTERNAL_FUNCTIONS = 17;
  SQLITE_TESTCTRL_LOCALTIME_FAULT = 18;
  SQLITE_TESTCTRL_EXPLAIN_STMT = 19;
  SQLITE_TESTCTRL_ONCE_RESET_THRESHOLD = 19;
  SQLITE_TESTCTRL_NEVER_CORRUPT = 20;
  SQLITE_TESTCTRL_VDBE_COVERAGE = 21;
  SQLITE_TESTCTRL_BYTEORDER = 22;
  SQLITE_TESTCTRL_ISINIT = 23;
  SQLITE_TESTCTRL_SORTER_MMAP = 24;
  SQLITE_TESTCTRL_IMPOSTER = 25;
  SQLITE_TESTCTRL_PARSER_COVERAGE = 26;
  SQLITE_TESTCTRL_RESULT_INTREAL = 27;
  SQLITE_TESTCTRL_PRNG_SEED = 28;
  SQLITE_TESTCTRL_EXTRA_SCHEMA_CHECKS = 29;
  SQLITE_TESTCTRL_SEEK_COUNT = 30;
  SQLITE_TESTCTRL_TRACEFLAGS = 31;
  SQLITE_TESTCTRL_TUNE = 32;
  SQLITE_TESTCTRL_LOGEST = 33;
  SQLITE_TESTCTRL_USELONGDOUBLE = 34;
  SQLITE_TESTCTRL_LAST = 34;
  SQLITE_STATUS_MEMORY_USED = 0;
  SQLITE_STATUS_PAGECACHE_USED = 1;
  SQLITE_STATUS_PAGECACHE_OVERFLOW = 2;
  SQLITE_STATUS_SCRATCH_USED = 3;
  SQLITE_STATUS_SCRATCH_OVERFLOW = 4;
  SQLITE_STATUS_MALLOC_SIZE = 5;
  SQLITE_STATUS_PARSER_STACK = 6;
  SQLITE_STATUS_PAGECACHE_SIZE = 7;
  SQLITE_STATUS_SCRATCH_SIZE = 8;
  SQLITE_STATUS_MALLOC_COUNT = 9;
  SQLITE_DBSTATUS_LOOKASIDE_USED = 0;
  SQLITE_DBSTATUS_CACHE_USED = 1;
  SQLITE_DBSTATUS_SCHEMA_USED = 2;
  SQLITE_DBSTATUS_STMT_USED = 3;
  SQLITE_DBSTATUS_LOOKASIDE_HIT = 4;
  SQLITE_DBSTATUS_LOOKASIDE_MISS_SIZE = 5;
  SQLITE_DBSTATUS_LOOKASIDE_MISS_FULL = 6;
  SQLITE_DBSTATUS_CACHE_HIT = 7;
  SQLITE_DBSTATUS_CACHE_MISS = 8;
  SQLITE_DBSTATUS_CACHE_WRITE = 9;
  SQLITE_DBSTATUS_DEFERRED_FKS = 10;
  SQLITE_DBSTATUS_CACHE_USED_SHARED = 11;
  SQLITE_DBSTATUS_CACHE_SPILL = 12;
  SQLITE_DBSTATUS_MAX = 12;
  SQLITE_STMTSTATUS_FULLSCAN_STEP = 1;
  SQLITE_STMTSTATUS_SORT = 2;
  SQLITE_STMTSTATUS_AUTOINDEX = 3;
  SQLITE_STMTSTATUS_VM_STEP = 4;
  SQLITE_STMTSTATUS_REPREPARE = 5;
  SQLITE_STMTSTATUS_RUN = 6;
  SQLITE_STMTSTATUS_FILTER_MISS = 7;
  SQLITE_STMTSTATUS_FILTER_HIT = 8;
  SQLITE_STMTSTATUS_MEMUSED = 99;
  SQLITE_CHECKPOINT_PASSIVE = 0;
  SQLITE_CHECKPOINT_FULL = 1;
  SQLITE_CHECKPOINT_RESTART = 2;
  SQLITE_CHECKPOINT_TRUNCATE = 3;
  SQLITE_VTAB_CONSTRAINT_SUPPORT = 1;
  SQLITE_VTAB_INNOCUOUS = 2;
  SQLITE_VTAB_DIRECTONLY = 3;
  SQLITE_VTAB_USES_ALL_SCHEMAS = 4;
  SQLITE_ROLLBACK = 1;
  SQLITE_FAIL = 3;
  SQLITE_REPLACE = 5;
  SQLITE_SCANSTAT_NLOOP = 0;
  SQLITE_SCANSTAT_NVISIT = 1;
  SQLITE_SCANSTAT_EST = 2;
  SQLITE_SCANSTAT_NAME = 3;
  SQLITE_SCANSTAT_EXPLAIN = 4;
  SQLITE_SCANSTAT_SELECTID = 5;
  SQLITE_SCANSTAT_PARENTID = 6;
  SQLITE_SCANSTAT_NCYCLE = 7;
  SQLITE_SCANSTAT_COMPLEX = $0001;
  SQLITE_SERIALIZE_NOCOPY = $001;
  SQLITE_DESERIALIZE_FREEONCLOSE = 1;
  SQLITE_DESERIALIZE_RESIZEABLE = 2;
  SQLITE_DESERIALIZE_READONLY = 4;
  NOT_WITHIN = 0;
  PARTLY_WITHIN = 1;
  FULLY_WITHIN = 2;
  FTS5_TOKENIZE_QUERY = $0001;
  FTS5_TOKENIZE_PREFIX = $0002;
  FTS5_TOKENIZE_DOCUMENT = $0004;
  FTS5_TOKENIZE_AUX = $0008;
  FTS5_TOKEN_COLOCATED = $0001;

type
  OgaElementType = Integer;
  POgaElementType = ^OgaElementType;

const
  OgaElementType_undefined = 0;
  OgaElementType_float32 = 1;
  OgaElementType_uint8 = 2;
  OgaElementType_int8 = 3;
  OgaElementType_uint16 = 4;
  OgaElementType_int16 = 5;
  OgaElementType_int32 = 6;
  OgaElementType_int64 = 7;
  OgaElementType_string = 8;
  OgaElementType_bool = 9;
  OgaElementType_float16 = 10;
  OgaElementType_float64 = 11;
  OgaElementType_uint32 = 12;
  OgaElementType_uint64 = 13;
  OgaElementType_complex64 = 14;
  OgaElementType_complex128 = 15;
  OgaElementType_bfloat16 = 16;

type
  // Forward declarations
  PPUTF8Char = ^PUTF8Char;
  PPPUTF8Char = ^PPUTF8Char;
  PInt32 = ^Int32;
  PPInt32 = ^PInt32;
  PNativeUInt = ^NativeUInt;
  PInt64 = ^Int64;
  Psqlite3_file = ^sqlite3_file;
  Psqlite3_io_methods = ^sqlite3_io_methods;
  Psqlite3_vfs = ^sqlite3_vfs;
  Psqlite3_mem_methods = ^sqlite3_mem_methods;
  Psqlite3_module = ^sqlite3_module;
  Psqlite3_index_constraint = ^sqlite3_index_constraint;
  Psqlite3_index_orderby = ^sqlite3_index_orderby;
  Psqlite3_index_constraint_usage = ^sqlite3_index_constraint_usage;
  Psqlite3_index_info = ^sqlite3_index_info;
  Psqlite3_vtab = ^sqlite3_vtab;
  PPsqlite3_vtab = ^Psqlite3_vtab;
  Psqlite3_vtab_cursor = ^sqlite3_vtab_cursor;
  PPsqlite3_vtab_cursor = ^Psqlite3_vtab_cursor;
  Psqlite3_mutex_methods = ^sqlite3_mutex_methods;
  Psqlite3_pcache_page = ^sqlite3_pcache_page;
  Psqlite3_pcache_methods2 = ^sqlite3_pcache_methods2;
  Psqlite3_pcache_methods = ^sqlite3_pcache_methods;
  Psqlite3_snapshot = ^sqlite3_snapshot;
  PPsqlite3_snapshot = ^Psqlite3_snapshot;
  Psqlite3_rtree_geometry = ^sqlite3_rtree_geometry;
  Psqlite3_rtree_query_info = ^sqlite3_rtree_query_info;
  PFts5PhraseIter = ^Fts5PhraseIter;
  PFts5ExtensionApi = ^Fts5ExtensionApi;
  Pfts5_tokenizer_v2 = ^fts5_tokenizer_v2;
  PPfts5_tokenizer_v2 = ^Pfts5_tokenizer_v2;
  Pfts5_tokenizer = ^fts5_tokenizer;
  Pfts5_api = ^fts5_api;
  Psqlite3_api_routines = ^sqlite3_api_routines;

  POgaResult = Pointer;
  PPOgaResult = ^POgaResult;
  POgaGeneratorParams = Pointer;
  PPOgaGeneratorParams = ^POgaGeneratorParams;
  POgaGenerator = Pointer;
  PPOgaGenerator = ^POgaGenerator;
  POgaRuntimeSettings = Pointer;
  PPOgaRuntimeSettings = ^POgaRuntimeSettings;
  POgaConfig = Pointer;
  PPOgaConfig = ^POgaConfig;
  POgaModel = Pointer;
  PPOgaModel = ^POgaModel;
  POgaSequences = Pointer;
  PPOgaSequences = ^POgaSequences;
  POgaTokenizer = Pointer;
  PPOgaTokenizer = ^POgaTokenizer;
  POgaTokenizerStream = Pointer;
  PPOgaTokenizerStream = ^POgaTokenizerStream;
  POgaTensor = Pointer;
  PPOgaTensor = ^POgaTensor;
  POgaImages = Pointer;
  PPOgaImages = ^POgaImages;
  POgaNamedTensors = Pointer;
  PPOgaNamedTensors = ^POgaNamedTensors;
  POgaMultiModalProcessor = Pointer;
  PPOgaMultiModalProcessor = ^POgaMultiModalProcessor;
  POgaAudios = Pointer;
  PPOgaAudios = ^POgaAudios;
  POgaStringArray = Pointer;
  PPOgaStringArray = ^POgaStringArray;
  POgaAdapters = Pointer;
  PPOgaAdapters = ^POgaAdapters;
  Psqlite3 = Pointer;
  PPsqlite3 = ^Psqlite3;
  sqlite_int64 = Int64;
  sqlite_uint64 = UInt64;
  sqlite3_int64 = sqlite_int64;
  Psqlite3_int64 = ^sqlite3_int64;
  sqlite3_uint64 = sqlite_uint64;

  sqlite3_callback = function(p1: Pointer; p2: Integer; p3: PPUTF8Char; p4: PPUTF8Char): Integer; cdecl;

  sqlite3_file = record
    pMethods: Psqlite3_io_methods;
  end;

  sqlite3_io_methods = record
    iVersion: Integer;
    xClose: function(p1: Psqlite3_file): Integer; cdecl;
    xRead: function(p1: Psqlite3_file; p2: Pointer; iAmt: Integer; iOfst: sqlite3_int64): Integer; cdecl;
    xWrite: function(p1: Psqlite3_file; const p2: Pointer; iAmt: Integer; iOfst: sqlite3_int64): Integer; cdecl;
    xTruncate: function(p1: Psqlite3_file; size: sqlite3_int64): Integer; cdecl;
    xSync: function(p1: Psqlite3_file; flags: Integer): Integer; cdecl;
    xFileSize: function(p1: Psqlite3_file; pSize: Psqlite3_int64): Integer; cdecl;
    xLock: function(p1: Psqlite3_file; p2: Integer): Integer; cdecl;
    xUnlock: function(p1: Psqlite3_file; p2: Integer): Integer; cdecl;
    xCheckReservedLock: function(p1: Psqlite3_file; pResOut: PInteger): Integer; cdecl;
    xFileControl: function(p1: Psqlite3_file; op: Integer; pArg: Pointer): Integer; cdecl;
    xSectorSize: function(p1: Psqlite3_file): Integer; cdecl;
    xDeviceCharacteristics: function(p1: Psqlite3_file): Integer; cdecl;
    xShmMap: function(p1: Psqlite3_file; iPg: Integer; pgsz: Integer; p4: Integer; p5: PPointer): Integer; cdecl;
    xShmLock: function(p1: Psqlite3_file; offset: Integer; n: Integer; flags: Integer): Integer; cdecl;
    xShmBarrier: procedure(p1: Psqlite3_file); cdecl;
    xShmUnmap: function(p1: Psqlite3_file; deleteFlag: Integer): Integer; cdecl;
    xFetch: function(p1: Psqlite3_file; iOfst: sqlite3_int64; iAmt: Integer; pp: PPointer): Integer; cdecl;
    xUnfetch: function(p1: Psqlite3_file; iOfst: sqlite3_int64; p: Pointer): Integer; cdecl;
  end;

  Psqlite3_mutex = Pointer;
  PPsqlite3_mutex = ^Psqlite3_mutex;
  sqlite3_filename = PUTF8Char;

  sqlite3_syscall_ptr = procedure(); cdecl;

  Pvoid = Pointer;
  sqlite3_vfs = record
    iVersion: Integer;
    szOsFile: Integer;
    mxPathname: Integer;
    pNext: Psqlite3_vfs;
    zName: PUTF8Char;
    pAppData: Pointer;
    xOpen: function(p1: Psqlite3_vfs; zName: sqlite3_filename; p3: Psqlite3_file; flags: Integer; pOutFlags: PInteger): Integer; cdecl;
    xDelete: function(p1: Psqlite3_vfs; const zName: PUTF8Char; syncDir: Integer): Integer; cdecl;
    xAccess: function(p1: Psqlite3_vfs; const zName: PUTF8Char; flags: Integer; pResOut: PInteger): Integer; cdecl;
    xFullPathname: function(p1: Psqlite3_vfs; const zName: PUTF8Char; nOut: Integer; zOut: PUTF8Char): Integer; cdecl;
    xDlOpen: function(p1: Psqlite3_vfs; const zFilename: PUTF8Char): Pointer; cdecl;
    xDlError: procedure(p1: Psqlite3_vfs; nByte: Integer; zErrMsg: PUTF8Char); cdecl;
    xDlSym: function(p1: Psqlite3_vfs; p2: Pointer; const zSymbol: PUTF8Char): Pvoid; cdecl;
    xDlClose: procedure(p1: Psqlite3_vfs; p2: Pointer); cdecl;
    xRandomness: function(p1: Psqlite3_vfs; nByte: Integer; zOut: PUTF8Char): Integer; cdecl;
    xSleep: function(p1: Psqlite3_vfs; microseconds: Integer): Integer; cdecl;
    xCurrentTime: function(p1: Psqlite3_vfs; p2: PDouble): Integer; cdecl;
    xGetLastError: function(p1: Psqlite3_vfs; p2: Integer; p3: PUTF8Char): Integer; cdecl;
    xCurrentTimeInt64: function(p1: Psqlite3_vfs; p2: Psqlite3_int64): Integer; cdecl;
    xSetSystemCall: function(p1: Psqlite3_vfs; const zName: PUTF8Char; p3: sqlite3_syscall_ptr): Integer; cdecl;
    xGetSystemCall: function(p1: Psqlite3_vfs; const zName: PUTF8Char): sqlite3_syscall_ptr; cdecl;
    xNextSystemCall: function(p1: Psqlite3_vfs; const zName: PUTF8Char): PUTF8Char; cdecl;
  end;

  sqlite3_mem_methods = record
    xMalloc: function(p1: Integer): Pointer; cdecl;
    xFree: procedure(p1: Pointer); cdecl;
    xRealloc: function(p1: Pointer; p2: Integer): Pointer; cdecl;
    xSize: function(p1: Pointer): Integer; cdecl;
    xRoundup: function(p1: Integer): Integer; cdecl;
    xInit: function(p1: Pointer): Integer; cdecl;
    xShutdown: procedure(p1: Pointer); cdecl;
    pAppData: Pointer;
  end;

  Psqlite3_stmt = Pointer;
  PPsqlite3_stmt = ^Psqlite3_stmt;
  Psqlite3_value = Pointer;
  PPsqlite3_value = ^Psqlite3_value;
  Psqlite3_context = Pointer;
  PPsqlite3_context = ^Psqlite3_context;

  sqlite3_destructor_type = procedure(p1: Pointer); cdecl;

  PPvoid = ^Pvoid;
  TpxFunc = procedure(pCtx: Psqlite3_context; n: Integer; apVal: PPsqlite3_value);
  sqlite3_module = record
    iVersion: Integer;
    xCreate: function(p1: Psqlite3; pAux: Pointer; argc: Integer; const argv: PPUTF8Char; ppVTab: PPsqlite3_vtab; p6: PPUTF8Char): Integer; cdecl;
    xConnect: function(p1: Psqlite3; pAux: Pointer; argc: Integer; const argv: PPUTF8Char; ppVTab: PPsqlite3_vtab; p6: PPUTF8Char): Integer; cdecl;
    xBestIndex: function(pVTab: Psqlite3_vtab; p2: Psqlite3_index_info): Integer; cdecl;
    xDisconnect: function(pVTab: Psqlite3_vtab): Integer; cdecl;
    xDestroy: function(pVTab: Psqlite3_vtab): Integer; cdecl;
    xOpen: function(pVTab: Psqlite3_vtab; ppCursor: PPsqlite3_vtab_cursor): Integer; cdecl;
    xClose: function(p1: Psqlite3_vtab_cursor): Integer; cdecl;
    xFilter: function(p1: Psqlite3_vtab_cursor; idxNum: Integer; const idxStr: PUTF8Char; argc: Integer; argv: PPsqlite3_value): Integer; cdecl;
    xNext: function(p1: Psqlite3_vtab_cursor): Integer; cdecl;
    xEof: function(p1: Psqlite3_vtab_cursor): Integer; cdecl;
    xColumn: function(p1: Psqlite3_vtab_cursor; p2: Psqlite3_context; p3: Integer): Integer; cdecl;
    xRowid: function(p1: Psqlite3_vtab_cursor; pRowid: Psqlite3_int64): Integer; cdecl;
    xUpdate: function(p1: Psqlite3_vtab; p2: Integer; p3: PPsqlite3_value; p4: Psqlite3_int64): Integer; cdecl;
    xBegin: function(pVTab: Psqlite3_vtab): Integer; cdecl;
    xSync: function(pVTab: Psqlite3_vtab): Integer; cdecl;
    xCommit: function(pVTab: Psqlite3_vtab): Integer; cdecl;
    xRollback: function(pVTab: Psqlite3_vtab): Integer; cdecl;
    xFindFunction: function(pVtab: Psqlite3_vtab; nArg: Integer; zName: PAnsiChar; var pxFunc: TpxFunc; var ppArg: Pointer): Integer; cdecl;
    xRename: function(pVtab: Psqlite3_vtab; const zNew: PUTF8Char): Integer; cdecl;
    xSavepoint: function(pVTab: Psqlite3_vtab; p2: Integer): Integer; cdecl;
    xRelease: function(pVTab: Psqlite3_vtab; p2: Integer): Integer; cdecl;
    xRollbackTo: function(pVTab: Psqlite3_vtab; p2: Integer): Integer; cdecl;
    xShadowName: function(const p1: PUTF8Char): Integer; cdecl;
    xIntegrity: function(pVTab: Psqlite3_vtab; const zSchema: PUTF8Char; const zTabName: PUTF8Char; mFlags: Integer; pzErr: PPUTF8Char): Integer; cdecl;
  end;

  sqlite3_index_constraint = record
    iColumn: Integer;
    op: Byte;
    usable: Byte;
    iTermOffset: Integer;
  end;

  sqlite3_index_orderby = record
    iColumn: Integer;
    desc: Byte;
  end;

  sqlite3_index_constraint_usage = record
    argvIndex: Integer;
    omit: Byte;
  end;

  sqlite3_index_info = record
    nConstraint: Integer;
    aConstraint: Psqlite3_index_constraint;
    nOrderBy: Integer;
    aOrderBy: Psqlite3_index_orderby;
    aConstraintUsage: Psqlite3_index_constraint_usage;
    idxNum: Integer;
    idxStr: PUTF8Char;
    needToFreeIdxStr: Integer;
    orderByConsumed: Integer;
    estimatedCost: Double;
    estimatedRows: sqlite3_int64;
    idxFlags: Integer;
    colUsed: sqlite3_uint64;
  end;

  sqlite3_vtab = record
    pModule: Psqlite3_module;
    nRef: Integer;
    zErrMsg: PUTF8Char;
  end;

  sqlite3_vtab_cursor = record
    pVtab: Psqlite3_vtab;
  end;

  Psqlite3_blob = Pointer;
  PPsqlite3_blob = ^Psqlite3_blob;

  sqlite3_mutex_methods = record
    xMutexInit: function(): Integer; cdecl;
    xMutexEnd: function(): Integer; cdecl;
    xMutexAlloc: function(p1: Integer): Psqlite3_mutex; cdecl;
    xMutexFree: procedure(p1: Psqlite3_mutex); cdecl;
    xMutexEnter: procedure(p1: Psqlite3_mutex); cdecl;
    xMutexTry: function(p1: Psqlite3_mutex): Integer; cdecl;
    xMutexLeave: procedure(p1: Psqlite3_mutex); cdecl;
    xMutexHeld: function(p1: Psqlite3_mutex): Integer; cdecl;
    xMutexNotheld: function(p1: Psqlite3_mutex): Integer; cdecl;
  end;

  Psqlite3_str = Pointer;
  PPsqlite3_str = ^Psqlite3_str;
  Psqlite3_pcache = Pointer;
  PPsqlite3_pcache = ^Psqlite3_pcache;

  sqlite3_pcache_page = record
    pBuf: Pointer;
    pExtra: Pointer;
  end;

  sqlite3_pcache_methods2 = record
    iVersion: Integer;
    pArg: Pointer;
    xInit: function(p1: Pointer): Integer; cdecl;
    xShutdown: procedure(p1: Pointer); cdecl;
    xCreate: function(szPage: Integer; szExtra: Integer; bPurgeable: Integer): Psqlite3_pcache; cdecl;
    xCachesize: procedure(p1: Psqlite3_pcache; nCachesize: Integer); cdecl;
    xPagecount: function(p1: Psqlite3_pcache): Integer; cdecl;
    xFetch: function(p1: Psqlite3_pcache; key: Cardinal; createFlag: Integer): Psqlite3_pcache_page; cdecl;
    xUnpin: procedure(p1: Psqlite3_pcache; p2: Psqlite3_pcache_page; discard: Integer); cdecl;
    xRekey: procedure(p1: Psqlite3_pcache; p2: Psqlite3_pcache_page; oldKey: Cardinal; newKey: Cardinal); cdecl;
    xTruncate: procedure(p1: Psqlite3_pcache; iLimit: Cardinal); cdecl;
    xDestroy: procedure(p1: Psqlite3_pcache); cdecl;
    xShrink: procedure(p1: Psqlite3_pcache); cdecl;
  end;

  sqlite3_pcache_methods = record
    pArg: Pointer;
    xInit: function(p1: Pointer): Integer; cdecl;
    xShutdown: procedure(p1: Pointer); cdecl;
    xCreate: function(szPage: Integer; bPurgeable: Integer): Psqlite3_pcache; cdecl;
    xCachesize: procedure(p1: Psqlite3_pcache; nCachesize: Integer); cdecl;
    xPagecount: function(p1: Psqlite3_pcache): Integer; cdecl;
    xFetch: function(p1: Psqlite3_pcache; key: Cardinal; createFlag: Integer): Pointer; cdecl;
    xUnpin: procedure(p1: Psqlite3_pcache; p2: Pointer; discard: Integer); cdecl;
    xRekey: procedure(p1: Psqlite3_pcache; p2: Pointer; oldKey: Cardinal; newKey: Cardinal); cdecl;
    xTruncate: procedure(p1: Psqlite3_pcache; iLimit: Cardinal); cdecl;
    xDestroy: procedure(p1: Psqlite3_pcache); cdecl;
  end;

  Psqlite3_backup = Pointer;
  PPsqlite3_backup = ^Psqlite3_backup;

  sqlite3_snapshot = record
    hidden: array [0..47] of Byte;
  end;

  sqlite3_rtree_dbl = Double;
  Psqlite3_rtree_dbl = ^sqlite3_rtree_dbl;

  sqlite3_rtree_geometry = record
    pContext: Pointer;
    nParam: Integer;
    aParam: Psqlite3_rtree_dbl;
    pUser: Pointer;
    xDelUser: procedure(p1: Pointer); cdecl;
  end;

  sqlite3_rtree_query_info = record
    pContext: Pointer;
    nParam: Integer;
    aParam: Psqlite3_rtree_dbl;
    pUser: Pointer;
    xDelUser: procedure(p1: Pointer); cdecl;
    aCoord: Psqlite3_rtree_dbl;
    anQueue: PCardinal;
    nCoord: Integer;
    iLevel: Integer;
    mxLevel: Integer;
    iRowid: sqlite3_int64;
    rParentScore: sqlite3_rtree_dbl;
    eParentWithin: Integer;
    eWithin: Integer;
    rScore: sqlite3_rtree_dbl;
    apSqlParam: PPsqlite3_value;
  end;

  PFts5Context = Pointer;
  PPFts5Context = ^PFts5Context;

  fts5_extension_function = procedure(const pApi: PFts5ExtensionApi; pFts: PFts5Context; pCtx: Psqlite3_context; nVal: Integer; apVal: PPsqlite3_value); cdecl;

  Fts5PhraseIter = record
    a: PByte;
    b: PByte;
  end;

  Fts5ExtensionApi = record
    iVersion: Integer;
    xUserData: function(p1: PFts5Context): Pointer; cdecl;
    xColumnCount: function(p1: PFts5Context): Integer; cdecl;
    xRowCount: function(p1: PFts5Context; pnRow: Psqlite3_int64): Integer; cdecl;
    xColumnTotalSize: function(p1: PFts5Context; iCol: Integer; pnToken: Psqlite3_int64): Integer; cdecl;
    xTokenize: function(p1: PFts5Context; const pText: PUTF8Char; nText: Integer; pCtx: Pointer; xToken: Pointer): Integer; cdecl;
    xPhraseCount: function(p1: PFts5Context): Integer; cdecl;
    xPhraseSize: function(p1: PFts5Context; iPhrase: Integer): Integer; cdecl;
    xInstCount: function(p1: PFts5Context; pnInst: PInteger): Integer; cdecl;
    xInst: function(p1: PFts5Context; iIdx: Integer; piPhrase: PInteger; piCol: PInteger; piOff: PInteger): Integer; cdecl;
    xRowid: function(p1: PFts5Context): sqlite3_int64; cdecl;
    xColumnText: function(p1: PFts5Context; iCol: Integer; pz: PPUTF8Char; pn: PInteger): Integer; cdecl;
    xColumnSize: function(p1: PFts5Context; iCol: Integer; pnToken: PInteger): Integer; cdecl;
    xQueryPhrase: function(p1: PFts5Context; iPhrase: Integer; pUserData: Pointer; p4: Pointer): Integer; cdecl;
    xSetAuxdata: function(p1: PFts5Context; pAux: Pointer; xDelete: Pointer): Integer; cdecl;
    xGetAuxdata: function(p1: PFts5Context; bClear: Integer): Pointer; cdecl;
    xPhraseFirst: function(p1: PFts5Context; iPhrase: Integer; p3: PFts5PhraseIter; p4: PInteger; p5: PInteger): Integer; cdecl;
    xPhraseNext: procedure(p1: PFts5Context; p2: PFts5PhraseIter; piCol: PInteger; piOff: PInteger); cdecl;
    xPhraseFirstColumn: function(p1: PFts5Context; iPhrase: Integer; p3: PFts5PhraseIter; p4: PInteger): Integer; cdecl;
    xPhraseNextColumn: procedure(p1: PFts5Context; p2: PFts5PhraseIter; piCol: PInteger); cdecl;
    xQueryToken: function(p1: PFts5Context; iPhrase: Integer; iToken: Integer; ppToken: PPUTF8Char; pnToken: PInteger): Integer; cdecl;
    xInstToken: function(p1: PFts5Context; iIdx: Integer; iToken: Integer; p4: PPUTF8Char; p5: PInteger): Integer; cdecl;
    xColumnLocale: function(p1: PFts5Context; iCol: Integer; pz: PPUTF8Char; pn: PInteger): Integer; cdecl;
    xTokenize_v2: function(p1: PFts5Context; const pText: PUTF8Char; nText: Integer; const pLocale: PUTF8Char; nLocale: Integer; pCtx: Pointer; xToken: Pointer): Integer; cdecl;
  end;

  PFts5Tokenizer = Pointer;
  PPFts5Tokenizer = ^PFts5Tokenizer;

  fts5_tokenizer_v2 = record
    iVersion: Integer;
    xCreate: function(p1: Pointer; azArg: PPUTF8Char; nArg: Integer; ppOut: PPFts5Tokenizer): Integer; cdecl;
    xDelete: procedure(p1: PFts5Tokenizer); cdecl;
    xTokenize: function(p1: PFts5Tokenizer; pCtx: Pointer; flags: Integer; const pText: PUTF8Char; nText: Integer; const pLocale: PUTF8Char; nLocale: Integer; xToken: Pointer): Integer; cdecl;
  end;

  fts5_tokenizer = record
    xCreate: function(p1: Pointer; azArg: PPUTF8Char; nArg: Integer; ppOut: PPFts5Tokenizer): Integer; cdecl;
    xDelete: procedure(p1: PFts5Tokenizer); cdecl;
    xTokenize: function(p1: PFts5Tokenizer; pCtx: Pointer; flags: Integer; const pText: PUTF8Char; nText: Integer; xToken: Pointer): Integer; cdecl;
  end;

  fts5_api = record
    iVersion: Integer;
    xCreateTokenizer: function(pApi: Pfts5_api; const zName: PUTF8Char; pUserData: Pointer; pTokenizer: Pfts5_tokenizer; xDestroy: Pointer): Integer; cdecl;
    xFindTokenizer: function(pApi: Pfts5_api; const zName: PUTF8Char; ppUserData: PPointer; pTokenizer: Pfts5_tokenizer): Integer; cdecl;
    xCreateFunction: function(pApi: Pfts5_api; const zName: PUTF8Char; pUserData: Pointer; xFunction: fts5_extension_function; xDestroy: Pointer): Integer; cdecl;
    xCreateTokenizer_v2: function(pApi: Pfts5_api; const zName: PUTF8Char; pUserData: Pointer; pTokenizer: Pfts5_tokenizer_v2; xDestroy: Pointer): Integer; cdecl;
    xFindTokenizer_v2: function(pApi: Pfts5_api; const zName: PUTF8Char; ppUserData: PPointer; ppTokenizer: PPfts5_tokenizer_v2): Integer; cdecl;
  end;

  sqlite3_api_routines = record
    aggregate_context: function(p1: Psqlite3_context; nBytes: Integer): Pointer; cdecl;
    aggregate_count: function(p1: Psqlite3_context): Integer; cdecl;
    bind_blob: function(p1: Psqlite3_stmt; p2: Integer; const p3: Pointer; n: Integer; p5: Pointer): Integer; cdecl;
    bind_double: function(p1: Psqlite3_stmt; p2: Integer; p3: Double): Integer; cdecl;
    bind_int: function(p1: Psqlite3_stmt; p2: Integer; p3: Integer): Integer; cdecl;
    bind_int64: function(p1: Psqlite3_stmt; p2: Integer; p3: sqlite_int64): Integer; cdecl;
    bind_null: function(p1: Psqlite3_stmt; p2: Integer): Integer; cdecl;
    bind_parameter_count: function(p1: Psqlite3_stmt): Integer; cdecl;
    bind_parameter_index: function(p1: Psqlite3_stmt; const zName: PUTF8Char): Integer; cdecl;
    bind_parameter_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
    bind_text: function(p1: Psqlite3_stmt; p2: Integer; const p3: PUTF8Char; n: Integer; p5: Pointer): Integer; cdecl;
    bind_text16: function(p1: Psqlite3_stmt; p2: Integer; const p3: Pointer; p4: Integer; p5: Pointer): Integer; cdecl;
    bind_value: function(p1: Psqlite3_stmt; p2: Integer; const p3: Psqlite3_value): Integer; cdecl;
    busy_handler: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Integer; cdecl;
    busy_timeout: function(p1: Psqlite3; ms: Integer): Integer; cdecl;
    changes: function(p1: Psqlite3): Integer; cdecl;
    close: function(p1: Psqlite3): Integer; cdecl;
    collation_needed: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Integer; cdecl;
    collation_needed16: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Integer; cdecl;
    column_blob: function(p1: Psqlite3_stmt; iCol: Integer): Pointer; cdecl;
    column_bytes: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
    column_bytes16: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
    column_count: function(pStmt: Psqlite3_stmt): Integer; cdecl;
    column_database_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
    column_database_name16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
    column_decltype: function(p1: Psqlite3_stmt; i: Integer): PUTF8Char; cdecl;
    column_decltype16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
    column_double: function(p1: Psqlite3_stmt; iCol: Integer): Double; cdecl;
    column_int: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
    column_int64: function(p1: Psqlite3_stmt; iCol: Integer): sqlite_int64; cdecl;
    column_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
    column_name16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
    column_origin_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
    column_origin_name16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
    column_table_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
    column_table_name16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
    column_text: function(p1: Psqlite3_stmt; iCol: Integer): PByte; cdecl;
    column_text16: function(p1: Psqlite3_stmt; iCol: Integer): Pointer; cdecl;
    column_type: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
    column_value: function(p1: Psqlite3_stmt; iCol: Integer): Psqlite3_value; cdecl;
    commit_hook: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Pointer; cdecl;
    complete: function(const sql: PUTF8Char): Integer; cdecl;
    complete16: function(const sql: Pointer): Integer; cdecl;
    create_collation: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: Pointer; p5: Pointer): Integer; cdecl;
    create_collation16: function(p1: Psqlite3; const p2: Pointer; p3: Integer; p4: Pointer; p5: Pointer): Integer; cdecl;
    create_function: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: Integer; p5: Pointer; xFunc: Pointer; xStep: Pointer; xFinal: Pointer): Integer; cdecl;
    create_function16: function(p1: Psqlite3; const p2: Pointer; p3: Integer; p4: Integer; p5: Pointer; xFunc: Pointer; xStep: Pointer; xFinal: Pointer): Integer; cdecl;
    create_module: function(p1: Psqlite3; const p2: PUTF8Char; const p3: Psqlite3_module; p4: Pointer): Integer; cdecl;
    data_count: function(pStmt: Psqlite3_stmt): Integer; cdecl;
    db_handle: function(p1: Psqlite3_stmt): Psqlite3; cdecl;
    declare_vtab: function(p1: Psqlite3; const p2: PUTF8Char): Integer; cdecl;
    enable_shared_cache: function(p1: Integer): Integer; cdecl;
    errcode: function(db: Psqlite3): Integer; cdecl;
    errmsg: function(p1: Psqlite3): PUTF8Char; cdecl;
    errmsg16: function(p1: Psqlite3): Pointer; cdecl;
    exec: function(p1: Psqlite3; const p2: PUTF8Char; p3: sqlite3_callback; p4: Pointer; p5: PPUTF8Char): Integer; cdecl;
    expired: function(p1: Psqlite3_stmt): Integer; cdecl;
    finalize: function(pStmt: Psqlite3_stmt): Integer; cdecl;
    free: procedure(p1: Pointer); cdecl;
    free_table: procedure(result: PPUTF8Char); cdecl;
    get_autocommit: function(p1: Psqlite3): Integer; cdecl;
    get_auxdata: function(p1: Psqlite3_context; p2: Integer): Pointer; cdecl;
    get_table: function(p1: Psqlite3; const p2: PUTF8Char; p3: PPPUTF8Char; p4: PInteger; p5: PInteger; p6: PPUTF8Char): Integer; cdecl;
    global_recover: function(): Integer; cdecl;
    interruptx: procedure(p1: Psqlite3); cdecl;
    last_insert_rowid: function(p1: Psqlite3): sqlite_int64; cdecl;
    libversion: function(): PUTF8Char; cdecl;
    libversion_number: function(): Integer; cdecl;
    malloc: function(p1: Integer): Pointer; cdecl;
    mprintf: function(const p1: PUTF8Char): PUTF8Char varargs; cdecl;
    open: function(const p1: PUTF8Char; p2: PPsqlite3): Integer; cdecl;
    open16: function(const p1: Pointer; p2: PPsqlite3): Integer; cdecl;
    prepare: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: PPsqlite3_stmt; p5: PPUTF8Char): Integer; cdecl;
    prepare16: function(p1: Psqlite3; const p2: Pointer; p3: Integer; p4: PPsqlite3_stmt; p5: PPointer): Integer; cdecl;
    profile: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Pointer; cdecl;
    progress_handler: procedure(p1: Psqlite3; p2: Integer; p3: Pointer; p4: Pointer); cdecl;
    realloc: function(p1: Pointer; p2: Integer): Pointer; cdecl;
    reset: function(pStmt: Psqlite3_stmt): Integer; cdecl;
    result_blob: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: Pointer); cdecl;
    result_double: procedure(p1: Psqlite3_context; p2: Double); cdecl;
    result_error: procedure(p1: Psqlite3_context; const p2: PUTF8Char; p3: Integer); cdecl;
    result_error16: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer); cdecl;
    result_int: procedure(p1: Psqlite3_context; p2: Integer); cdecl;
    result_int64: procedure(p1: Psqlite3_context; p2: sqlite_int64); cdecl;
    result_null: procedure(p1: Psqlite3_context); cdecl;
    result_text: procedure(p1: Psqlite3_context; const p2: PUTF8Char; p3: Integer; p4: Pointer); cdecl;
    result_text16: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: Pointer); cdecl;
    result_text16be: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: Pointer); cdecl;
    result_text16le: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: Pointer); cdecl;
    result_value: procedure(p1: Psqlite3_context; p2: Psqlite3_value); cdecl;
    rollback_hook: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Pointer; cdecl;
    set_authorizer: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Integer; cdecl;
    set_auxdata: procedure(p1: Psqlite3_context; p2: Integer; p3: Pointer; p4: Pointer); cdecl;
    xsnprintf: function(p1: Integer; p2: PUTF8Char; const p3: PUTF8Char): PUTF8Char varargs; cdecl;
    step: function(p1: Psqlite3_stmt): Integer; cdecl;
    table_column_metadata: function(p1: Psqlite3; const p2: PUTF8Char; const p3: PUTF8Char; const p4: PUTF8Char; p5: PPUTF8Char; p6: PPUTF8Char; p7: PInteger; p8: PInteger; p9: PInteger): Integer; cdecl;
    thread_cleanup: procedure(); cdecl;
    total_changes: function(p1: Psqlite3): Integer; cdecl;
    trace: function(p1: Psqlite3; xTrace: Pointer; p3: Pointer): Pointer; cdecl;
    transfer_bindings: function(p1: Psqlite3_stmt; p2: Psqlite3_stmt): Integer; cdecl;
    update_hook: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Pointer; cdecl;
    user_data: function(p1: Psqlite3_context): Pointer; cdecl;
    value_blob: function(p1: Psqlite3_value): Pointer; cdecl;
    value_bytes: function(p1: Psqlite3_value): Integer; cdecl;
    value_bytes16: function(p1: Psqlite3_value): Integer; cdecl;
    value_double: function(p1: Psqlite3_value): Double; cdecl;
    value_int: function(p1: Psqlite3_value): Integer; cdecl;
    value_int64: function(p1: Psqlite3_value): sqlite_int64; cdecl;
    value_numeric_type: function(p1: Psqlite3_value): Integer; cdecl;
    value_text: function(p1: Psqlite3_value): PByte; cdecl;
    value_text16: function(p1: Psqlite3_value): Pointer; cdecl;
    value_text16be: function(p1: Psqlite3_value): Pointer; cdecl;
    value_text16le: function(p1: Psqlite3_value): Pointer; cdecl;
    value_type: function(p1: Psqlite3_value): Integer; cdecl;
    vmprintf: function(const p1: PUTF8Char; p2: Pointer): PUTF8Char; cdecl;
    overload_function: function(p1: Psqlite3; const zFuncName: PUTF8Char; nArg: Integer): Integer; cdecl;
    prepare_v2: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: PPsqlite3_stmt; p5: PPUTF8Char): Integer; cdecl;
    prepare16_v2: function(p1: Psqlite3; const p2: Pointer; p3: Integer; p4: PPsqlite3_stmt; p5: PPointer): Integer; cdecl;
    clear_bindings: function(p1: Psqlite3_stmt): Integer; cdecl;
    create_module_v2: function(p1: Psqlite3; const p2: PUTF8Char; const p3: Psqlite3_module; p4: Pointer; xDestroy: Pointer): Integer; cdecl;
    bind_zeroblob: function(p1: Psqlite3_stmt; p2: Integer; p3: Integer): Integer; cdecl;
    blob_bytes: function(p1: Psqlite3_blob): Integer; cdecl;
    blob_close: function(p1: Psqlite3_blob): Integer; cdecl;
    blob_open: function(p1: Psqlite3; const p2: PUTF8Char; const p3: PUTF8Char; const p4: PUTF8Char; p5: sqlite3_int64; p6: Integer; p7: PPsqlite3_blob): Integer; cdecl;
    blob_read: function(p1: Psqlite3_blob; p2: Pointer; p3: Integer; p4: Integer): Integer; cdecl;
    blob_write: function(p1: Psqlite3_blob; const p2: Pointer; p3: Integer; p4: Integer): Integer; cdecl;
    create_collation_v2: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: Pointer; p5: Pointer; p6: Pointer): Integer; cdecl;
    file_control: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: Pointer): Integer; cdecl;
    memory_highwater: function(p1: Integer): sqlite3_int64; cdecl;
    memory_used: function(): sqlite3_int64; cdecl;
    mutex_alloc: function(p1: Integer): Psqlite3_mutex; cdecl;
    mutex_enter: procedure(p1: Psqlite3_mutex); cdecl;
    mutex_free: procedure(p1: Psqlite3_mutex); cdecl;
    mutex_leave: procedure(p1: Psqlite3_mutex); cdecl;
    mutex_try: function(p1: Psqlite3_mutex): Integer; cdecl;
    open_v2: function(const p1: PUTF8Char; p2: PPsqlite3; p3: Integer; const p4: PUTF8Char): Integer; cdecl;
    release_memory: function(p1: Integer): Integer; cdecl;
    result_error_nomem: procedure(p1: Psqlite3_context); cdecl;
    result_error_toobig: procedure(p1: Psqlite3_context); cdecl;
    sleep: function(p1: Integer): Integer; cdecl;
    soft_heap_limit: procedure(p1: Integer); cdecl;
    vfs_find: function(const p1: PUTF8Char): Psqlite3_vfs; cdecl;
    vfs_register: function(p1: Psqlite3_vfs; p2: Integer): Integer; cdecl;
    vfs_unregister: function(p1: Psqlite3_vfs): Integer; cdecl;
    xthreadsafe: function(): Integer; cdecl;
    result_zeroblob: procedure(p1: Psqlite3_context; p2: Integer); cdecl;
    result_error_code: procedure(p1: Psqlite3_context; p2: Integer); cdecl;
    test_control: function(p1: Integer): Integer varargs; cdecl;
    randomness: procedure(p1: Integer; p2: Pointer); cdecl;
    context_db_handle: function(p1: Psqlite3_context): Psqlite3; cdecl;
    extended_result_codes: function(p1: Psqlite3; p2: Integer): Integer; cdecl;
    limit: function(p1: Psqlite3; p2: Integer; p3: Integer): Integer; cdecl;
    next_stmt: function(p1: Psqlite3; p2: Psqlite3_stmt): Psqlite3_stmt; cdecl;
    sql: function(p1: Psqlite3_stmt): PUTF8Char; cdecl;
    status: function(p1: Integer; p2: PInteger; p3: PInteger; p4: Integer): Integer; cdecl;
    backup_finish: function(p1: Psqlite3_backup): Integer; cdecl;
    backup_init: function(p1: Psqlite3; const p2: PUTF8Char; p3: Psqlite3; const p4: PUTF8Char): Psqlite3_backup; cdecl;
    backup_pagecount: function(p1: Psqlite3_backup): Integer; cdecl;
    backup_remaining: function(p1: Psqlite3_backup): Integer; cdecl;
    backup_step: function(p1: Psqlite3_backup; p2: Integer): Integer; cdecl;
    compileoption_get: function(p1: Integer): PUTF8Char; cdecl;
    compileoption_used: function(const p1: PUTF8Char): Integer; cdecl;
    create_function_v2: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: Integer; p5: Pointer; xFunc: Pointer; xStep: Pointer; xFinal: Pointer; xDestroy: Pointer): Integer; cdecl;
    db_config: function(p1: Psqlite3; p2: Integer): Integer varargs; cdecl;
    db_mutex: function(p1: Psqlite3): Psqlite3_mutex; cdecl;
    db_status: function(p1: Psqlite3; p2: Integer; p3: PInteger; p4: PInteger; p5: Integer): Integer; cdecl;
    extended_errcode: function(p1: Psqlite3): Integer; cdecl;
    log: procedure(p1: Integer; const p2: PUTF8Char) varargs; cdecl;
    soft_heap_limit64: function(p1: sqlite3_int64): sqlite3_int64; cdecl;
    sourceid: function(): PUTF8Char; cdecl;
    stmt_status: function(p1: Psqlite3_stmt; p2: Integer; p3: Integer): Integer; cdecl;
    strnicmp: function(const p1: PUTF8Char; const p2: PUTF8Char; p3: Integer): Integer; cdecl;
    unlock_notify: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Integer; cdecl;
    wal_autocheckpoint: function(p1: Psqlite3; p2: Integer): Integer; cdecl;
    wal_checkpoint: function(p1: Psqlite3; const p2: PUTF8Char): Integer; cdecl;
    wal_hook: function(p1: Psqlite3; p2: Pointer; p3: Pointer): Pointer; cdecl;
    blob_reopen: function(p1: Psqlite3_blob; p2: sqlite3_int64): Integer; cdecl;
    vtab_config: function(p1: Psqlite3; op: Integer): Integer varargs; cdecl;
    vtab_on_conflict: function(p1: Psqlite3): Integer; cdecl;
    close_v2: function(p1: Psqlite3): Integer; cdecl;
    db_filename: function(p1: Psqlite3; const p2: PUTF8Char): PUTF8Char; cdecl;
    db_readonly: function(p1: Psqlite3; const p2: PUTF8Char): Integer; cdecl;
    db_release_memory: function(p1: Psqlite3): Integer; cdecl;
    errstr: function(p1: Integer): PUTF8Char; cdecl;
    stmt_busy: function(p1: Psqlite3_stmt): Integer; cdecl;
    stmt_readonly: function(p1: Psqlite3_stmt): Integer; cdecl;
    stricmp: function(const p1: PUTF8Char; const p2: PUTF8Char): Integer; cdecl;
    uri_boolean: function(const p1: PUTF8Char; const p2: PUTF8Char; p3: Integer): Integer; cdecl;
    uri_int64: function(const p1: PUTF8Char; const p2: PUTF8Char; p3: sqlite3_int64): sqlite3_int64; cdecl;
    uri_parameter: function(const p1: PUTF8Char; const p2: PUTF8Char): PUTF8Char; cdecl;
    xvsnprintf: function(p1: Integer; p2: PUTF8Char; const p3: PUTF8Char; p4: Pointer): PUTF8Char; cdecl;
    wal_checkpoint_v2: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: PInteger; p5: PInteger): Integer; cdecl;
    auto_extension: function(p1: Pointer): Integer; cdecl;
    bind_blob64: function(p1: Psqlite3_stmt; p2: Integer; const p3: Pointer; p4: sqlite3_uint64; p5: Pointer): Integer; cdecl;
    bind_text64: function(p1: Psqlite3_stmt; p2: Integer; const p3: PUTF8Char; p4: sqlite3_uint64; p5: Pointer; p6: Byte): Integer; cdecl;
    cancel_auto_extension: function(p1: Pointer): Integer; cdecl;
    load_extension: function(p1: Psqlite3; const p2: PUTF8Char; const p3: PUTF8Char; p4: PPUTF8Char): Integer; cdecl;
    malloc64: function(p1: sqlite3_uint64): Pointer; cdecl;
    msize: function(p1: Pointer): sqlite3_uint64; cdecl;
    realloc64: function(p1: Pointer; p2: sqlite3_uint64): Pointer; cdecl;
    reset_auto_extension: procedure(); cdecl;
    result_blob64: procedure(p1: Psqlite3_context; const p2: Pointer; p3: sqlite3_uint64; p4: Pointer); cdecl;
    result_text64: procedure(p1: Psqlite3_context; const p2: PUTF8Char; p3: sqlite3_uint64; p4: Pointer; p5: Byte); cdecl;
    strglob: function(const p1: PUTF8Char; const p2: PUTF8Char): Integer; cdecl;
    value_dup: function(const p1: Psqlite3_value): Psqlite3_value; cdecl;
    value_free: procedure(p1: Psqlite3_value); cdecl;
    result_zeroblob64: function(p1: Psqlite3_context; p2: sqlite3_uint64): Integer; cdecl;
    bind_zeroblob64: function(p1: Psqlite3_stmt; p2: Integer; p3: sqlite3_uint64): Integer; cdecl;
    value_subtype: function(p1: Psqlite3_value): Cardinal; cdecl;
    result_subtype: procedure(p1: Psqlite3_context; p2: Cardinal); cdecl;
    status64: function(p1: Integer; p2: Psqlite3_int64; p3: Psqlite3_int64; p4: Integer): Integer; cdecl;
    strlike: function(const p1: PUTF8Char; const p2: PUTF8Char; p3: Cardinal): Integer; cdecl;
    db_cacheflush: function(p1: Psqlite3): Integer; cdecl;
    system_errno: function(p1: Psqlite3): Integer; cdecl;
    trace_v2: function(p1: Psqlite3; p2: Cardinal; p3: Pointer; p4: Pointer): Integer; cdecl;
    expanded_sql: function(p1: Psqlite3_stmt): PUTF8Char; cdecl;
    set_last_insert_rowid: procedure(p1: Psqlite3; p2: sqlite3_int64); cdecl;
    prepare_v3: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: Cardinal; p5: PPsqlite3_stmt; p6: PPUTF8Char): Integer; cdecl;
    prepare16_v3: function(p1: Psqlite3; const p2: Pointer; p3: Integer; p4: Cardinal; p5: PPsqlite3_stmt; p6: PPointer): Integer; cdecl;
    bind_pointer: function(p1: Psqlite3_stmt; p2: Integer; p3: Pointer; const p4: PUTF8Char; p5: Pointer): Integer; cdecl;
    result_pointer: procedure(p1: Psqlite3_context; p2: Pointer; const p3: PUTF8Char; p4: Pointer); cdecl;
    value_pointer: function(p1: Psqlite3_value; const p2: PUTF8Char): Pointer; cdecl;
    vtab_nochange: function(p1: Psqlite3_context): Integer; cdecl;
    value_nochange: function(p1: Psqlite3_value): Integer; cdecl;
    vtab_collation: function(p1: Psqlite3_index_info; p2: Integer): PUTF8Char; cdecl;
    keyword_count: function(): Integer; cdecl;
    keyword_name: function(p1: Integer; p2: PPUTF8Char; p3: PInteger): Integer; cdecl;
    keyword_check: function(const p1: PUTF8Char; p2: Integer): Integer; cdecl;
    str_new: function(p1: Psqlite3): Psqlite3_str; cdecl;
    str_finish: function(p1: Psqlite3_str): PUTF8Char; cdecl;
    str_appendf: procedure(p1: Psqlite3_str; const zFormat: PUTF8Char) varargs; cdecl;
    str_vappendf: procedure(p1: Psqlite3_str; const zFormat: PUTF8Char; p3: Pointer); cdecl;
    str_append: procedure(p1: Psqlite3_str; const zIn: PUTF8Char; N: Integer); cdecl;
    str_appendall: procedure(p1: Psqlite3_str; const zIn: PUTF8Char); cdecl;
    str_appendchar: procedure(p1: Psqlite3_str; N: Integer; C: UTF8Char); cdecl;
    str_reset: procedure(p1: Psqlite3_str); cdecl;
    str_errcode: function(p1: Psqlite3_str): Integer; cdecl;
    str_length: function(p1: Psqlite3_str): Integer; cdecl;
    str_value: function(p1: Psqlite3_str): PUTF8Char; cdecl;
    create_window_function: function(p1: Psqlite3; const p2: PUTF8Char; p3: Integer; p4: Integer; p5: Pointer; xStep: Pointer; xFinal: Pointer; xValue: Pointer; xInv: Pointer; xDestroy: Pointer): Integer; cdecl;
    normalized_sql: function(p1: Psqlite3_stmt): PUTF8Char; cdecl;
    stmt_isexplain: function(p1: Psqlite3_stmt): Integer; cdecl;
    value_frombind: function(p1: Psqlite3_value): Integer; cdecl;
    drop_modules: function(p1: Psqlite3; p2: PPUTF8Char): Integer; cdecl;
    hard_heap_limit64: function(p1: sqlite3_int64): sqlite3_int64; cdecl;
    uri_key: function(const p1: PUTF8Char; p2: Integer): PUTF8Char; cdecl;
    filename_database: function(const p1: PUTF8Char): PUTF8Char; cdecl;
    filename_journal: function(const p1: PUTF8Char): PUTF8Char; cdecl;
    filename_wal: function(const p1: PUTF8Char): PUTF8Char; cdecl;
    create_filename: function(const p1: PUTF8Char; const p2: PUTF8Char; const p3: PUTF8Char; p4: Integer; p5: PPUTF8Char): PUTF8Char; cdecl;
    free_filename: procedure(const p1: PUTF8Char); cdecl;
    database_file_object: function(const p1: PUTF8Char): Psqlite3_file; cdecl;
    txn_state: function(p1: Psqlite3; const p2: PUTF8Char): Integer; cdecl;
    changes64: function(p1: Psqlite3): sqlite3_int64; cdecl;
    total_changes64: function(p1: Psqlite3): sqlite3_int64; cdecl;
    autovacuum_pages: function(p1: Psqlite3; p2: Pointer; p3: Pointer; p4: Pointer): Integer; cdecl;
    error_offset: function(p1: Psqlite3): Integer; cdecl;
    vtab_rhs_value: function(p1: Psqlite3_index_info; p2: Integer; p3: PPsqlite3_value): Integer; cdecl;
    vtab_distinct: function(p1: Psqlite3_index_info): Integer; cdecl;
    vtab_in: function(p1: Psqlite3_index_info; p2: Integer; p3: Integer): Integer; cdecl;
    vtab_in_first: function(p1: Psqlite3_value; p2: PPsqlite3_value): Integer; cdecl;
    vtab_in_next: function(p1: Psqlite3_value; p2: PPsqlite3_value): Integer; cdecl;
    deserialize: function(p1: Psqlite3; const p2: PUTF8Char; p3: PByte; p4: sqlite3_int64; p5: sqlite3_int64; p6: Cardinal): Integer; cdecl;
    serialize: function(p1: Psqlite3; const p2: PUTF8Char; p3: Psqlite3_int64; p4: Cardinal): PByte; cdecl;
    db_name: function(p1: Psqlite3; p2: Integer): PUTF8Char; cdecl;
    value_encoding: function(p1: Psqlite3_value): Integer; cdecl;
    is_interrupted: function(p1: Psqlite3): Integer; cdecl;
    stmt_explain: function(p1: Psqlite3_stmt; p2: Integer): Integer; cdecl;
    get_clientdata: function(p1: Psqlite3; const p2: PUTF8Char): Pointer; cdecl;
    set_clientdata: function(p1: Psqlite3; const p2: PUTF8Char; p3: Pointer; p4: Pointer): Integer; cdecl;
  end;

  sqlite3_loadext_entry = function(db: Psqlite3; pzErrMsg: PPUTF8Char; const pThunk: Psqlite3_api_routines): Integer; cdecl;

type
  sqlite3_exec_callback = function(p1: Pointer; p2: Integer; p3: PPUTF8Char; p4: PPUTF8Char): Integer; cdecl;

type
  sqlite3_busy_handler_ = function(p1: Pointer; p2: Integer): Integer; cdecl;

type
  sqlite3_set_authorizer_xAuth = function(p1: Pointer; p2: Integer; const p3: PUTF8Char; const p4: PUTF8Char; const p5: PUTF8Char; const p6: PUTF8Char): Integer; cdecl;

type
  sqlite3_trace_xTrace = procedure(p1: Pointer; const p2: PUTF8Char); cdecl;

type
  sqlite3_profile_xProfile = procedure(p1: Pointer; const p2: PUTF8Char; p3: sqlite3_uint64); cdecl;

type
  sqlite3_trace_v2_xCallback = function(p1: Cardinal; p2: Pointer; p3: Pointer; p4: Pointer): Integer; cdecl;

type
  sqlite3_progress_handler_ = function(p1: Pointer): Integer; cdecl;

type
  sqlite3_bind_blob_ = procedure(p1: Pointer); cdecl;

const
  SQLITE_STATIC: sqlite3_destructor_type = sqlite3_destructor_type(0);
  SQLITE_TRANSIENT: sqlite3_destructor_type = sqlite3_destructor_type(-1);

type
  sqlite3_bind_blob64_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_bind_text_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_bind_text16_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_bind_text64_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_bind_pointer_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_create_function_xFunc = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_function_xStep = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_function_xFinal = procedure(p1: Psqlite3_context); cdecl;

type
  sqlite3_create_function16_xFunc = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_function16_xStep = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_function16_xFinal = procedure(p1: Psqlite3_context); cdecl;

type
  sqlite3_create_function_v2_xFunc = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_function_v2_xStep = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_function_v2_xFinal = procedure(p1: Psqlite3_context); cdecl;

type
  sqlite3_create_function_v2_xDestroy = procedure(p1: Pointer); cdecl;

type
  sqlite3_create_window_function_xStep = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_window_function_xFinal = procedure(p1: Psqlite3_context); cdecl;

type
  sqlite3_create_window_function_xValue = procedure(p1: Psqlite3_context); cdecl;

type
  sqlite3_create_window_function_xInverse = procedure(p1: Psqlite3_context; p2: Integer; p3: PPsqlite3_value); cdecl;

type
  sqlite3_create_window_function_xDestroy = procedure(p1: Pointer); cdecl;

type
  sqlite3_memory_alarm_ = procedure(p1: Pointer; p2: sqlite3_int64; p3: Integer); cdecl;

type
  sqlite3_set_auxdata_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_set_clientdata_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_blob_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_blob64_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_text_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_text64_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_text16_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_text16le_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_text16be_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_result_pointer_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_create_collation_xCompare = function(p1: Pointer; p2: Integer; const p3: Pointer; p4: Integer; const p5: Pointer): Integer; cdecl;

type
  sqlite3_create_collation_v2_xCompare = function(p1: Pointer; p2: Integer; const p3: Pointer; p4: Integer; const p5: Pointer): Integer; cdecl;

type
  sqlite3_create_collation_v2_xDestroy = procedure(p1: Pointer); cdecl;

type
  sqlite3_create_collation16_xCompare = function(p1: Pointer; p2: Integer; const p3: Pointer; p4: Integer; const p5: Pointer): Integer; cdecl;

type
  sqlite3_collation_needed_ = procedure(p1: Pointer; p2: Psqlite3; eTextRep: Integer; const p4: PUTF8Char); cdecl;

type
  sqlite3_collation_needed16_ = procedure(p1: Pointer; p2: Psqlite3; eTextRep: Integer; const p4: Pointer); cdecl;

type
  sqlite3_commit_hook_ = function(p1: Pointer): Integer; cdecl;

type
  sqlite3_rollback_hook_ = procedure(p1: Pointer); cdecl;

type
  sqlite3_autovacuum_pages_1 = function(p1: Pointer; const p2: PUTF8Char; p3: Cardinal; p4: Cardinal; p5: Cardinal): Cardinal; cdecl;

type
  sqlite3_autovacuum_pages_2 = procedure(p1: Pointer); cdecl;

type
  sqlite3_update_hook_ = procedure(p1: Pointer; p2: Integer; const p3: PUTF8Char; const p4: PUTF8Char; p5: sqlite3_int64); cdecl;

type
  sqlite3_auto_extension_xEntryPoint = procedure(); cdecl;

type
  sqlite3_cancel_auto_extension_xEntryPoint = procedure(); cdecl;

type
  sqlite3_create_module_v2_xDestroy = procedure(p1: Pointer); cdecl;

type
  sqlite3_wal_hook_ = function(p1: Pointer; p2: Psqlite3; const p3: PUTF8Char; p4: Integer): Integer; cdecl;

var
  OgaShutdown: procedure(); cdecl;
  OgaResultGetError: function(const result: POgaResult): PUTF8Char; cdecl;
  OgaSetLogBool: function(const name: PUTF8Char; value: Boolean): POgaResult; cdecl;
  OgaSetLogString: function(const name: PUTF8Char; const value: PUTF8Char): POgaResult; cdecl;
  OgaDestroyResult: procedure(result: POgaResult); cdecl;
  OgaDestroyString: procedure(const p1: PUTF8Char); cdecl;
  OgaDestroyNamedTensors: procedure(p1: POgaNamedTensors); cdecl;
  OgaCreateSequences: function(&out: PPOgaSequences): POgaResult; cdecl;
  OgaDestroySequences: procedure(sequences: POgaSequences); cdecl;
  OgaSequencesCount: function(const sequences: POgaSequences): NativeUInt; cdecl;
  OgaAppendTokenSequence: function(const token_ptr: PInt32; token_cnt: NativeUInt; sequences: POgaSequences): POgaResult; cdecl;
  OgaAppendTokenToSequence: function(token: Int32; sequences: POgaSequences; sequence_index: NativeUInt): POgaResult; cdecl;
  OgaSequencesGetSequenceCount: function(const sequences: POgaSequences; sequence_index: NativeUInt): NativeUInt; cdecl;
  OgaSequencesGetSequenceData: function(const sequences: POgaSequences; sequence_index: NativeUInt): PInt32; cdecl;
  OgaLoadImage: function(const image_path: PUTF8Char; images: PPOgaImages): POgaResult; cdecl;
  OgaLoadImages: function(const image_paths: POgaStringArray; images: PPOgaImages): POgaResult; cdecl;
  OgaLoadImagesFromBuffers: function(image_data: PPointer; const image_data_sizes: PNativeUInt; count: NativeUInt; images: PPOgaImages): POgaResult; cdecl;
  OgaDestroyImages: procedure(images: POgaImages); cdecl;
  OgaLoadAudio: function(const audio_path: PUTF8Char; audios: PPOgaAudios): POgaResult; cdecl;
  OgaLoadAudios: function(const audio_paths: POgaStringArray; audios: PPOgaAudios): POgaResult; cdecl;
  OgaLoadAudiosFromBuffers: function(audio_data: PPointer; const audio_data_sizes: PNativeUInt; count: NativeUInt; audios: PPOgaAudios): POgaResult; cdecl;
  OgaDestroyAudios: procedure(audios: POgaAudios); cdecl;
  OgaCreateRuntimeSettings: function(&out: PPOgaRuntimeSettings): POgaResult; cdecl;
  OgaDestroyRuntimeSettings: procedure(settings: POgaRuntimeSettings); cdecl;
  OgaRuntimeSettingsSetHandle: function(settings: POgaRuntimeSettings; const handle_name: PUTF8Char; handle: Pointer): POgaResult; cdecl;
  OgaCreateConfig: function(const config_path: PUTF8Char; &out: PPOgaConfig): POgaResult; cdecl;
  OgaConfigClearProviders: function(config: POgaConfig): POgaResult; cdecl;
  OgaConfigAppendProvider: function(config: POgaConfig; const provider: PUTF8Char): POgaResult; cdecl;
  OgaConfigSetProviderOption: function(config: POgaConfig; const provider: PUTF8Char; const key: PUTF8Char; const value: PUTF8Char): POgaResult; cdecl;
  OgaConfigOverlay: function(config: POgaConfig; const json: PUTF8Char): POgaResult; cdecl;
  OgaCreateModel: function(const config_path: PUTF8Char; &out: PPOgaModel): POgaResult; cdecl;
  OgaCreateModelFromConfig: function(const config: POgaConfig; &out: PPOgaModel): POgaResult; cdecl;
  OgaCreateModelWithRuntimeSettings: function(const config_path: PUTF8Char; const settings: POgaRuntimeSettings; &out: PPOgaModel): POgaResult; cdecl;
  OgaModelGetType: function(const model: POgaModel; &out: PPUTF8Char): POgaResult; cdecl;
  OgaModelGetDeviceType: function(const model: POgaModel; &out: PPUTF8Char): POgaResult; cdecl;
  OgaDestroyConfig: procedure(config: POgaConfig); cdecl;
  OgaDestroyModel: procedure(model: POgaModel); cdecl;
  OgaCreateGeneratorParams: function(const model: POgaModel; &out: PPOgaGeneratorParams): POgaResult; cdecl;
  OgaDestroyGeneratorParams: procedure(generator_params: POgaGeneratorParams); cdecl;
  OgaGeneratorParamsSetSearchNumber: function(generator_params: POgaGeneratorParams; const name: PUTF8Char; value: Double): POgaResult; cdecl;
  OgaGeneratorParamsSetSearchBool: function(generator_params: POgaGeneratorParams; const name: PUTF8Char; value: Boolean): POgaResult; cdecl;
  OgaGeneratorParamsTryGraphCaptureWithMaxBatchSize: function(generator_params: POgaGeneratorParams; max_batch_size: Int32): POgaResult; cdecl;
  OgaGeneratorParamsSetInputs: function(generator_params: POgaGeneratorParams; const named_tensors: POgaNamedTensors): POgaResult; cdecl;
  OgaGeneratorParamsSetModelInput: function(generator_params: POgaGeneratorParams; const name: PUTF8Char; tensor: POgaTensor): POgaResult; cdecl;
  OgaGeneratorParamsSetWhisperInputFeatures: function(p1: POgaGeneratorParams; tensor: POgaTensor): POgaResult; cdecl;
  OgaCreateGenerator: function(const model: POgaModel; const params: POgaGeneratorParams; &out: PPOgaGenerator): POgaResult; cdecl;
  OgaDestroyGenerator: procedure(generator: POgaGenerator); cdecl;
  OgaGenerator_IsDone: function(const generator: POgaGenerator): Boolean; cdecl;
  OgaGenerator_IsSessionTerminated: function(const generator: POgaGenerator): Boolean; cdecl;
  OgaGenerator_AppendTokenSequences: function(oga_generator: POgaGenerator; const p_sequences: POgaSequences): POgaResult; cdecl;
  OgaGenerator_AppendTokens: function(oga_generator: POgaGenerator; const input_ids: PInt32; input_ids_count: NativeUInt): POgaResult; cdecl;
  OgaGenerator_GenerateNextToken: function(generator: POgaGenerator): POgaResult; cdecl;
  OgaGenerator_GetNextTokens: function(const generator: POgaGenerator; &out: PPInt32; out_count: PNativeUInt): POgaResult; cdecl;
  OgaGenerator_SetRuntimeOption: function(generator: POgaGenerator; const key: PUTF8Char; const value: PUTF8Char): POgaResult; cdecl;
  OgaGenerator_RewindTo: function(generator: POgaGenerator; new_length: NativeUInt): POgaResult; cdecl;
  OgaGenerator_GetOutput: function(const generator: POgaGenerator; const name: PUTF8Char; &out: PPOgaTensor): POgaResult; cdecl;
  OgaGenerator_GetLogits: function(generator: POgaGenerator; &out: PPOgaTensor): POgaResult; cdecl;
  OgaGenerator_SetLogits: function(generator: POgaGenerator; tensor: POgaTensor): POgaResult; cdecl;
  OgaGenerator_GetSequenceCount: function(const generator: POgaGenerator; index: NativeUInt): NativeUInt; cdecl;
  OgaGenerator_GetSequenceData: function(const generator: POgaGenerator; index: NativeUInt): PInt32; cdecl;
  OgaCreateTokenizer: function(const model: POgaModel; &out: PPOgaTokenizer): POgaResult; cdecl;
  OgaDestroyTokenizer: procedure(p1: POgaTokenizer); cdecl;
  OgaCreateMultiModalProcessor: function(const model: POgaModel; &out: PPOgaMultiModalProcessor): POgaResult; cdecl;
  OgaDestroyMultiModalProcessor: procedure(processor: POgaMultiModalProcessor); cdecl;
  OgaTokenizerEncode: function(const p1: POgaTokenizer; const str: PUTF8Char; sequences: POgaSequences): POgaResult; cdecl;
  OgaTokenizerEncodeBatch: function(const p1: POgaTokenizer; strings: PPUTF8Char; count: NativeUInt; &out: PPOgaTensor): POgaResult; cdecl;
  OgaTokenizerDecodeBatch: function(const p1: POgaTokenizer; const tensor: POgaTensor; &out: PPOgaStringArray): POgaResult; cdecl;
  OgaTokenizerToTokenId: function(const tokenizer: POgaTokenizer; const str: PUTF8Char; token_id: PInt32): POgaResult; cdecl;
  OgaProcessorProcessImages: function(const p1: POgaMultiModalProcessor; const prompt: PUTF8Char; const images: POgaImages; input_tensors: PPOgaNamedTensors): POgaResult; cdecl;
  OgaProcessorProcessAudios: function(const p1: POgaMultiModalProcessor; const audios: POgaAudios; input_tensors: PPOgaNamedTensors): POgaResult; cdecl;
  OgaProcessorProcessImagesAndAudios: function(const p1: POgaMultiModalProcessor; const prompt: PUTF8Char; const images: POgaImages; const audios: POgaAudios; input_tensors: PPOgaNamedTensors): POgaResult; cdecl;
  OgaTokenizerDecode: function(const p1: POgaTokenizer; const tokens: PInt32; token_count: NativeUInt; out_string: PPUTF8Char): POgaResult; cdecl;
  OgaProcessorDecode: function(const p1: POgaMultiModalProcessor; const tokens: PInt32; token_count: NativeUInt; out_string: PPUTF8Char): POgaResult; cdecl;
  OgaCreateTokenizerStream: function(const p1: POgaTokenizer; &out: PPOgaTokenizerStream): POgaResult; cdecl;
  OgaCreateTokenizerStreamFromProcessor: function(const p1: POgaMultiModalProcessor; &out: PPOgaTokenizerStream): POgaResult; cdecl;
  OgaDestroyTokenizerStream: procedure(p1: POgaTokenizerStream); cdecl;
  OgaTokenizerStreamDecode: function(p1: POgaTokenizerStream; token: Int32; &out: PPUTF8Char): POgaResult; cdecl;
  OgaCreateTensorFromBuffer: function(data: Pointer; const shape_dims: PInt64; shape_dims_count: NativeUInt; element_type: OgaElementType; &out: PPOgaTensor): POgaResult; cdecl;
  OgaDestroyTensor: procedure(tensor: POgaTensor); cdecl;
  OgaTensorGetType: function(p1: POgaTensor; &out: POgaElementType): POgaResult; cdecl;
  OgaTensorGetShapeRank: function(p1: POgaTensor; &out: PNativeUInt): POgaResult; cdecl;
  OgaTensorGetShape: function(p1: POgaTensor; shape_dims: PInt64; shape_dims_count: NativeUInt): POgaResult; cdecl;
  OgaTensorGetData: function(p1: POgaTensor; &out: PPointer): POgaResult; cdecl;
  OgaCreateNamedTensors: function(&out: PPOgaNamedTensors): POgaResult; cdecl;
  OgaNamedTensorsGet: function(const named_tensors: POgaNamedTensors; const name: PUTF8Char; &out: PPOgaTensor): POgaResult; cdecl;
  OgaNamedTensorsSet: function(named_tensors: POgaNamedTensors; const name: PUTF8Char; tensor: POgaTensor): POgaResult; cdecl;
  OgaNamedTensorsDelete: function(named_tensors: POgaNamedTensors; const name: PUTF8Char): POgaResult; cdecl;
  OgaNamedTensorsCount: function(const named_tensors: POgaNamedTensors; &out: PNativeUInt): POgaResult; cdecl;
  OgaNamedTensorsGetNames: function(const named_tensors: POgaNamedTensors; &out: PPOgaStringArray): POgaResult; cdecl;
  OgaSetCurrentGpuDeviceId: function(device_id: Integer): POgaResult; cdecl;
  OgaGetCurrentGpuDeviceId: function(device_id: PInteger): POgaResult; cdecl;
  OgaCreateStringArray: function(&out: PPOgaStringArray): POgaResult; cdecl;
  OgaCreateStringArrayFromStrings: function(const strs: PPUTF8Char; count: NativeUInt; &out: PPOgaStringArray): POgaResult; cdecl;
  OgaDestroyStringArray: procedure(string_array: POgaStringArray); cdecl;
  OgaStringArrayAddString: function(string_array: POgaStringArray; const str: PUTF8Char): POgaResult; cdecl;
  OgaStringArrayGetCount: function(const string_array: POgaStringArray; &out: PNativeUInt): POgaResult; cdecl;
  OgaStringArrayGetString: function(const string_array: POgaStringArray; index: NativeUInt; &out: PPUTF8Char): POgaResult; cdecl;
  OgaCreateAdapters: function(const model: POgaModel; &out: PPOgaAdapters): POgaResult; cdecl;
  OgaDestroyAdapters: procedure(adapters: POgaAdapters); cdecl;
  OgaLoadAdapter: function(adapters: POgaAdapters; const adapter_file_path: PUTF8Char; const adapter_name: PUTF8Char): POgaResult; cdecl;
  OgaUnloadAdapter: function(adapters: POgaAdapters; const adapter_name: PUTF8Char): POgaResult; cdecl;
  OgaSetActiveAdapter: function(generator: POgaGenerator; adapters: POgaAdapters; const adapter_name: PUTF8Char): POgaResult; cdecl;
  sqlite3_libversion: function(): PUTF8Char; cdecl;
  sqlite3_sourceid: function(): PUTF8Char; cdecl;
  sqlite3_libversion_number: function(): Integer; cdecl;
  sqlite3_compileoption_used: function(const zOptName: PUTF8Char): Integer; cdecl;
  sqlite3_compileoption_get: function(N: Integer): PUTF8Char; cdecl;
  sqlite3_threadsafe: function(): Integer; cdecl;
  sqlite3_close: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_close_v2: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_exec: function(p1: Psqlite3; const sql: PUTF8Char; callback: sqlite3_exec_callback; p4: Pointer; errmsg: PPUTF8Char): Integer; cdecl;
  sqlite3_initialize: function(): Integer; cdecl;
  sqlite3_shutdown: function(): Integer; cdecl;
  sqlite3_os_init: function(): Integer; cdecl;
  sqlite3_os_end: function(): Integer; cdecl;
  sqlite3_config: function(p1: Integer): Integer varargs; cdecl;
  sqlite3_db_config: function(p1: Psqlite3; op: Integer): Integer varargs; cdecl;
  sqlite3_extended_result_codes: function(p1: Psqlite3; onoff: Integer): Integer; cdecl;
  sqlite3_last_insert_rowid: function(p1: Psqlite3): sqlite3_int64; cdecl;
  sqlite3_set_last_insert_rowid: procedure(p1: Psqlite3; p2: sqlite3_int64); cdecl;
  sqlite3_changes: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_changes64: function(p1: Psqlite3): sqlite3_int64; cdecl;
  sqlite3_total_changes: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_total_changes64: function(p1: Psqlite3): sqlite3_int64; cdecl;
  sqlite3_interrupt: procedure(p1: Psqlite3); cdecl;
  sqlite3_is_interrupted: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_complete: function(const sql: PUTF8Char): Integer; cdecl;
  sqlite3_complete16: function(const sql: Pointer): Integer; cdecl;
  sqlite3_busy_handler: function(p1: Psqlite3; p2: sqlite3_busy_handler_; p3: Pointer): Integer; cdecl;
  sqlite3_busy_timeout: function(p1: Psqlite3; ms: Integer): Integer; cdecl;
  sqlite3_get_table: function(db: Psqlite3; const zSql: PUTF8Char; pazResult: PPPUTF8Char; pnRow: PInteger; pnColumn: PInteger; pzErrmsg: PPUTF8Char): Integer; cdecl;
  sqlite3_free_table: procedure(result: PPUTF8Char); cdecl;
  sqlite3_mprintf: function(const p1: PUTF8Char): PUTF8Char varargs; cdecl;
  sqlite3_vmprintf: function(const p1: PUTF8Char; p2: Pointer): PUTF8Char; cdecl;
  sqlite3_snprintf: function(p1: Integer; p2: PUTF8Char; const p3: PUTF8Char): PUTF8Char varargs; cdecl;
  sqlite3_vsnprintf: function(p1: Integer; p2: PUTF8Char; const p3: PUTF8Char; p4: Pointer): PUTF8Char; cdecl;
  sqlite3_malloc: function(p1: Integer): Pointer; cdecl;
  sqlite3_malloc64: function(p1: sqlite3_uint64): Pointer; cdecl;
  sqlite3_realloc: function(p1: Pointer; p2: Integer): Pointer; cdecl;
  sqlite3_realloc64: function(p1: Pointer; p2: sqlite3_uint64): Pointer; cdecl;
  sqlite3_free: procedure(p1: Pointer); cdecl;
  sqlite3_msize: function(p1: Pointer): sqlite3_uint64; cdecl;
  sqlite3_memory_used: function(): sqlite3_int64; cdecl;
  sqlite3_memory_highwater: function(resetFlag: Integer): sqlite3_int64; cdecl;
  sqlite3_randomness: procedure(N: Integer; P: Pointer); cdecl;
  sqlite3_set_authorizer: function(p1: Psqlite3; xAuth: sqlite3_set_authorizer_xAuth; pUserData: Pointer): Integer; cdecl;
  sqlite3_trace: function(p1: Psqlite3; xTrace: sqlite3_trace_xTrace; p3: Pointer): Pointer; cdecl;
  sqlite3_profile: function(p1: Psqlite3; xProfile: sqlite3_profile_xProfile; p3: Pointer): Pointer; cdecl;
  sqlite3_trace_v2: function(p1: Psqlite3; uMask: Cardinal; xCallback: sqlite3_trace_v2_xCallback; pCtx: Pointer): Integer; cdecl;
  sqlite3_progress_handler: procedure(p1: Psqlite3; p2: Integer; p3: sqlite3_progress_handler_; p4: Pointer); cdecl;
  sqlite3_open: function(const filename: PUTF8Char; ppDb: PPsqlite3): Integer; cdecl;
  sqlite3_open16: function(const filename: Pointer; ppDb: PPsqlite3): Integer; cdecl;
  sqlite3_open_v2: function(const filename: PUTF8Char; ppDb: PPsqlite3; flags: Integer; const zVfs: PUTF8Char): Integer; cdecl;
  sqlite3_uri_parameter: function(z: sqlite3_filename; const zParam: PUTF8Char): PUTF8Char; cdecl;
  sqlite3_uri_boolean: function(z: sqlite3_filename; const zParam: PUTF8Char; bDefault: Integer): Integer; cdecl;
  sqlite3_uri_int64: function(p1: sqlite3_filename; const p2: PUTF8Char; p3: sqlite3_int64): sqlite3_int64; cdecl;
  sqlite3_uri_key: function(z: sqlite3_filename; N: Integer): PUTF8Char; cdecl;
  sqlite3_filename_database: function(p1: sqlite3_filename): PUTF8Char; cdecl;
  sqlite3_filename_journal: function(p1: sqlite3_filename): PUTF8Char; cdecl;
  sqlite3_filename_wal: function(p1: sqlite3_filename): PUTF8Char; cdecl;
  sqlite3_database_file_object: function(const p1: PUTF8Char): Psqlite3_file; cdecl;
  sqlite3_create_filename: function(const zDatabase: PUTF8Char; const zJournal: PUTF8Char; const zWal: PUTF8Char; nParam: Integer; azParam: PPUTF8Char): sqlite3_filename; cdecl;
  sqlite3_free_filename: procedure(p1: sqlite3_filename); cdecl;
  sqlite3_errcode: function(db: Psqlite3): Integer; cdecl;
  sqlite3_extended_errcode: function(db: Psqlite3): Integer; cdecl;
  sqlite3_errmsg: function(p1: Psqlite3): PUTF8Char; cdecl;
  sqlite3_errmsg16: function(p1: Psqlite3): Pointer; cdecl;
  sqlite3_errstr: function(p1: Integer): PUTF8Char; cdecl;
  sqlite3_error_offset: function(db: Psqlite3): Integer; cdecl;
  sqlite3_limit: function(p1: Psqlite3; id: Integer; newVal: Integer): Integer; cdecl;
  sqlite3_prepare: function(db: Psqlite3; const zSql: PUTF8Char; nByte: Integer; ppStmt: PPsqlite3_stmt; pzTail: PPUTF8Char): Integer; cdecl;
  sqlite3_prepare_v2: function(db: Psqlite3; const zSql: PUTF8Char; nByte: Integer; ppStmt: PPsqlite3_stmt; pzTail: PPUTF8Char): Integer; cdecl;
  sqlite3_prepare_v3: function(db: Psqlite3; const zSql: PUTF8Char; nByte: Integer; prepFlags: Cardinal; ppStmt: PPsqlite3_stmt; pzTail: PPUTF8Char): Integer; cdecl;
  sqlite3_prepare16: function(db: Psqlite3; const zSql: Pointer; nByte: Integer; ppStmt: PPsqlite3_stmt; pzTail: PPointer): Integer; cdecl;
  sqlite3_prepare16_v2: function(db: Psqlite3; const zSql: Pointer; nByte: Integer; ppStmt: PPsqlite3_stmt; pzTail: PPointer): Integer; cdecl;
  sqlite3_prepare16_v3: function(db: Psqlite3; const zSql: Pointer; nByte: Integer; prepFlags: Cardinal; ppStmt: PPsqlite3_stmt; pzTail: PPointer): Integer; cdecl;
  sqlite3_sql: function(pStmt: Psqlite3_stmt): PUTF8Char; cdecl;
  sqlite3_expanded_sql: function(pStmt: Psqlite3_stmt): PUTF8Char; cdecl;
  sqlite3_stmt_readonly: function(pStmt: Psqlite3_stmt): Integer; cdecl;
  sqlite3_stmt_isexplain: function(pStmt: Psqlite3_stmt): Integer; cdecl;
  sqlite3_stmt_explain: function(pStmt: Psqlite3_stmt; eMode: Integer): Integer; cdecl;
  sqlite3_stmt_busy: function(p1: Psqlite3_stmt): Integer; cdecl;
  sqlite3_bind_blob: function(p1: Psqlite3_stmt; p2: Integer; const p3: Pointer; n: Integer; p5: sqlite3_bind_blob_): Integer; cdecl;
  sqlite3_bind_blob64: function(p1: Psqlite3_stmt; p2: Integer; const p3: Pointer; p4: sqlite3_uint64; p5: sqlite3_bind_blob64_): Integer; cdecl;
  sqlite3_bind_double: function(p1: Psqlite3_stmt; p2: Integer; p3: Double): Integer; cdecl;
  sqlite3_bind_int: function(p1: Psqlite3_stmt; p2: Integer; p3: Integer): Integer; cdecl;
  sqlite3_bind_int64: function(p1: Psqlite3_stmt; p2: Integer; p3: sqlite3_int64): Integer; cdecl;
  sqlite3_bind_null: function(p1: Psqlite3_stmt; p2: Integer): Integer; cdecl;
  sqlite3_bind_text: function(p1: Psqlite3_stmt; p2: Integer; const p3: PUTF8Char; p4: Integer; p5: sqlite3_bind_text_): Integer; cdecl;
  sqlite3_bind_text16: function(p1: Psqlite3_stmt; p2: Integer; const p3: Pointer; p4: Integer; p5: sqlite3_bind_text16_): Integer; cdecl;
  sqlite3_bind_text64: function(p1: Psqlite3_stmt; p2: Integer; const p3: PUTF8Char; p4: sqlite3_uint64; p5: sqlite3_bind_text64_; encoding: Byte): Integer; cdecl;
  sqlite3_bind_value: function(p1: Psqlite3_stmt; p2: Integer; const p3: Psqlite3_value): Integer; cdecl;
  sqlite3_bind_pointer: function(p1: Psqlite3_stmt; p2: Integer; p3: Pointer; const p4: PUTF8Char; p5: sqlite3_bind_pointer_): Integer; cdecl;
  sqlite3_bind_zeroblob: function(p1: Psqlite3_stmt; p2: Integer; n: Integer): Integer; cdecl;
  sqlite3_bind_zeroblob64: function(p1: Psqlite3_stmt; p2: Integer; p3: sqlite3_uint64): Integer; cdecl;
  sqlite3_bind_parameter_count: function(p1: Psqlite3_stmt): Integer; cdecl;
  sqlite3_bind_parameter_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
  sqlite3_bind_parameter_index: function(p1: Psqlite3_stmt; const zName: PUTF8Char): Integer; cdecl;
  sqlite3_clear_bindings: function(p1: Psqlite3_stmt): Integer; cdecl;
  sqlite3_column_count: function(pStmt: Psqlite3_stmt): Integer; cdecl;
  sqlite3_column_name: function(p1: Psqlite3_stmt; N: Integer): PUTF8Char; cdecl;
  sqlite3_column_name16: function(p1: Psqlite3_stmt; N: Integer): Pointer; cdecl;
  sqlite3_column_database_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
  sqlite3_column_database_name16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
  sqlite3_column_table_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
  sqlite3_column_table_name16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
  sqlite3_column_origin_name: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
  sqlite3_column_origin_name16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
  sqlite3_column_decltype: function(p1: Psqlite3_stmt; p2: Integer): PUTF8Char; cdecl;
  sqlite3_column_decltype16: function(p1: Psqlite3_stmt; p2: Integer): Pointer; cdecl;
  sqlite3_step: function(p1: Psqlite3_stmt): Integer; cdecl;
  sqlite3_data_count: function(pStmt: Psqlite3_stmt): Integer; cdecl;
  sqlite3_column_blob: function(p1: Psqlite3_stmt; iCol: Integer): Pointer; cdecl;
  sqlite3_column_double: function(p1: Psqlite3_stmt; iCol: Integer): Double; cdecl;
  sqlite3_column_int: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
  sqlite3_column_int64: function(p1: Psqlite3_stmt; iCol: Integer): sqlite3_int64; cdecl;
  sqlite3_column_text: function(p1: Psqlite3_stmt; iCol: Integer): PByte; cdecl;
  sqlite3_column_text16: function(p1: Psqlite3_stmt; iCol: Integer): Pointer; cdecl;
  sqlite3_column_value: function(p1: Psqlite3_stmt; iCol: Integer): Psqlite3_value; cdecl;
  sqlite3_column_bytes: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
  sqlite3_column_bytes16: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
  sqlite3_column_type: function(p1: Psqlite3_stmt; iCol: Integer): Integer; cdecl;
  sqlite3_finalize: function(pStmt: Psqlite3_stmt): Integer; cdecl;
  sqlite3_reset: function(pStmt: Psqlite3_stmt): Integer; cdecl;
  sqlite3_create_function: function(db: Psqlite3; const zFunctionName: PUTF8Char; nArg: Integer; eTextRep: Integer; pApp: Pointer; xFunc: sqlite3_create_function_xFunc; xStep: sqlite3_create_function_xStep; xFinal: sqlite3_create_function_xFinal): Integer; cdecl;
  sqlite3_create_function16: function(db: Psqlite3; const zFunctionName: Pointer; nArg: Integer; eTextRep: Integer; pApp: Pointer; xFunc: sqlite3_create_function16_xFunc; xStep: sqlite3_create_function16_xStep; xFinal: sqlite3_create_function16_xFinal): Integer; cdecl;
  sqlite3_create_function_v2: function(db: Psqlite3; const zFunctionName: PUTF8Char; nArg: Integer; eTextRep: Integer; pApp: Pointer; xFunc: sqlite3_create_function_v2_xFunc; xStep: sqlite3_create_function_v2_xStep; xFinal: sqlite3_create_function_v2_xFinal; xDestroy: sqlite3_create_function_v2_xDestroy): Integer; cdecl;
  sqlite3_create_window_function: function(db: Psqlite3; const zFunctionName: PUTF8Char; nArg: Integer; eTextRep: Integer; pApp: Pointer; xStep: sqlite3_create_window_function_xStep; xFinal: sqlite3_create_window_function_xFinal; xValue: sqlite3_create_window_function_xValue; xInverse: sqlite3_create_window_function_xInverse; xDestroy: sqlite3_create_window_function_xDestroy): Integer; cdecl;
  sqlite3_aggregate_count: function(p1: Psqlite3_context): Integer; cdecl;
  sqlite3_expired: function(p1: Psqlite3_stmt): Integer; cdecl;
  sqlite3_transfer_bindings: function(p1: Psqlite3_stmt; p2: Psqlite3_stmt): Integer; cdecl;
  sqlite3_global_recover: function(): Integer; cdecl;
  sqlite3_thread_cleanup: procedure(); cdecl;
  sqlite3_memory_alarm: function(p1: sqlite3_memory_alarm_; p2: Pointer; p3: sqlite3_int64): Integer; cdecl;
  sqlite3_value_blob: function(p1: Psqlite3_value): Pointer; cdecl;
  sqlite3_value_double: function(p1: Psqlite3_value): Double; cdecl;
  sqlite3_value_int: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_int64: function(p1: Psqlite3_value): sqlite3_int64; cdecl;
  sqlite3_value_pointer: function(p1: Psqlite3_value; const p2: PUTF8Char): Pointer; cdecl;
  sqlite3_value_text: function(p1: Psqlite3_value): PByte; cdecl;
  sqlite3_value_text16: function(p1: Psqlite3_value): Pointer; cdecl;
  sqlite3_value_text16le: function(p1: Psqlite3_value): Pointer; cdecl;
  sqlite3_value_text16be: function(p1: Psqlite3_value): Pointer; cdecl;
  sqlite3_value_bytes: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_bytes16: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_type: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_numeric_type: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_nochange: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_frombind: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_encoding: function(p1: Psqlite3_value): Integer; cdecl;
  sqlite3_value_subtype: function(p1: Psqlite3_value): Cardinal; cdecl;
  sqlite3_value_dup: function(const p1: Psqlite3_value): Psqlite3_value; cdecl;
  sqlite3_value_free: procedure(p1: Psqlite3_value); cdecl;
  sqlite3_aggregate_context: function(p1: Psqlite3_context; nBytes: Integer): Pointer; cdecl;
  sqlite3_user_data: function(p1: Psqlite3_context): Pointer; cdecl;
  sqlite3_context_db_handle: function(p1: Psqlite3_context): Psqlite3; cdecl;
  sqlite3_get_auxdata: function(p1: Psqlite3_context; N: Integer): Pointer; cdecl;
  sqlite3_set_auxdata: procedure(p1: Psqlite3_context; N: Integer; p3: Pointer; p4: sqlite3_set_auxdata_); cdecl;
  sqlite3_get_clientdata: function(p1: Psqlite3; const p2: PUTF8Char): Pointer; cdecl;
  sqlite3_set_clientdata: function(p1: Psqlite3; const p2: PUTF8Char; p3: Pointer; p4: sqlite3_set_clientdata_): Integer; cdecl;
  sqlite3_result_blob: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: sqlite3_result_blob_); cdecl;
  sqlite3_result_blob64: procedure(p1: Psqlite3_context; const p2: Pointer; p3: sqlite3_uint64; p4: sqlite3_result_blob64_); cdecl;
  sqlite3_result_double: procedure(p1: Psqlite3_context; p2: Double); cdecl;
  sqlite3_result_error: procedure(p1: Psqlite3_context; const p2: PUTF8Char; p3: Integer); cdecl;
  sqlite3_result_error16: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer); cdecl;
  sqlite3_result_error_toobig: procedure(p1: Psqlite3_context); cdecl;
  sqlite3_result_error_nomem: procedure(p1: Psqlite3_context); cdecl;
  sqlite3_result_error_code: procedure(p1: Psqlite3_context; p2: Integer); cdecl;
  sqlite3_result_int: procedure(p1: Psqlite3_context; p2: Integer); cdecl;
  sqlite3_result_int64: procedure(p1: Psqlite3_context; p2: sqlite3_int64); cdecl;
  sqlite3_result_null: procedure(p1: Psqlite3_context); cdecl;
  sqlite3_result_text: procedure(p1: Psqlite3_context; const p2: PUTF8Char; p3: Integer; p4: sqlite3_result_text_); cdecl;
  sqlite3_result_text64: procedure(p1: Psqlite3_context; const p2: PUTF8Char; p3: sqlite3_uint64; p4: sqlite3_result_text64_; encoding: Byte); cdecl;
  sqlite3_result_text16: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: sqlite3_result_text16_); cdecl;
  sqlite3_result_text16le: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: sqlite3_result_text16le_); cdecl;
  sqlite3_result_text16be: procedure(p1: Psqlite3_context; const p2: Pointer; p3: Integer; p4: sqlite3_result_text16be_); cdecl;
  sqlite3_result_value: procedure(p1: Psqlite3_context; p2: Psqlite3_value); cdecl;
  sqlite3_result_pointer: procedure(p1: Psqlite3_context; p2: Pointer; const p3: PUTF8Char; p4: sqlite3_result_pointer_); cdecl;
  sqlite3_result_zeroblob: procedure(p1: Psqlite3_context; n: Integer); cdecl;
  sqlite3_result_zeroblob64: function(p1: Psqlite3_context; n: sqlite3_uint64): Integer; cdecl;
  sqlite3_result_subtype: procedure(p1: Psqlite3_context; p2: Cardinal); cdecl;
  sqlite3_create_collation: function(p1: Psqlite3; const zName: PUTF8Char; eTextRep: Integer; pArg: Pointer; xCompare: sqlite3_create_collation_xCompare): Integer; cdecl;
  sqlite3_create_collation_v2: function(p1: Psqlite3; const zName: PUTF8Char; eTextRep: Integer; pArg: Pointer; xCompare: sqlite3_create_collation_v2_xCompare; xDestroy: sqlite3_create_collation_v2_xDestroy): Integer; cdecl;
  sqlite3_create_collation16: function(p1: Psqlite3; const zName: Pointer; eTextRep: Integer; pArg: Pointer; xCompare: sqlite3_create_collation16_xCompare): Integer; cdecl;
  sqlite3_collation_needed: function(p1: Psqlite3; p2: Pointer; p3: sqlite3_collation_needed_): Integer; cdecl;
  sqlite3_collation_needed16: function(p1: Psqlite3; p2: Pointer; p3: sqlite3_collation_needed16_): Integer; cdecl;
  sqlite3_sleep: function(p1: Integer): Integer; cdecl;
  sqlite3_win32_set_directory: function(&type: Longword; zValue: Pointer): Integer; cdecl;
  sqlite3_win32_set_directory8: function(&type: Longword; const zValue: PUTF8Char): Integer; cdecl;
  sqlite3_win32_set_directory16: function(&type: Longword; const zValue: Pointer): Integer; cdecl;
  sqlite3_get_autocommit: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_db_handle: function(p1: Psqlite3_stmt): Psqlite3; cdecl;
  sqlite3_db_name: function(db: Psqlite3; N: Integer): PUTF8Char; cdecl;
  sqlite3_db_filename: function(db: Psqlite3; const zDbName: PUTF8Char): sqlite3_filename; cdecl;
  sqlite3_db_readonly: function(db: Psqlite3; const zDbName: PUTF8Char): Integer; cdecl;
  sqlite3_txn_state: function(p1: Psqlite3; const zSchema: PUTF8Char): Integer; cdecl;
  sqlite3_next_stmt: function(pDb: Psqlite3; pStmt: Psqlite3_stmt): Psqlite3_stmt; cdecl;
  sqlite3_commit_hook: function(p1: Psqlite3; p2: sqlite3_commit_hook_; p3: Pointer): Pointer; cdecl;
  sqlite3_rollback_hook: function(p1: Psqlite3; p2: sqlite3_rollback_hook_; p3: Pointer): Pointer; cdecl;
  sqlite3_autovacuum_pages: function(db: Psqlite3; p2: sqlite3_autovacuum_pages_1; p3: Pointer; p4: sqlite3_autovacuum_pages_2): Integer; cdecl;
  sqlite3_update_hook: function(p1: Psqlite3; p2: sqlite3_update_hook_; p3: Pointer): Pointer; cdecl;
  sqlite3_enable_shared_cache: function(p1: Integer): Integer; cdecl;
  sqlite3_release_memory: function(p1: Integer): Integer; cdecl;
  sqlite3_db_release_memory: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_soft_heap_limit64: function(N: sqlite3_int64): sqlite3_int64; cdecl;
  sqlite3_hard_heap_limit64: function(N: sqlite3_int64): sqlite3_int64; cdecl;
  sqlite3_soft_heap_limit: procedure(N: Integer); cdecl;
  sqlite3_table_column_metadata: function(db: Psqlite3; const zDbName: PUTF8Char; const zTableName: PUTF8Char; const zColumnName: PUTF8Char; pzDataType: PPUTF8Char; pzCollSeq: PPUTF8Char; pNotNull: PInteger; pPrimaryKey: PInteger; pAutoinc: PInteger): Integer; cdecl;
  sqlite3_auto_extension: function(xEntryPoint: sqlite3_auto_extension_xEntryPoint): Integer; cdecl;
  sqlite3_cancel_auto_extension: function(xEntryPoint: sqlite3_cancel_auto_extension_xEntryPoint): Integer; cdecl;
  sqlite3_reset_auto_extension: procedure(); cdecl;
  sqlite3_create_module: function(db: Psqlite3; const zName: PUTF8Char; const p: Psqlite3_module; pClientData: Pointer): Integer; cdecl;
  sqlite3_create_module_v2: function(db: Psqlite3; const zName: PUTF8Char; const p: Psqlite3_module; pClientData: Pointer; xDestroy: sqlite3_create_module_v2_xDestroy): Integer; cdecl;
  sqlite3_drop_modules: function(db: Psqlite3; azKeep: PPUTF8Char): Integer; cdecl;
  sqlite3_declare_vtab: function(p1: Psqlite3; const zSQL: PUTF8Char): Integer; cdecl;
  sqlite3_overload_function: function(p1: Psqlite3; const zFuncName: PUTF8Char; nArg: Integer): Integer; cdecl;
  sqlite3_blob_open: function(p1: Psqlite3; const zDb: PUTF8Char; const zTable: PUTF8Char; const zColumn: PUTF8Char; iRow: sqlite3_int64; flags: Integer; ppBlob: PPsqlite3_blob): Integer; cdecl;
  sqlite3_blob_reopen: function(p1: Psqlite3_blob; p2: sqlite3_int64): Integer; cdecl;
  sqlite3_blob_close: function(p1: Psqlite3_blob): Integer; cdecl;
  sqlite3_blob_bytes: function(p1: Psqlite3_blob): Integer; cdecl;
  sqlite3_blob_read: function(p1: Psqlite3_blob; Z: Pointer; N: Integer; iOffset: Integer): Integer; cdecl;
  sqlite3_blob_write: function(p1: Psqlite3_blob; const z: Pointer; n: Integer; iOffset: Integer): Integer; cdecl;
  sqlite3_vfs_find: function(const zVfsName: PUTF8Char): Psqlite3_vfs; cdecl;
  sqlite3_vfs_register: function(p1: Psqlite3_vfs; makeDflt: Integer): Integer; cdecl;
  sqlite3_vfs_unregister: function(p1: Psqlite3_vfs): Integer; cdecl;
  sqlite3_mutex_alloc: function(p1: Integer): Psqlite3_mutex; cdecl;
  sqlite3_mutex_free: procedure(p1: Psqlite3_mutex); cdecl;
  sqlite3_mutex_enter: procedure(p1: Psqlite3_mutex); cdecl;
  sqlite3_mutex_try: function(p1: Psqlite3_mutex): Integer; cdecl;
  sqlite3_mutex_leave: procedure(p1: Psqlite3_mutex); cdecl;
  sqlite3_db_mutex: function(p1: Psqlite3): Psqlite3_mutex; cdecl;
  sqlite3_file_control: function(p1: Psqlite3; const zDbName: PUTF8Char; op: Integer; p4: Pointer): Integer; cdecl;
  sqlite3_test_control: function(op: Integer): Integer varargs; cdecl;
  sqlite3_keyword_count: function(): Integer; cdecl;
  sqlite3_keyword_name: function(p1: Integer; p2: PPUTF8Char; p3: PInteger): Integer; cdecl;
  sqlite3_keyword_check: function(const p1: PUTF8Char; p2: Integer): Integer; cdecl;
  sqlite3_str_new: function(p1: Psqlite3): Psqlite3_str; cdecl;
  sqlite3_str_finish: function(p1: Psqlite3_str): PUTF8Char; cdecl;
  sqlite3_str_appendf: procedure(p1: Psqlite3_str; const zFormat: PUTF8Char) varargs; cdecl;
  sqlite3_str_vappendf: procedure(p1: Psqlite3_str; const zFormat: PUTF8Char; p3: Pointer); cdecl;
  sqlite3_str_append: procedure(p1: Psqlite3_str; const zIn: PUTF8Char; N: Integer); cdecl;
  sqlite3_str_appendall: procedure(p1: Psqlite3_str; const zIn: PUTF8Char); cdecl;
  sqlite3_str_appendchar: procedure(p1: Psqlite3_str; N: Integer; C: UTF8Char); cdecl;
  sqlite3_str_reset: procedure(p1: Psqlite3_str); cdecl;
  sqlite3_str_errcode: function(p1: Psqlite3_str): Integer; cdecl;
  sqlite3_str_length: function(p1: Psqlite3_str): Integer; cdecl;
  sqlite3_str_value: function(p1: Psqlite3_str): PUTF8Char; cdecl;
  sqlite3_status: function(op: Integer; pCurrent: PInteger; pHighwater: PInteger; resetFlag: Integer): Integer; cdecl;
  sqlite3_status64: function(op: Integer; pCurrent: Psqlite3_int64; pHighwater: Psqlite3_int64; resetFlag: Integer): Integer; cdecl;
  sqlite3_db_status: function(p1: Psqlite3; op: Integer; pCur: PInteger; pHiwtr: PInteger; resetFlg: Integer): Integer; cdecl;
  sqlite3_stmt_status: function(p1: Psqlite3_stmt; op: Integer; resetFlg: Integer): Integer; cdecl;
  sqlite3_backup_init: function(pDest: Psqlite3; const zDestName: PUTF8Char; pSource: Psqlite3; const zSourceName: PUTF8Char): Psqlite3_backup; cdecl;
  sqlite3_backup_step: function(p: Psqlite3_backup; nPage: Integer): Integer; cdecl;
  sqlite3_backup_finish: function(p: Psqlite3_backup): Integer; cdecl;
  sqlite3_backup_remaining: function(p: Psqlite3_backup): Integer; cdecl;
  sqlite3_backup_pagecount: function(p: Psqlite3_backup): Integer; cdecl;
  sqlite3_stricmp: function(const p1: PUTF8Char; const p2: PUTF8Char): Integer; cdecl;
  sqlite3_strnicmp: function(const p1: PUTF8Char; const p2: PUTF8Char; p3: Integer): Integer; cdecl;
  sqlite3_strglob: function(const zGlob: PUTF8Char; const zStr: PUTF8Char): Integer; cdecl;
  sqlite3_strlike: function(const zGlob: PUTF8Char; const zStr: PUTF8Char; cEsc: Cardinal): Integer; cdecl;
  sqlite3_log: procedure(iErrCode: Integer; const zFormat: PUTF8Char) varargs; cdecl;
  sqlite3_wal_hook: function(p1: Psqlite3; p2: sqlite3_wal_hook_; p3: Pointer): Pointer; cdecl;
  sqlite3_wal_autocheckpoint: function(db: Psqlite3; N: Integer): Integer; cdecl;
  sqlite3_wal_checkpoint: function(db: Psqlite3; const zDb: PUTF8Char): Integer; cdecl;
  sqlite3_wal_checkpoint_v2: function(db: Psqlite3; const zDb: PUTF8Char; eMode: Integer; pnLog: PInteger; pnCkpt: PInteger): Integer; cdecl;
  sqlite3_vtab_config: function(p1: Psqlite3; op: Integer): Integer varargs; cdecl;
  sqlite3_vtab_on_conflict: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_vtab_nochange: function(p1: Psqlite3_context): Integer; cdecl;
  sqlite3_vtab_collation: function(p1: Psqlite3_index_info; p2: Integer): PUTF8Char; cdecl;
  sqlite3_vtab_distinct: function(p1: Psqlite3_index_info): Integer; cdecl;
  sqlite3_vtab_in: function(p1: Psqlite3_index_info; iCons: Integer; bHandle: Integer): Integer; cdecl;
  sqlite3_vtab_in_first: function(pVal: Psqlite3_value; ppOut: PPsqlite3_value): Integer; cdecl;
  sqlite3_vtab_in_next: function(pVal: Psqlite3_value; ppOut: PPsqlite3_value): Integer; cdecl;
  sqlite3_vtab_rhs_value: function(p1: Psqlite3_index_info; p2: Integer; ppVal: PPsqlite3_value): Integer; cdecl;
  sqlite3_db_cacheflush: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_system_errno: function(p1: Psqlite3): Integer; cdecl;
  sqlite3_serialize: function(db: Psqlite3; const zSchema: PUTF8Char; piSize: Psqlite3_int64; mFlags: Cardinal): PByte; cdecl;
  sqlite3_deserialize: function(db: Psqlite3; const zSchema: PUTF8Char; pData: PByte; szDb: sqlite3_int64; szBuf: sqlite3_int64; mFlags: Cardinal): Integer; cdecl;

procedure GetExports(const aDLLHandle: THandle);

implementation

procedure GetExports(const aDLLHandle: THandle);
begin
  if aDllHandle = 0 then Exit;
  OgaAppendTokenSequence := GetProcAddress(aDLLHandle, 'OgaAppendTokenSequence');
  OgaAppendTokenToSequence := GetProcAddress(aDLLHandle, 'OgaAppendTokenToSequence');
  OgaConfigAppendProvider := GetProcAddress(aDLLHandle, 'OgaConfigAppendProvider');
  OgaConfigClearProviders := GetProcAddress(aDLLHandle, 'OgaConfigClearProviders');
  OgaConfigOverlay := GetProcAddress(aDLLHandle, 'OgaConfigOverlay');
  OgaConfigSetProviderOption := GetProcAddress(aDLLHandle, 'OgaConfigSetProviderOption');
  OgaCreateAdapters := GetProcAddress(aDLLHandle, 'OgaCreateAdapters');
  OgaCreateConfig := GetProcAddress(aDLLHandle, 'OgaCreateConfig');
  OgaCreateGenerator := GetProcAddress(aDLLHandle, 'OgaCreateGenerator');
  OgaCreateGeneratorParams := GetProcAddress(aDLLHandle, 'OgaCreateGeneratorParams');
  OgaCreateModel := GetProcAddress(aDLLHandle, 'OgaCreateModel');
  OgaCreateModelFromConfig := GetProcAddress(aDLLHandle, 'OgaCreateModelFromConfig');
  OgaCreateModelWithRuntimeSettings := GetProcAddress(aDLLHandle, 'OgaCreateModelWithRuntimeSettings');
  OgaCreateMultiModalProcessor := GetProcAddress(aDLLHandle, 'OgaCreateMultiModalProcessor');
  OgaCreateNamedTensors := GetProcAddress(aDLLHandle, 'OgaCreateNamedTensors');
  OgaCreateRuntimeSettings := GetProcAddress(aDLLHandle, 'OgaCreateRuntimeSettings');
  OgaCreateSequences := GetProcAddress(aDLLHandle, 'OgaCreateSequences');
  OgaCreateStringArray := GetProcAddress(aDLLHandle, 'OgaCreateStringArray');
  OgaCreateStringArrayFromStrings := GetProcAddress(aDLLHandle, 'OgaCreateStringArrayFromStrings');
  OgaCreateTensorFromBuffer := GetProcAddress(aDLLHandle, 'OgaCreateTensorFromBuffer');
  OgaCreateTokenizer := GetProcAddress(aDLLHandle, 'OgaCreateTokenizer');
  OgaCreateTokenizerStream := GetProcAddress(aDLLHandle, 'OgaCreateTokenizerStream');
  OgaCreateTokenizerStreamFromProcessor := GetProcAddress(aDLLHandle, 'OgaCreateTokenizerStreamFromProcessor');
  OgaDestroyAdapters := GetProcAddress(aDLLHandle, 'OgaDestroyAdapters');
  OgaDestroyAudios := GetProcAddress(aDLLHandle, 'OgaDestroyAudios');
  OgaDestroyConfig := GetProcAddress(aDLLHandle, 'OgaDestroyConfig');
  OgaDestroyGenerator := GetProcAddress(aDLLHandle, 'OgaDestroyGenerator');
  OgaDestroyGeneratorParams := GetProcAddress(aDLLHandle, 'OgaDestroyGeneratorParams');
  OgaDestroyImages := GetProcAddress(aDLLHandle, 'OgaDestroyImages');
  OgaDestroyModel := GetProcAddress(aDLLHandle, 'OgaDestroyModel');
  OgaDestroyMultiModalProcessor := GetProcAddress(aDLLHandle, 'OgaDestroyMultiModalProcessor');
  OgaDestroyNamedTensors := GetProcAddress(aDLLHandle, 'OgaDestroyNamedTensors');
  OgaDestroyResult := GetProcAddress(aDLLHandle, 'OgaDestroyResult');
  OgaDestroyRuntimeSettings := GetProcAddress(aDLLHandle, 'OgaDestroyRuntimeSettings');
  OgaDestroySequences := GetProcAddress(aDLLHandle, 'OgaDestroySequences');
  OgaDestroyString := GetProcAddress(aDLLHandle, 'OgaDestroyString');
  OgaDestroyStringArray := GetProcAddress(aDLLHandle, 'OgaDestroyStringArray');
  OgaDestroyTensor := GetProcAddress(aDLLHandle, 'OgaDestroyTensor');
  OgaDestroyTokenizer := GetProcAddress(aDLLHandle, 'OgaDestroyTokenizer');
  OgaDestroyTokenizerStream := GetProcAddress(aDLLHandle, 'OgaDestroyTokenizerStream');
  OgaGenerator_AppendTokens := GetProcAddress(aDLLHandle, 'OgaGenerator_AppendTokens');
  OgaGenerator_AppendTokenSequences := GetProcAddress(aDLLHandle, 'OgaGenerator_AppendTokenSequences');
  OgaGenerator_GenerateNextToken := GetProcAddress(aDLLHandle, 'OgaGenerator_GenerateNextToken');
  OgaGenerator_GetLogits := GetProcAddress(aDLLHandle, 'OgaGenerator_GetLogits');
  OgaGenerator_GetNextTokens := GetProcAddress(aDLLHandle, 'OgaGenerator_GetNextTokens');
  OgaGenerator_GetOutput := GetProcAddress(aDLLHandle, 'OgaGenerator_GetOutput');
  OgaGenerator_GetSequenceCount := GetProcAddress(aDLLHandle, 'OgaGenerator_GetSequenceCount');
  OgaGenerator_GetSequenceData := GetProcAddress(aDLLHandle, 'OgaGenerator_GetSequenceData');
  OgaGenerator_IsDone := GetProcAddress(aDLLHandle, 'OgaGenerator_IsDone');
  OgaGenerator_IsSessionTerminated := GetProcAddress(aDLLHandle, 'OgaGenerator_IsSessionTerminated');
  OgaGenerator_RewindTo := GetProcAddress(aDLLHandle, 'OgaGenerator_RewindTo');
  OgaGenerator_SetLogits := GetProcAddress(aDLLHandle, 'OgaGenerator_SetLogits');
  OgaGenerator_SetRuntimeOption := GetProcAddress(aDLLHandle, 'OgaGenerator_SetRuntimeOption');
  OgaGeneratorParamsSetInputs := GetProcAddress(aDLLHandle, 'OgaGeneratorParamsSetInputs');
  OgaGeneratorParamsSetModelInput := GetProcAddress(aDLLHandle, 'OgaGeneratorParamsSetModelInput');
  OgaGeneratorParamsSetSearchBool := GetProcAddress(aDLLHandle, 'OgaGeneratorParamsSetSearchBool');
  OgaGeneratorParamsSetSearchNumber := GetProcAddress(aDLLHandle, 'OgaGeneratorParamsSetSearchNumber');
  OgaGeneratorParamsSetWhisperInputFeatures := GetProcAddress(aDLLHandle, 'OgaGeneratorParamsSetWhisperInputFeatures');
  OgaGeneratorParamsTryGraphCaptureWithMaxBatchSize := GetProcAddress(aDLLHandle, 'OgaGeneratorParamsTryGraphCaptureWithMaxBatchSize');
  OgaGetCurrentGpuDeviceId := GetProcAddress(aDLLHandle, 'OgaGetCurrentGpuDeviceId');
  OgaLoadAdapter := GetProcAddress(aDLLHandle, 'OgaLoadAdapter');
  OgaLoadAudio := GetProcAddress(aDLLHandle, 'OgaLoadAudio');
  OgaLoadAudios := GetProcAddress(aDLLHandle, 'OgaLoadAudios');
  OgaLoadAudiosFromBuffers := GetProcAddress(aDLLHandle, 'OgaLoadAudiosFromBuffers');
  OgaLoadImage := GetProcAddress(aDLLHandle, 'OgaLoadImage');
  OgaLoadImages := GetProcAddress(aDLLHandle, 'OgaLoadImages');
  OgaLoadImagesFromBuffers := GetProcAddress(aDLLHandle, 'OgaLoadImagesFromBuffers');
  OgaModelGetDeviceType := GetProcAddress(aDLLHandle, 'OgaModelGetDeviceType');
  OgaModelGetType := GetProcAddress(aDLLHandle, 'OgaModelGetType');
  OgaNamedTensorsCount := GetProcAddress(aDLLHandle, 'OgaNamedTensorsCount');
  OgaNamedTensorsDelete := GetProcAddress(aDLLHandle, 'OgaNamedTensorsDelete');
  OgaNamedTensorsGet := GetProcAddress(aDLLHandle, 'OgaNamedTensorsGet');
  OgaNamedTensorsGetNames := GetProcAddress(aDLLHandle, 'OgaNamedTensorsGetNames');
  OgaNamedTensorsSet := GetProcAddress(aDLLHandle, 'OgaNamedTensorsSet');
  OgaProcessorDecode := GetProcAddress(aDLLHandle, 'OgaProcessorDecode');
  OgaProcessorProcessAudios := GetProcAddress(aDLLHandle, 'OgaProcessorProcessAudios');
  OgaProcessorProcessImages := GetProcAddress(aDLLHandle, 'OgaProcessorProcessImages');
  OgaProcessorProcessImagesAndAudios := GetProcAddress(aDLLHandle, 'OgaProcessorProcessImagesAndAudios');
  OgaResultGetError := GetProcAddress(aDLLHandle, 'OgaResultGetError');
  OgaRuntimeSettingsSetHandle := GetProcAddress(aDLLHandle, 'OgaRuntimeSettingsSetHandle');
  OgaSequencesCount := GetProcAddress(aDLLHandle, 'OgaSequencesCount');
  OgaSequencesGetSequenceCount := GetProcAddress(aDLLHandle, 'OgaSequencesGetSequenceCount');
  OgaSequencesGetSequenceData := GetProcAddress(aDLLHandle, 'OgaSequencesGetSequenceData');
  OgaSetActiveAdapter := GetProcAddress(aDLLHandle, 'OgaSetActiveAdapter');
  OgaSetCurrentGpuDeviceId := GetProcAddress(aDLLHandle, 'OgaSetCurrentGpuDeviceId');
  OgaSetLogBool := GetProcAddress(aDLLHandle, 'OgaSetLogBool');
  OgaSetLogString := GetProcAddress(aDLLHandle, 'OgaSetLogString');
  OgaShutdown := GetProcAddress(aDLLHandle, 'OgaShutdown');
  OgaStringArrayAddString := GetProcAddress(aDLLHandle, 'OgaStringArrayAddString');
  OgaStringArrayGetCount := GetProcAddress(aDLLHandle, 'OgaStringArrayGetCount');
  OgaStringArrayGetString := GetProcAddress(aDLLHandle, 'OgaStringArrayGetString');
  OgaTensorGetData := GetProcAddress(aDLLHandle, 'OgaTensorGetData');
  OgaTensorGetShape := GetProcAddress(aDLLHandle, 'OgaTensorGetShape');
  OgaTensorGetShapeRank := GetProcAddress(aDLLHandle, 'OgaTensorGetShapeRank');
  OgaTensorGetType := GetProcAddress(aDLLHandle, 'OgaTensorGetType');
  OgaTokenizerDecode := GetProcAddress(aDLLHandle, 'OgaTokenizerDecode');
  OgaTokenizerDecodeBatch := GetProcAddress(aDLLHandle, 'OgaTokenizerDecodeBatch');
  OgaTokenizerEncode := GetProcAddress(aDLLHandle, 'OgaTokenizerEncode');
  OgaTokenizerEncodeBatch := GetProcAddress(aDLLHandle, 'OgaTokenizerEncodeBatch');
  OgaTokenizerStreamDecode := GetProcAddress(aDLLHandle, 'OgaTokenizerStreamDecode');
  OgaTokenizerToTokenId := GetProcAddress(aDLLHandle, 'OgaTokenizerToTokenId');
  OgaUnloadAdapter := GetProcAddress(aDLLHandle, 'OgaUnloadAdapter');
  sqlite3_aggregate_context := GetProcAddress(aDLLHandle, 'sqlite3_aggregate_context');
  sqlite3_aggregate_count := GetProcAddress(aDLLHandle, 'sqlite3_aggregate_count');
  sqlite3_auto_extension := GetProcAddress(aDLLHandle, 'sqlite3_auto_extension');
  sqlite3_autovacuum_pages := GetProcAddress(aDLLHandle, 'sqlite3_autovacuum_pages');
  sqlite3_backup_finish := GetProcAddress(aDLLHandle, 'sqlite3_backup_finish');
  sqlite3_backup_init := GetProcAddress(aDLLHandle, 'sqlite3_backup_init');
  sqlite3_backup_pagecount := GetProcAddress(aDLLHandle, 'sqlite3_backup_pagecount');
  sqlite3_backup_remaining := GetProcAddress(aDLLHandle, 'sqlite3_backup_remaining');
  sqlite3_backup_step := GetProcAddress(aDLLHandle, 'sqlite3_backup_step');
  sqlite3_bind_blob := GetProcAddress(aDLLHandle, 'sqlite3_bind_blob');
  sqlite3_bind_blob64 := GetProcAddress(aDLLHandle, 'sqlite3_bind_blob64');
  sqlite3_bind_double := GetProcAddress(aDLLHandle, 'sqlite3_bind_double');
  sqlite3_bind_int := GetProcAddress(aDLLHandle, 'sqlite3_bind_int');
  sqlite3_bind_int64 := GetProcAddress(aDLLHandle, 'sqlite3_bind_int64');
  sqlite3_bind_null := GetProcAddress(aDLLHandle, 'sqlite3_bind_null');
  sqlite3_bind_parameter_count := GetProcAddress(aDLLHandle, 'sqlite3_bind_parameter_count');
  sqlite3_bind_parameter_index := GetProcAddress(aDLLHandle, 'sqlite3_bind_parameter_index');
  sqlite3_bind_parameter_name := GetProcAddress(aDLLHandle, 'sqlite3_bind_parameter_name');
  sqlite3_bind_pointer := GetProcAddress(aDLLHandle, 'sqlite3_bind_pointer');
  sqlite3_bind_text := GetProcAddress(aDLLHandle, 'sqlite3_bind_text');
  sqlite3_bind_text16 := GetProcAddress(aDLLHandle, 'sqlite3_bind_text16');
  sqlite3_bind_text64 := GetProcAddress(aDLLHandle, 'sqlite3_bind_text64');
  sqlite3_bind_value := GetProcAddress(aDLLHandle, 'sqlite3_bind_value');
  sqlite3_bind_zeroblob := GetProcAddress(aDLLHandle, 'sqlite3_bind_zeroblob');
  sqlite3_bind_zeroblob64 := GetProcAddress(aDLLHandle, 'sqlite3_bind_zeroblob64');
  sqlite3_blob_bytes := GetProcAddress(aDLLHandle, 'sqlite3_blob_bytes');
  sqlite3_blob_close := GetProcAddress(aDLLHandle, 'sqlite3_blob_close');
  sqlite3_blob_open := GetProcAddress(aDLLHandle, 'sqlite3_blob_open');
  sqlite3_blob_read := GetProcAddress(aDLLHandle, 'sqlite3_blob_read');
  sqlite3_blob_reopen := GetProcAddress(aDLLHandle, 'sqlite3_blob_reopen');
  sqlite3_blob_write := GetProcAddress(aDLLHandle, 'sqlite3_blob_write');
  sqlite3_busy_handler := GetProcAddress(aDLLHandle, 'sqlite3_busy_handler');
  sqlite3_busy_timeout := GetProcAddress(aDLLHandle, 'sqlite3_busy_timeout');
  sqlite3_cancel_auto_extension := GetProcAddress(aDLLHandle, 'sqlite3_cancel_auto_extension');
  sqlite3_changes := GetProcAddress(aDLLHandle, 'sqlite3_changes');
  sqlite3_changes64 := GetProcAddress(aDLLHandle, 'sqlite3_changes64');
  sqlite3_clear_bindings := GetProcAddress(aDLLHandle, 'sqlite3_clear_bindings');
  sqlite3_close := GetProcAddress(aDLLHandle, 'sqlite3_close');
  sqlite3_close_v2 := GetProcAddress(aDLLHandle, 'sqlite3_close_v2');
  sqlite3_collation_needed := GetProcAddress(aDLLHandle, 'sqlite3_collation_needed');
  sqlite3_collation_needed16 := GetProcAddress(aDLLHandle, 'sqlite3_collation_needed16');
  sqlite3_column_blob := GetProcAddress(aDLLHandle, 'sqlite3_column_blob');
  sqlite3_column_bytes := GetProcAddress(aDLLHandle, 'sqlite3_column_bytes');
  sqlite3_column_bytes16 := GetProcAddress(aDLLHandle, 'sqlite3_column_bytes16');
  sqlite3_column_count := GetProcAddress(aDLLHandle, 'sqlite3_column_count');
  sqlite3_column_database_name := GetProcAddress(aDLLHandle, 'sqlite3_column_database_name');
  sqlite3_column_database_name16 := GetProcAddress(aDLLHandle, 'sqlite3_column_database_name16');
  sqlite3_column_decltype := GetProcAddress(aDLLHandle, 'sqlite3_column_decltype');
  sqlite3_column_decltype16 := GetProcAddress(aDLLHandle, 'sqlite3_column_decltype16');
  sqlite3_column_double := GetProcAddress(aDLLHandle, 'sqlite3_column_double');
  sqlite3_column_int := GetProcAddress(aDLLHandle, 'sqlite3_column_int');
  sqlite3_column_int64 := GetProcAddress(aDLLHandle, 'sqlite3_column_int64');
  sqlite3_column_name := GetProcAddress(aDLLHandle, 'sqlite3_column_name');
  sqlite3_column_name16 := GetProcAddress(aDLLHandle, 'sqlite3_column_name16');
  sqlite3_column_origin_name := GetProcAddress(aDLLHandle, 'sqlite3_column_origin_name');
  sqlite3_column_origin_name16 := GetProcAddress(aDLLHandle, 'sqlite3_column_origin_name16');
  sqlite3_column_table_name := GetProcAddress(aDLLHandle, 'sqlite3_column_table_name');
  sqlite3_column_table_name16 := GetProcAddress(aDLLHandle, 'sqlite3_column_table_name16');
  sqlite3_column_text := GetProcAddress(aDLLHandle, 'sqlite3_column_text');
  sqlite3_column_text16 := GetProcAddress(aDLLHandle, 'sqlite3_column_text16');
  sqlite3_column_type := GetProcAddress(aDLLHandle, 'sqlite3_column_type');
  sqlite3_column_value := GetProcAddress(aDLLHandle, 'sqlite3_column_value');
  sqlite3_commit_hook := GetProcAddress(aDLLHandle, 'sqlite3_commit_hook');
  sqlite3_compileoption_get := GetProcAddress(aDLLHandle, 'sqlite3_compileoption_get');
  sqlite3_compileoption_used := GetProcAddress(aDLLHandle, 'sqlite3_compileoption_used');
  sqlite3_complete := GetProcAddress(aDLLHandle, 'sqlite3_complete');
  sqlite3_complete16 := GetProcAddress(aDLLHandle, 'sqlite3_complete16');
  sqlite3_config := GetProcAddress(aDLLHandle, 'sqlite3_config');
  sqlite3_context_db_handle := GetProcAddress(aDLLHandle, 'sqlite3_context_db_handle');
  sqlite3_create_collation := GetProcAddress(aDLLHandle, 'sqlite3_create_collation');
  sqlite3_create_collation_v2 := GetProcAddress(aDLLHandle, 'sqlite3_create_collation_v2');
  sqlite3_create_collation16 := GetProcAddress(aDLLHandle, 'sqlite3_create_collation16');
  sqlite3_create_filename := GetProcAddress(aDLLHandle, 'sqlite3_create_filename');
  sqlite3_create_function := GetProcAddress(aDLLHandle, 'sqlite3_create_function');
  sqlite3_create_function_v2 := GetProcAddress(aDLLHandle, 'sqlite3_create_function_v2');
  sqlite3_create_function16 := GetProcAddress(aDLLHandle, 'sqlite3_create_function16');
  sqlite3_create_module := GetProcAddress(aDLLHandle, 'sqlite3_create_module');
  sqlite3_create_module_v2 := GetProcAddress(aDLLHandle, 'sqlite3_create_module_v2');
  sqlite3_create_window_function := GetProcAddress(aDLLHandle, 'sqlite3_create_window_function');
  sqlite3_data_count := GetProcAddress(aDLLHandle, 'sqlite3_data_count');
  sqlite3_database_file_object := GetProcAddress(aDLLHandle, 'sqlite3_database_file_object');
  sqlite3_db_cacheflush := GetProcAddress(aDLLHandle, 'sqlite3_db_cacheflush');
  sqlite3_db_config := GetProcAddress(aDLLHandle, 'sqlite3_db_config');
  sqlite3_db_filename := GetProcAddress(aDLLHandle, 'sqlite3_db_filename');
  sqlite3_db_handle := GetProcAddress(aDLLHandle, 'sqlite3_db_handle');
  sqlite3_db_mutex := GetProcAddress(aDLLHandle, 'sqlite3_db_mutex');
  sqlite3_db_name := GetProcAddress(aDLLHandle, 'sqlite3_db_name');
  sqlite3_db_readonly := GetProcAddress(aDLLHandle, 'sqlite3_db_readonly');
  sqlite3_db_release_memory := GetProcAddress(aDLLHandle, 'sqlite3_db_release_memory');
  sqlite3_db_status := GetProcAddress(aDLLHandle, 'sqlite3_db_status');
  sqlite3_declare_vtab := GetProcAddress(aDLLHandle, 'sqlite3_declare_vtab');
  sqlite3_deserialize := GetProcAddress(aDLLHandle, 'sqlite3_deserialize');
  sqlite3_drop_modules := GetProcAddress(aDLLHandle, 'sqlite3_drop_modules');
  sqlite3_enable_shared_cache := GetProcAddress(aDLLHandle, 'sqlite3_enable_shared_cache');
  sqlite3_errcode := GetProcAddress(aDLLHandle, 'sqlite3_errcode');
  sqlite3_errmsg := GetProcAddress(aDLLHandle, 'sqlite3_errmsg');
  sqlite3_errmsg16 := GetProcAddress(aDLLHandle, 'sqlite3_errmsg16');
  sqlite3_error_offset := GetProcAddress(aDLLHandle, 'sqlite3_error_offset');
  sqlite3_errstr := GetProcAddress(aDLLHandle, 'sqlite3_errstr');
  sqlite3_exec := GetProcAddress(aDLLHandle, 'sqlite3_exec');
  sqlite3_expanded_sql := GetProcAddress(aDLLHandle, 'sqlite3_expanded_sql');
  sqlite3_expired := GetProcAddress(aDLLHandle, 'sqlite3_expired');
  sqlite3_extended_errcode := GetProcAddress(aDLLHandle, 'sqlite3_extended_errcode');
  sqlite3_extended_result_codes := GetProcAddress(aDLLHandle, 'sqlite3_extended_result_codes');
  sqlite3_file_control := GetProcAddress(aDLLHandle, 'sqlite3_file_control');
  sqlite3_filename_database := GetProcAddress(aDLLHandle, 'sqlite3_filename_database');
  sqlite3_filename_journal := GetProcAddress(aDLLHandle, 'sqlite3_filename_journal');
  sqlite3_filename_wal := GetProcAddress(aDLLHandle, 'sqlite3_filename_wal');
  sqlite3_finalize := GetProcAddress(aDLLHandle, 'sqlite3_finalize');
  sqlite3_free := GetProcAddress(aDLLHandle, 'sqlite3_free');
  sqlite3_free_filename := GetProcAddress(aDLLHandle, 'sqlite3_free_filename');
  sqlite3_free_table := GetProcAddress(aDLLHandle, 'sqlite3_free_table');
  sqlite3_get_autocommit := GetProcAddress(aDLLHandle, 'sqlite3_get_autocommit');
  sqlite3_get_auxdata := GetProcAddress(aDLLHandle, 'sqlite3_get_auxdata');
  sqlite3_get_clientdata := GetProcAddress(aDLLHandle, 'sqlite3_get_clientdata');
  sqlite3_get_table := GetProcAddress(aDLLHandle, 'sqlite3_get_table');
  sqlite3_global_recover := GetProcAddress(aDLLHandle, 'sqlite3_global_recover');
  sqlite3_hard_heap_limit64 := GetProcAddress(aDLLHandle, 'sqlite3_hard_heap_limit64');
  sqlite3_initialize := GetProcAddress(aDLLHandle, 'sqlite3_initialize');
  sqlite3_interrupt := GetProcAddress(aDLLHandle, 'sqlite3_interrupt');
  sqlite3_is_interrupted := GetProcAddress(aDLLHandle, 'sqlite3_is_interrupted');
  sqlite3_keyword_check := GetProcAddress(aDLLHandle, 'sqlite3_keyword_check');
  sqlite3_keyword_count := GetProcAddress(aDLLHandle, 'sqlite3_keyword_count');
  sqlite3_keyword_name := GetProcAddress(aDLLHandle, 'sqlite3_keyword_name');
  sqlite3_last_insert_rowid := GetProcAddress(aDLLHandle, 'sqlite3_last_insert_rowid');
  sqlite3_libversion := GetProcAddress(aDLLHandle, 'sqlite3_libversion');
  sqlite3_libversion_number := GetProcAddress(aDLLHandle, 'sqlite3_libversion_number');
  sqlite3_limit := GetProcAddress(aDLLHandle, 'sqlite3_limit');
  sqlite3_log := GetProcAddress(aDLLHandle, 'sqlite3_log');
  sqlite3_malloc := GetProcAddress(aDLLHandle, 'sqlite3_malloc');
  sqlite3_malloc64 := GetProcAddress(aDLLHandle, 'sqlite3_malloc64');
  sqlite3_memory_alarm := GetProcAddress(aDLLHandle, 'sqlite3_memory_alarm');
  sqlite3_memory_highwater := GetProcAddress(aDLLHandle, 'sqlite3_memory_highwater');
  sqlite3_memory_used := GetProcAddress(aDLLHandle, 'sqlite3_memory_used');
  sqlite3_mprintf := GetProcAddress(aDLLHandle, 'sqlite3_mprintf');
  sqlite3_msize := GetProcAddress(aDLLHandle, 'sqlite3_msize');
  sqlite3_mutex_alloc := GetProcAddress(aDLLHandle, 'sqlite3_mutex_alloc');
  sqlite3_mutex_enter := GetProcAddress(aDLLHandle, 'sqlite3_mutex_enter');
  sqlite3_mutex_free := GetProcAddress(aDLLHandle, 'sqlite3_mutex_free');
  sqlite3_mutex_leave := GetProcAddress(aDLLHandle, 'sqlite3_mutex_leave');
  sqlite3_mutex_try := GetProcAddress(aDLLHandle, 'sqlite3_mutex_try');
  sqlite3_next_stmt := GetProcAddress(aDLLHandle, 'sqlite3_next_stmt');
  sqlite3_open := GetProcAddress(aDLLHandle, 'sqlite3_open');
  sqlite3_open_v2 := GetProcAddress(aDLLHandle, 'sqlite3_open_v2');
  sqlite3_open16 := GetProcAddress(aDLLHandle, 'sqlite3_open16');
  sqlite3_os_end := GetProcAddress(aDLLHandle, 'sqlite3_os_end');
  sqlite3_os_init := GetProcAddress(aDLLHandle, 'sqlite3_os_init');
  sqlite3_overload_function := GetProcAddress(aDLLHandle, 'sqlite3_overload_function');
  sqlite3_prepare := GetProcAddress(aDLLHandle, 'sqlite3_prepare');
  sqlite3_prepare_v2 := GetProcAddress(aDLLHandle, 'sqlite3_prepare_v2');
  sqlite3_prepare_v3 := GetProcAddress(aDLLHandle, 'sqlite3_prepare_v3');
  sqlite3_prepare16 := GetProcAddress(aDLLHandle, 'sqlite3_prepare16');
  sqlite3_prepare16_v2 := GetProcAddress(aDLLHandle, 'sqlite3_prepare16_v2');
  sqlite3_prepare16_v3 := GetProcAddress(aDLLHandle, 'sqlite3_prepare16_v3');
  sqlite3_profile := GetProcAddress(aDLLHandle, 'sqlite3_profile');
  sqlite3_progress_handler := GetProcAddress(aDLLHandle, 'sqlite3_progress_handler');
  sqlite3_randomness := GetProcAddress(aDLLHandle, 'sqlite3_randomness');
  sqlite3_realloc := GetProcAddress(aDLLHandle, 'sqlite3_realloc');
  sqlite3_realloc64 := GetProcAddress(aDLLHandle, 'sqlite3_realloc64');
  sqlite3_release_memory := GetProcAddress(aDLLHandle, 'sqlite3_release_memory');
  sqlite3_reset := GetProcAddress(aDLLHandle, 'sqlite3_reset');
  sqlite3_reset_auto_extension := GetProcAddress(aDLLHandle, 'sqlite3_reset_auto_extension');
  sqlite3_result_blob := GetProcAddress(aDLLHandle, 'sqlite3_result_blob');
  sqlite3_result_blob64 := GetProcAddress(aDLLHandle, 'sqlite3_result_blob64');
  sqlite3_result_double := GetProcAddress(aDLLHandle, 'sqlite3_result_double');
  sqlite3_result_error := GetProcAddress(aDLLHandle, 'sqlite3_result_error');
  sqlite3_result_error_code := GetProcAddress(aDLLHandle, 'sqlite3_result_error_code');
  sqlite3_result_error_nomem := GetProcAddress(aDLLHandle, 'sqlite3_result_error_nomem');
  sqlite3_result_error_toobig := GetProcAddress(aDLLHandle, 'sqlite3_result_error_toobig');
  sqlite3_result_error16 := GetProcAddress(aDLLHandle, 'sqlite3_result_error16');
  sqlite3_result_int := GetProcAddress(aDLLHandle, 'sqlite3_result_int');
  sqlite3_result_int64 := GetProcAddress(aDLLHandle, 'sqlite3_result_int64');
  sqlite3_result_null := GetProcAddress(aDLLHandle, 'sqlite3_result_null');
  sqlite3_result_pointer := GetProcAddress(aDLLHandle, 'sqlite3_result_pointer');
  sqlite3_result_subtype := GetProcAddress(aDLLHandle, 'sqlite3_result_subtype');
  sqlite3_result_text := GetProcAddress(aDLLHandle, 'sqlite3_result_text');
  sqlite3_result_text16 := GetProcAddress(aDLLHandle, 'sqlite3_result_text16');
  sqlite3_result_text16be := GetProcAddress(aDLLHandle, 'sqlite3_result_text16be');
  sqlite3_result_text16le := GetProcAddress(aDLLHandle, 'sqlite3_result_text16le');
  sqlite3_result_text64 := GetProcAddress(aDLLHandle, 'sqlite3_result_text64');
  sqlite3_result_value := GetProcAddress(aDLLHandle, 'sqlite3_result_value');
  sqlite3_result_zeroblob := GetProcAddress(aDLLHandle, 'sqlite3_result_zeroblob');
  sqlite3_result_zeroblob64 := GetProcAddress(aDLLHandle, 'sqlite3_result_zeroblob64');
  sqlite3_rollback_hook := GetProcAddress(aDLLHandle, 'sqlite3_rollback_hook');
  sqlite3_serialize := GetProcAddress(aDLLHandle, 'sqlite3_serialize');
  sqlite3_set_authorizer := GetProcAddress(aDLLHandle, 'sqlite3_set_authorizer');
  sqlite3_set_auxdata := GetProcAddress(aDLLHandle, 'sqlite3_set_auxdata');
  sqlite3_set_clientdata := GetProcAddress(aDLLHandle, 'sqlite3_set_clientdata');
  sqlite3_set_last_insert_rowid := GetProcAddress(aDLLHandle, 'sqlite3_set_last_insert_rowid');
  sqlite3_shutdown := GetProcAddress(aDLLHandle, 'sqlite3_shutdown');
  sqlite3_sleep := GetProcAddress(aDLLHandle, 'sqlite3_sleep');
  sqlite3_snprintf := GetProcAddress(aDLLHandle, 'sqlite3_snprintf');
  sqlite3_soft_heap_limit := GetProcAddress(aDLLHandle, 'sqlite3_soft_heap_limit');
  sqlite3_soft_heap_limit64 := GetProcAddress(aDLLHandle, 'sqlite3_soft_heap_limit64');
  sqlite3_sourceid := GetProcAddress(aDLLHandle, 'sqlite3_sourceid');
  sqlite3_sql := GetProcAddress(aDLLHandle, 'sqlite3_sql');
  sqlite3_status := GetProcAddress(aDLLHandle, 'sqlite3_status');
  sqlite3_status64 := GetProcAddress(aDLLHandle, 'sqlite3_status64');
  sqlite3_step := GetProcAddress(aDLLHandle, 'sqlite3_step');
  sqlite3_stmt_busy := GetProcAddress(aDLLHandle, 'sqlite3_stmt_busy');
  sqlite3_stmt_explain := GetProcAddress(aDLLHandle, 'sqlite3_stmt_explain');
  sqlite3_stmt_isexplain := GetProcAddress(aDLLHandle, 'sqlite3_stmt_isexplain');
  sqlite3_stmt_readonly := GetProcAddress(aDLLHandle, 'sqlite3_stmt_readonly');
  sqlite3_stmt_status := GetProcAddress(aDLLHandle, 'sqlite3_stmt_status');
  sqlite3_str_append := GetProcAddress(aDLLHandle, 'sqlite3_str_append');
  sqlite3_str_appendall := GetProcAddress(aDLLHandle, 'sqlite3_str_appendall');
  sqlite3_str_appendchar := GetProcAddress(aDLLHandle, 'sqlite3_str_appendchar');
  sqlite3_str_appendf := GetProcAddress(aDLLHandle, 'sqlite3_str_appendf');
  sqlite3_str_errcode := GetProcAddress(aDLLHandle, 'sqlite3_str_errcode');
  sqlite3_str_finish := GetProcAddress(aDLLHandle, 'sqlite3_str_finish');
  sqlite3_str_length := GetProcAddress(aDLLHandle, 'sqlite3_str_length');
  sqlite3_str_new := GetProcAddress(aDLLHandle, 'sqlite3_str_new');
  sqlite3_str_reset := GetProcAddress(aDLLHandle, 'sqlite3_str_reset');
  sqlite3_str_value := GetProcAddress(aDLLHandle, 'sqlite3_str_value');
  sqlite3_str_vappendf := GetProcAddress(aDLLHandle, 'sqlite3_str_vappendf');
  sqlite3_strglob := GetProcAddress(aDLLHandle, 'sqlite3_strglob');
  sqlite3_stricmp := GetProcAddress(aDLLHandle, 'sqlite3_stricmp');
  sqlite3_strlike := GetProcAddress(aDLLHandle, 'sqlite3_strlike');
  sqlite3_strnicmp := GetProcAddress(aDLLHandle, 'sqlite3_strnicmp');
  sqlite3_system_errno := GetProcAddress(aDLLHandle, 'sqlite3_system_errno');
  sqlite3_table_column_metadata := GetProcAddress(aDLLHandle, 'sqlite3_table_column_metadata');
  sqlite3_test_control := GetProcAddress(aDLLHandle, 'sqlite3_test_control');
  sqlite3_thread_cleanup := GetProcAddress(aDLLHandle, 'sqlite3_thread_cleanup');
  sqlite3_threadsafe := GetProcAddress(aDLLHandle, 'sqlite3_threadsafe');
  sqlite3_total_changes := GetProcAddress(aDLLHandle, 'sqlite3_total_changes');
  sqlite3_total_changes64 := GetProcAddress(aDLLHandle, 'sqlite3_total_changes64');
  sqlite3_trace := GetProcAddress(aDLLHandle, 'sqlite3_trace');
  sqlite3_trace_v2 := GetProcAddress(aDLLHandle, 'sqlite3_trace_v2');
  sqlite3_transfer_bindings := GetProcAddress(aDLLHandle, 'sqlite3_transfer_bindings');
  sqlite3_txn_state := GetProcAddress(aDLLHandle, 'sqlite3_txn_state');
  sqlite3_update_hook := GetProcAddress(aDLLHandle, 'sqlite3_update_hook');
  sqlite3_uri_boolean := GetProcAddress(aDLLHandle, 'sqlite3_uri_boolean');
  sqlite3_uri_int64 := GetProcAddress(aDLLHandle, 'sqlite3_uri_int64');
  sqlite3_uri_key := GetProcAddress(aDLLHandle, 'sqlite3_uri_key');
  sqlite3_uri_parameter := GetProcAddress(aDLLHandle, 'sqlite3_uri_parameter');
  sqlite3_user_data := GetProcAddress(aDLLHandle, 'sqlite3_user_data');
  sqlite3_value_blob := GetProcAddress(aDLLHandle, 'sqlite3_value_blob');
  sqlite3_value_bytes := GetProcAddress(aDLLHandle, 'sqlite3_value_bytes');
  sqlite3_value_bytes16 := GetProcAddress(aDLLHandle, 'sqlite3_value_bytes16');
  sqlite3_value_double := GetProcAddress(aDLLHandle, 'sqlite3_value_double');
  sqlite3_value_dup := GetProcAddress(aDLLHandle, 'sqlite3_value_dup');
  sqlite3_value_encoding := GetProcAddress(aDLLHandle, 'sqlite3_value_encoding');
  sqlite3_value_free := GetProcAddress(aDLLHandle, 'sqlite3_value_free');
  sqlite3_value_frombind := GetProcAddress(aDLLHandle, 'sqlite3_value_frombind');
  sqlite3_value_int := GetProcAddress(aDLLHandle, 'sqlite3_value_int');
  sqlite3_value_int64 := GetProcAddress(aDLLHandle, 'sqlite3_value_int64');
  sqlite3_value_nochange := GetProcAddress(aDLLHandle, 'sqlite3_value_nochange');
  sqlite3_value_numeric_type := GetProcAddress(aDLLHandle, 'sqlite3_value_numeric_type');
  sqlite3_value_pointer := GetProcAddress(aDLLHandle, 'sqlite3_value_pointer');
  sqlite3_value_subtype := GetProcAddress(aDLLHandle, 'sqlite3_value_subtype');
  sqlite3_value_text := GetProcAddress(aDLLHandle, 'sqlite3_value_text');
  sqlite3_value_text16 := GetProcAddress(aDLLHandle, 'sqlite3_value_text16');
  sqlite3_value_text16be := GetProcAddress(aDLLHandle, 'sqlite3_value_text16be');
  sqlite3_value_text16le := GetProcAddress(aDLLHandle, 'sqlite3_value_text16le');
  sqlite3_value_type := GetProcAddress(aDLLHandle, 'sqlite3_value_type');
  sqlite3_vfs_find := GetProcAddress(aDLLHandle, 'sqlite3_vfs_find');
  sqlite3_vfs_register := GetProcAddress(aDLLHandle, 'sqlite3_vfs_register');
  sqlite3_vfs_unregister := GetProcAddress(aDLLHandle, 'sqlite3_vfs_unregister');
  sqlite3_vmprintf := GetProcAddress(aDLLHandle, 'sqlite3_vmprintf');
  sqlite3_vsnprintf := GetProcAddress(aDLLHandle, 'sqlite3_vsnprintf');
  sqlite3_vtab_collation := GetProcAddress(aDLLHandle, 'sqlite3_vtab_collation');
  sqlite3_vtab_config := GetProcAddress(aDLLHandle, 'sqlite3_vtab_config');
  sqlite3_vtab_distinct := GetProcAddress(aDLLHandle, 'sqlite3_vtab_distinct');
  sqlite3_vtab_in := GetProcAddress(aDLLHandle, 'sqlite3_vtab_in');
  sqlite3_vtab_in_first := GetProcAddress(aDLLHandle, 'sqlite3_vtab_in_first');
  sqlite3_vtab_in_next := GetProcAddress(aDLLHandle, 'sqlite3_vtab_in_next');
  sqlite3_vtab_nochange := GetProcAddress(aDLLHandle, 'sqlite3_vtab_nochange');
  sqlite3_vtab_on_conflict := GetProcAddress(aDLLHandle, 'sqlite3_vtab_on_conflict');
  sqlite3_vtab_rhs_value := GetProcAddress(aDLLHandle, 'sqlite3_vtab_rhs_value');
  sqlite3_wal_autocheckpoint := GetProcAddress(aDLLHandle, 'sqlite3_wal_autocheckpoint');
  sqlite3_wal_checkpoint := GetProcAddress(aDLLHandle, 'sqlite3_wal_checkpoint');
  sqlite3_wal_checkpoint_v2 := GetProcAddress(aDLLHandle, 'sqlite3_wal_checkpoint_v2');
  sqlite3_wal_hook := GetProcAddress(aDLLHandle, 'sqlite3_wal_hook');
  sqlite3_win32_set_directory := GetProcAddress(aDLLHandle, 'sqlite3_win32_set_directory');
  sqlite3_win32_set_directory16 := GetProcAddress(aDLLHandle, 'sqlite3_win32_set_directory16');
  sqlite3_win32_set_directory8 := GetProcAddress(aDLLHandle, 'sqlite3_win32_set_directory8');
end;

end.
