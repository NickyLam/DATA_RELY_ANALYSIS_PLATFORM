/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_dubil_indv_loan_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,white_list_cust_flg varchar2(10) -- 白户标志
    ,blon_loan_amort_exp_dt date -- 气球贷摊销到期日期
    ,farm_flg varchar2(10) -- 农户标志
    ,cust_char_cd varchar2(30) -- 客户性质代码
    ,cust_crdt_tot_amt number(30,6) -- 客户授信总额度
    ,move_flg varchar2(30) -- 迁移标志
    ,prod_chn_idf_cd varchar2(30) -- 产品渠道标识代码
    ,corp_cred_rht_advise_id varchar2(100) -- 企业级债权通知书编号
    ,corp_cred_dubil_id varchar2(100) -- 企业级客户借据编号
    ,cust_cred_rht_advise_id varchar2(100) -- 客户级债权通知书编号
    ,tax_flg varchar2(10) -- 涉税标志
    ,agclt_flg varchar2(10) -- 涉农标志
    ,file_int_accr_flg varchar2(10) -- 靠档计息标志
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
grant select on ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h is '贷款借据个人贷款附属信息历史';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.white_list_cust_flg is '白户标志';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.blon_loan_amort_exp_dt is '气球贷摊销到期日期';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.farm_flg is '农户标志';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.cust_char_cd is '客户性质代码';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.cust_crdt_tot_amt is '客户授信总额度';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.move_flg is '迁移标志';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.prod_chn_idf_cd is '产品渠道标识代码';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.corp_cred_rht_advise_id is '企业级债权通知书编号';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.corp_cred_dubil_id is '企业级客户借据编号';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.cust_cred_rht_advise_id is '客户级债权通知书编号';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.tax_flg is '涉税标志';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.agclt_flg is '涉农标志';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.file_int_accr_flg is '靠档计息标志';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h.etl_timestamp is 'ETL处理时间戳';
