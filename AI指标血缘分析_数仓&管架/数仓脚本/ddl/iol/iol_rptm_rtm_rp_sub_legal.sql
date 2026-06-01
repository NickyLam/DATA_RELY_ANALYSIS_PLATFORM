/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rptm_rtm_rp_sub_legal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rptm_rtm_rp_sub_legal
whenever sqlerror continue none;
drop table ${iol_schema}.rptm_rtm_rp_sub_legal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_rp_sub_legal(
    id varchar2(288) -- 
    ,record_bus_id varchar2(576) -- 
    ,rp_name varchar2(1800) -- 
    ,domestic_state varchar2(18) -- 
    ,card_type varchar2(72) -- 
    ,card_no varchar2(900) -- 
    ,economic_nature varchar2(450) -- 
    ,economic_scope varchar2(4000) -- 
    ,representative varchar2(1800) -- 
    ,registered varchar2(4000) -- 
    ,registered_capital number(22,6) -- 
    ,legal_org_code varchar2(2295) -- 
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
grant select on ${iol_schema}.rptm_rtm_rp_sub_legal to ${iml_schema};
grant select on ${iol_schema}.rptm_rtm_rp_sub_legal to ${icl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_sub_legal to ${idl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_sub_legal to ${iel_schema};

-- comment
comment on table ${iol_schema}.rptm_rtm_rp_sub_legal is '关联方档案法人详情表';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.id is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.record_bus_id is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.rp_name is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.domestic_state is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.card_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.card_no is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.economic_nature is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.economic_scope is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.representative is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.registered is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.registered_capital is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.legal_org_code is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.create_user is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.create_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.create_org is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.create_dep is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.update_user is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.update_time is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.update_org is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.update_dep is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.reserve1 is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.reserve2 is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.reserve3 is '';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.start_dt is '开始时间';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.end_dt is '结束时间';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.id_mark is '增删标志';
comment on column ${iol_schema}.rptm_rtm_rp_sub_legal.etl_timestamp is 'ETL处理时间戳';
