/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_charge_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_charge_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_charge_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_charge_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,charge_seq_num varchar2(60) -- 收费序号
    ,tran_dt date -- 交易日期
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,flow_num varchar2(100) -- 流水号
    ,cust_id varchar2(100) -- 客户编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,sub_acct_num varchar2(60) -- 子账号
    ,acct_flg_idf varchar2(60) -- 账户标识符
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,dep_agt_id varchar2(100) -- 存款协议编号
    ,dep_vouch_cate_cd varchar2(30) -- 存款凭证类别代码
    ,vouch_begin_num varchar2(60) -- 凭证起始号码
    ,vouch_sum_qtty number(30) -- 凭证合计数量
    ,effect_dt date -- 生效日期
    ,revs_org_id varchar2(100) -- 冲正机构编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,tran_cd varchar2(30) -- 交易码
    ,tran_seq_num varchar2(60) -- 交易序号
    ,tran_tm timestamp -- 交易时间
    ,cntpty_cust_acct_num varchar2(100) -- 交易对手业务编号
    ,cntpty_name varchar2(500) -- 交易对手名称
    ,cntpty_cust_id varchar2(100) -- 交易对手客户编号
    ,cntpty_cust_name varchar2(250) -- 交易对手客户名称
    ,cntpty_type_cd varchar2(30) -- 交易对手客户类型代码
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,recvbl_fee_seq_num varchar2(60) -- 应收费用序号
    ,fee_charge_way_cd varchar2(30) -- 费用收费方式代码
    ,comm_fee_coll_way_cd varchar2(30) -- 手续费收取方式代码
    ,fee_type_id varchar2(100) -- 费用类型编号
    ,acct_dmic_charge_curr_cd varchar2(30) -- 费用币种代码
    ,fee_price number(30,2) -- 费用单价
    ,acct_dmic_fee_amt number(30,2) -- 费用金额
    ,init_recvbl_fee_amt number(30,2) -- 原应收费用金额
    ,fee_discnt_rat number(30,2) -- 费用折扣率
    ,fee_discnt_type_cd varchar2(30) -- 费用折扣类型代码
    ,init_fee_amt number(30,2) -- 原始费用金额
    ,discnt_fee_amt number(30,2) -- 折扣费用金额
    ,tax number(30,2) -- 税金
    ,tax_rat number(18,6) -- 税率
    ,tax_category_cd varchar2(30) -- 税种代码
    ,amort_flg varchar2(10) -- 摊销标志
    ,amort_tm_type_cd varchar2(30) -- 摊销时间类型代码
    ,amort_tenor_type_cd varchar2(30) -- 摊销期限类型代码
    ,amort_day varchar2(10) -- 摊销日
    ,amort_mon varchar2(10) -- 摊销月
    ,amort_begin_dt date -- 摊销起始日期
    ,amort_closing_dt date -- 摊销截止日期
    ,prft_cut_flg varchar2(10) -- 分润标志
    ,tran_bank_ratio number(18,6) -- 交易行比例
    ,tran_bank_prft_cut_amt number(30,2) -- 交易行分润金额
    ,acct_bank_ratio number(18,6) -- 账户行比例
    ,acct_bank_prft_cut_amt number(30,2) -- 账户行分润金额
    ,post_flg varchar2(10) -- 过账标志
    ,check_entry_cd varchar2(30) -- 对账码
    ,tran_revd_flg varchar2(10) -- 交易已冲正标志
    ,tran_acct_serv_fee_revs_seq_num varchar2(60) -- 转账服务费冲正序号
    ,revs_auth_teller varchar2(100) -- 冲正授权柜员编号
    ,revs_teller varchar2(100) -- 冲正柜员编号
    ,org_tran_seq_num varchar2(60) -- 机构交易序号
    ,end_day_onl_cd varchar2(30) -- 日终联机代码
    ,termnt_num varchar2(60) -- 终止号码
    ,core_flow_num varchar2(100) -- 核心流水号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,cust_mgr_name varchar2(250) -- 客户经理名称
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,remark varchar2(750) -- 备注
    ,amort_status_cd varchar2(30) -- 摊销状态代码
    ,loan_prod_id varchar2(60) -- 贷款产品编号
    ,bal_pay_idf_cd varchar2(30) -- 收支标识代码
    ,chn_id varchar2(60) -- 渠道编号
    ,enter_acct_dt date -- 入账日期
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
grant select on ${iml_schema}.evt_charge_flow to ${icl_schema};
grant select on ${iml_schema}.evt_charge_flow to ${idl_schema};
grant select on ${iml_schema}.evt_charge_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_charge_flow is '收费流水';
comment on column ${iml_schema}.evt_charge_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_charge_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_charge_flow.charge_seq_num is '收费序号';
comment on column ${iml_schema}.evt_charge_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_charge_flow.prod_id is '产品编号';
comment on column ${iml_schema}.evt_charge_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_charge_flow.flow_num is '流水号';
comment on column ${iml_schema}.evt_charge_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_charge_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_charge_flow.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_charge_flow.sub_acct_num is '子账号';
comment on column ${iml_schema}.evt_charge_flow.acct_flg_idf is '账户标识符';
comment on column ${iml_schema}.evt_charge_flow.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_charge_flow.dep_agt_id is '存款协议编号';
comment on column ${iml_schema}.evt_charge_flow.dep_vouch_cate_cd is '存款凭证类别代码';
comment on column ${iml_schema}.evt_charge_flow.vouch_begin_num is '凭证起始号码';
comment on column ${iml_schema}.evt_charge_flow.vouch_sum_qtty is '凭证合计数量';
comment on column ${iml_schema}.evt_charge_flow.effect_dt is '生效日期';
comment on column ${iml_schema}.evt_charge_flow.revs_org_id is '冲正机构编号';
comment on column ${iml_schema}.evt_charge_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_charge_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_charge_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_charge_flow.tran_cd is '交易码';
comment on column ${iml_schema}.evt_charge_flow.tran_seq_num is '交易序号';
comment on column ${iml_schema}.evt_charge_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_charge_flow.cntpty_cust_acct_num is '交易对手业务编号';
comment on column ${iml_schema}.evt_charge_flow.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.evt_charge_flow.cntpty_cust_id is '交易对手客户编号';
comment on column ${iml_schema}.evt_charge_flow.cntpty_cust_name is '交易对手客户名称';
comment on column ${iml_schema}.evt_charge_flow.cntpty_type_cd is '交易对手客户类型代码';
comment on column ${iml_schema}.evt_charge_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_charge_flow.recvbl_fee_seq_num is '应收费用序号';
comment on column ${iml_schema}.evt_charge_flow.fee_charge_way_cd is '费用收费方式代码';
comment on column ${iml_schema}.evt_charge_flow.comm_fee_coll_way_cd is '手续费收取方式代码';
comment on column ${iml_schema}.evt_charge_flow.fee_type_id is '费用类型编号';
comment on column ${iml_schema}.evt_charge_flow.acct_dmic_charge_curr_cd is '费用币种代码';
comment on column ${iml_schema}.evt_charge_flow.fee_price is '费用单价';
comment on column ${iml_schema}.evt_charge_flow.acct_dmic_fee_amt is '费用金额';
comment on column ${iml_schema}.evt_charge_flow.init_recvbl_fee_amt is '原应收费用金额';
comment on column ${iml_schema}.evt_charge_flow.fee_discnt_rat is '费用折扣率';
comment on column ${iml_schema}.evt_charge_flow.fee_discnt_type_cd is '费用折扣类型代码';
comment on column ${iml_schema}.evt_charge_flow.init_fee_amt is '原始费用金额';
comment on column ${iml_schema}.evt_charge_flow.discnt_fee_amt is '折扣费用金额';
comment on column ${iml_schema}.evt_charge_flow.tax is '税金';
comment on column ${iml_schema}.evt_charge_flow.tax_rat is '税率';
comment on column ${iml_schema}.evt_charge_flow.tax_category_cd is '税种代码';
comment on column ${iml_schema}.evt_charge_flow.amort_flg is '摊销标志';
comment on column ${iml_schema}.evt_charge_flow.amort_tm_type_cd is '摊销时间类型代码';
comment on column ${iml_schema}.evt_charge_flow.amort_tenor_type_cd is '摊销期限类型代码';
comment on column ${iml_schema}.evt_charge_flow.amort_day is '摊销日';
comment on column ${iml_schema}.evt_charge_flow.amort_mon is '摊销月';
comment on column ${iml_schema}.evt_charge_flow.amort_begin_dt is '摊销起始日期';
comment on column ${iml_schema}.evt_charge_flow.amort_closing_dt is '摊销截止日期';
comment on column ${iml_schema}.evt_charge_flow.prft_cut_flg is '分润标志';
comment on column ${iml_schema}.evt_charge_flow.tran_bank_ratio is '交易行比例';
comment on column ${iml_schema}.evt_charge_flow.tran_bank_prft_cut_amt is '交易行分润金额';
comment on column ${iml_schema}.evt_charge_flow.acct_bank_ratio is '账户行比例';
comment on column ${iml_schema}.evt_charge_flow.acct_bank_prft_cut_amt is '账户行分润金额';
comment on column ${iml_schema}.evt_charge_flow.post_flg is '过账标志';
comment on column ${iml_schema}.evt_charge_flow.check_entry_cd is '对账码';
comment on column ${iml_schema}.evt_charge_flow.tran_revd_flg is '交易已冲正标志';
comment on column ${iml_schema}.evt_charge_flow.tran_acct_serv_fee_revs_seq_num is '转账服务费冲正序号';
comment on column ${iml_schema}.evt_charge_flow.revs_auth_teller is '冲正授权柜员编号';
comment on column ${iml_schema}.evt_charge_flow.revs_teller is '冲正柜员编号';
comment on column ${iml_schema}.evt_charge_flow.org_tran_seq_num is '机构交易序号';
comment on column ${iml_schema}.evt_charge_flow.end_day_onl_cd is '日终联机代码';
comment on column ${iml_schema}.evt_charge_flow.termnt_num is '终止号码';
comment on column ${iml_schema}.evt_charge_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_charge_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_charge_flow.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_charge_flow.cust_mgr_name is '客户经理名称';
comment on column ${iml_schema}.evt_charge_flow.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_charge_flow.remark is '备注';
comment on column ${iml_schema}.evt_charge_flow.amort_status_cd is '摊销状态代码';
comment on column ${iml_schema}.evt_charge_flow.loan_prod_id is '贷款产品编号';
comment on column ${iml_schema}.evt_charge_flow.bal_pay_idf_cd is '收支标识代码';
comment on column ${iml_schema}.evt_charge_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_charge_flow.enter_acct_dt is '入账日期';
comment on column ${iml_schema}.evt_charge_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_charge_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_charge_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_charge_flow.etl_timestamp is 'ETL处理时间戳';
