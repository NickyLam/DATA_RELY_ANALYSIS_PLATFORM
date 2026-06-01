/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbtacfmdetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbtacfmdetail
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbtacfmdetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbtacfmdetail(
    busin_code varchar2(9) -- 
    ,cfm_date number(22) -- 
    ,detail_cfm_no varchar2(48) -- 
    ,cfm_no varchar2(48) -- 
    ,seller_code varchar2(14) -- 
    ,asset_acc varchar2(30) -- 
    ,prd_code varchar2(30) -- 
    ,share_class varchar2(2) -- 
    ,trans_date number(22) -- 
    ,serial_no varchar2(48) -- 
    ,ori_cfm_date number(22) -- 
    ,ori_cfm_no varchar2(36) -- 
    ,regist_date number(22) -- 
    ,cfm_amt number(18,2) -- 
    ,cfm_vol number(18,3) -- 
    ,trade_fee number(18,2) -- 
    ,transfer_fee number(18,2) -- 
    ,stamp_tax number(18,2) -- 
    ,back_fee number(18,2) -- 
    ,other_fee1 number(18,2) -- 
    ,gain_income number(18,2) -- 
    ,amt1 number(18,2) -- 
    ,amt2 number(18,2) -- 
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
grant select on ${iol_schema}.ifms_tbtacfmdetail to ${iml_schema};
grant select on ${iol_schema}.ifms_tbtacfmdetail to ${icl_schema};
grant select on ${iol_schema}.ifms_tbtacfmdetail to ${idl_schema};
grant select on ${iol_schema}.ifms_tbtacfmdetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbtacfmdetail is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.busin_code is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.cfm_date is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.detail_cfm_no is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.cfm_no is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.seller_code is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.asset_acc is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.prd_code is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.share_class is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.trans_date is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.serial_no is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.ori_cfm_date is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.ori_cfm_no is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.regist_date is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.cfm_amt is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.cfm_vol is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.trade_fee is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.transfer_fee is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.stamp_tax is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.back_fee is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.other_fee1 is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.gain_income is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.amt1 is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.amt2 is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.reserve1 is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.reserve2 is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.reserve3 is '';
comment on column ${iol_schema}.ifms_tbtacfmdetail.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbtacfmdetail.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbtacfmdetail.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbtacfmdetail.etl_timestamp is 'ETL处理时间戳';
