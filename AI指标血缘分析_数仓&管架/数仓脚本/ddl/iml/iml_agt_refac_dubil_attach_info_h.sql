/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_refac_dubil_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_refac_dubil_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_refac_dubil_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_refac_dubil_attach_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,batch_pkg_id varchar2(100) -- 批次包编号
    ,cert_name varchar2(500) -- 证件名称
    ,cert_no varchar2(100) -- 证件号码
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,dubil_amt number(30,2) -- 借据金额
    ,exec_int_rat number(18,8) -- 执行利率
    ,dubil_bal number(30,8) -- 借据余额
    ,loan_distr_dt date -- 贷款发放日期
    ,loan_exp_dt date -- 贷款到期日期
    ,loan_level5_cls_cd varchar2(30) -- 贷款五级分类代码
    ,loan_usage_cd varchar2(30) -- 贷款用途代码
    ,main_guar_way_cd varchar2(30) -- 主担保方式代码
    ,indus_type_cd varchar2(30) -- 行业类型代码
    ,loan_type_cd varchar2(30) -- 贷款类型代码
    ,loan_type_subdv_cd varchar2(30) -- 贷款类型细分代码
    ,corp_size_cd varchar2(30) -- 企业规模代码
    ,corp_number varchar2(30) -- 企业人数
    ,last_year_bus_inco varchar2(60) -- 上年末营业收入
    ,in_pool_flg varchar2(10) -- 入池标志
    ,refac_status_cd varchar2(30) -- 支小再状态代码
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,org_name varchar2(500) -- 机构名称
    ,dubil_status_cd varchar2(30) -- 借据状态代码
    ,batch_pkg_name varchar2(500) -- 批次包名称
    ,dubil_invalid_dt date -- 借据失效日期
    ,corp_asset_tot number(18,8) -- 企业资产总额(万元)
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_refac_dubil_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_refac_dubil_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_refac_dubil_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_refac_dubil_attach_info_h is '支小再贷款借据补充信息历史';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.batch_pkg_id is '批次包编号';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.cert_name is '证件名称';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.dubil_amt is '借据金额';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.dubil_bal is '借据余额';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.loan_distr_dt is '贷款发放日期';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.loan_exp_dt is '贷款到期日期';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.loan_level5_cls_cd is '贷款五级分类代码';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.main_guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.indus_type_cd is '行业类型代码';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.loan_type_cd is '贷款类型代码';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.loan_type_subdv_cd is '贷款类型细分代码';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.corp_size_cd is '企业规模代码';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.corp_number is '企业人数';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.last_year_bus_inco is '上年末营业收入';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.in_pool_flg is '入池标志';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.refac_status_cd is '支小再状态代码';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.org_name is '机构名称';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.dubil_status_cd is '借据状态代码';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.batch_pkg_name is '批次包名称';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.dubil_invalid_dt is '借据失效日期';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.corp_asset_tot is '企业资产总额(万元)';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_refac_dubil_attach_info_h.etl_timestamp is 'ETL处理时间戳';
