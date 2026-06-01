/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_accti_midgrod_acct_ety
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_accti_midgrod_acct_ety
whenever sqlerror continue none;
drop table ${iml_schema}.evt_accti_midgrod_acct_ety purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_accti_midgrod_acct_ety(
    evt_id varchar2(100) -- 事件编号
    ,sob_id varchar2(100) -- 账套编号
    ,bus_sys_id varchar2(100) -- 业务系统编号
    ,tran_dt date -- 交易日期
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,sumos_seq_num varchar2(60) -- 传票序号
    ,sumos_id varchar2(100) -- 传票编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,fin_org_id varchar2(100) -- 财务机构编号
    ,subj_id varchar2(100) -- 科目编号
    ,subj_name varchar2(500) -- 科目名称
    ,batch_no varchar2(60) -- 批次号
    ,tran_tm timestamp -- 交易时间
    ,curr_cd varchar2(30) -- 币种代码
    ,off_bs_flg varchar2(10) -- 表外标志
    ,cust_id varchar2(100) -- 客户编号
    ,prod_id varchar2(100) -- 产品编号
    ,acct_id varchar2(100) -- 账户编号
    ,cash_trans_flg_cd varchar2(30) -- 现转标志代码
    ,debit_crdt_dir_cd varchar2(30) -- 借贷方向代码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_bal number(30,2) -- 交易余额
    ,memo_id varchar2(100) -- 摘要编号
    ,memo_descb varchar2(500) -- 摘要描述
    ,convt_exch_rat number(18,8) -- 折算汇率
    ,user_id varchar2(100) -- 用户编号
    ,sorc_sys_dt date -- 源系统日期
    ,sorc_sys_flow_num varchar2(100) -- 源系统流水号
    ,src_sys_cd varchar2(30) -- 源系统代码
    ,src_tran_flow_seq_num varchar2(60) -- 源交易流水序号
    ,chn_id varchar2(100) -- 渠道编号
    ,sellbl_prod_id varchar2(100) -- 可售产品编号
    ,clear_status_cd varchar2(30) -- 清算状态代码
    ,clear_flow_num varchar2(100) -- 清算流水号
    ,clear_dt date -- 清算日期
    ,enter_acct_status_cd varchar2(30) -- 入账状态代码
    ,src_sob_id varchar2(100) -- 源账套编号
    ,revs_status_cd varchar2(30) -- 冲正状态代码
    ,init_bus_dt date -- 原业务日期
    ,init_bus_flow_num varchar2(100) -- 原业务流水号
    ,stand_mony_amt number(30,2) -- 本位币金额
    ,aldy_sync_flg varchar2(10) -- 已同步标志
    ,ova_flow_num varchar2(100) -- 全局流水号
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
grant select on ${iml_schema}.evt_accti_midgrod_acct_ety to ${icl_schema};
grant select on ${iml_schema}.evt_accti_midgrod_acct_ety to ${idl_schema};
grant select on ${iml_schema}.evt_accti_midgrod_acct_ety to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_accti_midgrod_acct_ety is '核算中台会计分录事件';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.evt_id is '事件编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.sob_id is '账套编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.bus_sys_id is '业务系统编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.sumos_seq_num is '传票序号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.sumos_id is '传票编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.fin_org_id is '财务机构编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.subj_id is '科目编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.subj_name is '科目名称';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.batch_no is '批次号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.off_bs_flg is '表外标志';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.cust_id is '客户编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.prod_id is '产品编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.acct_id is '账户编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.cash_trans_flg_cd is '现转标志代码';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.debit_crdt_dir_cd is '借贷方向代码';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.tran_bal is '交易余额';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.memo_id is '摘要编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.memo_descb is '摘要描述';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.convt_exch_rat is '折算汇率';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.user_id is '用户编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.sorc_sys_dt is '源系统日期';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.sorc_sys_flow_num is '源系统流水号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.src_sys_cd is '源系统代码';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.src_tran_flow_seq_num is '源交易流水序号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.sellbl_prod_id is '可售产品编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.clear_status_cd is '清算状态代码';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.clear_flow_num is '清算流水号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.enter_acct_status_cd is '入账状态代码';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.src_sob_id is '源账套编号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.revs_status_cd is '冲正状态代码';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.init_bus_dt is '原业务日期';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.init_bus_flow_num is '原业务流水号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.stand_mony_amt is '本位币金额';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.aldy_sync_flg is '已同步标志';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.job_cd is '任务编码';
comment on column ${iml_schema}.evt_accti_midgrod_acct_ety.etl_timestamp is 'ETL处理时间戳';
