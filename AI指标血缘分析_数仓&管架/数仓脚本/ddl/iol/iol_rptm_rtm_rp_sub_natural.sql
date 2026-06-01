/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rptm_rtm_rp_sub_natural
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rptm_rtm_rp_sub_natural
whenever sqlerror continue none;
drop table ${iol_schema}.rptm_rtm_rp_sub_natural purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_rp_sub_natural(
    id varchar2(288) -- 
    ,record_bus_id varchar2(576) -- 
    ,rp_name varchar2(1800) -- 
    ,domestic_state varchar2(18) -- 
    ,card_type varchar2(36) -- 
    ,card_no varchar2(900) -- 
    ,create_user varchar2(288) -- 
    ,create_time date -- 
    ,create_org varchar2(288) -- 
    ,create_dep varchar2(288) -- 
    ,update_user varchar2(288) -- 
    ,update_time date -- 
    ,update_org varchar2(288) -- 
    ,update_dep varchar2(288) -- 
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
grant select on ${iol_schema}.rptm_rtm_rp_sub_natural to ${iml_schema};
grant select on ${iol_schema}.rptm_rtm_rp_sub_natural to ${icl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_sub_natural to ${idl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_sub_natural to ${iel_schema};

-- comment
comment on table ${iol_schema}.rptm_rtm_rp_sub_natural is '关联方档案自然人详情表';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.id is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.record_bus_id is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.rp_name is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.domestic_state is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.card_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.card_no is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.create_user is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.create_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.create_org is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.create_dep is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.update_user is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.update_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.update_org is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.update_dep is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.reserve1 is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.reserve2 is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.reserve3 is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.start_dt is '开始时间';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.end_dt is '结束时间';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.id_mark is '增删标志';
comment on column ${iol_schema}.rptm_rtm_rp_sub_natural.etl_timestamp is 'ETL处理时间戳';
