-- Drop child tables first due to FK dependencies
DROP TABLE TBMonitorDatabaseState;
DROP TABLE EventViewerAlertHistory;
DROP TABLE TBIndicator;
DROP TABLE TBMONITORWORKLOAD;
DROP TABLE TBMonitorServicePackTable;
DROP TABLE HWM_LOG;
DROP TABLE TBMonitorBatchRequestTable;
DROP TABLE AlertStatusServiceOracleTable;
DROP TABLE TopQueryPerformanceLog;
DROP TABLE JobStatus;
DROP TABLE ServiceStatus;
DROP TABLE BackupHistory;
DROP TABLE BackupsDetails;
DROP TABLE LockTypes;
DROP TABLE UndoUsageSessions;
DROP TABLE UsageTempTables;
DROP TABLE SQLConfigurationTable;
DROP TABLE IF EXISTS ActivityMonitorProcesses CASCADE;
DROP TABLE IF EXISTS deadlock_reports CASCADE;
DROP TABLE IF EXISTS ActiveTransactionsInfo CASCADE;
DROP TABLE IF EXISTS IndexesInfo CASCADE;
DROP TABLE IF EXISTS TablesInfo CASCADE;
DROP TABLE IF EXISTS TransactionLogsTableInfo CASCADE;
DROP TABLE IF EXISTS TBMonitorBackupStatus CASCADE;
DROP TABLE IF EXISTS LogFilesTableInfo CASCADE;
DROP TABLE IF EXISTS DataFilesTableInfo CASCADE;
DROP TABLE IF EXISTS DatabasesTableInfo CASCADE;
DROP TABLE IF EXISTS TBMonitorMemory CASCADE;
DROP TABLE IF EXISTS TBMonitorCpuUsage CASCADE;
DROP TABLE IF EXISTS TBMonitorCPU CASCADE;
DROP TABLE IF EXISTS TBMonitorAudit CASCADE;
DROP TABLE IF EXISTS StatusServiceSQLTable CASCADE;
DROP TABLE IF EXISTS TBMonitorSqlCompilationTable CASCADE;
DROP TABLE IF EXISTS Region CASCADE;
DROP TABLE IF EXISTS QueryBydurationTable CASCADE;
DROP TABLE IF EXISTS TBMonitorBlocsTable CASCADE;
DROP TABLE IF EXISTS TBMonitorNbrUserRunningDB CASCADE;
DROP TABLE IF EXISTS TBMonitorLatchWaitsPerSecondTable CASCADE;
DROP TABLE IF EXISTS TBMonitorFullScanTable CASCADE;
DROP TABLE IF EXISTS TBMonitorFailedJobsTable CASCADE;
DROP TABLE IF EXISTS TBMonitorErrorLogTable CASCADE;
DROP TABLE IF EXISTS detailSessionTable CASCADE;
DROP TABLE IF EXISTS TBMonitorCollecteStatisticsTable CASCADE;
DROP TABLE IF EXISTS TBMonitorCollecteFragmentationTable CASCADE;
DROP TABLE IF EXISTS TBMonitorCollecteDiskDB CASCADE;
DROP TABLE IF EXISTS TBMonitorCheckUserConection CASCADE;
DROP TABLE IF EXISTS TBMonitorTopLogicalPhysicalRead CASCADE;
DROP TABLE IF EXISTS TBMonitorTopCPU CASCADE;
DROP TABLE IF EXISTS TBMonitorLockWait CASCADE;
DROP TABLE IF EXISTS CheckLogSpaceUsedInPourcentageTable CASCADE;
DROP TABLE IF EXISTS TBMonitorCheckLatencyDiskTable CASCADE;
DROP TABLE IF EXISTS TBMonitorLatchWait CASCADE;
DROP TABLE IF EXISTS CheckDataSpaceUsedInPourcentageTable CASCADE;
DROP TABLE IF EXISTS CheckDataBaseInfoTable CASCADE;
DROP TABLE IF EXISTS TBMonitorCheckBufferCatchHitRatio CASCADE;
DROP TABLE IF EXISTS TBMonitorAverageWaitTimeTable CASCADE;
DROP TABLE IF EXISTS TBTASKMONITORINGSTATUS CASCADE;
DROP TABLE IF EXISTS Datafiles CASCADE;
DROP TABLE IF EXISTS TablespaceInfo CASCADE;
DROP TABLE IF EXISTS Databases CASCADE;
DROP TABLE IF EXISTS OracleSIDTable CASCADE;
DROP TABLE IF EXISTS Servers CASCADE;

CREATE TABLE Servers (
    Id SERIAL PRIMARY KEY,
    ServerName VARCHAR(255)
);
CREATE TABLE OracleSIDTable (
    Id SERIAL PRIMARY KEY,
    ServerId INT REFERENCES Servers(Id),
    OracleSID VARCHAR(255)
);
CREATE TABLE Databases (
    Id SERIAL PRIMARY KEY,
    ServerId INT NOT NULL,
    OracleSIDId INT NOT NULL,
    DatabaseName VARCHAR(255),
    DateCollecte TIMESTAMP,
    CONSTRAINT fk_server FOREIGN KEY (ServerId) REFERENCES Servers(Id),
    CONSTRAINT fk_sid FOREIGN KEY (OracleSIDId) REFERENCES OracleSIDTable(Id),
    CONSTRAINT uq_server_sid UNIQUE (ServerId, OracleSIDId)
);
CREATE TABLE TablespaceInfo (
    Id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP,
    DatabaseId INT NOT NULL,
    TablespaceName VARCHAR(255),
    Status VARCHAR(255),
    UsedSpaceMB NUMERIC,
    FreeSpaceMB NUMERIC,
    TotalSpaceMB NUMERIC,
    Contents VARCHAR(255),
    ExtentManagement VARCHAR(255),
    SegmentSpaceManagement VARCHAR(255),
    FileName VARCHAR(255),
    FileSizeMB NUMERIC,
    IsAutoExtensible BOOLEAN,
    NextExtentMB NUMERIC,
    MaxSizeMB NUMERIC,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE Datafiles (
    Id SERIAL PRIMARY KEY,
    DatabaseId INT NOT NULL,
    TablespaceId INT NOT NULL,
    DateCollecte TIMESTAMP,
    LogicalDataName VARCHAR(255),
    FileLocation VARCHAR(500),
    TotalFileSize_MB NUMERIC,
    FileType VARCHAR(100),
    FileGroupName VARCHAR(255),
    TablespaceName VARCHAR(255),
    CONSTRAINT fk_database_df FOREIGN KEY (DatabaseId) REFERENCES Databases(Id),
    CONSTRAINT fk_tablespace_df FOREIGN KEY (TablespaceId) REFERENCES TablespaceInfo(Id)
);
CREATE TABLE TBTASKMONITORINGSTATUS (
    ID SERIAL PRIMARY KEY,
    DATE_COLLECTE TIMESTAMP NOT NULL,
    SEV INTEGER,
    DatabaseId INT NOT NULL,
    VERSION VARCHAR(256),
    UP_SINCE TIMESTAMP,
    CPU_USAGE INTEGER,
    IO_WAIT INTEGER,
    NETWORK_WAIT INTEGER,
    LATCH_WAIT INTEGER,
    CPU_WAIT INTEGER,
    MEMORY_WAIT INTEGER,
    LOCK_WAIT INTEGER,
    LOG_WAIT INTEGER,
    REMOTE_WAIT INTEGER,
    OTHER_WAIT INTEGER,
    LSOSHOST INTEGER,
    DB_ALARMS TEXT,
    HOST VARCHAR(256),
    CPU_LOAD INTEGER,
    MEMORY_USAGE INTEGER,
    DISK_USAGE INTEGER,
    AGENT_STATUS VARCHAR(4000),
    OS_STATUS INTEGER,
    STATUS INTEGER,
    OS_VERSION VARCHAR(256),
    UP_SINCE_OS TIMESTAMP,
    CONSTRAINT fk_database_df FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorAverageWaitTimeTable (
    Id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INT NOT NULL,
    CounterName VARCHAR(128) NOT NULL,
    CounterValue NUMERIC NOT NULL,
    CounterType INTEGER NOT NULL,
    CONSTRAINT fk_database_df FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorCheckBufferCatchHitRatio (
    id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INTEGER NOT NULL,
    counter_name VARCHAR(128),
    BufferCacheHitRatio NUMERIC,
    CONSTRAINT fk_database_df FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE CheckDataBaseInfoTable (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INT,
    totalDBSize_MB NUMERIC(10,2),
    DB_Free_Space_Size_MB NUMERIC(10,2),
    DB_Used_Space_Size_MB NUMERIC(10,2),
    FILENAME VARCHAR(256),
    TYPE VARCHAR(120),
    FILEGROUPNAME VARCHAR(120),
    FILE_LOCATION VARCHAR(500),
    FILESIZE_MB NUMERIC(10,2),
    USEDSPACE_MB NUMERIC(10,2),
    FREESPACE_MB NUMERIC(10,2),
    AUTOGROW_STATUS VARCHAR(100),
    log_reuse_wait_desc VARCHAR(4000),
    recovery_model_desc VARCHAR(4000),
    CONSTRAINT fk_database_df FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE CheckDataSpaceUsedInPourcentageTable (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INT NOT NULL,
    logicalDataName VARCHAR(128),
    tablespace_name VARCHAR(128),
    usage VARCHAR(20),
    SpaceAllocatedMB NUMERIC,
    SpaceUsedMB NUMERIC,
    freeSpaceMB NUMERIC,
    SpaceUsedPer NUMERIC(9,2),
    FreeSpacePer NUMERIC(9,2),
    CONSTRAINT fk_database_df FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorLatchWait (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INT,
    avg_latch_wait_time_ms NUMERIC NOT NULL,
    CONSTRAINT fk_database_df FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorCheckLatencyDiskTable (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INT,
    path VARCHAR(500),
    filename VARCHAR(500),
    ReadLatency NUMERIC NOT NULL,
    WriteLatency NUMERIC NOT NULL,
    AvgLatency NUMERIC NOT NULL,
    LatencyAssessment VARCHAR(20) NOT NULL,
    AvgKBsPerTransfer NUMERIC NOT NULL,
    Volume VARCHAR(2) NOT NULL,
    CONSTRAINT fk_database_df FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE CheckLogSpaceUsedInPourcentageTable (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INT,
    GroupNumber INT,
    ThreadNumber INT,
    SequenceNumber INT,
    Bytes NUMERIC,
    Members INT,
    Status VARCHAR(16),
    FirstChangeNumber NUMERIC,
    FirstTime TIMESTAMP,
    NextChangeNumber NUMERIC,
    LogFileName VARCHAR(2000),
	filename Varchar(20),
    SpaceAllocatedMB NUMERIC,
    SpaceUsedMB NUMERIC,
    SpaceUsedPer NUMERIC(9,2),
    IsCurrent VARCHAR(3),
    CONSTRAINT fk_database_df FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorLockWait (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INT,
    avg_lock_wait_time_ms REAL NOT NULL,
    blocked_sessions_count INT,
    CONSTRAINT fk_database_df FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorTopCPU (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INT,
    session_id INT,
    serial_number INT,
    sql_id VARCHAR(13),
    last_execution_time TIMESTAMP,
    cpu_time NUMERIC(18, 3),
    average_cpu_time NUMERIC(18, 3),
    elapsed_time NUMERIC(18, 3),
    executions INT,
    buffer_gets INT,
    disk_reads INT,
    sql_text TEXT,
    username VARCHAR(128),
    program_name VARCHAR(128),
    module VARCHAR(128),
    action VARCHAR(128),
    machine VARCHAR(128),
    osuser VARCHAR(128),
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorTopLogicalPhysicalRead (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INT,
    session_id INT,
    serial_number INT,                 
    sql_id VARCHAR(13),
    logical_reads BIGINT,
    physical_reads BIGINT,
    executions BIGINT,
    rows_processed BIGINT,
    sql_text TEXT,
    username VARCHAR(128),
    program_name VARCHAR(128),
    module VARCHAR(128),
    action VARCHAR(128),
    machine VARCHAR(128),
    osuser VARCHAR(128),
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorCheckUserConection (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INT,
    Username VARCHAR(128),
    SessionStatus VARCHAR(16),
    CurrentSessions INT,
    MaxSessions INT,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorCollecteDiskDB (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Drivename VARCHAR(10),
    Datecollecte TIMESTAMP,
    DatabaseId INT,
    Total_space_GB NUMERIC(18,2),
    Free_Space_GB NUMERIC(18,2),
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorCollecteFragmentationTable (
    Id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DateCollecte TIMESTAMP,
    DatabaseId INT,
    IndexType VARCHAR(30),
    IndexDepth INT,
    IndexLevel INT,
    AvgFragCount INT,
    FragmentCount INT,
    Owner VARCHAR(128),
    ObjectName VARCHAR(128),
    ObjectType VARCHAR(30),
    FragmentationPercent NUMERIC,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorCollecteStatisticsTable (
    Id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DateCollecte TIMESTAMP,
    DatabaseId INT,
    name VARCHAR(128),
    StatsUpdated TIMESTAMP,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE detailSessionTable (
    id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    DateCollecte TIMESTAMP,
    DatabaseId INT,
    session_id INT,
    serial_number INT,  
    login_time TIMESTAMP,
    host_name VARCHAR(256),
    program_name VARCHAR(2000),
    client_interface_name VARCHAR(2000),
    login_name VARCHAR(2000),
    status VARCHAR(2000),
    memory_usage_mb NUMERIC(10, 2),
    total_elapsed_time BIGINT,
    last_call_start_time TIMESTAMP,
    reads BIGINT,
    logical_reads BIGINT,
    is_user_process BOOLEAN, 
    original_login_name VARCHAR(2000),
    database_id INT,
    num_reads BIGINT,
    text TEXT, 
    sql_id VARCHAR(50),
    event VARCHAR(256),
    wait_class VARCHAR(100),
    blocking_session INT,
    module VARCHAR(200),
    action VARCHAR(200),
    cpu_time BIGINT,
    elapsed_time BIGINT,
    plsql_entry_object_id INT,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorErrorLogTable (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INTEGER,
    logdate TIMESTAMP,
    procInfo VARCHAR(10),
    ERRORLOG VARCHAR(4000),
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorFailedJobsTable (
    Id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP,
    DatabaseId INTEGER,
    IndicatorCategory VARCHAR(100),
    IndicatorName VARCHAR(50),
    JobName VARCHAR(128),
    Description VARCHAR(4000),
    JobStartTime TIMESTAMP,
    JobDuration VARCHAR(50),
    ErrorMessage VARCHAR(4000),
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorFullScanTable (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INTEGER,
    counter_name VARCHAR(128) NOT NULL,
    cntr_value NUMERIC NOT NULL,
    cntr_type NUMERIC NOT NULL,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorLatchWaitsPerSecondTable (
    Id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INTEGER,
    ObjectName VARCHAR(128),
    CounterName VARCHAR(128),
    CounterValue NUMERIC NOT NULL,
    CounterType NUMERIC NOT NULL,
    TotalWaitTimeSeconds NUMERIC NOT NULL,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorNbrUserRunningDB (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INTEGER,
    numbersession NUMERIC NOT NULL,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorBlocsTable (
    ID SERIAL PRIMARY KEY,
    DatabaseId INTEGER,
    TablespaceName VARCHAR(255) NOT NULL,
    SegmentName VARCHAR(255) NOT NULL,
    SegmentType VARCHAR(50) NOT NULL,
    UsedBlocks NUMERIC NOT NULL,
    TotalBlocks NUMERIC NOT NULL,
    FreeBlocks NUMERIC NOT NULL,
    DateCollecte TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE QueryBydurationTable (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INTEGER,
    session_id NUMERIC,
    duration_ms NUMERIC,
    database_id NUMERIC,
    cpu_time_ms NUMERIC,
    wait_time NUMERIC,
    logical_reads NUMERIC,
    statement_text TEXT,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE Region (
    ID SERIAL PRIMARY KEY,
    DatabaseId INTEGER,
    DateCollecte TIMESTAMP NOT NULL,
    IPAddress VARCHAR(50),
    Region VARCHAR(255),
    Country VARCHAR(255),
    City VARCHAR(255),
    Latitude NUMERIC(9,7),
    Longitude NUMERIC(9,7),
    statement_text TEXT,
	CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorSqlCompilationTable (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INTEGER,
    counter_name VARCHAR(128) NOT NULL,
    object_name VARCHAR(128) NOT NULL,
    cntr_value NUMERIC NOT NULL,
	CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE StatusServiceSQLTable (
    Id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    DatabaseId INTEGER,
    ServiceName VARCHAR(128),
    StartupType VARCHAR(128),
    StatusDesc VARCHAR(128),
	CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorAudit (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INTEGER,
    Control VARCHAR(256),         
    RiskDescription VARCHAR(100), 
    ActionRequired VARCHAR(50),  
    MetricValue VARCHAR(1000) NOT NULL,
    ExpectedValue VARCHAR(100),
    Alert BOOLEAN,
	CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorCPU (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INTEGER,
    cpu_idle VARCHAR(128), -- System-wide CPU idle percentage
    cpu_sql VARCHAR(128),
	CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorCpuUsage (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INTEGER,
    CpuUsage NUMERIC NOT NULL,
	CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorMemory (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP NOT NULL,
    DatabaseId INTEGER,
    Total_OSMemory VARCHAR(128),
    AvailableMemory VARCHAR(128),
    MemoryUtilizationPct NUMERIC,
    PGA_Allocated VARCHAR(128),
    SGA_Allocated VARCHAR(128),
	CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE DatabasesTableInfo (
    ID SERIAL PRIMARY KEY,
    DBID NUMERIC,
    DateCollecte TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    DatabaseId INTEGER,
    DBUniqueName VARCHAR(30),
    Created DATE,
    LogMode VARCHAR(12),
    OpenMode VARCHAR(20),
    ProtectionMode VARCHAR(20),
    ProtectionLevel VARCHAR(20),
    DatabaseRole VARCHAR(16),
    PlatformName VARCHAR(101),
    FlashbackOn VARCHAR(18),
    CDB VARCHAR(3),
    VersionTime DATE,
    ControlfileTime DATE,
    Status VARCHAR(20),
    DatabaseSpace NUMERIC,
    DataSize NUMERIC,
    DataUsedSize NUMERIC,
    DataFreeSize NUMERIC,
    LogSize NUMERIC,
    LogUsedSize NUMERIC,
    LogFreeSize NUMERIC,
    NumberOfTables NUMERIC,
    NumberOfIndexes NUMERIC,
    NumberOfFilegroups NUMERIC,
    LocalLastBackupDate DATE,
    HadrMethod VARCHAR(30),
	CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE DataFilesTableInfo (
    ID                      SERIAL PRIMARY KEY,
    DateCollecte            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    DatabaseId              INTEGER,
    FileID                  INTEGER,
    FileName                VARCHAR(513),
    TablespaceName          VARCHAR(30),
    Bytes                   BIGINT,
    Blocks                  BIGINT,
    Status                  VARCHAR(9),
    AutoExtensible          VARCHAR(3),
    MaxBytes                BIGINT,
    IncrementBy             BIGINT,
    OnlineStatus            VARCHAR(7),
    LostWriteProtect        VARCHAR(7),
    CreationTime            DATE,
    LastChange              DATE,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE LogFilesTableInfo (
    Id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    DatabaseId INTEGER REFERENCES Databases(Id),
    LogGroup INTEGER,
    FileName VARCHAR(513),
    FileType VARCHAR(20),
    TotalSizeMB NUMERIC,
    Status VARCHAR(16),
    "Sequence#" INTEGER,
    Members INTEGER,
    FilePath VARCHAR(513),
    IsCurrentGroup VARCHAR(3),          -- 'YES' or 'NO'
    IsArchived VARCHAR(3),              -- 'YES' or 'NO'
    SwitchesLastHour INTEGER,           -- Count from v$log_history
    SecondsInStatus INTEGER             -- Time since log entered status
);
CREATE TABLE TBMonitorBackupStatus (
    Id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE,
    DatabaseId INTEGER,
    DatabaseType VARCHAR(50),
    LastBackupDate TIMESTAMP WITH TIME ZONE,
    BackupStatus VARCHAR(50),
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TransactionLogsTableInfo (
    Id BIGSERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    DatabaseId INTEGER REFERENCES Databases(Id),
    LogGroup INTEGER,
    FileCount INTEGER,
    TotalSizeMB NUMERIC(18,2),
    Status VARCHAR(16),
    "Sequence#" INTEGER,
    Archived VARCHAR(3),            -- YES / NO
    IsCurrentGroup VARCHAR(3),      -- YES / NO
    SwitchesLastHour INTEGER,
    SecondsInStatus INTEGER
);
CREATE TABLE TablesInfo (
    ID SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE,
    DatabaseId INTEGER,
    OwnerName VARCHAR(128),
    TableName VARCHAR(128),
    FileGroupName VARCHAR(128),
    TableSize NUMERIC(18,2),
    ReservedSize NUMERIC(18,2),
    UsedSize NUMERIC(18,2),
    FreeSize NUMERIC(18,2),
    PercentOfDB NUMERIC(5,2),
    RowCount BIGINT,
    ReservedMemory NUMERIC(18,2),
    UsedMemory NUMERIC(18,2),
    NumberOfPartitions INTEGER,
    CompressionType VARCHAR(20),
    TableType VARCHAR(20),
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id) 
);
CREATE TABLE IndexesInfo (
    Id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    DatabaseId INTEGER,
    OwnerName VARCHAR(128),
    TableName VARCHAR(128),
    IndexName VARCHAR(128),
    IndexId INTEGER,
    FileGroupName VARCHAR(128),
    Type VARCHAR(128),
    No_OfKeys INTEGER,
    IndexSize BIGINT,
    UsedSize BIGINT,
    FreeSize BIGINT,
    Rows1 BIGINT,
    RowModCtr INTEGER,
    OriginalFillFactor INTEGER,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE ActiveTransactionsInfo (
    ID SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    DatabaseId INTEGER,
    SqlText TEXT,
    ExecutionCount BIGINT,
    CpuTime BIGINT,
    TotalElapsedTime BIGINT,
    CreationTime TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE deadlock_reports (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE NOT NULL,
    DatabaseId INTEGER,
    SessionID INTEGER,
    OracleUsername VARCHAR(128),
    OSUserName VARCHAR(128),
    Process VARCHAR(24),
    LockedMode INTEGER,
    ObjectID INTEGER,
    ObjectName VARCHAR(128),
    ObjectType VARCHAR(23),
    Owner VARCHAR(128),
    LockType VARCHAR(2),
    ID1 INTEGER,
    ID2 INTEGER,
    LMode INTEGER,
    Request INTEGER,
    CTime INTEGER,
    Block INTEGER,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE ActivityMonitorProcesses (
    ID SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE NOT NULL,
    DatabaseId INTEGER,
    SessionID INTEGER NOT NULL,
    UserProcess BOOLEAN NOT NULL,
    Username VARCHAR(255) NOT NULL,
    Application VARCHAR(255) NOT NULL,
    WaitType VARCHAR(255),
    Statement TEXT,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE SQLConfigurationTable (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    DatabaseId INTEGER,
    ParamNum INTEGER,
    ParamName VARCHAR(80),
    RunValue VARCHAR(4000),
    ConfigurationValue VARCHAR(4000),
    PreviousValue VARCHAR(4000),
    MinValue VARCHAR(400),
    MaxValue VARCHAR(400),
    Modifiable VARCHAR(20),
    Description VARCHAR(255),
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE UsageTempTables (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE,
    DatabaseId INTEGER,
    TablesCreated INTEGER,
    TablesForDestruction INTEGER,
    TablesPerSecond INTEGER,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE UndoUsageSessions (
    Id SERIAL PRIMARY KEY,
    DateCollecte DATE,
    DatabaseId INTEGER,
    SID INTEGER,
    SerialNum INTEGER,
    Username VARCHAR(128),
    Status VARCHAR(64),
    UndoSegment VARCHAR(64),
    UsedUndoBlocks INTEGER,
    UsedUndoRecords INTEGER,
    TransactionStartTime DATE,
    LogonTime DATE,
    Machine VARCHAR(128),
    Program VARCHAR(256),
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE LockTypes (
    Id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    DatabaseId INTEGER,
    ObjectName VARCHAR(128),
    CounterName VARCHAR(128),
    Username VARCHAR(128),
    CounterValue INTEGER,
    CounterType INTEGER,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE BackupsDetails (
    ID SERIAL PRIMARY KEY,
    BACKUP_JOB_ID VARCHAR(128),
    DateCollecte TIMESTAMP WITH TIME ZONE,
    DatabaseId INTEGER,
    RecoveryModel VARCHAR(60),
    BackupType VARCHAR(10),
    Full_Start_Date TIMESTAMP WITH TIME ZONE,
    Full_Duration INTEGER,
    Full_Size BIGINT,
    Differential_Start_Date TIMESTAMP WITH TIME ZONE,
    Differential_Duration INTEGER,
    Differential_Size BIGINT,
    Log_Start_Date TIMESTAMP WITH TIME ZONE,
    Log_Duration INTEGER,
    Log_Size BIGINT,
    Export_Start_Date TIMESTAMP WITH TIME ZONE,
    Export_Duration INTEGER,
    Export_Size BIGINT,
    Worst_RPO_Last_30_Days VARCHAR(50),
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE BackupHistory (
    id SERIAL PRIMARY KEY,
    BACKUP_JOB_ID VARCHAR(36),
    DateCollecte TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    DatabaseId INTEGER,
    Type VARCHAR(50) NOT NULL,
    StartDate TIMESTAMP WITH TIME ZONE,
    Duration INTEGER NOT NULL,
    BackupSize NUMERIC(10,2) NOT NULL,
    CopyOnly VARCHAR(3) NOT NULL,
    Compressed VARCHAR(3) NOT NULL,
    Encrypted VARCHAR(3) NOT NULL,
    Location VARCHAR(512) NOT NULL,
    BackupSource VARCHAR(10) NOT NULL,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE ServiceStatus (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    DatabaseId INTEGER,
    ServiceName VARCHAR(256) NOT NULL,
    Status VARCHAR(50) NOT NULL,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE JobStatus (
    Id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    DatabaseId INTEGER,
    job_name VARCHAR(100) CONSTRAINT uk_job_name UNIQUE,
    status VARCHAR(20),
    start_time TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TopQueryPerformanceLog (
    Id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE,
    DatabaseId INTEGER,
    QueryStatement TEXT,
    Requests INTEGER,
    AvgLatency INTEGER,
    TotalTime INTEGER,
    LastExecutionTime TIMESTAMP WITH TIME ZONE,
    Status VARCHAR(64),
    IndexStatus VARCHAR(64),
    TableName VARCHAR(128),
    EqualityColumns VARCHAR(4000),
    InequalityColumns VARCHAR(4000),
    IncludedColumns VARCHAR(4000),
    IndexSeekScanCount INTEGER,
    EstimatedImpact INTEGER,
    SuggestedIndex VARCHAR(4000),
    TotalQueriesCurrentlyRunning INTEGER,
    MaxDuration INTEGER,
    TotalWaitPercent INTEGER,
    CPUWaitPercent INTEGER,
    NetworkWaitPercent INTEGER,
    OtherWaitPercent INTEGER,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE AlertStatusServiceOracleTable (
    id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE NOT NULL,
    DatabaseId INTEGER,
    service_name VARCHAR(128) NOT NULL,
    startup_type VARCHAR(128) NOT NULL,
    status VARCHAR(4000) NOT NULL,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorBatchRequestTable (
    Id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE NOT NULL,
    DatabaseId INTEGER,
    CounterName VARCHAR(128),
    CounterValue INTEGER NOT NULL,
    cntr_type INTEGER DEFAULT 272696576 NOT NULL,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE HWM_LOG (
    ID SERIAL PRIMARY KEY,
    DATECOLLECTE TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    TABLE_NAME VARCHAR(128),
    DatabaseId INTEGER,
    TOTAL_BLOCKS INTEGER,
    USED_BLOCKS INTEGER,
    HWM_BLOCKS INTEGER,
    SEGMENT_SIZE_MB INTEGER,
    LOG_DATE TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorServicePackTable (
    Id SERIAL PRIMARY KEY,
    DateCollecte TIMESTAMP WITH TIME ZONE,
    DatabaseId INTEGER,
    PlatformName VARCHAR(128),
    Version VARCHAR(128),
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMONITORWORKLOAD (
    ID BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DATE_COLLECTE TIMESTAMP NOT NULL,
    DatabaseId INTEGER,
    CPU_USAGE NUMERIC(20,2),
    IO_WAIT NUMERIC(20,2),
    NETWORK_WAIT NUMERIC(20,2),
    LATCH_WAIT NUMERIC(20,2),
    CPU_WAIT NUMERIC(20,2),
    MEMORY_WAIT NUMERIC(20,2),
    LOCK_WAIT NUMERIC(20,2),
    LOG_WAIT NUMERIC(20,2),
    REMOTE_WAIT NUMERIC(20,2),
    OTHER_WAIT NUMERIC(20,2),
    LSOS_HOST NUMERIC(20,2),
    CONCURRENCY_WAIT NUMERIC(20,2),
    SYSTEM_IO_WAIT NUMERIC(20,2),
    USER_COMMITS BIGINT,
    USER_ROLLBACKS BIGINT,
    PHYSICAL_READS BIGINT,
    PHYSICAL_WRITES BIGINT,
    LOGICAL_READS BIGINT,
    ACTIVE_SESSIONS BIGINT,    
    DB_CPU_TIME NUMERIC(20,2),   
    DB_WAIT_TIME NUMERIC(20,2),
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)  
);
CREATE TABLE TBIndicator (
    ID BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    IndicatorName       VARCHAR(100),
    IndicatorCategory   VARCHAR(50),
    Detail              VARCHAR(200),
    AlertType           VARCHAR(50),
    WarningThreshold    NUMERIC,
    AlertThreshold      NUMERIC,
    ThresholdUnit       VARCHAR(10),
    UpdateDate          TIMESTAMP,
    LastControlDate     TIMESTAMP,
    alerte              VARCHAR(10),
    DatabaseId          INTEGER,
    alertsent           NUMERIC,
    DBAlarme            VARCHAR(10),
    CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE EventViewerAlertHistory (
    ID SERIAL PRIMARY KEY,  
    DatabaseId INTEGER,  
    DateCollecte TIMESTAMP NOT NULL,
    corrected_time TIMESTAMP,
    event_time TIMESTAMP,
    session_server_principal_name VARCHAR(255),
    server_principal_name VARCHAR(255),
    target_server_principal_name VARCHAR(255),
    object_name VARCHAR(255),
    statement VARCHAR(255),  
    NameOfAlerte VARCHAR(255),
	CONSTRAINT fk_database_ts FOREIGN KEY (DatabaseId) REFERENCES Databases(Id)
);
CREATE TABLE TBMonitorDatabaseState (
    ID             SERIAL PRIMARY KEY,
    DateCollecte   TIMESTAMP NOT NULL,
    OracleSIDId    INTEGER,
    DatabaseName   VARCHAR(128),
    Status         VARCHAR(50),
	CONSTRAINT fk_sid FOREIGN KEY (OracleSIDId) REFERENCES OracleSIDTable(Id)
);

-- Test select
SELECT * FROM Servers;
SELECT * FROM OracleSIDTable;
SELECT * FROM Databases;
SELECT * FROM TablespaceInfo;
SELECT * FROM Datafiles;
SELECT * FROM TBTASKMONITORINGSTATUS;
SELECT * FROM TBMonitorAverageWaitTimeTable;
SELECT * FROM TBMonitorCheckBufferCatchHitRatio;
SELECT * FROM CheckDataBaseInfoTable;
SELECT * FROM CheckDataSpaceUsedInPourcentageTable;
SELECT * FROM TBMonitorLatchWait;
SELECT * FROM TBMonitorCheckLatencyDiskTable;
UPDATE TBMonitorCheckLatencyDiskTable SET Latencyassessment = 'Bad' WHERE ID IN (1,3);
SELECT * FROM CheckLogSpaceUsedInPourcentageTable; 
SELECT * FROM TBMonitorLockWait;
SELECT * FROM TBMonitorTopCPU;
SELECT * FROM TBMonitorTopLogicalPhysicalRead;
SELECT * FROM TBMonitorCheckUserConection;
SELECT * FROM TBMonitorCollecteDiskDB;
SELECT * FROM TBMonitorCollecteFragmentationTable;
SELECT * FROM TBMonitorCollecteStatisticsTable;
SELECT * FROM detailSessionTable;
SELECT * FROM TBMonitorErrorLogTable;
SELECT * FROM TBMonitorFailedJobsTable;
SELECT * FROM TBMonitorFullScanTable;
SELECT * FROM TBMonitorLatchWaitsPerSecondTable;
SELECT * FROM TBMonitorNbrUserRunningDB;
SELECT * FROM TBMonitorBlocsTable;
SELECT * FROM QueryBydurationTable;
SELECT * FROM Region;
UPDATE Region SET region = 'Tetouan', latitude = 35.5881, longitude = 5.3625;
SELECT * FROM TBMonitorSqlCompilationTable;
SELECT * FROM StatusServiceSQLTable;
SELECT * FROM TBMonitorAudit;
SELECT * FROM TBMonitorCPU;
SELECT * FROM TBMonitorCpuUsage;
SELECT * FROM TBMonitorMemory;
SELECT * FROM DatabasesTableInfo;
SELECT * FROM DataFilesTableInfo;
SELECT * FROM LogFilesTableInfo;
SELECT * FROM TBMonitorBackupStatus;
SELECT * FROM TransactionLogsTableInfo;
SELECT * FROM TablesInfo ORDER BY rowcount DESC;
SELECT * FROM IndexesInfo;
SELECT * FROM ActiveTransactionsInfo ORDER BY ID;
SELECT * FROM deadlock_reports;
SELECT * FROM ActivityMonitorProcesses;
SELECT * FROM SQLConfigurationTable;
SELECT * FROM UsageTempTables;
SELECT * FROM UndoUsageSessions;
SELECT * FROM LockTypes;
SELECT * FROM BackupsDetails;
SELECT * FROM BackupHistory;
SELECT * FROM ServiceStatus;
SELECT * FROM JobStatus;
SELECT * FROM TopQueryPerformanceLog;
SELECT * FROM AlertStatusServiceOracleTable;
SELECT * FROM TBMonitorBatchRequestTable;
SELECT * FROM HWM_LOG;
SELECT * FROM TBMonitorServicePackTable;
SELECT * FROM TBMONITORWORKLOAD;
SELECT * FROM TBIndicator;
SELECT Id,Databaseid,Indicatorname,updatedate,alerte FROM TBIndicator ORDER BY ID;
SELECT * FROM EventViewerAlertHistory;
SELECT * FROM TBMonitorDatabaseState;


SELECT * FROM Datafiles Df JOIN Databases D ON Df.DatabaseId = D.id JOIN OracleSIDTable O ON O.id = D.OracleSIDId JOIN Servers S ON S.id = O.ServerId;
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

BEGIN;

INSERT INTO TBMONITORWORKLOAD (DATE_COLLECTE, DatabaseId, CPU_USAGE, IO_WAIT, NETWORK_WAIT, LATCH_WAIT, CPU_WAIT, MEMORY_WAIT, LOCK_WAIT, LOG_WAIT, REMOTE_WAIT, OTHER_WAIT, LSOS_HOST, CONCURRENCY_WAIT, SYSTEM_IO_WAIT, USER_COMMITS, USER_ROLLBACKS, PHYSICAL_READS, PHYSICAL_WRITES, LOGICAL_READS, ACTIVE_SESSIONS, DB_CPU_TIME, DB_WAIT_TIME) VALUES 
('2025-07-08 12:07:30.054748', 2, 4.59, 14275.97, 1711060.81, 942508.77, 18107.10, 233.38, 0.0, 37.75, 1071021.18, 2.28, 9901.03, 0.01, 0.56, 5078, 216, 408079, 14767, 27909673, 68, 2955426.36, 670992598.42),
('2025-07-04 03:44:30.054748', 2, 4.62, 14004.22, 1674291.06, 968064.12, 17659.52, 248.19, 0.0, 38.64, 1058915.12, 2.37, 9731.58, 0.01, 0.60, 5167, 212, 420520, 15059, 28402616, 67, 2947195.82, 714913027.51),
('2025-07-09 09:49:30.054748', 1, 4.84, 14418.82, 1605000.99, 967823.35, 18750.23, 232.07, 0.0, 37.09, 1112286.75, 2.21, 9715.94, 0.01, 0.55, 5147, 216, 412875, 15245, 28614359, 67, 2783019.27, 721077429.81),
('2025-07-07 21:40:30.054748', 1, 4.52, 14586.83, 1723487.39, 990472.99, 19373.78, 232.07, 0.0, 36.45, 1128257.03, 2.19, 9860.74, 0.01, 0.60, 5016, 216, 421775, 15563, 27201542, 65, 2951016.13, 736453416.02),
('2025-07-09 10:18:30.054748', 1, 4.80, 15038.68, 1718860.63, 987499.18, 18005.85, 244.08, 0.0, 36.14, 1133315.08, 2.30, 9885.21, 0.01, 0.56, 5210, 204, 398823, 14584, 29546519, 64, 3001503.20, 736474268.34),
('2025-07-05 17:29:30.054748', 2, 4.48, 13928.20, 1700251.31, 951000.43, 18846.70, 237.52, 0.0, 37.22, 1145802.94, 2.29, 9872.34, 0.01, 0.57, 5241, 220, 416022, 15367, 29067213, 69, 2845324.23, 715402021.27),
('2025-07-06 07:33:30.054748', 1, 4.56, 14112.17, 1663342.17, 951288.11, 19035.33, 243.81, 0.0, 36.85, 1108761.44, 2.18, 9378.92, 0.01, 0.60, 5072, 218, 417099, 14915, 28734196, 66, 2938412.15, 699512049.68),
('2025-07-03 15:22:30.054748', 2, 4.67, 14867.96, 1687432.60, 963128.60, 17627.91, 239.55, 0.0, 36.74, 1079510.34, 2.31, 9486.18, 0.01, 0.57, 5098, 222, 410989, 14681, 28217215, 66, 2971517.89, 723670152.99),
('2025-07-10 05:41:30.054748', 1, 4.91, 14924.13, 1692431.07, 985408.22, 18232.71, 243.06, 0.0, 37.88, 1096501.08, 2.31, 9502.62, 0.01, 0.59, 5195, 214, 408125, 14890, 28402594, 67, 2965301.01, 731580278.44),
('2025-07-08 20:57:30.054748', 2, 4.66, 14757.51, 1649821.49, 940508.10, 19005.10, 240.27, 0.0, 36.38, 1110571.49, 2.23, 9392.34, 0.01, 0.55, 5127, 210, 411711, 14792, 28851640, 66, 2815509.41, 689732105.01),
('2025-07-06 23:18:30.054748', 1, 4.50, 14338.01, 1679821.44, 959107.17, 18034.11, 238.63, 0.0, 36.05, 1087215.75, 2.35, 9835.48, 0.01, 0.59, 5024, 219, 406704, 14701, 27635191, 66, 2992412.11, 695723056.15),
('2025-07-05 01:12:30.054748', 2, 4.61, 14508.17, 1650282.92, 949503.45, 18351.05, 241.75, 0.0, 37.96, 1059812.07, 2.30, 9374.61, 0.01, 0.60, 5184, 215, 404562, 14910, 28139476, 67, 2850413.11, 714231015.32),
('2025-07-04 09:54:30.054748', 1, 4.88, 14275.73, 1629310.38, 954102.22, 18506.03, 239.21, 0.0, 36.29, 1131703.22, 2.32, 9598.01, 0.01, 0.55, 5221, 217, 414703, 15023, 28896121, 67, 2930402.81, 692490368.92),
('2025-07-03 19:08:30.054748', 2, 4.65, 14079.51, 1690542.19, 982119.53, 18923.74, 234.82, 0.0, 37.19, 1104601.83, 2.27, 9405.84, 0.01, 0.57, 5208, 213, 415099, 15012, 28693128, 68, 2960411.87, 723012056.72);

COMMIT;
