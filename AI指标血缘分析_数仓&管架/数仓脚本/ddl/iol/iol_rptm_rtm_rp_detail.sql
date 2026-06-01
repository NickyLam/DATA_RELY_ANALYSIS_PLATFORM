/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rptm_rtm_rp_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rptm_rtm_rp_detail
whenever sqlerror continue none;
drop table ${iol_schema}.rptm_rtm_rp_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_rp_detail(
    bus_id varchar2(576) -- 
    ,ybj_rp_type varchar2(18) -- 
    ,rp_name varchar2(1800) -- 
    ,ybj_card_type varchar2(90) -- 
    ,card_no varchar2(900) -- 
    ,rea_no varchar2(2295) -- 
    ,inst_org varchar2(450) -- 
    ,economic_nature varchar2(450) -- 
    ,registered varchar2(4000) -- 
    ,effect_state varchar2(18) -- 
    ,active_time varchar2(72) -- 
    ,invalid_time varchar2(72) -- 
    ,etl_dt varchar2(72) -- 
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
grant select on ${iol_schema}.rptm_rtm_rp_detail to ${iml_schema};
grant select on ${iol_schema}.rptm_rtm_rp_detail to ${icl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_detail to ${idl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.rptm_rtm_rp_detail is '关联方名单';
comment on column ${iol_schema}.rptm_rtm_rp_detail.bus_id is '';
comment on column ${iol_schema}.rptm_rtm_rp_detail.ybj_rp_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_detail.rp_name is '';
comment on column ${iol_schema}.rptm_rtm_rp_detail.ybj_card_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_detail.card_no is '';
comment on column ${iol_schema}.rptm_rtm_rp_detail.rea_no is '';
comment on column ${iol_schema}.rptm_rtm_rp_detail.inst_org is '';
comment on column ${iol_schema}.rptm_rtm_rp_detail.economic_nature is '';
comment on column ${iol_schema}.rptm_rtm_rp_detail.registered is '';
comment on column ${iol_schema}.rptm_rtm_rp_detail.effect_state is '';
comment on column ${iol_schema}.rptm_rtm_rp_detail.active_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_detail.invalid_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_detail.etl_dt is '';
comment on column ${iol_schema}.rptm_rtm_rp_detail.start_dt is '开始时间';
comment on column ${iol_schema}.rptm_rtm_rp_detail.end_dt is '结束时间';
comment on column ${iol_schema}.rptm_rtm_rp_detail.id_mark is '增删标志';
comment on column ${iol_schema}.rptm_rtm_rp_detail.etl_timestamp is 'ETL处理时间戳';
