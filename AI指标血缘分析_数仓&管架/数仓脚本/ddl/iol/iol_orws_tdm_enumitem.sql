/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orws_tdm_enumitem
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orws_tdm_enumitem
whenever sqlerror continue none;
drop table ${iol_schema}.orws_tdm_enumitem purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_tdm_enumitem(
    enumid number(18) -- 
    ,enumsortid number(18) -- 
    ,superenumid number(18) -- 
    ,enumword varchar2(75) -- 
    ,code varchar2(45) -- 
    ,name varchar2(383) -- 
    ,seqno number(18) -- 
    ,status number(18) -- 
    ,managetype number(18) -- 
    ,isdefault number(1) -- 
    ,iscanselect number(1) -- 
    ,remark varchar2(375) -- 
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
grant select on ${iol_schema}.orws_tdm_enumitem to ${iml_schema};
grant select on ${iol_schema}.orws_tdm_enumitem to ${icl_schema};
grant select on ${iol_schema}.orws_tdm_enumitem to ${idl_schema};
grant select on ${iol_schema}.orws_tdm_enumitem to ${iel_schema};

-- comment
comment on table ${iol_schema}.orws_tdm_enumitem is '系统枚举值表';
comment on column ${iol_schema}.orws_tdm_enumitem.enumid is '';
comment on column ${iol_schema}.orws_tdm_enumitem.enumsortid is '';
comment on column ${iol_schema}.orws_tdm_enumitem.superenumid is '';
comment on column ${iol_schema}.orws_tdm_enumitem.enumword is '';
comment on column ${iol_schema}.orws_tdm_enumitem.code is '';
comment on column ${iol_schema}.orws_tdm_enumitem.name is '';
comment on column ${iol_schema}.orws_tdm_enumitem.seqno is '';
comment on column ${iol_schema}.orws_tdm_enumitem.status is '';
comment on column ${iol_schema}.orws_tdm_enumitem.managetype is '';
comment on column ${iol_schema}.orws_tdm_enumitem.isdefault is '';
comment on column ${iol_schema}.orws_tdm_enumitem.iscanselect is '';
comment on column ${iol_schema}.orws_tdm_enumitem.remark is '';
comment on column ${iol_schema}.orws_tdm_enumitem.start_dt is '开始时间';
comment on column ${iol_schema}.orws_tdm_enumitem.end_dt is '结束时间';
comment on column ${iol_schema}.orws_tdm_enumitem.id_mark is '增删标志';
comment on column ${iol_schema}.orws_tdm_enumitem.etl_timestamp is 'ETL处理时间戳';
