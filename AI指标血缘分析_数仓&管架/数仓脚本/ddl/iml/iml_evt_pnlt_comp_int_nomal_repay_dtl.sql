/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_pnlt_comp_int_nomal_repay_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl(
    evt_id varchar2(250) -- 事件编号
    ,advise_odd_no varchar2(60) -- 通知单号
    ,lp_id varchar2(100) -- 法人编号
    ,cust_id varchar2(100) -- 客户编号
    ,acct_id varchar2(100) -- 账户编号
    ,bus_effect_dt date -- 业务生效日期
    ,bus_invalid_dt date -- 业务失效日期
    ,grace_dt date -- 宽限日期
    ,doc_exp_dt date -- 单据到期日期
    ,bus_tran_dt date -- 业务交易日期
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,iss_amt number(30,2) -- 出单金额
    ,doc_bal number(30,2) -- 单据余额
    ,ld_doc_unpaid_amt number(30,2) -- 上日单据未还金额
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,doc_create_way_cd varchar2(30) -- 单据生成方式代码
    ,curr_pd number(10) -- 当前期次
    ,iss_flg varchar2(10) -- 出单标志
    ,doc_full_amt_callbk_flg varchar2(10) -- 单据全额回收标志
    ,final_stl_dt date -- 最后结算日期
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,final_modif_dt date -- 最后修改日期
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl is '罚息复利正常还款明细';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.advise_odd_no is '通知单号';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.acct_id is '账户编号';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.bus_effect_dt is '业务生效日期';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.bus_invalid_dt is '业务失效日期';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.grace_dt is '宽限日期';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.doc_exp_dt is '单据到期日期';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.bus_tran_dt is '业务交易日期';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.iss_amt is '出单金额';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.doc_bal is '单据余额';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.ld_doc_unpaid_amt is '上日单据未还金额';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.doc_create_way_cd is '单据生成方式代码';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.curr_pd is '当前期次';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.iss_flg is '出单标志';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.doc_full_amt_callbk_flg is '单据全额回收标志';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.final_stl_dt is '最后结算日期';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl.etl_timestamp is 'ETL处理时间戳';
