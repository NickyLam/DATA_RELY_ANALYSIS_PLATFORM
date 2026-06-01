/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_myloan_dubil
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_myloan_dubil
whenever sqlerror continue none;
drop table ${iml_schema}.agt_myloan_dubil purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_myloan_dubil(
    agt_id varchar2(100) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,ext_prod_id varchar2(60) -- 外部产品编号
    ,cont_id varchar2(100) -- 合同编号
    ,loan_status_cd varchar2(10) -- 贷款状态代码
    ,loan_usage_cd varchar2(10) -- 贷款用途代码
    ,loan_cap_use_position_cd varchar2(10) -- 贷款资金使用位置代码
    ,distr_dt date -- 放款日期
    ,curr_cd varchar2(10) -- 币种代码
    ,distr_amt number(30,2) -- 放款金额
    ,loan_value_dt date -- 贷款起息日期
    ,loan_exp_dt date -- 贷款到期日期
    ,loan_cont_tenor number(10) -- 贷款合同期限
    ,repay_way_cd varchar2(10) -- 还款方式代码
    ,grace_period_days number(10) -- 宽限期天数
    ,src_int_rat_type_cd varchar2(10) -- 源利率类型代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,int_rat_adj_ped_corp_cd varchar2(10) -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq varchar2(10) -- 利率调整周期频率
    ,loan_actl_day_int_rat number(18,8) -- 贷款实际日利率
    ,pric_repay_freq_cd varchar2(10) -- 本金还款频率代码
    ,int_repay_freq_cd varchar2(10) -- 利息还款频率代码
    ,guar_type_cd varchar2(10) -- 担保类型代码
    ,crdt_appl_id varchar2(100) -- 授信申请编号
    ,recvbl_num_type_cd varchar2(30) -- 收款账号类型代码
    ,recvbl_acct_name varchar2(500) -- 收款账户名称
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recvbl_bank_name varchar2(500) -- 收款银行名称
    ,repay_num_type_cd varchar2(30) -- 还款账号类型代码
    ,repay_acct_name varchar2(500) -- 还款账户名称
    ,repay_acct_id varchar2(100) -- 还款账户编号
    ,repay_bank_name varchar2(500) -- 还款银行名称
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,acctnt_dt date -- 会计日期
    ,cont_status_cd varchar2(10) -- 合约状态代码
    ,payoff_dt date -- 结清日期
    ,loan_level5_cls_cd varchar2(10) -- 贷款五级分类代码
    ,acru_non_acru_flg varchar2(10) -- 应计非应计标志
    ,next_repay_dt date -- 下一还款日期
    ,unpayoff_perds number(10) -- 未结清期数
    ,ovdue_pd_cnt number(10) -- 逾期期次数
    ,pric_ovdue_days number(10) -- 本金逾期天数
    ,int_ovdue_days number(10) -- 利息逾期天数
    ,nomal_pric_bal number(30,2) -- 正常本金余额
    ,ovdue_pric_bal number(30,2) -- 逾期本金余额
    ,loan_dir_indus_cd varchar2(10) -- 贷款投向行业代码
    ,cust_id varchar2(60) -- 客户编号
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,nomal_int_bal number(30,2) -- 正常利息余额
    ,ovdue_int_bal number(30,2) -- 逾期利息余额
    ,ovdue_pric_pnlt_bal number(30,2) -- 逾期本金罚息余额
    ,ovdue_int_pnlt_bal number(30,2) -- 逾期利息罚息余额
    ,loan_exec_year_int_rat number(18,10) -- 贷款执行年利率
    ,lpr_int_rat number(18,10) -- LPR利率
    ,int_rat_float_spread_val number(18,10) -- 利率浮动点差值
    ,int_rat_float_dir_cd varchar2(10) -- 利率浮动方向代码
    ,base_rat_type_cd varchar2(10) -- 基准利率类型代码
    ,tran_type_cd varchar2(10) -- 转让类型代码
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,prod_id varchar2(100) -- 产品编号
    ,contri_type_cd varchar2(30) -- 出资类型代码
    ,contri_ratio number(38,8) -- 出资比例
    ,white_list_cust_flg varchar2(10) -- 白户标志
    ,cust_char_cd varchar2(30) -- 客户性质代码
    ,farm_flg varchar2(10) -- 农户标志
    ,cred_rht_turn_flg varchar2(10) -- 债权直转标志
    ,myloan_dubil_type_cd varchar2(100) -- 借据类型代码
    ,hxb_loan_amt number(30,8) -- 我行贷款金额
    ,hxb_loan_tot_perds number(10) -- 我行贷款总期数
    ,hxb_loan_begin_dt date -- 我行贷款起始日期
    ,happ_way_cd varchar2(30) -- 发生方式代码
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
grant select on ${iml_schema}.agt_myloan_dubil to ${icl_schema};
grant select on ${iml_schema}.agt_myloan_dubil to ${idl_schema};
grant select on ${iml_schema}.agt_myloan_dubil to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_myloan_dubil is '网商贷借据';
comment on column ${iml_schema}.agt_myloan_dubil.agt_id is '协议编号';
comment on column ${iml_schema}.agt_myloan_dubil.lp_id is '法人编号';
comment on column ${iml_schema}.agt_myloan_dubil.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_myloan_dubil.ext_prod_id is '外部产品编号';
comment on column ${iml_schema}.agt_myloan_dubil.cont_id is '合同编号';
comment on column ${iml_schema}.agt_myloan_dubil.loan_status_cd is '贷款状态代码';
comment on column ${iml_schema}.agt_myloan_dubil.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_myloan_dubil.loan_cap_use_position_cd is '贷款资金使用位置代码';
comment on column ${iml_schema}.agt_myloan_dubil.distr_dt is '放款日期';
comment on column ${iml_schema}.agt_myloan_dubil.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_myloan_dubil.distr_amt is '放款金额';
comment on column ${iml_schema}.agt_myloan_dubil.loan_value_dt is '贷款起息日期';
comment on column ${iml_schema}.agt_myloan_dubil.loan_exp_dt is '贷款到期日期';
comment on column ${iml_schema}.agt_myloan_dubil.loan_cont_tenor is '贷款合同期限';
comment on column ${iml_schema}.agt_myloan_dubil.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_myloan_dubil.grace_period_days is '宽限期天数';
comment on column ${iml_schema}.agt_myloan_dubil.src_int_rat_type_cd is '源利率类型代码';
comment on column ${iml_schema}.agt_myloan_dubil.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_myloan_dubil.int_rat_adj_ped_corp_cd is '利率调整周期单位代码';
comment on column ${iml_schema}.agt_myloan_dubil.int_rat_adj_ped_freq is '利率调整周期频率';
comment on column ${iml_schema}.agt_myloan_dubil.loan_actl_day_int_rat is '贷款实际日利率';
comment on column ${iml_schema}.agt_myloan_dubil.pric_repay_freq_cd is '本金还款频率代码';
comment on column ${iml_schema}.agt_myloan_dubil.int_repay_freq_cd is '利息还款频率代码';
comment on column ${iml_schema}.agt_myloan_dubil.guar_type_cd is '担保类型代码';
comment on column ${iml_schema}.agt_myloan_dubil.crdt_appl_id is '授信申请编号';
comment on column ${iml_schema}.agt_myloan_dubil.recvbl_num_type_cd is '收款账号类型代码';
comment on column ${iml_schema}.agt_myloan_dubil.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.agt_myloan_dubil.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_myloan_dubil.recvbl_bank_name is '收款银行名称';
comment on column ${iml_schema}.agt_myloan_dubil.repay_num_type_cd is '还款账号类型代码';
comment on column ${iml_schema}.agt_myloan_dubil.repay_acct_name is '还款账户名称';
comment on column ${iml_schema}.agt_myloan_dubil.repay_acct_id is '还款账户编号';
comment on column ${iml_schema}.agt_myloan_dubil.repay_bank_name is '还款银行名称';
comment on column ${iml_schema}.agt_myloan_dubil.prod_type_cd is '产品类型代码';
comment on column ${iml_schema}.agt_myloan_dubil.acctnt_dt is '会计日期';
comment on column ${iml_schema}.agt_myloan_dubil.cont_status_cd is '合约状态代码';
comment on column ${iml_schema}.agt_myloan_dubil.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_myloan_dubil.loan_level5_cls_cd is '贷款五级分类代码';
comment on column ${iml_schema}.agt_myloan_dubil.acru_non_acru_flg is '应计非应计标志';
comment on column ${iml_schema}.agt_myloan_dubil.next_repay_dt is '下一还款日期';
comment on column ${iml_schema}.agt_myloan_dubil.unpayoff_perds is '未结清期数';
comment on column ${iml_schema}.agt_myloan_dubil.ovdue_pd_cnt is '逾期期次数';
comment on column ${iml_schema}.agt_myloan_dubil.pric_ovdue_days is '本金逾期天数';
comment on column ${iml_schema}.agt_myloan_dubil.int_ovdue_days is '利息逾期天数';
comment on column ${iml_schema}.agt_myloan_dubil.nomal_pric_bal is '正常本金余额';
comment on column ${iml_schema}.agt_myloan_dubil.ovdue_pric_bal is '逾期本金余额';
comment on column ${iml_schema}.agt_myloan_dubil.loan_dir_indus_cd is '贷款投向行业代码';
comment on column ${iml_schema}.agt_myloan_dubil.cust_id is '客户编号';
comment on column ${iml_schema}.agt_myloan_dubil.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_myloan_dubil.nomal_int_bal is '正常利息余额';
comment on column ${iml_schema}.agt_myloan_dubil.ovdue_int_bal is '逾期利息余额';
comment on column ${iml_schema}.agt_myloan_dubil.ovdue_pric_pnlt_bal is '逾期本金罚息余额';
comment on column ${iml_schema}.agt_myloan_dubil.ovdue_int_pnlt_bal is '逾期利息罚息余额';
comment on column ${iml_schema}.agt_myloan_dubil.loan_exec_year_int_rat is '贷款执行年利率';
comment on column ${iml_schema}.agt_myloan_dubil.lpr_int_rat is 'LPR利率';
comment on column ${iml_schema}.agt_myloan_dubil.int_rat_float_spread_val is '利率浮动点差值';
comment on column ${iml_schema}.agt_myloan_dubil.int_rat_float_dir_cd is '利率浮动方向代码';
comment on column ${iml_schema}.agt_myloan_dubil.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_myloan_dubil.tran_type_cd is '转让类型代码';
comment on column ${iml_schema}.agt_myloan_dubil.asset_thd_cls_cd is '资产三分类代码';
comment on column ${iml_schema}.agt_myloan_dubil.prod_id is '产品编号';
comment on column ${iml_schema}.agt_myloan_dubil.contri_type_cd is '出资类型代码';
comment on column ${iml_schema}.agt_myloan_dubil.contri_ratio is '出资比例';
comment on column ${iml_schema}.agt_myloan_dubil.white_list_cust_flg is '白户标志';
comment on column ${iml_schema}.agt_myloan_dubil.cust_char_cd is '客户性质代码';
comment on column ${iml_schema}.agt_myloan_dubil.farm_flg is '农户标志';
comment on column ${iml_schema}.agt_myloan_dubil.cred_rht_turn_flg is '债权直转标志';
comment on column ${iml_schema}.agt_myloan_dubil.myloan_dubil_type_cd is '借据类型代码';
comment on column ${iml_schema}.agt_myloan_dubil.hxb_loan_amt is '我行贷款金额';
comment on column ${iml_schema}.agt_myloan_dubil.hxb_loan_tot_perds is '我行贷款总期数';
comment on column ${iml_schema}.agt_myloan_dubil.hxb_loan_begin_dt is '我行贷款起始日期';
comment on column ${iml_schema}.agt_myloan_dubil.happ_way_cd is '发生方式代码';
comment on column ${iml_schema}.agt_myloan_dubil.create_dt is '创建日期';
comment on column ${iml_schema}.agt_myloan_dubil.update_dt is '更新日期';
comment on column ${iml_schema}.agt_myloan_dubil.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_myloan_dubil.id_mark is '增删标志';
comment on column ${iml_schema}.agt_myloan_dubil.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_myloan_dubil.job_cd is '任务编码';
comment on column ${iml_schema}.agt_myloan_dubil.etl_timestamp is 'ETL处理时间戳';
