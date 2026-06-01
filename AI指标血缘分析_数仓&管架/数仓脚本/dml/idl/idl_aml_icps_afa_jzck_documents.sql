/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_icps_afa_jzck_documents
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_icps_afa_jzck_documents drop partition p_${last_date};
alter table ${idl_schema}.aml_icps_afa_jzck_documents drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_icps_afa_jzck_documents add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_icps_afa_jzck_documents (
    etl_dt  -- 数据日期
    ,productcode  -- 产品代码
    ,workdate  -- 平台日期
    ,agentserialno  -- 平台流水号
    ,worktime  -- 平台时间
    ,fileflag  -- 文件标志:0-文书,1-证件,2-其他
    ,fileid  -- 文件序号
    ,transserialnumber  -- 传输报文流水号
    ,applicationid  -- 业务申请编号
    ,casenumber  -- 案件编号
    ,documentnumber  -- 文书编号
    ,filename  -- 文件名称
    ,filetype  -- 文件格式类型编码:0-Jpg,1-PDF,2-Word
    ,filetypename  -- 文件格式类型名称
    ,documenttype  -- 文件类型编码
    ,documenttypename  -- 文件类型名称
    ,documentmd5  -- 文件MD5
    ,filepath  -- 文件存放路径
    ,content  -- 文件内容
    ,remark1  -- 备用字段1
    ,remark2  -- 备用字段2
    ,remark3  -- 备用字段3
    ,remark4  -- 备用字段4
    ,tradesystem  -- 交易系统,0-法院查控1-公安查控2-监委查控3-电信反欺诈
    ,tradetype  -- 交易类型,0-查询请求1-冻结请求2-扣划请求
    ,zjmc  -- 证件名称
    ,djr  -- 登记人
    ,djrq  -- 登记日期
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.productcode,chr(13),''),chr(10),'')  -- 产品代码
    ,replace(replace(t1.workdate,chr(13),''),chr(10),'')  -- 平台日期
    ,replace(replace(t1.agentserialno,chr(13),''),chr(10),'')  -- 平台流水号
    ,replace(replace(t1.worktime,chr(13),''),chr(10),'')  -- 平台时间
    ,replace(replace(t1.fileflag,chr(13),''),chr(10),'')  -- 文件标志:0-文书,1-证件,2-其他
    ,replace(replace(t1.fileid,chr(13),''),chr(10),'')  -- 文件序号
    ,replace(replace(t1.transserialnumber,chr(13),''),chr(10),'')  -- 传输报文流水号
    ,replace(replace(t1.applicationid,chr(13),''),chr(10),'')  -- 业务申请编号
    ,replace(replace(t1.casenumber,chr(13),''),chr(10),'')  -- 案件编号
    ,replace(replace(t1.documentnumber,chr(13),''),chr(10),'')  -- 文书编号
    ,replace(replace(t1.filename,chr(13),''),chr(10),'')  -- 文件名称
    ,replace(replace(t1.filetype,chr(13),''),chr(10),'')  -- 文件格式类型编码:0-Jpg,1-PDF,2-Word
    ,replace(replace(t1.filetypename,chr(13),''),chr(10),'')  -- 文件格式类型名称
    ,replace(replace(t1.documenttype,chr(13),''),chr(10),'')  -- 文件类型编码
    ,replace(replace(t1.documenttypename,chr(13),''),chr(10),'')  -- 文件类型名称
    ,replace(replace(t1.documentmd5,chr(13),''),chr(10),'')  -- 文件MD5
    ,replace(replace(t1.filepath,chr(13),''),chr(10),'')  -- 文件存放路径
    ,replace(replace(t1.content,chr(13),''),chr(10),'')  -- 文件内容
    ,replace(replace(t1.remark1,chr(13),''),chr(10),'')  -- 备用字段1
    ,replace(replace(t1.remark2,chr(13),''),chr(10),'')  -- 备用字段2
    ,replace(replace(t1.remark3,chr(13),''),chr(10),'')  -- 备用字段3
    ,replace(replace(t1.remark4,chr(13),''),chr(10),'')  -- 备用字段4
    ,replace(replace(t1.tradesystem,chr(13),''),chr(10),'')  -- 交易系统,0-法院查控1-公安查控2-监委查控3-电信反欺诈
    ,replace(replace(t1.tradetype,chr(13),''),chr(10),'')  -- 交易类型,0-查询请求1-冻结请求2-扣划请求
    ,replace(replace(t1.zjmc,chr(13),''),chr(10),'')  -- 证件名称
    ,replace(replace(t1.djr,chr(13),''),chr(10),'')  -- 登记人
    ,replace(replace(t1.djrq,chr(13),''),chr(10),'')  -- 登记日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.icps_afa_jzck_documents t1    --法律文书信息表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_icps_afa_jzck_documents',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);