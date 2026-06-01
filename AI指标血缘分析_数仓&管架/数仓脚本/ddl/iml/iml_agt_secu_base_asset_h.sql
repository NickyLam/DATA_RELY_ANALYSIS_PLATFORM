/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_secu_base_asset_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_secu_base_asset_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_secu_base_asset_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_secu_base_asset_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,base_asset_id varchar2(60) -- 基础资产编号
    ,asset_src_cd varchar2(60) -- 资产来源代码
    ,dubil_id varchar2(60) -- 借据编号
    ,loan_cont_id varchar2(60) -- 合同编号
    ,src_cont_id varchar2(60) -- 源合同编号
    ,asset_type_cd varchar2(60) -- 资产类型代码
    ,distr_dt date -- 放款日期
    ,dubil_exp_dt date -- 借据到期日期
    ,loan_tot_perds number(10) -- 贷款总期数
    ,surp_perds number(10) -- 剩余期数
    ,eh_issue_repay_day number(10) -- 每期还款日
    ,loan_amt number(30,2) -- 贷款金额
    ,bad_debt_amt number(30,2) -- 坏账金额
    ,ovdue_amt number(30,2) -- 逾期金额
    ,loan_bal number(30,2) -- 贷款余额
    ,idle_amt number(30,2) -- 呆滞金额
    ,ovdue_dt date -- 逾期日期
    ,ovdue_days number(22) -- 贷款逾期天数
    ,max_expe_days number(10) -- 最大预期天数
    ,provi_int number(30,2) -- 计提利息
    ,rpbl_int number(30,2) -- 应还利息
    ,pric_pnlt number(30,2) -- 本金罚息
    ,int_pnlt number(30,2) -- 利息罚息
    ,curr_cd varchar2(30) -- 币种代码
    ,loan_level5_cls_cd varchar2(30) -- 贷款五级分类代码
    ,exec_int_rat number(18,8) -- 执行利率
    ,loan_status_cd varchar2(30) -- 贷款状态代码
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,base_rat number(18,8) -- 基准利率
    ,int_rat_float_way_cd varchar2(30) -- 利率浮动方式代码
    ,flo_val number(18,8) -- 浮动值
    ,cust_id varchar2(60) -- 客户编号
    ,src_cust_id varchar2(60) -- 源客户编号
    ,asset_status_cd varchar2(30) -- 资产状态代码
    ,pkg_dt date -- 封包日期
    ,issue_dt date -- 发行日期
    ,tran_cosdetn number(30,2) -- 转让对价
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,pkg_belong_hxb_int number(30,2) -- 封包时归属我行利息
    ,pkg_pric_bal number(30,8) -- 封包时本金余额
    ,pkg_asset_bal number(30,8) -- 封包时资产余额
    ,pkg_belong_hxb_int_rat number(30,8) -- 封包时归属我行利率
    ,redem_belong_hxb_int number(30,8) -- 赎回时归属我行利息
    ,redem_belong_trust_int number(30,8) -- 赎回时归属信托利息
    ,redem_cosdetn number(30,8) -- 赎回对价
    ,redem_belong_trust_pric number(30,8) -- 赎回时归属信托本金
    ,redem_cosdetn_pric number(30,8) -- 赎回对价本金
    ,redem_cosdetn_int number(30,8) -- 赎回对价利息
    ,bf_pkg_int_recvbl_bal number(30,2) -- 封包前应收利息余额
    ,after_pkg_int_recvbl_tot number(30,2) -- 封包后应收利息总额
    ,after_pkg_int_recvbl_bal number(30,2) -- 封包后应收利息余额
    ,after_rtn_pkg_int_recvbl number(30,2) -- 已归还封包后应收利息
    ,tran_loan_int_tot number(30,2) -- 转让贷款利息总额
    ,org_id varchar2(60) -- 机构编号
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
grant select on ${iml_schema}.agt_secu_base_asset_h to ${icl_schema};
grant select on ${iml_schema}.agt_secu_base_asset_h to ${idl_schema};
grant select on ${iml_schema}.agt_secu_base_asset_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_secu_base_asset_h is '证券基础资产历史';
comment on column ${iml_schema}.agt_secu_base_asset_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_secu_base_asset_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_secu_base_asset_h.base_asset_id is '基础资产编号';
comment on column ${iml_schema}.agt_secu_base_asset_h.asset_src_cd is '资产来源代码';
comment on column ${iml_schema}.agt_secu_base_asset_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_secu_base_asset_h.loan_cont_id is '合同编号';
comment on column ${iml_schema}.agt_secu_base_asset_h.src_cont_id is '源合同编号';
comment on column ${iml_schema}.agt_secu_base_asset_h.asset_type_cd is '资产类型代码';
comment on column ${iml_schema}.agt_secu_base_asset_h.distr_dt is '放款日期';
comment on column ${iml_schema}.agt_secu_base_asset_h.dubil_exp_dt is '借据到期日期';
comment on column ${iml_schema}.agt_secu_base_asset_h.loan_tot_perds is '贷款总期数';
comment on column ${iml_schema}.agt_secu_base_asset_h.surp_perds is '剩余期数';
comment on column ${iml_schema}.agt_secu_base_asset_h.eh_issue_repay_day is '每期还款日';
comment on column ${iml_schema}.agt_secu_base_asset_h.loan_amt is '贷款金额';
comment on column ${iml_schema}.agt_secu_base_asset_h.bad_debt_amt is '坏账金额';
comment on column ${iml_schema}.agt_secu_base_asset_h.ovdue_amt is '逾期金额';
comment on column ${iml_schema}.agt_secu_base_asset_h.loan_bal is '贷款余额';
comment on column ${iml_schema}.agt_secu_base_asset_h.idle_amt is '呆滞金额';
comment on column ${iml_schema}.agt_secu_base_asset_h.ovdue_dt is '逾期日期';
comment on column ${iml_schema}.agt_secu_base_asset_h.ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.agt_secu_base_asset_h.max_expe_days is '最大预期天数';
comment on column ${iml_schema}.agt_secu_base_asset_h.provi_int is '计提利息';
comment on column ${iml_schema}.agt_secu_base_asset_h.rpbl_int is '应还利息';
comment on column ${iml_schema}.agt_secu_base_asset_h.pric_pnlt is '本金罚息';
comment on column ${iml_schema}.agt_secu_base_asset_h.int_pnlt is '利息罚息';
comment on column ${iml_schema}.agt_secu_base_asset_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_secu_base_asset_h.loan_level5_cls_cd is '贷款五级分类代码';
comment on column ${iml_schema}.agt_secu_base_asset_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_secu_base_asset_h.loan_status_cd is '贷款状态代码';
comment on column ${iml_schema}.agt_secu_base_asset_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_secu_base_asset_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_secu_base_asset_h.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${iml_schema}.agt_secu_base_asset_h.flo_val is '浮动值';
comment on column ${iml_schema}.agt_secu_base_asset_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_secu_base_asset_h.src_cust_id is '源客户编号';
comment on column ${iml_schema}.agt_secu_base_asset_h.asset_status_cd is '资产状态代码';
comment on column ${iml_schema}.agt_secu_base_asset_h.pkg_dt is '封包日期';
comment on column ${iml_schema}.agt_secu_base_asset_h.issue_dt is '发行日期';
comment on column ${iml_schema}.agt_secu_base_asset_h.tran_cosdetn is '转让对价';
comment on column ${iml_schema}.agt_secu_base_asset_h.ovdue_int_rat is '逾期利率';
comment on column ${iml_schema}.agt_secu_base_asset_h.pkg_belong_hxb_int is '封包时归属我行利息';
comment on column ${iml_schema}.agt_secu_base_asset_h.pkg_pric_bal is '封包时本金余额';
comment on column ${iml_schema}.agt_secu_base_asset_h.pkg_asset_bal is '封包时资产余额';
comment on column ${iml_schema}.agt_secu_base_asset_h.pkg_belong_hxb_int_rat is '封包时归属我行利率';
comment on column ${iml_schema}.agt_secu_base_asset_h.redem_belong_hxb_int is '赎回时归属我行利息';
comment on column ${iml_schema}.agt_secu_base_asset_h.redem_belong_trust_int is '赎回时归属信托利息';
comment on column ${iml_schema}.agt_secu_base_asset_h.redem_cosdetn is '赎回对价';
comment on column ${iml_schema}.agt_secu_base_asset_h.redem_belong_trust_pric is '赎回时归属信托本金';
comment on column ${iml_schema}.agt_secu_base_asset_h.redem_cosdetn_pric is '赎回对价本金';
comment on column ${iml_schema}.agt_secu_base_asset_h.redem_cosdetn_int is '赎回对价利息';
comment on column ${iml_schema}.agt_secu_base_asset_h.bf_pkg_int_recvbl_bal is '封包前应收利息余额';
comment on column ${iml_schema}.agt_secu_base_asset_h.after_pkg_int_recvbl_tot is '封包后应收利息总额';
comment on column ${iml_schema}.agt_secu_base_asset_h.after_pkg_int_recvbl_bal is '封包后应收利息余额';
comment on column ${iml_schema}.agt_secu_base_asset_h.after_rtn_pkg_int_recvbl is '已归还封包后应收利息';
comment on column ${iml_schema}.agt_secu_base_asset_h.tran_loan_int_tot is '转让贷款利息总额';
comment on column ${iml_schema}.agt_secu_base_asset_h.org_id is '机构编号';
comment on column ${iml_schema}.agt_secu_base_asset_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_secu_base_asset_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_secu_base_asset_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_secu_base_asset_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_secu_base_asset_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_secu_base_asset_h.etl_timestamp is 'ETL处理时间戳';
