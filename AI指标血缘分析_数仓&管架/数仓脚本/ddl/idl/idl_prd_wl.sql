/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl prd_wl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.prd_wl
whenever sqlerror continue none;
drop table ${idl_schema}.prd_wl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.prd_wl(
    etl_dt date -- 数据日期   
    ,prod_id varchar2(60) -- 产品编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,loan_prod_id varchar2(60) -- 贷款产品编号   
    ,prod_cls_id varchar2(60) -- 产品分类编号   
    ,cap_acct_id varchar2(60) -- 资金账户编号   
    ,return_acct_id varchar2(60) -- 回款账户编号   
    ,deflt_chn_id varchar2(60) -- 默认渠道编号   
    ,org_id varchar2(60) -- 机构编号   
    ,prod_attr_cd varchar2(10) -- 产品属性代码   
    ,user_group_id varchar2(60) -- 用户组编号   
    ,min_loan_tenor number(10) -- 最小贷款期限   
    ,max_loan_tenor number(10) -- 最大贷款期限   
    ,single_loan_lolmi_amt number(30,2) -- 单笔贷款下限金额   
    ,single_loan_uplmi_amt number(30,2) -- 单笔贷款上限金额   
    ,min_crdt_lmt number(30,2) -- 最小授信额度   
    ,max_crdt_lmt number(30,2) -- 最大授信额度   
    ,exec_uplmi_mon_int_rat number(18,6) -- 执行上限月利率   
    ,exec_lolmi_mon_int_rat number(18,6) -- 执行下限月利率   
    ,sp_check_ratio number(18,6) -- 抽检比例   
    ,grace_days number(10) -- 宽限天数   
    ,auto_apv_flg varchar2(10) -- 自动审批标志   
    ,auto_distr_flg varchar2(10) -- 自动放款标志   
    ,aval_status_flg varchar2(10) -- 可用状态标志   
    ,sp_check_swi_flg varchar2(10) -- 抽检开关标志   
    ,loan_mode_cd varchar2(10) -- 贷款模式代码   
    ,tenor_type_cd varchar2(10) -- 期限类型代码   
    ,int_rat_ped_cd varchar2(10) -- 利率周期代码   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识
    ,job_cd varchar2(10) -- 任务编码   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.prd_wl to ${iel_schema};

-- comment
comment on table ${idl_schema}.prd_wl is '网贷产品';
comment on column ${idl_schema}.prd_wl.etl_dt is '数据日期';
comment on column ${idl_schema}.prd_wl.prod_id is '产品编号';
comment on column ${idl_schema}.prd_wl.lp_id is '法人编号';
comment on column ${idl_schema}.prd_wl.loan_prod_id is '贷款产品编号';
comment on column ${idl_schema}.prd_wl.prod_cls_id is '产品分类编号';
comment on column ${idl_schema}.prd_wl.cap_acct_id is '资金账户编号';
comment on column ${idl_schema}.prd_wl.return_acct_id is '回款账户编号';
comment on column ${idl_schema}.prd_wl.deflt_chn_id is '默认渠道编号';
comment on column ${idl_schema}.prd_wl.org_id is '机构编号';
comment on column ${idl_schema}.prd_wl.prod_attr_cd is '产品属性代码';
comment on column ${idl_schema}.prd_wl.user_group_id is '用户组编号';
comment on column ${idl_schema}.prd_wl.min_loan_tenor is '最小贷款期限';
comment on column ${idl_schema}.prd_wl.max_loan_tenor is '最大贷款期限';
comment on column ${idl_schema}.prd_wl.single_loan_lolmi_amt is '单笔贷款下限金额';
comment on column ${idl_schema}.prd_wl.single_loan_uplmi_amt is '单笔贷款上限金额';
comment on column ${idl_schema}.prd_wl.min_crdt_lmt is '最小授信额度';
comment on column ${idl_schema}.prd_wl.max_crdt_lmt is '最大授信额度';
comment on column ${idl_schema}.prd_wl.exec_uplmi_mon_int_rat is '执行上限月利率';
comment on column ${idl_schema}.prd_wl.exec_lolmi_mon_int_rat is '执行下限月利率';
comment on column ${idl_schema}.prd_wl.sp_check_ratio is '抽检比例';
comment on column ${idl_schema}.prd_wl.grace_days is '宽限天数';
comment on column ${idl_schema}.prd_wl.auto_apv_flg is '自动审批标志';
comment on column ${idl_schema}.prd_wl.auto_distr_flg is '自动放款标志';
comment on column ${idl_schema}.prd_wl.aval_status_flg is '可用状态标志';
comment on column ${idl_schema}.prd_wl.sp_check_swi_flg is '抽检开关标志';
comment on column ${idl_schema}.prd_wl.loan_mode_cd is '贷款模式代码';
comment on column ${idl_schema}.prd_wl.tenor_type_cd is '期限类型代码';
comment on column ${idl_schema}.prd_wl.int_rat_ped_cd is '利率周期代码';
comment on column ${idl_schema}.prd_wl.create_dt is '创建日期';
comment on column ${idl_schema}.prd_wl.update_dt is '更新日期';
comment on column ${idl_schema}.prd_wl.id_mark is '删除标识';