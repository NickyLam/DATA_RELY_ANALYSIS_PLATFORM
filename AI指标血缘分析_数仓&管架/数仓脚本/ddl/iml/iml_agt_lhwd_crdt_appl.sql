/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lhwd_crdt_appl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lhwd_crdt_appl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lhwd_crdt_appl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lhwd_crdt_appl(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,crdt_id varchar2(100) -- 授信编号
    ,appl_amt number(30,2) -- 申请金额
    ,appl_status_cd varchar2(60) -- 申请状态代码
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,crdt_chn_cd varchar2(60) -- 授信渠道代码
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,mon_tenor number(10) -- 月期限
    ,day_tenor number(10) -- 日期限
    ,circl_flg varchar2(10) -- 循环标志
    ,main_guar_way_cd varchar2(30) -- 主担保方式代码
    ,loan_dir_indus_cd varchar2(60) -- 贷款投向行业代码
    ,loan_usage_cd varchar2(60) -- 贷款用途代码
    ,bank_contri_ratio number(30,8) -- 银行出资比例
    ,apv_start_dt date -- 审批开始日期
    ,risk_mgmt_crdt_lmt number(30,8) -- 风控授信额度
    ,risk_mgmt_refuse_code varchar2(100) -- 风控拒绝码
    ,risk_mgmt_refuse_rs_descb varchar2(2000) -- 风控拒绝原因描述
    ,risk_mgmt_return_dt date -- 风控返回日期
    ,manu_apv_flg varchar2(10) -- 人工审批标志
    ,partner_prod_id varchar2(100) -- 合作方产品编号
    ,partner_ova_flow_num varchar2(100) -- 合作方全局流水号
    ,partner_bus_mode_cd varchar2(100) -- 合作方业务模式代码
    ,partner_apv_status_cd varchar2(60) -- 合作方审批状态代码
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,latest_update_dt date -- 最新更新日期
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
grant select on ${iml_schema}.agt_lhwd_crdt_appl to ${icl_schema};
grant select on ${iml_schema}.agt_lhwd_crdt_appl to ${idl_schema};
grant select on ${iml_schema}.agt_lhwd_crdt_appl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lhwd_crdt_appl is '联合网贷授信申请';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.appl_id is '申请编号';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.crdt_id is '授信编号';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.appl_amt is '申请金额';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.appl_status_cd is '申请状态代码';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.cust_id is '客户编号';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.cust_name is '客户名称';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.crdt_chn_cd is '授信渠道代码';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.prod_id is '产品编号';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.mon_tenor is '月期限';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.day_tenor is '日期限';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.circl_flg is '循环标志';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.main_guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.loan_dir_indus_cd is '贷款投向行业代码';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.bank_contri_ratio is '银行出资比例';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.apv_start_dt is '审批开始日期';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.risk_mgmt_crdt_lmt is '风控授信额度';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.risk_mgmt_refuse_code is '风控拒绝码';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.risk_mgmt_refuse_rs_descb is '风控拒绝原因描述';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.risk_mgmt_return_dt is '风控返回日期';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.manu_apv_flg is '人工审批标志';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.partner_prod_id is '合作方产品编号';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.partner_ova_flow_num is '合作方全局流水号';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.partner_bus_mode_cd is '合作方业务模式代码';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.partner_apv_status_cd is '合作方审批状态代码';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.latest_update_dt is '最新更新日期';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lhwd_crdt_appl.etl_timestamp is 'ETL处理时间戳';
