/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_lp_od_sign_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_lp_od_sign_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_lp_od_sign_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_lp_od_sign_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,crdt_appl_id varchar2(60) -- 签约协议编号
    ,dubil_id varchar2(60) -- 借据编号
    ,cont_id varchar2(60) -- 合同编号
    ,od_acct_id varchar2(60) -- 透支账户编号
    ,od_sub_acct_id varchar2(60) -- 透支子户编号
    ,old_od_sub_acct_id varchar2(60) -- 旧透支子户编号
    ,cust_id varchar2(60) -- 客户编号
    ,loan_org_id varchar2(60) -- 贷款机构编号
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,sign_flow_num varchar2(60) -- 签约流水号
    ,int_rat_reval_cd varchar2(10) -- 利率重定价代码
    ,int_set_way_cd varchar2(10) -- 结息方式代码
    ,crdt_status_cd varchar2(10) -- 信用状态代码
    ,od_serv_status_cd varchar2(10) -- 透支服务状态代码
    ,lp_od_type_cd varchar2(30) -- 法透类型代码
    ,tenor varchar2(10) -- 期限
    ,tenor_type_cd varchar2(10) -- 期限类型代码
    ,base_rat_cd varchar2(30) -- 基准利率代码
    ,sign_dt date -- 签约日期
    ,lmt_start_dt date -- 额度开始日期
    ,lmt_exp_dt date -- 额度到期日期
    ,sig_od_valid_days number(10) -- 单笔透支有效天数
    ,od_lmt_uplmi number(30,2) -- 透支额度上限
    ,start_od_amt number(30,2) -- 起透金额
    ,od_promis_fee number(30,2) -- 透支承诺费
    ,od_lmt number(30,2) -- 透支额度
    ,used_od_lmt number(30,2) -- 已用透支额度
    ,surp_od_lmt number(30,2) -- 剩余透支额度
    ,nomal_int_rat_fl_rt number(18,6) -- 正常利率浮动比例
    ,ovdue_int_rat_fl_rt number(18,6) -- 逾期利率浮动比例
    ,nomal_loan_int_rat number(18,8) -- 正常贷款利率
    ,ovdue_loan_int_rat number(18,8) -- 逾期贷款利率
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_lp_od_sign_info to ${idl_schema};
grant select on ${icl_schema}.cmm_lp_od_sign_info to ${iel_schema};
grant select on ${icl_schema}.cmm_lp_od_sign_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_lp_od_sign_info is '法透签约信息';
comment on column ${icl_schema}.cmm_lp_od_sign_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_lp_od_sign_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_lp_od_sign_info.crdt_appl_id is '签约协议编号';
comment on column ${icl_schema}.cmm_lp_od_sign_info.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_lp_od_sign_info.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_lp_od_sign_info.od_acct_id is '透支账户编号';
comment on column ${icl_schema}.cmm_lp_od_sign_info.od_sub_acct_id is '透支子户编号';
comment on column ${icl_schema}.cmm_lp_od_sign_info.old_od_sub_acct_id is '旧透支子户编号';
comment on column ${icl_schema}.cmm_lp_od_sign_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_lp_od_sign_info.loan_org_id is '贷款机构编号';
comment on column ${icl_schema}.cmm_lp_od_sign_info.cust_mgr_id is '客户经理编号';
comment on column ${icl_schema}.cmm_lp_od_sign_info.sign_flow_num is '签约流水号';
comment on column ${icl_schema}.cmm_lp_od_sign_info.int_rat_reval_cd is '利率重定价代码';
comment on column ${icl_schema}.cmm_lp_od_sign_info.int_set_way_cd is '结息方式代码';
comment on column ${icl_schema}.cmm_lp_od_sign_info.crdt_status_cd is '信用状态代码';
comment on column ${icl_schema}.cmm_lp_od_sign_info.od_serv_status_cd is '透支服务状态代码';
comment on column ${icl_schema}.cmm_lp_od_sign_info.lp_od_type_cd is '法透类型代码';
comment on column ${icl_schema}.cmm_lp_od_sign_info.tenor is '期限';
comment on column ${icl_schema}.cmm_lp_od_sign_info.tenor_type_cd is '期限类型代码';
comment on column ${icl_schema}.cmm_lp_od_sign_info.base_rat_cd is '基准利率代码';
comment on column ${icl_schema}.cmm_lp_od_sign_info.sign_dt is '签约日期';
comment on column ${icl_schema}.cmm_lp_od_sign_info.lmt_start_dt is '额度开始日期';
comment on column ${icl_schema}.cmm_lp_od_sign_info.lmt_exp_dt is '额度到期日期';
comment on column ${icl_schema}.cmm_lp_od_sign_info.sig_od_valid_days is '单笔透支有效天数';
comment on column ${icl_schema}.cmm_lp_od_sign_info.od_lmt_uplmi is '透支额度上限';
comment on column ${icl_schema}.cmm_lp_od_sign_info.start_od_amt is '起透金额';
comment on column ${icl_schema}.cmm_lp_od_sign_info.od_promis_fee is '透支承诺费';
comment on column ${icl_schema}.cmm_lp_od_sign_info.od_lmt is '透支额度';
comment on column ${icl_schema}.cmm_lp_od_sign_info.used_od_lmt is '已用透支额度';
comment on column ${icl_schema}.cmm_lp_od_sign_info.surp_od_lmt is '剩余透支额度';
comment on column ${icl_schema}.cmm_lp_od_sign_info.nomal_int_rat_fl_rt is '正常利率浮动比例';
comment on column ${icl_schema}.cmm_lp_od_sign_info.ovdue_int_rat_fl_rt is '逾期利率浮动比例';
comment on column ${icl_schema}.cmm_lp_od_sign_info.nomal_loan_int_rat is '正常贷款利率';
comment on column ${icl_schema}.cmm_lp_od_sign_info.ovdue_loan_int_rat is '逾期贷款利率';
comment on column ${icl_schema}.cmm_lp_od_sign_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_lp_od_sign_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_lp_od_sign_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_lp_od_sign_info.etl_timestamp is 'ETL处理时间戳';
