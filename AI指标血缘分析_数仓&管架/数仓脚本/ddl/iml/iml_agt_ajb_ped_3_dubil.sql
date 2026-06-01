/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ajb_ped_3_dubil
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ajb_ped_3_dubil
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ajb_ped_3_dubil purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ajb_ped_3_dubil(
    agt_id varchar2(100) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,prod_id varchar2(100) -- 产品编号
    ,cust_name varchar2(500) -- 客户名称
    ,loan_status_cd varchar2(10) -- 贷款状态代码
    ,loan_usage_cd varchar2(10) -- 贷款用途代码
    ,loan_cap_use_position_cd varchar2(10) -- 贷款资金使用位置代码
    ,distr_dt date -- 放款日期
    ,curr_cd varchar2(10) -- 币种代码
    ,distr_amt number(30,6) -- 放款金额
    ,loan_value_dt date -- 贷款起息日期
    ,loan_exp_dt date -- 贷款到期日期
    ,loan_cont_tenor number(10) -- 贷款合同期限
    ,repay_way_cd varchar2(10) -- 还款方式代码
    ,grace_period_days number(10) -- 宽限期天数
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,loan_actl_day_int_rat number(18,8) -- 贷款实际日利率
    ,pric_repay_freq_cd varchar2(10) -- 本金还款频率代码
    ,int_repay_freq_cd varchar2(10) -- 利息还款频率代码
    ,guar_type_cd varchar2(10) -- 担保类型代码
    ,loan_crdt_appl_id varchar2(100) -- 贷款授信申请编号
    ,recvbl_num_type_cd varchar2(10) -- 收款账号类型代码
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,repay_num_type_cd varchar2(10) -- 还款账号类型代码
    ,repay_acct_id varchar2(100) -- 还款账户编号
    ,acctnt_dt date -- 会计日期
    ,cont_status_cd varchar2(10) -- 合约状态代码
    ,payoff_dt date -- 结清日期
    ,loan_level5_cls_cd varchar2(10) -- 贷款五级分类代码
    ,acru_non_acru_flg varchar2(10) -- 应计非应计标志
    ,next_repay_dt date -- 下一还款日期
    ,int_ovdue_days number(10) -- 利息逾期天数
    ,nomal_pric_bal number(30,2) -- 正常本金余额
    ,ovdue_pric_bal number(30,2) -- 逾期本金余额
    ,nomal_int_bal number(30,2) -- 正常利息余额
    ,ovdue_int_bal number(30,2) -- 逾期利息余额
    ,ovdue_pric_pnlt_bal number(30,2) -- 逾期本金罚息余额
    ,ovdue_int_pnlt_bal number(30,2) -- 逾期利息罚息余额
    ,unpayoff_perds number(10) -- 未结清期数
    ,ovdue_pd_cnt number(10) -- 逾期期次数
    ,pric_ovdue_days number(10) -- 本金逾期天数
    ,cust_id varchar2(60) -- 客户编号
    ,wrt_off_flg varchar2(10) -- 核销标志
    ,loan_exec_year_int_rat number(18,10) -- 贷款执行年利率
    ,lpr_int_rat number(18,10) -- LPR利率
    ,int_rat_float_spread_val number(18,10) -- 利率浮动点差值
    ,int_rat_float_dir_cd varchar2(10) -- 利率浮动方向代码
    ,base_rat_type_cd varchar2(10) -- 基准利率类型代码
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
grant select on ${iml_schema}.agt_ajb_ped_3_dubil to ${icl_schema};
grant select on ${iml_schema}.agt_ajb_ped_3_dubil to ${idl_schema};
grant select on ${iml_schema}.agt_ajb_ped_3_dubil to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ajb_ped_3_dubil is '借呗三期借据';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.prod_id is '产品编号';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.cust_name is '客户名称';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.loan_status_cd is '贷款状态代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.loan_cap_use_position_cd is '贷款资金使用位置代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.distr_dt is '放款日期';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.distr_amt is '放款金额';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.loan_value_dt is '贷款起息日期';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.loan_exp_dt is '贷款到期日期';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.loan_cont_tenor is '贷款合同期限';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.grace_period_days is '宽限期天数';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.loan_actl_day_int_rat is '贷款实际日利率';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.pric_repay_freq_cd is '本金还款频率代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.int_repay_freq_cd is '利息还款频率代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.guar_type_cd is '担保类型代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.loan_crdt_appl_id is '贷款授信申请编号';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.recvbl_num_type_cd is '收款账号类型代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.repay_num_type_cd is '还款账号类型代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.repay_acct_id is '还款账户编号';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.acctnt_dt is '会计日期';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.cont_status_cd is '合约状态代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.loan_level5_cls_cd is '贷款五级分类代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.acru_non_acru_flg is '应计非应计标志';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.next_repay_dt is '下一还款日期';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.int_ovdue_days is '利息逾期天数';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.nomal_pric_bal is '正常本金余额';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.ovdue_pric_bal is '逾期本金余额';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.nomal_int_bal is '正常利息余额';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.ovdue_int_bal is '逾期利息余额';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.ovdue_pric_pnlt_bal is '逾期本金罚息余额';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.ovdue_int_pnlt_bal is '逾期利息罚息余额';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.unpayoff_perds is '未结清期数';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.ovdue_pd_cnt is '逾期期次数';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.pric_ovdue_days is '本金逾期天数';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.cust_id is '客户编号';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.wrt_off_flg is '核销标志';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.loan_exec_year_int_rat is '贷款执行年利率';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.lpr_int_rat is 'LPR利率';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.int_rat_float_spread_val is '利率浮动点差值';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.int_rat_float_dir_cd is '利率浮动方向代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.asset_thd_cls_cd is '资产三分类代码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.white_list_cust_flg is '白户标志';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.create_dt is '创建日期';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.update_dt is '更新日期';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ajb_ped_3_dubil.etl_timestamp is 'ETL处理时间戳';
