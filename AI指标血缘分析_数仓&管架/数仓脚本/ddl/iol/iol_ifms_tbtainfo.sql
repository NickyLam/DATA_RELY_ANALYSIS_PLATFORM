/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbtainfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbtainfo
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbtainfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbtainfo(
    ta_code varchar2(18) -- 
    ,ta_shortname varchar2(30) -- 
    ,ta_name varchar2(90) -- 
    ,comp_mode varchar2(2) -- 
    ,templet varchar2(30) -- 
    ,open_time number(22) -- 
    ,close_time number(22) -- 
    ,status varchar2(2) -- 
    ,prd_type varchar2(2) -- 
    ,sum_flag varchar2(2) -- 
    ,muti_acc varchar2(2) -- 
    ,clear_type varchar2(2) -- 
    ,real_cfm_flag varchar2(2) -- 
    ,sub_deal_mode varchar2(2) -- 
    ,cfm_fail_intere_in varchar2(2) -- 
    ,host_check_date number(22) -- 
    ,first_invest_flags varchar2(90) -- 
    ,clear_table_flag varchar2(2) -- 
    ,control_flag varchar2(512) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbtainfo to ${iml_schema};
grant select on ${iol_schema}.ifms_tbtainfo to ${icl_schema};
grant select on ${iol_schema}.ifms_tbtainfo to ${idl_schema};
grant select on ${iol_schema}.ifms_tbtainfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbtainfo is '信息表';
comment on column ${iol_schema}.ifms_tbtainfo.ta_code is '';
comment on column ${iol_schema}.ifms_tbtainfo.ta_shortname is '';
comment on column ${iol_schema}.ifms_tbtainfo.ta_name is '';
comment on column ${iol_schema}.ifms_tbtainfo.comp_mode is '';
comment on column ${iol_schema}.ifms_tbtainfo.templet is '';
comment on column ${iol_schema}.ifms_tbtainfo.open_time is '';
comment on column ${iol_schema}.ifms_tbtainfo.close_time is '';
comment on column ${iol_schema}.ifms_tbtainfo.status is '';
comment on column ${iol_schema}.ifms_tbtainfo.prd_type is '';
comment on column ${iol_schema}.ifms_tbtainfo.sum_flag is '';
comment on column ${iol_schema}.ifms_tbtainfo.muti_acc is '';
comment on column ${iol_schema}.ifms_tbtainfo.clear_type is '';
comment on column ${iol_schema}.ifms_tbtainfo.real_cfm_flag is '';
comment on column ${iol_schema}.ifms_tbtainfo.sub_deal_mode is '';
comment on column ${iol_schema}.ifms_tbtainfo.cfm_fail_intere_in is '';
comment on column ${iol_schema}.ifms_tbtainfo.host_check_date is '';
comment on column ${iol_schema}.ifms_tbtainfo.first_invest_flags is '';
comment on column ${iol_schema}.ifms_tbtainfo.clear_table_flag is '';
comment on column ${iol_schema}.ifms_tbtainfo.control_flag is '';
comment on column ${iol_schema}.ifms_tbtainfo.reserve1 is '';
comment on column ${iol_schema}.ifms_tbtainfo.reserve2 is '';
comment on column ${iol_schema}.ifms_tbtainfo.reserve3 is '';
comment on column ${iol_schema}.ifms_tbtainfo.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbtainfo.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbtainfo.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbtainfo.etl_timestamp is 'ETL处理时间戳';
