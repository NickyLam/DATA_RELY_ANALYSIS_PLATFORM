/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rptm_rtm_rp_natural
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rptm_rtm_rp_natural
whenever sqlerror continue none;
drop table ${iol_schema}.rptm_rtm_rp_natural purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_rp_natural(
    id varchar2(96) -- 
    ,bus_id varchar2(192) -- 
    ,east_rp_type varchar2(6) -- 
    ,ybj_rp_type varchar2(6) -- 
    ,rp_name varchar2(600) -- 
    ,ybj_card_type varchar2(30) -- 
    ,east_card_type varchar2(6) -- 
    ,card_no varchar2(300) -- 
    ,domestic_state varchar2(6) -- 
    ,rea_no varchar2(765) -- 
    ,inst_org varchar2(150) -- 
    ,east_relation_type varchar2(9) -- 
    ,org_type varchar2(6) -- 
    ,bloc_state varchar2(6) -- 
    ,bloc_id varchar2(192) -- 
    ,remarks varchar2(3000) -- 
    ,data_state varchar2(6) -- 
    ,effect_state varchar2(6) -- 
    ,active_time date -- 
    ,invalid_time date -- 
    ,process_time date -- 
    ,data_source varchar2(6) -- 
    ,legal_org_code varchar2(765) -- 
    ,create_user varchar2(96) -- 
    ,create_time date -- 
    ,create_org varchar2(96) -- 
    ,create_dep varchar2(96) -- 
    ,update_user varchar2(96) -- 
    ,update_time date -- 
    ,update_org varchar2(96) -- 
    ,update_dep varchar2(96) -- 
    ,wf_state varchar2(6) -- 
    ,agree varchar2(1500) -- 
    ,process_instance_id varchar2(192) -- 
    ,reserve1 varchar2(765) -- 
    ,reserve2 varchar2(765) -- 
    ,reserve3 varchar2(765) -- 
    ,duty varchar2(600) -- 
    ,cust_no varchar2(192) -- 
    ,east_rp_bad_info varchar2(6) -- 不良信息-east报表口径
    ,east_rp_economic_nature varchar2(6) -- 经济性质和类型-east报表口径
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
grant select on ${iol_schema}.rptm_rtm_rp_natural to ${iml_schema};
grant select on ${iol_schema}.rptm_rtm_rp_natural to ${icl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_natural to ${idl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_natural to ${iel_schema};

-- comment
comment on table ${iol_schema}.rptm_rtm_rp_natural is '关联自然人主表';
comment on column ${iol_schema}.rptm_rtm_rp_natural.id is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.bus_id is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.east_rp_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.ybj_rp_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.rp_name is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.ybj_card_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.east_card_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.card_no is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.domestic_state is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.rea_no is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.inst_org is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.east_relation_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.org_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.bloc_state is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.bloc_id is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.remarks is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.data_state is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.effect_state is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.active_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.invalid_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.process_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.data_source is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.legal_org_code is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.create_user is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.create_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.create_org is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.create_dep is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.update_user is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.update_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.update_org is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.update_dep is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.wf_state is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.agree is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.process_instance_id is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.reserve1 is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.reserve2 is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.reserve3 is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.duty is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.cust_no is '';
comment on column ${iol_schema}.rptm_rtm_rp_natural.east_rp_bad_info is '不良信息-east报表口径';
comment on column ${iol_schema}.rptm_rtm_rp_natural.east_rp_economic_nature is '经济性质和类型-east报表口径';
comment on column ${iol_schema}.rptm_rtm_rp_natural.start_dt is '开始时间';
comment on column ${iol_schema}.rptm_rtm_rp_natural.end_dt is '结束时间';
comment on column ${iol_schema}.rptm_rtm_rp_natural.id_mark is '增删标志';
comment on column ${iol_schema}.rptm_rtm_rp_natural.etl_timestamp is 'ETL处理时间戳';
