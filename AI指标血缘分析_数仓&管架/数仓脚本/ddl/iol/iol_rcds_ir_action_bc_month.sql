/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_action_bc_month
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_action_bc_month
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_action_bc_month purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_action_bc_month(
    loan_no varchar2(30) -- 贷款借据号
    ,data_dt varchar2(10) -- 数据日期
    ,cust_id varchar2(60) -- 客户编号
    ,cust_name varchar2(60) -- 客户名称
    ,cont_no varchar2(60) -- 合同号
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,overduedays_month number(17,2) -- 逾期天数
    ,ovdue_princp_amt number(17,2) -- 逾期本金
    ,rcva_owe_int number(17,2) -- 应收欠息
    ,dun_owe_int number(17,2) -- 催收欠息
    ,rcva_acr_intr number(17,2) -- 应收应计利息
    ,dun_acr_intr number(17,2) -- 催收应计利息
    ,rcva_pnlt number(17,2) -- 应收罚息
    ,dun_pnlt number(17,2) -- 催收罚息
    ,rcva_accr_pnlt number(17,2) -- 应收应计罚息
    ,dun_accr_pnlt number(17,2) -- 催收应计罚息
    ,rcva_cmpd_intr number(17,2) -- 应收复息
    ,accr_cmpd_intr number(17,2) -- 应计复息
    ,loan_total_bal number(17,2) -- 贷款余额
    ,repayment number(17,2) -- 实还金额
    ,adv_repay_flg varchar2(40) -- 提前还款标志
    ,adv_repay_amt number(17,2) -- 提前还款本金
    ,agt_status_cd varchar2(40) -- 贷款账户状态代码
    ,risk_rat_categ_cd varchar2(40) -- 风险评级类别代码
    ,risk_rat_resu_cd varchar2(40) -- 风险评级结果代码
    ,v_dyyhje number(17,2) -- 当月应还金额
    ,v_dysjhkl number(11,7) -- 当月实际还款率
    ,v_dyyqje number(17,2) -- 当月逾期金额
    ,v_dyyqqs number(5,0) -- 当月逾期期数
    ,v_ye number(17,2) -- 余额
    ,v_yelxzjys number(22) -- 余额连续增加月份数
    ,v_hkllxzjys number(22) -- 还款率连续增加月份数
    ,v_hkllxjsys number(22) -- 还款率连续减少月份数
    ,v_lxwyqys number(22) -- 连续未逾期月数
    ,v_lxqyys number(22) -- 
    ,v_yqbyqqslxzjys number(22) -- 逾期并逾期期数连续增加的月数
    ,v_yqjelxzjys number(22) -- 逾期金额连续增加月数
    ,v_lxyqys number(22) -- 连续逾期月数
    ,write_off_flg varchar2(10) -- 核销标志
    ,bout_liqdt_flg varchar2(10) -- 第三方代偿标志
    ,data_src_cd varchar2(10) -- 数据来源代码
    ,serno varchar2(60) -- 业务流水号
    ,blng_org_id varchar2(30) -- 所属机构
    ,iden_num varchar2(40) -- 客户证件号码
    ,grade_key_id varchar2(60) -- 申请评分流水号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rcds_ir_action_bc_month to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_action_bc_month to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_action_bc_month to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_action_bc_month to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_action_bc_month is '月度行为表';
comment on column ${iol_schema}.rcds_ir_action_bc_month.loan_no is '贷款借据号';
comment on column ${iol_schema}.rcds_ir_action_bc_month.data_dt is '数据日期';
comment on column ${iol_schema}.rcds_ir_action_bc_month.cust_id is '客户编号';
comment on column ${iol_schema}.rcds_ir_action_bc_month.cust_name is '客户名称';
comment on column ${iol_schema}.rcds_ir_action_bc_month.cont_no is '合同号';
comment on column ${iol_schema}.rcds_ir_action_bc_month.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rcds_ir_action_bc_month.overduedays_month is '逾期天数';
comment on column ${iol_schema}.rcds_ir_action_bc_month.ovdue_princp_amt is '逾期本金';
comment on column ${iol_schema}.rcds_ir_action_bc_month.rcva_owe_int is '应收欠息';
comment on column ${iol_schema}.rcds_ir_action_bc_month.dun_owe_int is '催收欠息';
comment on column ${iol_schema}.rcds_ir_action_bc_month.rcva_acr_intr is '应收应计利息';
comment on column ${iol_schema}.rcds_ir_action_bc_month.dun_acr_intr is '催收应计利息';
comment on column ${iol_schema}.rcds_ir_action_bc_month.rcva_pnlt is '应收罚息';
comment on column ${iol_schema}.rcds_ir_action_bc_month.dun_pnlt is '催收罚息';
comment on column ${iol_schema}.rcds_ir_action_bc_month.rcva_accr_pnlt is '应收应计罚息';
comment on column ${iol_schema}.rcds_ir_action_bc_month.dun_accr_pnlt is '催收应计罚息';
comment on column ${iol_schema}.rcds_ir_action_bc_month.rcva_cmpd_intr is '应收复息';
comment on column ${iol_schema}.rcds_ir_action_bc_month.accr_cmpd_intr is '应计复息';
comment on column ${iol_schema}.rcds_ir_action_bc_month.loan_total_bal is '贷款余额';
comment on column ${iol_schema}.rcds_ir_action_bc_month.repayment is '实还金额';
comment on column ${iol_schema}.rcds_ir_action_bc_month.adv_repay_flg is '提前还款标志';
comment on column ${iol_schema}.rcds_ir_action_bc_month.adv_repay_amt is '提前还款本金';
comment on column ${iol_schema}.rcds_ir_action_bc_month.agt_status_cd is '贷款账户状态代码';
comment on column ${iol_schema}.rcds_ir_action_bc_month.risk_rat_categ_cd is '风险评级类别代码';
comment on column ${iol_schema}.rcds_ir_action_bc_month.risk_rat_resu_cd is '风险评级结果代码';
comment on column ${iol_schema}.rcds_ir_action_bc_month.v_dyyhje is '当月应还金额';
comment on column ${iol_schema}.rcds_ir_action_bc_month.v_dysjhkl is '当月实际还款率';
comment on column ${iol_schema}.rcds_ir_action_bc_month.v_dyyqje is '当月逾期金额';
comment on column ${iol_schema}.rcds_ir_action_bc_month.v_dyyqqs is '当月逾期期数';
comment on column ${iol_schema}.rcds_ir_action_bc_month.v_ye is '余额';
comment on column ${iol_schema}.rcds_ir_action_bc_month.v_yelxzjys is '余额连续增加月份数';
comment on column ${iol_schema}.rcds_ir_action_bc_month.v_hkllxzjys is '还款率连续增加月份数';
comment on column ${iol_schema}.rcds_ir_action_bc_month.v_hkllxjsys is '还款率连续减少月份数';
comment on column ${iol_schema}.rcds_ir_action_bc_month.v_lxwyqys is '连续未逾期月数';
comment on column ${iol_schema}.rcds_ir_action_bc_month.v_lxqyys is '';
comment on column ${iol_schema}.rcds_ir_action_bc_month.v_yqbyqqslxzjys is '逾期并逾期期数连续增加的月数';
comment on column ${iol_schema}.rcds_ir_action_bc_month.v_yqjelxzjys is '逾期金额连续增加月数';
comment on column ${iol_schema}.rcds_ir_action_bc_month.v_lxyqys is '连续逾期月数';
comment on column ${iol_schema}.rcds_ir_action_bc_month.write_off_flg is '核销标志';
comment on column ${iol_schema}.rcds_ir_action_bc_month.bout_liqdt_flg is '第三方代偿标志';
comment on column ${iol_schema}.rcds_ir_action_bc_month.data_src_cd is '数据来源代码';
comment on column ${iol_schema}.rcds_ir_action_bc_month.serno is '业务流水号';
comment on column ${iol_schema}.rcds_ir_action_bc_month.blng_org_id is '所属机构';
comment on column ${iol_schema}.rcds_ir_action_bc_month.iden_num is '客户证件号码';
comment on column ${iol_schema}.rcds_ir_action_bc_month.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_action_bc_month.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rcds_ir_action_bc_month.etl_timestamp is 'ETL处理时间戳';
