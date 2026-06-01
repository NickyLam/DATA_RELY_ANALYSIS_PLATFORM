/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scfs_scf_fnc_price_view
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scfs_scf_fnc_price_view
whenever sqlerror continue none;
drop table ${iol_schema}.scfs_scf_fnc_price_view purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scfs_scf_fnc_price_view(
    out_acct_seq_num varchar2(96) -- 出账流水号
    ,iou_id varchar2(96) -- 借据编号
    ,pd_nm varchar2(600) -- 产品名称
    ,ctr_id varchar2(96) -- 合同编号
    ,fnc_jrnl_id varchar2(96) -- 融资编号
    ,pric_ord_nbr varchar2(96) -- 定价单号
    ,credit_aggreement varchar2(96) -- 信贷合同编号
    ,cst_nm varchar2(600) -- 融资企业名称
    ,core_entp_nm varchar2(600) -- 核心企业名称
    ,ths_fnc_amt number(20,6) -- 融资金额
    ,iou_amt number(20,6) -- 借款金额
    ,fnc_dt varchar2(30) -- 融资日期
    ,fnc_bg_dt date -- 融资开始日期
    ,fnc_ex_dt date -- 融资结束日期
    ,pcs_st_cd_nm varchar2(900) -- 审批结果
    ,fns_st_cd_nm varchar2(900) -- 融资状态
    ,is_used_ph varchar2(2) -- 
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
grant select on ${iol_schema}.scfs_scf_fnc_price_view to ${iml_schema};
grant select on ${iol_schema}.scfs_scf_fnc_price_view to ${icl_schema};
grant select on ${iol_schema}.scfs_scf_fnc_price_view to ${idl_schema};
grant select on ${iol_schema}.scfs_scf_fnc_price_view to ${iel_schema};

-- comment
comment on table ${iol_schema}.scfs_scf_fnc_price_view is '供应链融资关联定价信息';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.out_acct_seq_num is '出账流水号';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.iou_id is '借据编号';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.pd_nm is '产品名称';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.ctr_id is '合同编号';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.fnc_jrnl_id is '融资编号';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.pric_ord_nbr is '定价单号';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.credit_aggreement is '信贷合同编号';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.cst_nm is '融资企业名称';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.core_entp_nm is '核心企业名称';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.ths_fnc_amt is '融资金额';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.iou_amt is '借款金额';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.fnc_dt is '融资日期';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.fnc_bg_dt is '融资开始日期';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.fnc_ex_dt is '融资结束日期';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.pcs_st_cd_nm is '审批结果';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.fns_st_cd_nm is '融资状态';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.is_used_ph is '';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.start_dt is '开始时间';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.end_dt is '结束时间';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.id_mark is '增删标志';
comment on column ${iol_schema}.scfs_scf_fnc_price_view.etl_timestamp is 'ETL处理时间戳';
