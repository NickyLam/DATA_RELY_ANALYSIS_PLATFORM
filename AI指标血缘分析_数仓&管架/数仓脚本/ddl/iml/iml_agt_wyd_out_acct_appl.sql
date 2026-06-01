/*
Purpose:    整合模型层-切片建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wyd_out_acct_appl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wyd_out_acct_appl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wyd_out_acct_appl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_out_acct_appl(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,org_id varchar2(100) -- 机构编号
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,prod_id varchar2(100) -- 产品编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,mercht_id varchar2(100) -- 商户编号
    ,bus_lics_id varchar2(100) -- 营业执照编号
    ,corp_size_cd varchar2(30) -- 企业规模代码
    ,eigen_code varchar2(100) -- 中征码
    ,tel_num varchar2(100) -- 联系号码
    ,appl_tm date -- 申请时间
    ,appl_site varchar2(500) -- 申请地点
    ,appl_usage_cd varchar2(30) -- 申请用途代码
    ,precon_distr_dt date -- 预约放款日期
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,cont_amt number(30,8) -- 合同金额
    ,exp_dt date -- 到期日期
    ,intnal_rating_cd varchar2(30) -- 内部评级代码
    ,risk_mgmt_return_dt date -- 风控返回日期
    ,lp_crdtc_auth_sign_dt date -- 法人征信授权书签署日期
    ,lp_crdtc_auth_sign_flow_num varchar2(100) -- 法人征信授权书签署流水号
    ,crdtc_rest_cd varchar2(30) -- 征信检验结果代码
    ,init_dubil_id varchar2(100) -- 原借据编号
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,cust_mgr_org_id varchar2(100) -- 客户经理机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_belong_org_id varchar2(100) -- 登记所属机构编号
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
grant select on ${iml_schema}.agt_wyd_out_acct_appl to ${icl_schema};
grant select on ${iml_schema}.agt_wyd_out_acct_appl to ${idl_schema};
grant select on ${iml_schema}.agt_wyd_out_acct_appl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wyd_out_acct_appl is '微业贷出账申请';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.appl_id is '申请编号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.org_id is '机构编号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.cust_name is '客户名称';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.mercht_id is '商户编号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.bus_lics_id is '营业执照编号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.corp_size_cd is '企业规模代码';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.eigen_code is '中征码';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.tel_num is '联系号码';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.appl_tm is '申请时间';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.appl_site is '申请地点';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.appl_usage_cd is '申请用途代码';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.precon_distr_dt is '预约放款日期';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.cont_amt is '合同金额';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.intnal_rating_cd is '内部评级代码';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.risk_mgmt_return_dt is '风控返回日期';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.lp_crdtc_auth_sign_dt is '法人征信授权书签署日期';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.lp_crdtc_auth_sign_flow_num is '法人征信授权书签署流水号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.crdtc_rest_cd is '征信检验结果代码';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.init_dubil_id is '原借据编号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.cust_mgr_org_id is '客户经理机构编号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.rgst_belong_org_id is '登记所属机构编号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wyd_out_acct_appl.etl_timestamp is 'ETL处理时间戳';
