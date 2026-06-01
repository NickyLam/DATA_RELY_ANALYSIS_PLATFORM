/*
Purpose:    整合模型层-切片建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wyd_loan_cont_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wyd_loan_cont_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wyd_loan_cont_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_loan_cont_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,cont_id varchar2(100) -- 合同编号
    ,lmt_id varchar2(100) -- 额度编号
    ,org_id varchar2(100) -- 机构编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cert_no varchar2(100) -- 证件号码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,acct_id varchar2(100) -- 账户编号
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,lmt_cont_flg varchar2(10) -- 额度合同标志
    ,cont_status_cd varchar2(30) -- 合同状态代码
    ,cont_amt number(30,8) -- 合同金额
    ,cont_effect_dt date -- 合同生效日期
    ,cont_exp_dt date -- 合同到期日期
    ,init_exp_dt date -- 原始到期日期
    ,appl_type_cd varchar2(100) -- 申请类型代码
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_wyd_loan_cont_h to ${icl_schema};
grant select on ${iml_schema}.agt_wyd_loan_cont_h to ${idl_schema};
grant select on ${iml_schema}.agt_wyd_loan_cont_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wyd_loan_cont_h is '微业贷贷款合同信息历史';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.lmt_id is '额度编号';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.org_id is '机构编号';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.lmt_cont_flg is '额度合同标志';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.cont_status_cd is '合同状态代码';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.cont_amt is '合同金额';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.cont_effect_dt is '合同生效日期';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.cont_exp_dt is '合同到期日期';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.init_exp_dt is '原始到期日期';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.appl_type_cd is '申请类型代码';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wyd_loan_cont_h.etl_timestamp is 'ETL处理时间戳';
