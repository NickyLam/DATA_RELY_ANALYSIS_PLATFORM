/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_intstl_acct_ety_tran_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_intstl_acct_ety_tran_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_intstl_acct_ety_tran_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_intstl_acct_ety_tran_evt(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,entry_id varchar2(60) -- 分录编号
    ,obj_name varchar2(150) -- 对象表名称
    ,obj_flow_num varchar2(60) -- 对象表流水号
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,tran_acct_id varchar2(60) -- 交易账户编号
    ,debit_crdt_dir_cd varchar2(30) -- 借贷方向代码
    ,entry_curr_cd varchar2(30) -- 记账币种代码
    ,entry_amt number(30,8) -- 记账金额
    ,tran_curr_cd varchar2(30) -- 交易币种代码
    ,tran_curr_amt number(30,8) -- 交易币种金额
    ,value_dt date -- 起息日期
    ,tran_dt date -- 交易日期
    ,memo_comnt_1 varchar2(375) -- 摘要说明1
    ,sumos_memo varchar2(750) -- 传票摘要
    ,memo_comnt_3 varchar2(150) -- 摘要说明3
    ,entry_seq_num varchar2(60) -- 分录顺序号
    ,exp_status_cd varchar2(30) -- 出口状态代码
    ,entry_org_id varchar2(60) -- 记账机构编号
    ,dubil_id varchar2(60) -- 借据编号
    ,off_bs_acct_id varchar2(60) -- 表外账户编号
    ,tran_exch_rat number(18,8) -- 交易汇率
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,intstl_party_id varchar2(60) -- 国结当事人编号
    ,wrt_guat_type_cd varchar2(30) -- 结售汇类型代码
    ,subj_id varchar2(60) -- 科目编号
    ,wrt_guat_tran_type_cd varchar2(30) -- 结售汇交易主体类型代码
    ,mdl_p number(30,8) -- 中间价
    ,mdl_p_quot_tm timestamp -- 中间价牌价时间
    ,wrt_guat_pl_amt number(30,8) -- 结售汇损益金额
    ,memo_type_cd varchar2(30) -- 摘要类型代码
    ,ec_idf_cd varchar2(30) -- 钞汇标识代码
    ,tran_cd varchar2(60) -- 交易代码
    ,cty_rg_cd varchar2(30) -- 国家和地区代码
    ,espec_econ_rg_type_cd varchar2(30) -- 特殊经济区内企业类型代码
    ,apprv_id varchar2(60) -- 批准编号
    ,cntpty_bank_name varchar2(150) -- 交易对手银行名称
    ,sell_exch_rat number(18,8) -- 卖出汇率
    ,buy_exch_rat number(18,8) -- 买入汇率
    ,prefr_point number(18,6) -- 优惠点数
    ,fin_type_cd varchar2(30) -- 账务类型代码
    ,sub_acct_num varchar2(60) -- 子账号
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
grant select on ${iml_schema}.evt_intstl_acct_ety_tran_evt to ${icl_schema};
grant select on ${iml_schema}.evt_intstl_acct_ety_tran_evt to ${idl_schema};
grant select on ${iml_schema}.evt_intstl_acct_ety_tran_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_intstl_acct_ety_tran_evt is '国结会计分录交易事件';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.entry_id is '分录编号';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.obj_name is '对象表名称';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.obj_flow_num is '对象表流水号';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.tran_acct_id is '交易账户编号';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.debit_crdt_dir_cd is '借贷方向代码';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.entry_curr_cd is '记账币种代码';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.entry_amt is '记账金额';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.tran_curr_cd is '交易币种代码';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.tran_curr_amt is '交易币种金额';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.value_dt is '起息日期';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.memo_comnt_1 is '摘要说明1';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.sumos_memo is '传票摘要';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.memo_comnt_3 is '摘要说明3';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.entry_seq_num is '分录顺序号';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.exp_status_cd is '出口状态代码';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.entry_org_id is '记账机构编号';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.off_bs_acct_id is '表外账户编号';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.tran_exch_rat is '交易汇率';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.intstl_party_id is '国结当事人编号';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.wrt_guat_type_cd is '结售汇类型代码';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.subj_id is '科目编号';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.wrt_guat_tran_type_cd is '结售汇交易主体类型代码';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.mdl_p is '中间价';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.mdl_p_quot_tm is '中间价牌价时间';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.wrt_guat_pl_amt is '结售汇损益金额';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.memo_type_cd is '摘要类型代码';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.ec_idf_cd is '钞汇标识代码';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.tran_cd is '交易代码';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.cty_rg_cd is '国家和地区代码';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.espec_econ_rg_type_cd is '特殊经济区内企业类型代码';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.apprv_id is '批准编号';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.cntpty_bank_name is '交易对手银行名称';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.sell_exch_rat is '卖出汇率';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.buy_exch_rat is '买入汇率';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.prefr_point is '优惠点数';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.fin_type_cd is '账务类型代码';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.sub_acct_num is '子账号';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_intstl_acct_ety_tran_evt.etl_timestamp is 'ETL处理时间戳';
