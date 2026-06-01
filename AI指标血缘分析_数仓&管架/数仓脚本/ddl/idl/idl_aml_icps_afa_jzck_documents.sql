/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_icps_afa_jzck_documents
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_icps_afa_jzck_documents
whenever sqlerror continue none;
drop table ${idl_schema}.aml_icps_afa_jzck_documents purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_icps_afa_jzck_documents(
    etl_dt date -- 数据日期   
    ,productcode varchar2(8) -- 产品代码   
    ,workdate varchar2(8) -- 平台日期   
    ,agentserialno varchar2(20) -- 平台流水号   
    ,worktime varchar2(6) -- 平台时间   
    ,fileflag varchar2(2) -- 文件标志:0-文书,1-证件,2-其他   
    ,fileid varchar2(10) -- 文件序号   
    ,transserialnumber varchar2(60) -- 传输报文流水号   
    ,applicationid varchar2(200) -- 业务申请编号   
    ,casenumber varchar2(100) -- 案件编号   
    ,documentnumber varchar2(64) -- 文书编号   
    ,filename varchar2(300) -- 文件名称   
    ,filetype varchar2(6) -- 文件格式类型编码:0-Jpg,1-PDF,2-Word   
    ,filetypename varchar2(400) -- 文件格式类型名称   
    ,documenttype varchar2(10) -- 文件类型编码   
    ,documenttypename varchar2(100) -- 文件类型名称   
    ,documentmd5 varchar2(32) -- 文件MD5   
    ,filepath varchar2(400) -- 文件存放路径   
    ,content varchar2(400) -- 文件内容   
    ,remark1 varchar2(16) -- 备用字段1   
    ,remark2 varchar2(32) -- 备用字段2   
    ,remark3 varchar2(64) -- 备用字段3   
    ,remark4 varchar2(512) -- 备用字段4   
    ,tradesystem varchar2(1) -- 交易系统,0-法院查控1-公安查控2-监委查控3-电信反欺诈   
    ,tradetype varchar2(1) -- 交易类型,0-查询请求1-冻结请求2-扣划请求   
    ,zjmc varchar2(200) -- 证件名称   
    ,djr varchar2(100) -- 登记人   
    ,djrq varchar2(8) -- 登记日期   
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_icps_afa_jzck_documents to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_icps_afa_jzck_documents is '法律文书信息表';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.productcode is '产品代码';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.workdate is '平台日期';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.agentserialno is '平台流水号';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.worktime is '平台时间';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.fileflag is '文件标志:0-文书,1-证件,2-其他';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.fileid is '文件序号';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.transserialnumber is '传输报文流水号';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.applicationid is '业务申请编号';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.casenumber is '案件编号';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.documentnumber is '文书编号';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.filename is '文件名称';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.filetype is '文件格式类型编码:0-Jpg,1-PDF,2-Word';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.filetypename is '文件格式类型名称';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.documenttype is '文件类型编码';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.documenttypename is '文件类型名称';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.documentmd5 is '文件MD5';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.filepath is '文件存放路径';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.content is '文件内容';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.remark1 is '备用字段1';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.remark2 is '备用字段2';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.remark3 is '备用字段3';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.remark4 is '备用字段4';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.tradesystem is '交易系统,0-法院查控1-公安查控2-监委查控3-电信反欺诈';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.tradetype is '交易类型,0-查询请求1-冻结请求2-扣划请求';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.zjmc is '证件名称';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.djr is '登记人';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.djrq is '登记日期';
comment on column ${idl_schema}.aml_icps_afa_jzck_documents.etl_timestamp is '数据处理时间';