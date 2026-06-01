/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a72tsmpsdcard
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a72tsmpsdcard
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a72tsmpsdcard purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a72tsmpsdcard(
    sdcard varchar2(30) -- sd卡号
    ,certid varchar2(60) -- 证件号码
    ,certidtype varchar2(3) -- 证件类型
    ,custno varchar2(30) -- 客户号
    ,sdcardstate varchar2(2) -- sd卡状态 0-正常，1-销户 ，2-挂失， 3-预开立（尚未下载芯片卡）,4-预插入,5-被冲正
    ,custmng varchar2(30) -- 客户经理号
    ,brcno varchar2(15) -- 机构号
    ,tlrno varchar2(15) -- 柜员号
    ,chnltrnseqno varchar2(38) -- 原系统标识号，凭证冲正用
    ,acctname varchar2(120) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a72tsmpsdcard to ${iml_schema};
grant select on ${iol_schema}.mpcs_a72tsmpsdcard to ${icl_schema};
grant select on ${iol_schema}.mpcs_a72tsmpsdcard to ${idl_schema};
grant select on ${iol_schema}.mpcs_a72tsmpsdcard to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a72tsmpsdcard is 'TSMPSD卡信息表';
comment on column ${iol_schema}.mpcs_a72tsmpsdcard.sdcard is 'sd卡号';
comment on column ${iol_schema}.mpcs_a72tsmpsdcard.certid is '证件号码';
comment on column ${iol_schema}.mpcs_a72tsmpsdcard.certidtype is '证件类型';
comment on column ${iol_schema}.mpcs_a72tsmpsdcard.custno is '客户号';
comment on column ${iol_schema}.mpcs_a72tsmpsdcard.sdcardstate is 'sd卡状态 0-正常，1-销户 ，2-挂失， 3-预开立（尚未下载芯片卡）,4-预插入,5-被冲正';
comment on column ${iol_schema}.mpcs_a72tsmpsdcard.custmng is '客户经理号';
comment on column ${iol_schema}.mpcs_a72tsmpsdcard.brcno is '机构号';
comment on column ${iol_schema}.mpcs_a72tsmpsdcard.tlrno is '柜员号';
comment on column ${iol_schema}.mpcs_a72tsmpsdcard.chnltrnseqno is '原系统标识号，凭证冲正用';
comment on column ${iol_schema}.mpcs_a72tsmpsdcard.acctname is '';
comment on column ${iol_schema}.mpcs_a72tsmpsdcard.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a72tsmpsdcard.etl_timestamp is 'ETL处理时间戳';
