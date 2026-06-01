/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_dep_acct_oc_acct_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_dep_acct_oc_acct_rgst_b
whenever sqlerror continue none;
drop table ${iml_schema}.evt_dep_acct_oc_acct_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dep_acct_oc_acct_rgst_b(
    evt_id varchar2(250) -- 事件编号
    ,flow_num varchar2(100) -- 流水号
    ,lp_id varchar2(100) -- 法人编号
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,acct_curr_cd varchar2(30) -- 账户币种代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,prod_id varchar2(100) -- 产品编号
    ,card_no varchar2(60) -- 卡号
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,core_acct_type_cd varchar2(30) -- 核心账户类型代码
    ,acct_usage_cd varchar2(30) -- 账户用途代码
    ,rs_descb varchar2(500) -- 原因描述
    ,acct_attr_cd varchar2(30) -- 账户属性代码
    ,acct_actv_dt date -- 账户激活日期
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,advise_pbc_flg varchar2(10) -- 通知人行标志
    ,oc_acct_oper_way_cd varchar2(30) -- 开销户操作方式代码
    ,oc_acct_rgst_type_cd varchar2(30) -- 开销户登记类型代码
    ,soci_unify_crdt_cd_flg varchar2(10) -- 社会统一信用代码标志
    ,regard_same_self_flg varchar2(10) -- 视同本人标志
    ,cust_cert_no varchar2(60) -- 客户证件号码
    ,cust_id varchar2(100) -- 客户编号
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,tran_dt date -- 交易日期
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_tm timestamp -- 交易时间
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,apv_form_id varchar2(100) -- 审批单编号
    ,fxq_tran_dt date -- 反洗钱交易日期
    ,memo_code varchar2(60) -- 摘要码
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
grant select on ${iml_schema}.evt_dep_acct_oc_acct_rgst_b to ${icl_schema};
grant select on ${iml_schema}.evt_dep_acct_oc_acct_rgst_b to ${idl_schema};
grant select on ${iml_schema}.evt_dep_acct_oc_acct_rgst_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_dep_acct_oc_acct_rgst_b is '存款账户开销户登记簿';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.evt_id is '事件编号';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.flow_num is '流水号';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.lp_id is '法人编号';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.acct_id is '账户编号';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.acct_curr_cd is '账户币种代码';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.sub_acct_num is '子账号';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.prod_id is '产品编号';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.card_no is '卡号';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.core_acct_type_cd is '核心账户类型代码';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.acct_usage_cd is '账户用途代码';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.rs_descb is '原因描述';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.acct_attr_cd is '账户属性代码';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.acct_actv_dt is '账户激活日期';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.advise_pbc_flg is '通知人行标志';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.oc_acct_oper_way_cd is '开销户操作方式代码';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.oc_acct_rgst_type_cd is '开销户登记类型代码';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.soci_unify_crdt_cd_flg is '社会统一信用代码标志';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.regard_same_self_flg is '视同本人标志';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.cust_cert_no is '客户证件号码';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.cust_id is '客户编号';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.apv_form_id is '审批单编号';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.fxq_tran_dt is '反洗钱交易日期';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.memo_code is '摘要码';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.job_cd is '任务编码';
comment on column ${iml_schema}.evt_dep_acct_oc_acct_rgst_b.etl_timestamp is 'ETL处理时间戳';
