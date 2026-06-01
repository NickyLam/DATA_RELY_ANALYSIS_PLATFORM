/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_fbs_v_deal_settle_path
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_fbs_v_deal_settle_path
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_fbs_v_deal_settle_path purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_deal_settle_path(
    deal_sqno varchar2(27) -- 
    ,self_pay number(8,0) -- 
    ,self_receive number(8,0) -- 
    ,cp_receive number(8,0) -- 
    ,cp_pay number(8,0) -- 
    ,system_name varchar2(15) -- 
    ,is_from_pack varchar2(2) -- 
    ,deal_type varchar2(75) -- 
    ,memo varchar2(750) -- 
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
grant select on ${iol_schema}.ctms_fbs_v_deal_settle_path to ${iml_schema};
grant select on ${iol_schema}.ctms_fbs_v_deal_settle_path to ${icl_schema};
grant select on ${iol_schema}.ctms_fbs_v_deal_settle_path to ${idl_schema};
grant select on ${iol_schema}.ctms_fbs_v_deal_settle_path to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_fbs_v_deal_settle_path is '交易清算路径视图';
comment on column ${iol_schema}.ctms_fbs_v_deal_settle_path.deal_sqno is '';
comment on column ${iol_schema}.ctms_fbs_v_deal_settle_path.self_pay is '';
comment on column ${iol_schema}.ctms_fbs_v_deal_settle_path.self_receive is '';
comment on column ${iol_schema}.ctms_fbs_v_deal_settle_path.cp_receive is '';
comment on column ${iol_schema}.ctms_fbs_v_deal_settle_path.cp_pay is '';
comment on column ${iol_schema}.ctms_fbs_v_deal_settle_path.system_name is '';
comment on column ${iol_schema}.ctms_fbs_v_deal_settle_path.is_from_pack is '';
comment on column ${iol_schema}.ctms_fbs_v_deal_settle_path.deal_type is '';
comment on column ${iol_schema}.ctms_fbs_v_deal_settle_path.memo is '';
comment on column ${iol_schema}.ctms_fbs_v_deal_settle_path.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_fbs_v_deal_settle_path.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_fbs_v_deal_settle_path.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_fbs_v_deal_settle_path.etl_timestamp is 'ETL处理时间戳';
