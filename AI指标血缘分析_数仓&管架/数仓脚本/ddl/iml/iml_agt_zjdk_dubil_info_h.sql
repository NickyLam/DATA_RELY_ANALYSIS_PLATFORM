/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_zjdk_dubil_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_zjdk_dubil_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_zjdk_dubil_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_zjdk_dubil_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 核心借据编号
    ,intnal_dubil_id varchar2(100) -- 字节借据号码
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,cont_id varchar2(100) -- 合同编号
    ,prod_id varchar2(100) -- 产品编号
    ,zjdk_prod_id varchar2(100) -- 字节产品编号
    ,cust_char_cd varchar2(30) -- 客户性质代码
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,dubil_amt number(30,8) -- 借据金额
    ,curr_cd varchar2(30) -- 币种代码
    ,tenor number(10) -- 期限
    ,int_rat_mode_cd varchar2(30) -- 利率模式代码
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,base_rat number(18,8) -- 基准利率
    ,exec_int_rat number(30,8) -- 执行利率
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,int_rat_adj_ped_cd varchar2(100) -- 利率调整周期代码
    ,int_rat_float_way_cd varchar2(60) -- 利率浮动方式代码
    ,flo_val number(30,8) -- 浮动值
    ,ovdue_int_rat_float_way_cd varchar2(100) -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val number(30,8) -- 逾期利率浮动值
    ,loan_level5_cls_cd varchar2(30) -- 贷款五级分类代码
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,guar_way_cd varchar2(30) -- 主担保方式代码
    ,loan_status_cd varchar2(30) -- 贷款状态代码
    ,loan_modal_cd varchar2(30) -- 贷款形态代码
    ,appl_dt date -- 申请日期
    ,begin_dt date -- 生效日期
    ,exp_dt date -- 到期日期
    ,payoff_dt date -- 结清日期
    ,loan_tot_perds number(10) -- 贷款总期数
    ,currt_perds number(10) -- 当期期数
    ,begin_perds number(10) -- 起始期数
    ,payoff_perds number(10) -- 结清期数
    ,grace_days number(30,8) -- 宽限天数
    ,repay_day number(10) -- 还款日
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,repay_ped_corp_cd varchar2(30) -- 还款周期单位代码
    ,rpbl_pric number(30,8) -- 应还本金
    ,rpbl_int number(30,8) -- 应还利息
    ,paid_pric number(30,8) -- 已还本金
    ,paid_int number(30,8) -- 已还利息
    ,paid_pnlt number(30,8) -- 已还罚息
    ,plan_int number(30,8) -- 计划利息
    ,nomal_int_rat number(18,8) -- 正常利率
    ,nomal_int_rat_type_cd varchar2(30) -- 正常利率类型代码
    ,nomal_pric_bal number(30,8) -- 正常本金余额
    ,ovdue_dt date -- 逾期日期
    ,ovdue_days number(30,8) -- 贷款逾期天数
    ,ovdue_exec_int_rat number(30,8) -- 逾期执行利率
    ,ovdue_pric_bal number(30,8) -- 逾期本金余额
    ,ovdue_int_bal number(30,8) -- 逾期利息余额
    ,derate_int number(30,8) -- 减免利息
    ,derate_pnlt number(30,8) -- 减免罚息
    ,recvbl_pnlt number(30,8) -- 应收罚息
    ,int_bal number(30,8) -- 利息余额
    ,td_provi_int number(30,8) -- 当日计提利息
    ,td_provi_pnlt number(30,8) -- 当日计提罚息
    ,pnlt_int_rat number(18,8) -- 罚息利率
    ,pnlt_int_rat_type_cd varchar2(30) -- 罚息利率类型代码
    ,pnlt_bal number(30,8) -- 罚息余额
    ,adv_repay_comm_fee_rat number(18,6) -- 提前还款手续费率
    ,paid_adv_repay_comm_fee number(30,8) -- 已还提前还款手续费
    ,non_acru_flg varchar2(10) -- 非应计标志
    ,wrt_off_flg varchar2(10) -- 已核销标志
    ,wrt_off_dt date -- 核销日期
    ,bank_contri_ratio number(30,8) -- 银行出资比例
    ,plat_indent_id varchar2(100) -- 平台订单编号
    ,distr_tran_sucs_dt date -- 放款交易成功日期
    ,repay_num_id varchar2(100) -- 还款账户编号
    ,repay_num_type_cd varchar2(100) -- 还款账户类型代码
    ,enter_id varchar2(100) -- 入账账户编号
    ,enter_type_cd varchar2(100) -- 入账账户类型代码
    ,oper_teller_id varchar2(100) -- 经办柜员编号
    ,oper_org_id varchar2(100) -- 经办机构编号
    ,fin_org_id varchar2(100) -- 财务机构编号
    ,mgmt_org_id varchar2(100) -- 管理机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
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
grant select on ${iml_schema}.agt_zjdk_dubil_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_zjdk_dubil_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_zjdk_dubil_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_zjdk_dubil_info_h is '字节小微贷借据信息历史';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.dubil_id is '核心借据编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.intnal_dubil_id is '字节借据号码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.zjdk_prod_id is '字节产品编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.cust_char_cd is '客户性质代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.dubil_amt is '借据金额';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.tenor is '期限';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.int_rat_mode_cd is '利率模式代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.flo_val is '浮动值';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.ovdue_int_rat_float_way_cd is '逾期利率浮动方式代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.ovdue_int_rat_flo_val is '逾期利率浮动值';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.loan_level5_cls_cd is '贷款五级分类代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.asset_thd_cls_cd is '资产三分类代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.loan_status_cd is '贷款状态代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.loan_modal_cd is '贷款形态代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.appl_dt is '申请日期';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.begin_dt is '生效日期';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.loan_tot_perds is '贷款总期数';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.currt_perds is '当期期数';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.begin_perds is '起始期数';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.payoff_perds is '结清期数';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.grace_days is '宽限天数';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.repay_day is '还款日';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.repay_ped_corp_cd is '还款周期单位代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.rpbl_pric is '应还本金';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.rpbl_int is '应还利息';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.paid_pric is '已还本金';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.paid_int is '已还利息';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.paid_pnlt is '已还罚息';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.plan_int is '计划利息';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.nomal_int_rat is '正常利率';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.nomal_int_rat_type_cd is '正常利率类型代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.nomal_pric_bal is '正常本金余额';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.ovdue_dt is '逾期日期';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.ovdue_exec_int_rat is '逾期执行利率';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.ovdue_pric_bal is '逾期本金余额';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.ovdue_int_bal is '逾期利息余额';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.derate_int is '减免利息';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.derate_pnlt is '减免罚息';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.recvbl_pnlt is '应收罚息';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.int_bal is '利息余额';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.td_provi_int is '当日计提利息';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.td_provi_pnlt is '当日计提罚息';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.pnlt_int_rat is '罚息利率';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.pnlt_int_rat_type_cd is '罚息利率类型代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.pnlt_bal is '罚息余额';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.adv_repay_comm_fee_rat is '提前还款手续费率';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.paid_adv_repay_comm_fee is '已还提前还款手续费';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.non_acru_flg is '非应计标志';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.wrt_off_flg is '已核销标志';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.wrt_off_dt is '核销日期';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.bank_contri_ratio is '银行出资比例';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.plat_indent_id is '平台订单编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.distr_tran_sucs_dt is '放款交易成功日期';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.repay_num_id is '还款账户编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.repay_num_type_cd is '还款账户类型代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.enter_id is '入账账户编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.enter_type_cd is '入账账户类型代码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.oper_teller_id is '经办柜员编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.fin_org_id is '财务机构编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_zjdk_dubil_info_h.etl_timestamp is 'ETL处理时间戳';
