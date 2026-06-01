/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_orws_tdm_enumitem
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_orws_tdm_enumitem
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_orws_tdm_enumitem purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_orws_tdm_enumitem(
    etl_dt date
    ,enumid number(18)
    ,enumsortid number(18)
    ,superenumid number(18)
    ,enumword varchar2(50)
    ,code varchar2(30)
    ,name varchar2(255)
    ,seqno number(18)
    ,status number(18)
    ,managetype number(18)
    ,isdefault number(1)
    ,iscanselect number(1)
    ,remark varchar2(250)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_orws_tdm_enumitem to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_orws_tdm_enumitem is '系统枚举值表';
comment on column ${msl_schema}.msl_edw_orws_tdm_enumitem.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_orws_tdm_enumitem.enumid is '';
comment on column ${msl_schema}.msl_edw_orws_tdm_enumitem.enumsortid is '';
comment on column ${msl_schema}.msl_edw_orws_tdm_enumitem.superenumid is '';
comment on column ${msl_schema}.msl_edw_orws_tdm_enumitem.enumword is '';
comment on column ${msl_schema}.msl_edw_orws_tdm_enumitem.code is '';
comment on column ${msl_schema}.msl_edw_orws_tdm_enumitem.name is '';
comment on column ${msl_schema}.msl_edw_orws_tdm_enumitem.seqno is '';
comment on column ${msl_schema}.msl_edw_orws_tdm_enumitem.status is '';
comment on column ${msl_schema}.msl_edw_orws_tdm_enumitem.managetype is '';
comment on column ${msl_schema}.msl_edw_orws_tdm_enumitem.isdefault is '';
comment on column ${msl_schema}.msl_edw_orws_tdm_enumitem.iscanselect is '';
comment on column ${msl_schema}.msl_edw_orws_tdm_enumitem.remark is '';
