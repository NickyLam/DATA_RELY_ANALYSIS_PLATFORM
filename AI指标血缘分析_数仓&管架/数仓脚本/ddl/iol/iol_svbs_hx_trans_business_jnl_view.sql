/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol svbs_hx_trans_business_jnl_view
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.svbs_hx_trans_business_jnl_view
whenever sqlerror continue none;
drop table ${iol_schema}.svbs_hx_trans_business_jnl_view purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.svbs_hx_trans_business_jnl_view(
    trans_date varchar2(256) -- 
    ,orgid varchar2(72) -- 
    ,departmentid varchar2(60) -- 
    ,departmentname varchar2(384) -- 
    ,client_id varchar2(48) -- 
    ,agentname varchar2(192) -- 
    ,author_id varchar2(48) -- 
    ,trans_code varchar2(96) -- 
    ,resourcename varchar2(4000) -- 
    ,trans_time timestamp -- 
    ,update_time timestamp -- 
    ,author_name varchar2(1200) -- 
    ,author_org_id varchar2(150) -- 
    ,access_jnl_no varchar2(4000) -- 
    ,ststem_name varchar2(60) -- 
    ,stm_jnl_no varchar2(50) -- STM授权流水号
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
grant select on ${iol_schema}.svbs_hx_trans_business_jnl_view to ${iml_schema};
grant select on ${iol_schema}.svbs_hx_trans_business_jnl_view to ${icl_schema};
grant select on ${iol_schema}.svbs_hx_trans_business_jnl_view to ${idl_schema};
grant select on ${iol_schema}.svbs_hx_trans_business_jnl_view to ${iel_schema};

-- comment
comment on table ${iol_schema}.svbs_hx_trans_business_jnl_view is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.trans_date is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.orgid is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.departmentid is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.departmentname is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.client_id is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.agentname is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.author_id is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.trans_code is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.resourcename is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.trans_time is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.update_time is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.author_name is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.author_org_id is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.access_jnl_no is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.ststem_name is '';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.stm_jnl_no is 'STM授权流水号';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.svbs_hx_trans_business_jnl_view.etl_timestamp is 'ETL处理时间戳';
