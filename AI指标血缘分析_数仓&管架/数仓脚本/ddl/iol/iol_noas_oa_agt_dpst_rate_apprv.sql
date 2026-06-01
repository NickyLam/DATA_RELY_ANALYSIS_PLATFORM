/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol noas_oa_agt_dpst_rate_apprv
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.noas_oa_agt_dpst_rate_apprv
whenever sqlerror continue none;
drop table ${iol_schema}.noas_oa_agt_dpst_rate_apprv purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_agt_dpst_rate_apprv(
    agt_dpst_rate_apprv_id varchar2(30) -- 主键
    ,data_src_cd varchar2(15) -- 数据来源代码
    ,del_flg varchar2(2) -- 删除标志:1-是，0:否
    ,etl_dt_ora date -- 数据日期
    ,aprv_id varchar2(90) -- 审批编号
    ,apprv_typ_cd varchar2(15) -- 审批类型代码
    ,aprv_status_cd varchar2(15) -- 审批状态代码
    ,app_categ_cd varchar2(15) -- 申请类别代码
    ,app_rate_acct varchar2(90) -- 申请利率账号
    ,new_acct_flg varchar2(2) -- 新增账号标志
    ,ccy_cd varchar2(90) -- 币种代码
    ,new_agt_flg varchar2(2) -- 新增协议标志
    ,ori_apprv_id varchar2(90) -- 原审批编号
    ,pty_id varchar2(30) -- 客户编号
    ,pty_name varchar2(600) -- 客户名称
    ,crdt_pty_flg varchar2(2) -- 授信客户标志
    ,crdt_pty_syn_income_situ varchar2(4000) -- 授信客户综合收益情况
    ,dpst_breed_cd varchar2(15) -- 储种代码
    ,peri_typ_cd varchar2(15) -- 存期类型代码
    ,agt_status_cd varchar2(15) -- 协议状态代码
    ,contr_due_dt date -- 协议到期日期
    ,apprv_start_dt date -- 审批开始日期
    ,apprv_end_dt date -- 审批结束日期
    ,apprv_due_dt date -- 审批到期日期
    ,blng_org_id varchar2(30) -- 所属机构编号
    ,app_emp_id varchar2(30) -- 申请员工编号
    ,final_aprv_emp_id varchar2(30) -- 最终审批人员工编号
    ,dpst_prd_acct_id varchar2(90) -- 存款产品户编号
    ,app_reas_situ_intro varchar2(600) -- 申请理由及情况介绍
    ,process_ins_id varchar2(90) -- 流程id
    ,last_updated_stamp timestamp -- 最后修改时间
    ,last_updated_tx_stamp timestamp -- 最后修改时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建时间
    ,app_amt_ceil number(22,4) -- 申请金额上限
    ,base_rate_val number(14,6) -- 基准利率值
    ,rate_float_val number(14,6) -- 利率浮动值
    ,exec_rate number(14,6) -- 执行利率
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.noas_oa_agt_dpst_rate_apprv to ${iml_schema};
grant select on ${iol_schema}.noas_oa_agt_dpst_rate_apprv to ${icl_schema};
grant select on ${iol_schema}.noas_oa_agt_dpst_rate_apprv to ${idl_schema};
grant select on ${iol_schema}.noas_oa_agt_dpst_rate_apprv to ${iel_schema};

-- comment
comment on table ${iol_schema}.noas_oa_agt_dpst_rate_apprv is '存款利率审批信息表';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.agt_dpst_rate_apprv_id is '主键';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.data_src_cd is '数据来源代码';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.del_flg is '删除标志:1-是，0:否';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.aprv_id is '审批编号';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.apprv_typ_cd is '审批类型代码';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.aprv_status_cd is '审批状态代码';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.app_categ_cd is '申请类别代码';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.app_rate_acct is '申请利率账号';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.new_acct_flg is '新增账号标志';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.ccy_cd is '币种代码';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.new_agt_flg is '新增协议标志';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.ori_apprv_id is '原审批编号';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.pty_id is '客户编号';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.pty_name is '客户名称';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.crdt_pty_flg is '授信客户标志';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.crdt_pty_syn_income_situ is '授信客户综合收益情况';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.dpst_breed_cd is '储种代码';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.peri_typ_cd is '存期类型代码';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.agt_status_cd is '协议状态代码';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.contr_due_dt is '协议到期日期';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.apprv_start_dt is '审批开始日期';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.apprv_end_dt is '审批结束日期';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.apprv_due_dt is '审批到期日期';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.blng_org_id is '所属机构编号';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.app_emp_id is '申请员工编号';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.final_aprv_emp_id is '最终审批人员工编号';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.dpst_prd_acct_id is '存款产品户编号';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.app_reas_situ_intro is '申请理由及情况介绍';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.process_ins_id is '流程id';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.last_updated_stamp is '最后修改时间';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.last_updated_tx_stamp is '最后修改时间';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.created_stamp is '创建时间';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.created_tx_stamp is '创建时间';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.app_amt_ceil is '申请金额上限';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.base_rate_val is '基准利率值';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.rate_float_val is '利率浮动值';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.exec_rate is '执行利率';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.start_dt is '开始时间';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.end_dt is '结束时间';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.id_mark is '增删标志';
comment on column ${iol_schema}.noas_oa_agt_dpst_rate_apprv.etl_timestamp is 'ETL处理时间戳';
