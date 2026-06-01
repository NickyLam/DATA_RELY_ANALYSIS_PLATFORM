/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbinsureproduct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbinsureproduct
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbinsureproduct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsureproduct(
    prd_code varchar2(30) -- 
    ,ta_code varchar2(14) -- 
    ,prd_name varchar2(375) -- 
    ,prd_name2 varchar2(375) -- 
    ,prd_type varchar2(2) -- 
    ,prd_sub_type varchar2(2) -- 
    ,prd_busin_flag varchar2(15) -- 
    ,prd_limit_flag varchar2(2) -- 
    ,curr_type varchar2(5) -- 
    ,online_flag varchar2(2) -- 
    ,begin_date number(22) -- 
    ,end_date number(22) -- 
    ,prd_add_flag varchar2(2) -- 
    ,targ_prd_code varchar2(48) -- 
    ,waver_days number(22) -- 
    ,master_agiorate number(18,2) -- 
    ,check_type varchar2(2) -- 
    ,control_flag varchar2(375) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
    ,pmin_amt number(18,2) -- 
    ,omin_amt number(18,2) -- 
    ,pmax_amt number(18,2) -- 
    ,omax_amt number(18,2) -- 
    ,punit_amt number(18,2) -- 
    ,ounit_amt number(18,2) -- 
    ,amt1 number(18,2) -- 
    ,amt2 number(18,2) -- 
    ,amt3 number(18,2) -- 
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
grant select on ${iol_schema}.ifms_tbinsureproduct to ${iml_schema};
grant select on ${iol_schema}.ifms_tbinsureproduct to ${icl_schema};
grant select on ${iol_schema}.ifms_tbinsureproduct to ${idl_schema};
grant select on ${iol_schema}.ifms_tbinsureproduct to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbinsureproduct is '保险产品信息表';
comment on column ${iol_schema}.ifms_tbinsureproduct.prd_code is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.ta_code is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.prd_name is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.prd_name2 is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.prd_type is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.prd_sub_type is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.prd_busin_flag is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.prd_limit_flag is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.curr_type is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.online_flag is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.begin_date is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.end_date is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.prd_add_flag is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.targ_prd_code is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.waver_days is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.master_agiorate is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.check_type is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.control_flag is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.reserve1 is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.reserve2 is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.reserve3 is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.reserve4 is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.pmin_amt is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.omin_amt is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.pmax_amt is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.omax_amt is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.punit_amt is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.ounit_amt is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.amt1 is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.amt2 is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.amt3 is '';
comment on column ${iol_schema}.ifms_tbinsureproduct.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbinsureproduct.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbinsureproduct.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbinsureproduct.etl_timestamp is 'ETL处理时间戳';
