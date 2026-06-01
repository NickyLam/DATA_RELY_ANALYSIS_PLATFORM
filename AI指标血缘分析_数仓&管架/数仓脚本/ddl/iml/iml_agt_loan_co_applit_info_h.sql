/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_co_applit_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_co_applit_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_co_applit_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_co_applit_info_h(
    agt_id varchar2(250) -- 协议编号
    ,ser_num varchar2(100) -- 序列号
    ,lp_id varchar2(100) -- 法人编号
    ,obj_id varchar2(100) -- 对象编号
    ,obj_type_name varchar2(500) -- 对象类型名称
    ,applit_cust_id varchar2(100) -- 申请人客户编号
    ,applit_cust_name varchar2(500) -- 申请人客户名称
    ,eqty_tprop_ratio number(18,6) -- 权益分担比例
    ,debt_tprop_ratio number(18,6) -- 债务分担比例
    ,and_main_debit_ps_rela_type_cd varchar2(30) -- 与主借人关系类型代码
    ,loan_apv_status_cd varchar2(60) -- 贷款审批状态代码
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_tm timestamp -- 登记时间
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,update_tm timestamp -- 更新时间
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
grant select on ${iml_schema}.agt_loan_co_applit_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_co_applit_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_co_applit_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_co_applit_info_h is '贷款共同申请人信息历史';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.ser_num is '序列号';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.obj_id is '对象编号';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.obj_type_name is '对象类型名称';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.applit_cust_id is '申请人客户编号';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.applit_cust_name is '申请人客户名称';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.eqty_tprop_ratio is '权益分担比例';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.debt_tprop_ratio is '债务分担比例';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.and_main_debit_ps_rela_type_cd is '与主借人关系类型代码';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.loan_apv_status_cd is '贷款审批状态代码';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.rgst_tm is '登记时间';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.update_tm is '更新时间';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_co_applit_info_h.etl_timestamp is 'ETL处理时间戳';
