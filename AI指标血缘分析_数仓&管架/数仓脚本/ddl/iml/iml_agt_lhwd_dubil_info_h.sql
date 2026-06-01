/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lhwd_dubil_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lhwd_dubil_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lhwd_dubil_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lhwd_dubil_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cont_id varchar2(100) -- 合同编号
    ,prod_id varchar2(100) -- 产品编号
    ,main_guar_way_cd varchar2(30) -- 主担保方式代码
    ,int_accr_way_cd varchar2(30) -- 计息方式代码
    ,distr_mode_pay_cd varchar2(60) -- 放款支付方式代码
    ,entry_idf_cd varchar2(30) -- 记账标识代码
    ,acru_non_acru_cd varchar2(30) -- 应计非应计代码
    ,crdt_chn_cd varchar2(60) -- 授信渠道代码
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,asset_thd_cls_cd varchar2(60) -- 资产三分类代码
    ,loan_type_cd varchar2(30) -- 贷款类型代码
    ,dubil_status_cd varchar2(30) -- 借据状态代码
    ,dubil_amt number(30,8) -- 借据金额
    ,curr_cd varchar2(30) -- 币种代码
    ,mon_tenor number(10) -- 月期限
    ,day_tenor number(10) -- 日期限
    ,grace_period number(10) -- 宽限期
    ,loan_perds number(10) -- 贷款期数
    ,curr_perds number(10) -- 当前期数
    ,unpayoff_perds number(10) -- 未结清期数
    ,payoff_dt date -- 结清日期
    ,exp_dt date -- 到期日期
    ,out_acct_dt date -- 出账日期
    ,wrt_off_dt date -- 核销日期
    ,level5_cls_dt date -- 五级分类日期
    ,loan_ovdue_dt date -- 贷款逾期日期
    ,loan_int_ovdue_dt date -- 贷款利息逾期日期
    ,loan_ovdue_days number(10) -- 贷款逾期天数
    ,loan_int_ovdue_days number(10) -- 贷款利息逾期天数
    ,int_rat_float_way_cd varchar2(30) -- 利率浮动方式代码
    ,int_rat_float_dir_cd varchar2(30) -- 利率浮动方向代码
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,int_rat_adj_ped_cd varchar2(60) -- 利率调整周期代码
    ,int_rat_float_spread number(18,8) -- 利率浮动点差
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,base_rat number(18,8) -- 基准利率
    ,exec_int_rat number(30,8) -- 执行利率
    ,int_rat number(30,8) -- 固收利率
    ,comp_int_int_rat number(18,8) -- 复利利率
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,ovdue_int_rat_float_way_cd varchar2(100) -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt number(30,8) -- 逾期利率浮动比例
    ,revs_flg varchar2(10) -- 冲正标志
    ,wrt_off_flg varchar2(10) -- 核销标志
    ,wrt_off_pric number(30,8) -- 核销本金
    ,loan_bal number(30,8) -- 贷款余额
    ,nomal_pric_bal number(30,8) -- 正常本金余额
    ,nomal_int_bal number(30,8) -- 正常利息余额
    ,ovdue_pric_bal number(30,8) -- 逾期本金余额
    ,ovdue_int_bal number(30,8) -- 逾期利息余额
    ,pnlt_bal number(30,8) -- 罚息余额
    ,comp_int_bal number(30,8) -- 复息余额
    ,td_acru_int number(30,8) -- 当日应计利息
    ,int_recvbl number(30,8) -- 应收利息
    ,recvbl_pnlt number(30,8) -- 应收罚息
    ,recvbl_comp_int number(30,8) -- 应收复息
    ,wrt_off_int number(30,8) -- 核销利息
    ,bank_contri_ratio number(30,8) -- 银行出资比例
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,out_acct_org_id varchar2(250) -- 出账机构编号
    ,enter_id varchar2(100) -- 入账账户编号
    ,enter_type_cd varchar2(100) -- 入账账户类型代码
    ,enter_name varchar2(500) -- 入账账户名称
    ,enter_open_acct_org_name varchar2(500) -- 入账账户开户机构名称
    ,stl_way_cd varchar2(30) -- 结算方式代码
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,repay_ped_cd varchar2(60) -- 还款周期代码
    ,repay_num_id varchar2(100) -- 还款账户编号
    ,repay_num_type_cd varchar2(100) -- 还款账户类型代码
    ,repay_num_name varchar2(500) -- 还款账户名称
    ,repay_num_open_acct_org_name varchar2(500) -- 还款账户开户机构名称
    ,partner_dubil_id varchar2(100) -- 合作方借据编号
    ,partner_prod_id varchar2(100) -- 合作方产品编号
    ,partner_ova_flow_num varchar2(100) -- 合作方全局流水号
    ,partner_bus_mode_cd varchar2(100) -- 合作方业务模式代码
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,final_update_dt date -- 最后更新日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_lhwd_dubil_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_lhwd_dubil_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_lhwd_dubil_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lhwd_dubil_info_h is '联合网贷借据信息历史';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.main_guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.int_accr_way_cd is '计息方式代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.distr_mode_pay_cd is '放款支付方式代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.entry_idf_cd is '记账标识代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.acru_non_acru_cd is '应计非应计代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.crdt_chn_cd is '授信渠道代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.asset_thd_cls_cd is '资产三分类代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.loan_type_cd is '贷款类型代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.dubil_status_cd is '借据状态代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.dubil_amt is '借据金额';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.mon_tenor is '月期限';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.day_tenor is '日期限';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.grace_period is '宽限期';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.loan_perds is '贷款期数';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.curr_perds is '当前期数';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.unpayoff_perds is '未结清期数';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.out_acct_dt is '出账日期';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.wrt_off_dt is '核销日期';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.level5_cls_dt is '五级分类日期';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.loan_ovdue_dt is '贷款逾期日期';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.loan_int_ovdue_dt is '贷款利息逾期日期';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.loan_ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.loan_int_ovdue_days is '贷款利息逾期天数';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.int_rat_float_dir_cd is '利率浮动方向代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.int_rat_float_spread is '利率浮动点差';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.int_rat is '固收利率';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.comp_int_int_rat is '复利利率';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.ovdue_int_rat is '逾期利率';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.ovdue_int_rat_float_way_cd is '逾期利率浮动方式代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.ovdue_int_rat_fl_rt is '逾期利率浮动比例';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.revs_flg is '冲正标志';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.wrt_off_flg is '核销标志';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.wrt_off_pric is '核销本金';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.loan_bal is '贷款余额';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.nomal_pric_bal is '正常本金余额';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.nomal_int_bal is '正常利息余额';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.ovdue_pric_bal is '逾期本金余额';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.ovdue_int_bal is '逾期利息余额';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.pnlt_bal is '罚息余额';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.comp_int_bal is '复息余额';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.td_acru_int is '当日应计利息';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.int_recvbl is '应收利息';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.recvbl_pnlt is '应收罚息';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.recvbl_comp_int is '应收复息';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.wrt_off_int is '核销利息';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.bank_contri_ratio is '银行出资比例';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.out_acct_org_id is '出账机构编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.enter_id is '入账账户编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.enter_type_cd is '入账账户类型代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.enter_name is '入账账户名称';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.enter_open_acct_org_name is '入账账户开户机构名称';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.stl_way_cd is '结算方式代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.repay_ped_cd is '还款周期代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.repay_num_id is '还款账户编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.repay_num_type_cd is '还款账户类型代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.repay_num_name is '还款账户名称';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.repay_num_open_acct_org_name is '还款账户开户机构名称';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.partner_dubil_id is '合作方借据编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.partner_prod_id is '合作方产品编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.partner_ova_flow_num is '合作方全局流水号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.partner_bus_mode_cd is '合作方业务模式代码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lhwd_dubil_info_h.etl_timestamp is 'ETL处理时间戳';
