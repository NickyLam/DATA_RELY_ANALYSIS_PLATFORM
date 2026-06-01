/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orws_t_match_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orws_t_match_info
whenever sqlerror continue none;
drop table ${iol_schema}.orws_t_match_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_t_match_info(
    cust_no varchar2(150) -- 
    ,own_organ varchar2(150) -- 
    ,organ_code varchar2(150) -- 
    ,acct_num varchar2(300) -- 
    ,acct_name varchar2(750) -- 
    ,acct_type varchar2(150) -- 
    ,licence_regist_num varchar2(300) -- 
    ,licence_social_num varchar2(300) -- 
    ,other_credtype varchar2(300) -- 
    ,core_people varchar2(3000) -- 
    ,core_business varchar2(3000) -- 
    ,people_business varchar2(3000) -- 
    ,suspend_info varchar2(4000) -- 
    ,manage_state varchar2(150) -- 
    ,abnormal_con varchar2(3000) -- 
    ,illegal_breach varchar2(3000) -- 
    ,last_inspect varchar2(150) -- 
    ,check_dt varchar2(150) -- 
    ,inspect_dt varchar2(150) -- 
    ,etl_dt_ora timestamp -- 
    ,org_num varchar2(100) -- 
    ,establish_dt varchar2(150) -- 
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
grant select on ${iol_schema}.orws_t_match_info to ${iml_schema};
grant select on ${iol_schema}.orws_t_match_info to ${icl_schema};
grant select on ${iol_schema}.orws_t_match_info to ${idl_schema};
grant select on ${iol_schema}.orws_t_match_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.orws_t_match_info is '';
comment on column ${iol_schema}.orws_t_match_info.cust_no is '';
comment on column ${iol_schema}.orws_t_match_info.own_organ is '';
comment on column ${iol_schema}.orws_t_match_info.organ_code is '';
comment on column ${iol_schema}.orws_t_match_info.acct_num is '';
comment on column ${iol_schema}.orws_t_match_info.acct_name is '';
comment on column ${iol_schema}.orws_t_match_info.acct_type is '';
comment on column ${iol_schema}.orws_t_match_info.licence_regist_num is '';
comment on column ${iol_schema}.orws_t_match_info.licence_social_num is '';
comment on column ${iol_schema}.orws_t_match_info.other_credtype is '';
comment on column ${iol_schema}.orws_t_match_info.core_people is '';
comment on column ${iol_schema}.orws_t_match_info.core_business is '';
comment on column ${iol_schema}.orws_t_match_info.people_business is '';
comment on column ${iol_schema}.orws_t_match_info.suspend_info is '';
comment on column ${iol_schema}.orws_t_match_info.manage_state is '';
comment on column ${iol_schema}.orws_t_match_info.abnormal_con is '';
comment on column ${iol_schema}.orws_t_match_info.illegal_breach is '';
comment on column ${iol_schema}.orws_t_match_info.last_inspect is '';
comment on column ${iol_schema}.orws_t_match_info.check_dt is '';
comment on column ${iol_schema}.orws_t_match_info.inspect_dt is '';
comment on column ${iol_schema}.orws_t_match_info.etl_dt_ora is '';
comment on column ${iol_schema}.orws_t_match_info.org_num is '';
comment on column ${iol_schema}.orws_t_match_info.establish_dt is '';
comment on column ${iol_schema}.orws_t_match_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.orws_t_match_info.etl_timestamp is 'ETL处理时间戳';
