/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_fds_tbprddaily
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_fds_tbprddaily
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_fds_tbprddaily purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_fds_tbprddaily(
    bank_no varchar2(14) -- 
    ,iss_date number(22,0) -- 
    ,cfm_date number(22,0) -- 
    ,prd_code varchar2(30) -- 
    ,real_prd_code varchar2(30) -- 
    ,ta_code varchar2(14) -- 
    ,prd_scale number(18,2) -- 
    ,tot_vol number(18,3) -- 
    ,increase_vol number(18,3) -- 
    ,reduce_vol number(18,3) -- 
    ,nav number(18,8) -- 
    ,face_value number(18,8) -- 
    ,larg_red_flag varchar2(2) -- 
    ,larg_red_cfm_rate number(9,8) -- 
    ,chgout_cfm_rate number(9,8) -- 
    ,excess_flag varchar2(2) -- 
    ,excess_cfm_rate number(9,8) -- 
    ,income_rate number(18,8) -- 
    ,income number(18,8) -- 
    ,income_unit number(18,4) -- 
    ,unassign_income number(18,3) -- 
    ,assign_income number(18,2) -- 
    ,assign_flag varchar2(2) -- 
    ,conv_flag varchar2(2) -- 
    ,status varchar2(2) -- 
    ,last_status varchar2(2) -- 
    ,tot_nav number(23,8) -- 
    ,amt1 number(18,2) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_fds_tbprddaily to ${iml_schema};
grant select on ${iol_schema}.ifms_fds_tbprddaily to ${icl_schema};
grant select on ${iol_schema}.ifms_fds_tbprddaily to ${idl_schema};
grant select on ${iol_schema}.ifms_fds_tbprddaily to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_fds_tbprddaily is '产品日信息表';
comment on column ${iol_schema}.ifms_fds_tbprddaily.bank_no is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.iss_date is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.cfm_date is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.prd_code is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.real_prd_code is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.ta_code is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.prd_scale is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.tot_vol is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.increase_vol is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.reduce_vol is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.nav is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.face_value is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.larg_red_flag is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.larg_red_cfm_rate is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.chgout_cfm_rate is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.excess_flag is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.excess_cfm_rate is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.income_rate is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.income is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.income_unit is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.unassign_income is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.assign_income is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.assign_flag is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.conv_flag is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.status is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.last_status is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.tot_nav is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.amt1 is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.reserve1 is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.reserve2 is '';
comment on column ${iol_schema}.ifms_fds_tbprddaily.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_fds_tbprddaily.etl_timestamp is 'ETL处理时间戳';
