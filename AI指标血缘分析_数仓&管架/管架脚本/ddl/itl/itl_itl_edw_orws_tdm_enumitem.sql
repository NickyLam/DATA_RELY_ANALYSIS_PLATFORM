/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_orws_tdm_enumitem
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_orws_tdm_enumitem
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_orws_tdm_enumitem purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_orws_tdm_enumitem(
    enumid  number(18) -- 
    ,enumsortid   number(18)           -- 
    ,superenumid  number(18)           -- 
    ,enumword     varchar2(50) -- 
    ,code         varchar2(30)           -- 
    ,name         varchar2(255)          -- 
    ,seqno        number(18)               -- 
    ,status       number(18)             -- 
    ,managetype   number(18)              -- 
    ,isdefault    number(1)              -- 
    ,iscanselect  number(1)              -- 
    ,remark  varchar2(250) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_orws_tdm_enumitem to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_orws_tdm_enumitem is '系统枚举值表';
comment on column ${itl_schema}.itl_edw_orws_tdm_enumitem.enumid  is '';
comment on column ${itl_schema}.itl_edw_orws_tdm_enumitem.enumsortid   is '';
comment on column ${itl_schema}.itl_edw_orws_tdm_enumitem.superenumid  is '';
comment on column ${itl_schema}.itl_edw_orws_tdm_enumitem.enumword     is '';
comment on column ${itl_schema}.itl_edw_orws_tdm_enumitem.code         is '';
comment on column ${itl_schema}.itl_edw_orws_tdm_enumitem.name         is '';
comment on column ${itl_schema}.itl_edw_orws_tdm_enumitem.seqno        is '';
comment on column ${itl_schema}.itl_edw_orws_tdm_enumitem.status       is '';
comment on column ${itl_schema}.itl_edw_orws_tdm_enumitem.managetype   is '';
comment on column ${itl_schema}.itl_edw_orws_tdm_enumitem.isdefault    is '';
comment on column ${itl_schema}.itl_edw_orws_tdm_enumitem.iscanselect  is '';
comment on column ${itl_schema}.itl_edw_orws_tdm_enumitem.remark  is '';
comment on column ${itl_schema}.itl_edw_orws_tdm_enumitem.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_orws_tdm_enumitem.etl_timestamp is 'ETL处理时间戳';