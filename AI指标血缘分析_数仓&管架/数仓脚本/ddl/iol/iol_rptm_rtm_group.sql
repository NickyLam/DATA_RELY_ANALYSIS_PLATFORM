/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rptm_rtm_group
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rptm_rtm_group
whenever sqlerror continue none;
drop table ${iol_schema}.rptm_rtm_group purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_group(
    id varchar2(2250) -- 
    ,rp_name varchar2(2250) -- 
    ,ybj_rp_card_type varchar2(90) -- 
    ,rp_card_no varchar2(900) -- 
    ,group_id varchar2(900) -- 
    ,group_name varchar2(2250) -- 
    ,etl_dt date -- 
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
grant select on ${iol_schema}.rptm_rtm_group to ${iml_schema};
grant select on ${iol_schema}.rptm_rtm_group to ${icl_schema};
grant select on ${iol_schema}.rptm_rtm_group to ${idl_schema};
grant select on ${iol_schema}.rptm_rtm_group to ${iel_schema};

-- comment
comment on table ${iol_schema}.rptm_rtm_group is '集团信息表';
comment on column ${iol_schema}.rptm_rtm_group.id is '';
comment on column ${iol_schema}.rptm_rtm_group.rp_name is '';
comment on column ${iol_schema}.rptm_rtm_group.ybj_rp_card_type is '';
comment on column ${iol_schema}.rptm_rtm_group.rp_card_no is '';
comment on column ${iol_schema}.rptm_rtm_group.group_id is '';
comment on column ${iol_schema}.rptm_rtm_group.group_name is '';
comment on column ${iol_schema}.rptm_rtm_group.etl_dt is '';
comment on column ${iol_schema}.rptm_rtm_group.start_dt is '开始时间';
comment on column ${iol_schema}.rptm_rtm_group.end_dt is '结束时间';
comment on column ${iol_schema}.rptm_rtm_group.id_mark is '增删标志';
comment on column ${iol_schema}.rptm_rtm_group.etl_timestamp is 'ETL处理时间戳';
