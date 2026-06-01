/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rptm_rtm_rp_insider_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rptm_rtm_rp_insider_relation
whenever sqlerror continue none;
drop table ${iol_schema}.rptm_rtm_rp_insider_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_rp_insider_relation(
    id varchar2(288) -- 
    ,bus_id varchar2(576) -- 
    ,entity_bus_id varchar2(576) -- 
    ,entity_rp_type varchar2(1800) -- 
    ,entity_name varchar2(1800) -- 
    ,entity_card_type varchar2(90) -- 
    ,entity_card_no varchar2(900) -- 
    ,super_bus_id varchar2(576) -- 
    ,super_name varchar2(1800) -- 
    ,super_card_type varchar2(90) -- 
    ,relation_info varchar2(900) -- 
    ,super_card_no varchar2(900) -- 
    ,hold_name varchar2(900) -- 
    ,hold_card_type varchar2(900) -- 
    ,hold_card_no varchar2(900) -- 
    ,hold_rate number(8,4) -- 
    ,hold_num number(8,4) -- 
    ,company_type varchar2(18) -- 
    ,economic_nature varchar2(450) -- 
    ,business_state varchar2(18) -- 
    ,registered_capital number(22,6) -- 
    ,representative varchar2(1800) -- 
    ,create_user varchar2(288) -- 
    ,create_time date -- 
    ,create_org varchar2(288) -- 
    ,update_user varchar2(288) -- 
    ,update_time date -- 
    ,update_org varchar2(288) -- 
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
grant select on ${iol_schema}.rptm_rtm_rp_insider_relation to ${iml_schema};
grant select on ${iol_schema}.rptm_rtm_rp_insider_relation to ${icl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_insider_relation to ${idl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_insider_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.rptm_rtm_rp_insider_relation is '内部人关系表';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.id is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.bus_id is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.entity_bus_id is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.entity_rp_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.entity_name is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.entity_card_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.entity_card_no is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.super_bus_id is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.super_name is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.super_card_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.relation_info is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.super_card_no is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.hold_name is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.hold_card_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.hold_card_no is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.hold_rate is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.hold_num is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.company_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.economic_nature is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.business_state is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.registered_capital is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.representative is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.create_user is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.create_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.create_org is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.update_user is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.update_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.update_org is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.reserve1 is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.reserve2 is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.reserve3 is '';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.start_dt is '开始时间';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.end_dt is '结束时间';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.id_mark is '增删标志';
comment on column ${iol_schema}.rptm_rtm_rp_insider_relation.etl_timestamp is 'ETL处理时间戳';
