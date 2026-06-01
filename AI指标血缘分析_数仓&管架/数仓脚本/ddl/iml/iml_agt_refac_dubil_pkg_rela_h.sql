/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_refac_dubil_pkg_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_refac_dubil_pkg_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_refac_dubil_pkg_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_refac_dubil_pkg_rela_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,apv_flow_num varchar2(100) -- 审批流水号
    ,batch_pkg_id varchar2(100) -- 批次包编号
    ,in_pool_idf_cd varchar2(30) -- 入池标识代码
    ,in_pool_org_cd varchar2(30) -- 入池机构代码
    ,actl_loan_distr_dt date -- 实际贷款发放日期
    ,actl_loan_termnt_dt date -- 实际贷款终止日期
    ,last_year_bus_inco number(30,6) -- 上年末营业收入
    ,corp_asset_tot number(30,6) -- 企业资产总额(万元)
    ,indus_type_cd varchar2(30) -- 行业类型代码
    ,loan_usage_descb varchar2(500) -- 贷款用途描述
    ,corp_size_cd varchar2(30) -- 企业规模代码
    ,exec_int_rat number(30,8) -- 执行利率
    ,corp_number number -- 企业人数
    ,loan_kind_cd varchar2(30) -- 贷款种类代码
    ,mang_main_crdt_id varchar2(60) -- 经营主体信用代码
    ,remark varchar2(2000) -- 备注
    ,move_remark varchar2(500) -- 迁移备注
    ,rzxz_indus_type_cd		varchar2(30) -- 支小再行业类型代码
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
grant select on ${iml_schema}.agt_refac_dubil_pkg_rela_h to ${icl_schema};
grant select on ${iml_schema}.agt_refac_dubil_pkg_rela_h to ${idl_schema};
grant select on ${iml_schema}.agt_refac_dubil_pkg_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_refac_dubil_pkg_rela_h is '支小再借据与批次包关系历史';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.apv_flow_num is '审批流水号';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.batch_pkg_id is '批次包编号';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.in_pool_idf_cd is '入池标识代码';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.in_pool_org_cd is '入池机构代码';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.actl_loan_distr_dt is '实际贷款发放日期';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.actl_loan_termnt_dt is '实际贷款终止日期';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.last_year_bus_inco is '上年末营业收入';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.corp_asset_tot is '企业资产总额(万元)';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.indus_type_cd is '行业类型代码';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.loan_usage_descb is '贷款用途描述';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.corp_size_cd is '企业规模代码';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.corp_number is '企业人数';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.loan_kind_cd is '贷款种类代码';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.mang_main_crdt_id is '经营主体信用代码';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.remark is '备注';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.move_remark is '迁移备注';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.rzxz_indus_type_cd is '支小再行业类型代码';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_refac_dubil_pkg_rela_h.etl_timestamp is 'ETL处理时间戳';
