/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wph_crdt_appl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wph_crdt_appl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wph_crdt_appl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wph_crdt_appl(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,src_appl_flow_num varchar2(100) -- 源申请流水号
    ,appl_status_cd varchar2(30) -- 申请状态代码
    ,org_id varchar2(100) -- 机构编号
    ,prod_id varchar2(100) -- 产品编号
    ,loan_type_cd varchar2(30) -- 贷款类型代码
    ,loan_usage_cd varchar2(30) -- 贷款用途代码
    ,loan_perds number(10) -- 贷款期数
    ,lmt_type_cd varchar2(30) -- 额度类型代码
    ,appl_tot_amt number(30,8) -- 申请总额度
    ,partner_promis_loan_amt number(30,8) -- 合作方承贷金额
    ,lmt_effect_dt date -- 额度生效日期
    ,lmt_invalid_dt date -- 额度失效日期
    ,year_int_rat number(30,8) -- 年利率
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,custs_cd varchar2(30) -- 客群代码
    ,mobile_no varchar2(60) -- 手机号码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,career_cd varchar2(30) -- 职业代码
    ,title_cd varchar2(30) -- 职称代码
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,risk_mgmt_rest_cd varchar2(60) -- 风控结果代码
    ,risk_mgmt_refuse_rs varchar2(4000) -- 风控拒绝原因
    ,risk_mgmt_crdt_lmt number(30,8) -- 风控授信额度
    ,risk_mgmt_int_year_int_rat number(30,8) -- 风控利息年利率
    ,risk_mgmt_dt date -- 风控回调日期
    ,risk_mgmt_remark varchar2(4000) -- 风控备注
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
grant select on ${iml_schema}.agt_wph_crdt_appl to ${icl_schema};
grant select on ${iml_schema}.agt_wph_crdt_appl to ${idl_schema};
grant select on ${iml_schema}.agt_wph_crdt_appl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wph_crdt_appl is '唯品会授信申请';
comment on column ${iml_schema}.agt_wph_crdt_appl.appl_id is '申请编号';
comment on column ${iml_schema}.agt_wph_crdt_appl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wph_crdt_appl.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.agt_wph_crdt_appl.src_appl_flow_num is '源申请流水号';
comment on column ${iml_schema}.agt_wph_crdt_appl.appl_status_cd is '申请状态代码';
comment on column ${iml_schema}.agt_wph_crdt_appl.org_id is '机构编号';
comment on column ${iml_schema}.agt_wph_crdt_appl.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wph_crdt_appl.loan_type_cd is '贷款类型代码';
comment on column ${iml_schema}.agt_wph_crdt_appl.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_wph_crdt_appl.loan_perds is '贷款期数';
comment on column ${iml_schema}.agt_wph_crdt_appl.lmt_type_cd is '额度类型代码';
comment on column ${iml_schema}.agt_wph_crdt_appl.appl_tot_amt is '申请总额度';
comment on column ${iml_schema}.agt_wph_crdt_appl.partner_promis_loan_amt is '合作方承贷金额';
comment on column ${iml_schema}.agt_wph_crdt_appl.lmt_effect_dt is '额度生效日期';
comment on column ${iml_schema}.agt_wph_crdt_appl.lmt_invalid_dt is '额度失效日期';
comment on column ${iml_schema}.agt_wph_crdt_appl.year_int_rat is '年利率';
comment on column ${iml_schema}.agt_wph_crdt_appl.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wph_crdt_appl.cust_name is '客户名称';
comment on column ${iml_schema}.agt_wph_crdt_appl.custs_cd is '客群代码';
comment on column ${iml_schema}.agt_wph_crdt_appl.mobile_no is '手机号码';
comment on column ${iml_schema}.agt_wph_crdt_appl.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_wph_crdt_appl.cert_no is '证件号码';
comment on column ${iml_schema}.agt_wph_crdt_appl.career_cd is '职业代码';
comment on column ${iml_schema}.agt_wph_crdt_appl.title_cd is '职称代码';
comment on column ${iml_schema}.agt_wph_crdt_appl.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_wph_crdt_appl.risk_mgmt_rest_cd is '风控结果代码';
comment on column ${iml_schema}.agt_wph_crdt_appl.risk_mgmt_refuse_rs is '风控拒绝原因';
comment on column ${iml_schema}.agt_wph_crdt_appl.risk_mgmt_crdt_lmt is '风控授信额度';
comment on column ${iml_schema}.agt_wph_crdt_appl.risk_mgmt_int_year_int_rat is '风控利息年利率';
comment on column ${iml_schema}.agt_wph_crdt_appl.risk_mgmt_dt is '风控回调日期';
comment on column ${iml_schema}.agt_wph_crdt_appl.risk_mgmt_remark is '风控备注';
comment on column ${iml_schema}.agt_wph_crdt_appl.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wph_crdt_appl.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_wph_crdt_appl.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wph_crdt_appl.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_wph_crdt_appl.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_wph_crdt_appl.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_wph_crdt_appl.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wph_crdt_appl.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wph_crdt_appl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wph_crdt_appl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wph_crdt_appl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wph_crdt_appl.etl_timestamp is 'ETL处理时间戳';
