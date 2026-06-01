/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_fmws_opbr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_fmws_opbr
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_fmws_opbr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fmws_opbr(
    inr varchar2(12) -- 
    ,opbrar varchar2(9) -- 
    ,opbrpc varchar2(9) -- 
    ,opbrad varchar2(192) -- 
    ,opendt date -- 
    ,opbrtp varchar2(3) -- 
    ,opbrna varchar2(96) -- 
    ,opbrnt varchar2(5) -- 
    ,opbrno varchar2(24) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.isbs_fmws_opbr to ${iml_schema};
grant select on ${iol_schema}.isbs_fmws_opbr to ${icl_schema};
grant select on ${iol_schema}.isbs_fmws_opbr to ${idl_schema};
grant select on ${iol_schema}.isbs_fmws_opbr to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_fmws_opbr is '银行信息表';
comment on column ${iol_schema}.isbs_fmws_opbr.inr is '';
comment on column ${iol_schema}.isbs_fmws_opbr.opbrar is '';
comment on column ${iol_schema}.isbs_fmws_opbr.opbrpc is '';
comment on column ${iol_schema}.isbs_fmws_opbr.opbrad is '';
comment on column ${iol_schema}.isbs_fmws_opbr.opendt is '';
comment on column ${iol_schema}.isbs_fmws_opbr.opbrtp is '';
comment on column ${iol_schema}.isbs_fmws_opbr.opbrna is '';
comment on column ${iol_schema}.isbs_fmws_opbr.opbrnt is '';
comment on column ${iol_schema}.isbs_fmws_opbr.opbrno is '';
comment on column ${iol_schema}.isbs_fmws_opbr.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_fmws_opbr.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_fmws_opbr.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_fmws_opbr.etl_timestamp is 'ETL处理时间戳';
