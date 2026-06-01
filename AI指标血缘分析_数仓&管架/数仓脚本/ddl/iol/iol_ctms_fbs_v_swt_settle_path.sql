/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_fbs_v_swt_settle_path
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_fbs_v_swt_settle_path
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_fbs_v_swt_settle_path purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_swt_settle_path(
    infr_srno number(8,0) -- 
    ,cus_number varchar2(384) -- 
    ,cus_branch_number varchar2(384) -- 
    ,settle_path_name varchar2(384) -- 
    ,mem_code_srno varchar2(15) -- 
    ,crncy_accnt_code_desc varchar2(384) -- 
    ,default_path_indc number(2,0) -- 
    ,settle_type_indc number(2,0) -- 
    ,prdct_srno varchar2(384) -- 
    ,account_bank_type varchar2(8) -- 
    ,account_bank_bic varchar2(384) -- 
    ,account_bank_desc varchar2(384) -- 
    ,account_bank_accnt varchar2(384) -- 
    ,benifit_bank_type varchar2(8) -- 
    ,benifit_bank_bic varchar2(384) -- 
    ,benifit_bank_desc varchar2(384) -- 
    ,benifit_bank_accnt varchar2(384) -- 
    ,mid_bank_type varchar2(8) -- 
    ,mid_bank_bic varchar2(384) -- 
    ,mid_bank_desc varchar2(384) -- 
    ,mid_bank_accnt varchar2(384) -- 
    ,agency_bank_type varchar2(8) -- 
    ,agency_bank_bic varchar2(384) -- 
    ,agency_bank_desc varchar2(384) -- 
    ,agency_bank_accnt varchar2(384) -- 
    ,order_bank_type varchar2(8) -- 
    ,order_bank_bic varchar2(384) -- 
    ,order_bank_desc varchar2(384) -- 
    ,order_bank_account varchar2(384) -- 
    ,crtd_user_id varchar2(384) -- 
    ,crtd_date date -- 
    ,updtd_user_id varchar2(384) -- 
    ,updtd_date date -- 
    ,system_name varchar2(30) -- 
    ,account_bank_cname varchar2(384) -- 
    ,mid_bank_cname varchar2(384) -- 
    ,agency_bank_cname varchar2(384) -- 
    ,benifit_bank_cname varchar2(384) -- 
    ,order_bank_cname varchar2(384) -- 
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
grant select on ${iol_schema}.ctms_fbs_v_swt_settle_path to ${iml_schema};
grant select on ${iol_schema}.ctms_fbs_v_swt_settle_path to ${icl_schema};
grant select on ${iol_schema}.ctms_fbs_v_swt_settle_path to ${idl_schema};
grant select on ${iol_schema}.ctms_fbs_v_swt_settle_path to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_fbs_v_swt_settle_path is '清算路径视图';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.infr_srno is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.cus_number is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.cus_branch_number is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.settle_path_name is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.mem_code_srno is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.crncy_accnt_code_desc is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.default_path_indc is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.settle_type_indc is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.prdct_srno is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.account_bank_type is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.account_bank_bic is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.account_bank_desc is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.account_bank_accnt is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.benifit_bank_type is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.benifit_bank_bic is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.benifit_bank_desc is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.benifit_bank_accnt is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.mid_bank_type is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.mid_bank_bic is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.mid_bank_desc is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.mid_bank_accnt is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.agency_bank_type is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.agency_bank_bic is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.agency_bank_desc is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.agency_bank_accnt is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.order_bank_type is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.order_bank_bic is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.order_bank_desc is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.order_bank_account is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.crtd_user_id is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.crtd_date is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.updtd_user_id is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.updtd_date is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.system_name is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.account_bank_cname is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.mid_bank_cname is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.agency_bank_cname is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.benifit_bank_cname is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.order_bank_cname is '';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_fbs_v_swt_settle_path.etl_timestamp is 'ETL处理时间戳';
