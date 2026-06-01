/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_direct_term_inf_tmp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_direct_term_inf_tmp
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_direct_term_inf_tmp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_direct_term_inf_tmp(
    term_cd varchar2(12) -- 
    ,term_sn varchar2(23) -- 
    ,mcht_no varchar2(23) -- 
    ,term_type varchar2(5) -- 
    ,use varchar2(15) -- 
    ,status varchar2(3) -- 
    ,comments varchar2(383) -- 
    ,recover varchar2(9) -- 
    ,order_dt varchar2(21) -- 
    ,install_dt varchar2(21) -- 
    ,hsm varchar2(48) -- 
    ,dealwith varchar2(2) -- 
    ,processing_code varchar2(3) -- 
    ,processing_dsp varchar2(383) -- 
    ,finish varchar2(2) -- 
    ,id varchar2(12) -- 
    ,term_area varchar2(150) -- 
    ,term_nm varchar2(120) -- 
    ,term_tel varchar2(18) -- 
    ,oper_id varchar2(18) -- 
    ,term_sta varchar2(2) -- 
    ,create_date varchar2(21) -- 
    ,rec_upd_ts varchar2(21) -- 
    ,upd_oper varchar2(18) -- 
    ,out_mcht_no varchar2(23) -- 
    ,out_term_cd varchar2(12) -- 
    ,mchtserial varchar2(12) -- 
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
grant select on ${iol_schema}.mrms_tbl_direct_term_inf_tmp to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_direct_term_inf_tmp to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_direct_term_inf_tmp to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_direct_term_inf_tmp to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_direct_term_inf_tmp is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.term_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.term_sn is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.mcht_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.term_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.use is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.status is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.comments is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.recover is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.order_dt is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.install_dt is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.hsm is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.dealwith is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.processing_code is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.processing_dsp is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.finish is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.id is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.term_area is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.term_nm is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.term_tel is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.oper_id is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.term_sta is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.create_date is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.rec_upd_ts is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.upd_oper is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.out_mcht_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.out_term_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.mchtserial is '';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_direct_term_inf_tmp.etl_timestamp is 'ETL处理时间戳';
