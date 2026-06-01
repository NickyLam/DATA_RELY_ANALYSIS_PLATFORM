/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbhisfeyehz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbhisfeyehz
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbhisfeyehz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbhisfeyehz(
    sum_date number(22) -- 
    ,sum_flag varchar2(3) -- 
    ,internal_branch varchar2(36) -- 
    ,client_type varchar2(3) -- 
    ,prd_code varchar2(60) -- 
    ,branch_no varchar2(48) -- 
    ,ta_code varchar2(27) -- 
    ,tot_vol number(18,3) -- 
    ,long_frozen_vol number(18,3) -- 
    ,nav number(18,8) -- 
    ,client_num number(22) -- 
    ,prd_type varchar2(3) -- 
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
grant select on ${iol_schema}.ifms_tbhisfeyehz to ${iml_schema};
grant select on ${iol_schema}.ifms_tbhisfeyehz to ${icl_schema};
grant select on ${iol_schema}.ifms_tbhisfeyehz to ${idl_schema};
grant select on ${iol_schema}.ifms_tbhisfeyehz to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbhisfeyehz is '份额余额汇总表';
comment on column ${iol_schema}.ifms_tbhisfeyehz.sum_date is '';
comment on column ${iol_schema}.ifms_tbhisfeyehz.sum_flag is '';
comment on column ${iol_schema}.ifms_tbhisfeyehz.internal_branch is '';
comment on column ${iol_schema}.ifms_tbhisfeyehz.client_type is '';
comment on column ${iol_schema}.ifms_tbhisfeyehz.prd_code is '';
comment on column ${iol_schema}.ifms_tbhisfeyehz.branch_no is '';
comment on column ${iol_schema}.ifms_tbhisfeyehz.ta_code is '';
comment on column ${iol_schema}.ifms_tbhisfeyehz.tot_vol is '';
comment on column ${iol_schema}.ifms_tbhisfeyehz.long_frozen_vol is '';
comment on column ${iol_schema}.ifms_tbhisfeyehz.nav is '';
comment on column ${iol_schema}.ifms_tbhisfeyehz.client_num is '';
comment on column ${iol_schema}.ifms_tbhisfeyehz.prd_type is '';
comment on column ${iol_schema}.ifms_tbhisfeyehz.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbhisfeyehz.etl_timestamp is 'ETL处理时间戳';
