/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icps_afa_jzck_documents
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icps_afa_jzck_documents_ex purge;
alter table ${iol_schema}.icps_afa_jzck_documents add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icps_afa_jzck_documents truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icps_afa_jzck_documents_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icps_afa_jzck_documents where 0=1;

insert /*+ append */ into ${iol_schema}.icps_afa_jzck_documents_ex(
    productcode -- 产品代码
    ,workdate -- 平台日期
    ,agentserialno -- 平台流水号
    ,worktime -- 平台时间
    ,fileflag -- 文件标志:0-文书,1-证件,2-其他
    ,fileid -- 文件序号
    ,transserialnumber -- 传输报文流水号
    ,applicationid -- 业务申请编号
    ,casenumber -- 案件编号
    ,documentnumber -- 文书编号
    ,filename -- 文件名称
    ,filetype -- 文件格式类型编码:0-Jpg,1-PDF,2-Word
    ,filetypename -- 文件格式类型名称
    ,documenttype -- 文件类型编码
    ,documenttypename -- 文件类型名称
    ,documentmd5 -- 文件MD5
    ,filepath -- 文件存放路径
    ,content -- 文件内容
    ,remark1 -- 备用字段1
    ,remark2 -- 备用字段2
    ,remark3 -- 备用字段3
    ,remark4 -- 备用字段4
    ,tradesystem -- 交易系统,0-法院查控1-公安查控2-监委查控3-电信反欺诈
    ,tradetype -- 交易类型,0-查询请求1-冻结请求2-扣划请求
    ,zjmc -- 证件名称
    ,djr -- 登记人
    ,djrq -- 登记日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    productcode -- 产品代码
    ,workdate -- 平台日期
    ,agentserialno -- 平台流水号
    ,worktime -- 平台时间
    ,fileflag -- 文件标志:0-文书,1-证件,2-其他
    ,fileid -- 文件序号
    ,transserialnumber -- 传输报文流水号
    ,applicationid -- 业务申请编号
    ,casenumber -- 案件编号
    ,documentnumber -- 文书编号
    ,filename -- 文件名称
    ,filetype -- 文件格式类型编码:0-Jpg,1-PDF,2-Word
    ,filetypename -- 文件格式类型名称
    ,documenttype -- 文件类型编码
    ,documenttypename -- 文件类型名称
    ,documentmd5 -- 文件MD5
    ,filepath -- 文件存放路径
    ,content -- 文件内容
    ,remark1 -- 备用字段1
    ,remark2 -- 备用字段2
    ,remark3 -- 备用字段3
    ,remark4 -- 备用字段4
    ,tradesystem -- 交易系统,0-法院查控1-公安查控2-监委查控3-电信反欺诈
    ,tradetype -- 交易类型,0-查询请求1-冻结请求2-扣划请求
    ,zjmc -- 证件名称
    ,djr -- 登记人
    ,djrq -- 登记日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icps_afa_jzck_documents
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icps_afa_jzck_documents exchange partition p_${batch_date} with table ${iol_schema}.icps_afa_jzck_documents_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icps_afa_jzck_documents to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icps_afa_jzck_documents_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icps_afa_jzck_documents',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);