/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_acp_dubil
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_acp_dubil
whenever sqlerror continue none;
drop table ${iml_schema}.agt_acp_dubil purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_acp_dubil(
    agt_id varchar2(100) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,prod_id varchar2(100) -- 产品编号
    ,intnal_carr_flg varchar2(10) -- 内部结转标志
    ,dubil_type_cd varchar2(10) -- 借据类型代码
    ,loan_status_cd varchar2(10) -- 贷款状态代码
    ,loan_cap_use_position_cd varchar2(10) -- 贷款资金使用位置代码
    ,curr_cd varchar2(10) -- 币种代码
    ,distr_amt number(30,2) -- 放款金额
    ,loan_cont_tenor number(10) -- 贷款合同期限
    ,distr_dt date -- 放款日期
    ,loan_value_dt date -- 贷款起息日期
    ,loan_exp_dt date -- 贷款到期日期
    ,repay_way_cd varchar2(10) -- 还款方式代码
    ,grace_period_days number(10) -- 宽限期天数
    ,inst_tot_comm_fee_rat number(18,6) -- 分期总手续费率
    ,src_int_rat_type_cd varchar2(10) -- 源利率类型代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,int_rat_adj_ped_corp_cd varchar2(10) -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq varchar2(10) -- 利率调整周期频率
    ,loan_actl_day_int_rat number(18,8) -- 贷款实际日利率
    ,pric_repay_freq_cd varchar2(10) -- 本金还款频率代码
    ,int_repay_freq_cd varchar2(10) -- 利息还款频率代码
    ,guar_type_cd varchar2(10) -- 担保类型代码
    ,crdt_appl_id varchar2(100) -- 授信申请编号
    ,recvbl_num_type_cd varchar2(10) -- 收款账号类型代码
    ,repay_num_type_cd varchar2(10) -- 还款帐号类型代码
    ,cust_id varchar2(60) -- 客户编号
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,acctnt_dt date -- 会计日期
    ,cont_status_cd varchar2(10) -- 合约状态代码
    ,payoff_dt date -- 结清日期
    ,loan_level5_cls_cd varchar2(10) -- 贷款五级分类代码
    ,next_repay_dt date -- 下一还款日期
    ,unpayoff_perds number(10) -- 未结清期数
    ,ovdue_pd_cnt number(10) -- 逾期期次数
    ,pric_ovdue_days number(10) -- 本金逾期天数
    ,int_ovdue_days number(10) -- 利息逾期天数
    ,loan_init_pric number(30,2) -- 贷款原始本金
    ,nomal_pric_bal number(30,2) -- 正常本金余额
    ,ovdue_pric_bal number(30,2) -- 逾期本金余额
    ,recvbl_num varchar2(120) -- 收款帐号
    ,repay_num varchar2(120) -- 还款帐号
    ,recvbl_acct_id varchar2(60) -- 收款账户编号
    ,repay_acct_id varchar2(60) -- 还款账户编号
    ,loan_usage_cd varchar2(10) -- 贷款用途代码
    ,acru_non_acru_flg varchar2(10) -- 应计非应计标志
    ,nomal_int_bal number(30,2) -- 正常利息余额
    ,ovdue_int_bal number(30,2) -- 逾期利息余额
    ,ovdue_pric_pnlt_bal number(30,2) -- 逾期本金罚息余额
    ,ovdue_int_pnlt_bal number(30,2) -- 逾期利息罚息余额
    ,loan_exec_year_int_rat number(18,10) -- 贷款执行年利率
    ,lpr_int_rat number(18,10) -- LPR利率
    ,int_rat_float_spread_val number(18,6) -- 利率浮动点差值
    ,int_rat_float_dir_cd varchar2(10) -- 利率浮动方向代码
    ,base_rat_type_cd varchar2(10) -- 基准利率类型代码
    ,wrt_off_flg varchar2(10) -- 核销标志
    ,dist_cd varchar2(10) -- 行政区划代码
    ,lmt_usage_cd varchar2(100) -- 额度用途代码
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,white_list_cust_flg varchar2(10) -- 白户标志
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.agt_acp_dubil to ${icl_schema};
grant select on ${iml_schema}.agt_acp_dubil to ${idl_schema};
grant select on ${iml_schema}.agt_acp_dubil to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_acp_dubil is '花呗借据';
comment on column ${iml_schema}.agt_acp_dubil.agt_id is '协议编号';
comment on column ${iml_schema}.agt_acp_dubil.lp_id is '法人编号';
comment on column ${iml_schema}.agt_acp_dubil.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_acp_dubil.prod_id is '产品编号';
comment on column ${iml_schema}.agt_acp_dubil.intnal_carr_flg is '内部结转标志';
comment on column ${iml_schema}.agt_acp_dubil.dubil_type_cd is '借据类型代码';
comment on column ${iml_schema}.agt_acp_dubil.loan_status_cd is '贷款状态代码';
comment on column ${iml_schema}.agt_acp_dubil.loan_cap_use_position_cd is '贷款资金使用位置代码';
comment on column ${iml_schema}.agt_acp_dubil.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_acp_dubil.distr_amt is '放款金额';
comment on column ${iml_schema}.agt_acp_dubil.loan_cont_tenor is '贷款合同期限';
comment on column ${iml_schema}.agt_acp_dubil.distr_dt is '放款日期';
comment on column ${iml_schema}.agt_acp_dubil.loan_value_dt is '贷款起息日期';
comment on column ${iml_schema}.agt_acp_dubil.loan_exp_dt is '贷款到期日期';
comment on column ${iml_schema}.agt_acp_dubil.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_acp_dubil.grace_period_days is '宽限期天数';
comment on column ${iml_schema}.agt_acp_dubil.inst_tot_comm_fee_rat is '分期总手续费率';
comment on column ${iml_schema}.agt_acp_dubil.src_int_rat_type_cd is '源利率类型代码';
comment on column ${iml_schema}.agt_acp_dubil.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_acp_dubil.int_rat_adj_ped_corp_cd is '利率调整周期单位代码';
comment on column ${iml_schema}.agt_acp_dubil.int_rat_adj_ped_freq is '利率调整周期频率';
comment on column ${iml_schema}.agt_acp_dubil.loan_actl_day_int_rat is '贷款实际日利率';
comment on column ${iml_schema}.agt_acp_dubil.pric_repay_freq_cd is '本金还款频率代码';
comment on column ${iml_schema}.agt_acp_dubil.int_repay_freq_cd is '利息还款频率代码';
comment on column ${iml_schema}.agt_acp_dubil.guar_type_cd is '担保类型代码';
comment on column ${iml_schema}.agt_acp_dubil.crdt_appl_id is '授信申请编号';
comment on column ${iml_schema}.agt_acp_dubil.recvbl_num_type_cd is '收款账号类型代码';
comment on column ${iml_schema}.agt_acp_dubil.repay_num_type_cd is '还款帐号类型代码';
comment on column ${iml_schema}.agt_acp_dubil.cust_id is '客户编号';
comment on column ${iml_schema}.agt_acp_dubil.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_acp_dubil.acctnt_dt is '会计日期';
comment on column ${iml_schema}.agt_acp_dubil.cont_status_cd is '合约状态代码';
comment on column ${iml_schema}.agt_acp_dubil.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_acp_dubil.loan_level5_cls_cd is '贷款五级分类代码';
comment on column ${iml_schema}.agt_acp_dubil.next_repay_dt is '下一还款日期';
comment on column ${iml_schema}.agt_acp_dubil.unpayoff_perds is '未结清期数';
comment on column ${iml_schema}.agt_acp_dubil.ovdue_pd_cnt is '逾期期次数';
comment on column ${iml_schema}.agt_acp_dubil.pric_ovdue_days is '本金逾期天数';
comment on column ${iml_schema}.agt_acp_dubil.int_ovdue_days is '利息逾期天数';
comment on column ${iml_schema}.agt_acp_dubil.loan_init_pric is '贷款原始本金';
comment on column ${iml_schema}.agt_acp_dubil.nomal_pric_bal is '正常本金余额';
comment on column ${iml_schema}.agt_acp_dubil.ovdue_pric_bal is '逾期本金余额';
comment on column ${iml_schema}.agt_acp_dubil.recvbl_num is '收款帐号';
comment on column ${iml_schema}.agt_acp_dubil.repay_num is '还款帐号';
comment on column ${iml_schema}.agt_acp_dubil.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_acp_dubil.repay_acct_id is '还款账户编号';
comment on column ${iml_schema}.agt_acp_dubil.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_acp_dubil.acru_non_acru_flg is '应计非应计标志';
comment on column ${iml_schema}.agt_acp_dubil.nomal_int_bal is '正常利息余额';
comment on column ${iml_schema}.agt_acp_dubil.ovdue_int_bal is '逾期利息余额';
comment on column ${iml_schema}.agt_acp_dubil.ovdue_pric_pnlt_bal is '逾期本金罚息余额';
comment on column ${iml_schema}.agt_acp_dubil.ovdue_int_pnlt_bal is '逾期利息罚息余额';
comment on column ${iml_schema}.agt_acp_dubil.loan_exec_year_int_rat is '贷款执行年利率';
comment on column ${iml_schema}.agt_acp_dubil.lpr_int_rat is 'LPR利率';
comment on column ${iml_schema}.agt_acp_dubil.int_rat_float_spread_val is '利率浮动点差值';
comment on column ${iml_schema}.agt_acp_dubil.int_rat_float_dir_cd is '利率浮动方向代码';
comment on column ${iml_schema}.agt_acp_dubil.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_acp_dubil.wrt_off_flg is '核销标志';
comment on column ${iml_schema}.agt_acp_dubil.dist_cd is '行政区划代码';
comment on column ${iml_schema}.agt_acp_dubil.lmt_usage_cd is '额度用途代码';
comment on column ${iml_schema}.agt_acp_dubil.asset_thd_cls_cd is '资产三分类代码';
comment on column ${iml_schema}.agt_acp_dubil.white_list_cust_flg is '白户标志';
comment on column ${iml_schema}.agt_acp_dubil.create_dt is '创建日期';
comment on column ${iml_schema}.agt_acp_dubil.update_dt is '更新日期';
comment on column ${iml_schema}.agt_acp_dubil.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_acp_dubil.id_mark is '增删标志';
comment on column ${iml_schema}.agt_acp_dubil.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_acp_dubil.job_cd is '任务编码';
comment on column ${iml_schema}.agt_acp_dubil.etl_timestamp is 'ETL处理时间戳';
