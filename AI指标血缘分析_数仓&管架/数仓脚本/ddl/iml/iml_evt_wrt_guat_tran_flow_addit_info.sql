/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_wrt_guat_tran_flow_addit_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_wrt_guat_tran_flow_addit_info
whenever sqlerror continue none;
drop table ${iml_schema}.evt_wrt_guat_tran_flow_addit_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wrt_guat_tran_flow_addit_info(
    evt_id varchar2(250) -- 事件编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,lp_id varchar2(100) -- 法人编号
    ,cust_id varchar2(100) -- 客户编号
    ,decl_type_cd varchar2(30) -- 申报类型代码
    ,decl_cust_type_cd varchar2(30) -- 申报客户类型代码
    ,subm_num varchar2(60) -- 报送号码
    ,inco_tran_code varchar2(60) -- 收入方交易编码
    ,expns_tran_code varchar2(60) -- 支出方交易编码
    ,wrt_guat_type_cd varchar2(30) -- 结售汇类型代码
    ,wrt_guat_proj_code varchar2(60) -- 结售汇项目编码
    ,wrt_guat_tran_status_cd varchar2(30) -- 结售汇交易状态代码
    ,wrt_guat_usage varchar2(500) -- 结售汇用途
    ,wrt_guat_dtl_usage varchar2(1000) -- 结汇详细用途
    ,cust_single_acct_prefr_val number(10) -- 客户单户优惠值
    ,int_rat_apv_form_id varchar2(100) -- 利率审批单编号
    ,cash_from_cd varchar2(30) -- 现钞来源代码
    ,cash_usage_cd varchar2(30) -- 现钞提取用途代码
    ,cash_from_cty_rg_cd varchar2(30) -- 现钞来源国家地区代码
    ,cash_to_cty_rg_cd varchar2(30) -- 现钞去向国家地区代码
    ,src_module_type_cd varchar2(30) -- 源模块类型代码
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,check_dt date -- 复核日期
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
    ,remark varchar2(750) -- 备注
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
grant select on ${iml_schema}.evt_wrt_guat_tran_flow_addit_info to ${icl_schema};
grant select on ${iml_schema}.evt_wrt_guat_tran_flow_addit_info to ${idl_schema};
grant select on ${iml_schema}.evt_wrt_guat_tran_flow_addit_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_wrt_guat_tran_flow_addit_info is '结售汇交易流水附加信息';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.evt_id is '事件编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.lp_id is '法人编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.cust_id is '客户编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.decl_type_cd is '申报类型代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.decl_cust_type_cd is '申报客户类型代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.subm_num is '报送号码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.inco_tran_code is '收入方交易编码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.expns_tran_code is '支出方交易编码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.wrt_guat_type_cd is '结售汇类型代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.wrt_guat_proj_code is '结售汇项目编码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.wrt_guat_tran_status_cd is '结售汇交易状态代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.wrt_guat_usage is '结售汇用途';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.wrt_guat_dtl_usage is '结汇详细用途';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.cust_single_acct_prefr_val is '客户单户优惠值';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.int_rat_apv_form_id is '利率审批单编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.cash_from_cd is '现钞来源代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.cash_usage_cd is '现钞提取用途代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.cash_from_cty_rg_cd is '现钞来源国家地区代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.cash_to_cty_rg_cd is '现钞去向国家地区代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.src_module_type_cd is '源模块类型代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.check_dt is '复核日期';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.remark is '备注';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.job_cd is '任务编码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow_addit_info.etl_timestamp is 'ETL处理时间戳';
