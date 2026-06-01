/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbfeerate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbfeerate
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbfeerate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbfeerate(
    prd_code varchar2(32) -- 
    ,share_class varchar2(3) -- 
    ,busin_code varchar2(9) -- 
    ,fee_type varchar2(2) -- 
    ,client_type varchar2(2) -- 
    ,seller_type varchar2(2) -- 
    ,sub_mode varchar2(2) -- 
    ,min_amt number(22,3) -- 
    ,max_amt number(22,3) -- 
    ,min_predays number(22,0) -- 
    ,max_predays number(22,0) -- 
    ,min_holddays number(22,0) -- 
    ,max_holddays number(22,0) -- 
    ,fee_rate number(9,8) -- 
    ,min_fee number(18,2) -- 
    ,max_fee number(18,2) -- 
    ,calculate_numeric number(18,2) -- 
    ,other_prd_code varchar2(32) -- 
    ,targ_share_class varchar2(2) -- 
    ,unit varchar2(10) -- 
    ,unit_name varchar2(375) -- 
    ,back_flag varchar2(2) -- 
    ,fee_mode varchar2(2) -- 
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
grant select on ${iol_schema}.ifms_tbfeerate to ${iml_schema};
grant select on ${iol_schema}.ifms_tbfeerate to ${icl_schema};
grant select on ${iol_schema}.ifms_tbfeerate to ${idl_schema};
grant select on ${iol_schema}.ifms_tbfeerate to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbfeerate is '保险产品费率表';
comment on column ${iol_schema}.ifms_tbfeerate.prd_code is '';
comment on column ${iol_schema}.ifms_tbfeerate.share_class is '';
comment on column ${iol_schema}.ifms_tbfeerate.busin_code is '';
comment on column ${iol_schema}.ifms_tbfeerate.fee_type is '';
comment on column ${iol_schema}.ifms_tbfeerate.client_type is '';
comment on column ${iol_schema}.ifms_tbfeerate.seller_type is '';
comment on column ${iol_schema}.ifms_tbfeerate.sub_mode is '';
comment on column ${iol_schema}.ifms_tbfeerate.min_amt is '';
comment on column ${iol_schema}.ifms_tbfeerate.max_amt is '';
comment on column ${iol_schema}.ifms_tbfeerate.min_predays is '';
comment on column ${iol_schema}.ifms_tbfeerate.max_predays is '';
comment on column ${iol_schema}.ifms_tbfeerate.min_holddays is '';
comment on column ${iol_schema}.ifms_tbfeerate.max_holddays is '';
comment on column ${iol_schema}.ifms_tbfeerate.fee_rate is '';
comment on column ${iol_schema}.ifms_tbfeerate.min_fee is '';
comment on column ${iol_schema}.ifms_tbfeerate.max_fee is '';
comment on column ${iol_schema}.ifms_tbfeerate.calculate_numeric is '';
comment on column ${iol_schema}.ifms_tbfeerate.other_prd_code is '';
comment on column ${iol_schema}.ifms_tbfeerate.targ_share_class is '';
comment on column ${iol_schema}.ifms_tbfeerate.unit is '';
comment on column ${iol_schema}.ifms_tbfeerate.unit_name is '';
comment on column ${iol_schema}.ifms_tbfeerate.back_flag is '';
comment on column ${iol_schema}.ifms_tbfeerate.fee_mode is '';
comment on column ${iol_schema}.ifms_tbfeerate.reserve1 is '';
comment on column ${iol_schema}.ifms_tbfeerate.reserve2 is '';
comment on column ${iol_schema}.ifms_tbfeerate.reserve3 is '';
comment on column ${iol_schema}.ifms_tbfeerate.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbfeerate.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbfeerate.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbfeerate.etl_timestamp is 'ETL处理时间戳';
