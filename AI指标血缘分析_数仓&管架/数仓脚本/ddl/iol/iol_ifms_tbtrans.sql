/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbtrans
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbtrans
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbtrans purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbtrans(
    trans_code varchar2(32) -- 
    ,trans_name varchar2(375) -- 
    ,enable_flag varchar2(2) -- 
    ,channels varchar2(75) -- 
    ,host_online varchar2(2) -- 
    ,trans_type varchar2(2) -- 
    ,monitor_status varchar2(2) -- 
    ,log_level varchar2(2) -- 
    ,cancel_flag varchar2(2) -- 
    ,erase_flag varchar2(2) -- 
    ,mon_trans_type varchar2(2) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,prd_type varchar2(1) -- 产品类型:[K_CPLX]0-基金 1-理财
    ,trans_types_flag varchar2(1) -- 是否多交易类型:交易类型既是系统又分ta级
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
grant select on ${iol_schema}.ifms_tbtrans to ${iml_schema};
grant select on ${iol_schema}.ifms_tbtrans to ${icl_schema};
grant select on ${iol_schema}.ifms_tbtrans to ${idl_schema};
grant select on ${iol_schema}.ifms_tbtrans to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbtrans is '';
comment on column ${iol_schema}.ifms_tbtrans.trans_code is '';
comment on column ${iol_schema}.ifms_tbtrans.trans_name is '';
comment on column ${iol_schema}.ifms_tbtrans.enable_flag is '';
comment on column ${iol_schema}.ifms_tbtrans.channels is '';
comment on column ${iol_schema}.ifms_tbtrans.host_online is '';
comment on column ${iol_schema}.ifms_tbtrans.trans_type is '';
comment on column ${iol_schema}.ifms_tbtrans.monitor_status is '';
comment on column ${iol_schema}.ifms_tbtrans.log_level is '';
comment on column ${iol_schema}.ifms_tbtrans.cancel_flag is '';
comment on column ${iol_schema}.ifms_tbtrans.erase_flag is '';
comment on column ${iol_schema}.ifms_tbtrans.mon_trans_type is '';
comment on column ${iol_schema}.ifms_tbtrans.reserve1 is '';
comment on column ${iol_schema}.ifms_tbtrans.reserve2 is '';
comment on column ${iol_schema}.ifms_tbtrans.reserve3 is '';
comment on column ${iol_schema}.ifms_tbtrans.prd_type is '产品类型:[K_CPLX]0-基金 1-理财';
comment on column ${iol_schema}.ifms_tbtrans.trans_types_flag is '是否多交易类型:交易类型既是系统又分ta级';
comment on column ${iol_schema}.ifms_tbtrans.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbtrans.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbtrans.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbtrans.etl_timestamp is 'ETL处理时间戳';
