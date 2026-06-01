/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rptm_rtm_rp_insider
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rptm_rtm_rp_insider
whenever sqlerror continue none;
drop table ${iol_schema}.rptm_rtm_rp_insider purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_rp_insider(
    id varchar2(288) -- 
    ,bus_id varchar2(576) -- 
    ,insider_name varchar2(1800) -- 
    ,card_type varchar2(90) -- 
    ,card_no varchar2(900) -- 
    ,duty varchar2(900) -- 
    ,data_state varchar2(18) -- 
    ,create_user varchar2(288) -- 
    ,create_time date -- 
    ,create_org varchar2(288) -- 
    ,update_user varchar2(288) -- 
    ,update_time date -- 
    ,update_org varchar2(288) -- 
    ,wf_state varchar2(18) -- 
    ,process_instance_id varchar2(576) -- 
    ,reserve1 varchar2(2295) -- 
    ,reserve2 varchar2(2295) -- 
    ,reserve3 varchar2(2295) -- 
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
grant select on ${iol_schema}.rptm_rtm_rp_insider to ${iml_schema};
grant select on ${iol_schema}.rptm_rtm_rp_insider to ${icl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_insider to ${idl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_insider to ${iel_schema};

-- comment
comment on table ${iol_schema}.rptm_rtm_rp_insider is '内部人信息表';
comment on column ${iol_schema}.rptm_rtm_rp_insider.id is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.bus_id is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.insider_name is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.card_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.card_no is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.duty is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.data_state is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.create_user is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.create_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.create_org is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.update_user is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.update_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.update_org is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.wf_state is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.process_instance_id is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.reserve1 is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.reserve2 is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.reserve3 is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider.start_dt is '开始时间';
comment on column ${iol_schema}.rptm_rtm_rp_insider.end_dt is '结束时间';
comment on column ${iol_schema}.rptm_rtm_rp_insider.id_mark is '增删标志';
comment on column ${iol_schema}.rptm_rtm_rp_insider.etl_timestamp is 'ETL处理时间戳';
