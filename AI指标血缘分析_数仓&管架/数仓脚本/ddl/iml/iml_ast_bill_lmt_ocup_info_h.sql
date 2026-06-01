/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_bill_lmt_ocup_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_bill_lmt_ocup_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.ast_bill_lmt_ocup_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_bill_lmt_ocup_info_h(
    asset_id varchar2(100) -- 资产编号
    ,lp_id varchar2(100) -- 法人编号
    ,col_id varchar2(100) -- 押品编号
    ,crdt_cont_id varchar2(100) -- 信贷合同编号
    ,margin_acct_id varchar2(100) -- 保证金账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,crdt_ocup_cust_id varchar2(100) -- 授信占用方客户编号
    ,crdt_cust_mgr_teller_id varchar2(100) -- 信贷客户经理柜员编号
    ,crdt_cust_mgr_belong_org_name varchar2(750) -- 信贷客户经理所属机构名称
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,froz_flg varchar2(10) -- 冻结标志
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
grant select on ${iml_schema}.ast_bill_lmt_ocup_info_h to ${icl_schema};
grant select on ${iml_schema}.ast_bill_lmt_ocup_info_h to ${idl_schema};
grant select on ${iml_schema}.ast_bill_lmt_ocup_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_bill_lmt_ocup_info_h is '票据额度占用信息历史';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.asset_id is '资产编号';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.col_id is '押品编号';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.crdt_cont_id is '信贷合同编号';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.margin_acct_id is '保证金账户编号';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.crdt_ocup_cust_id is '授信占用方客户编号';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.crdt_cust_mgr_teller_id is '信贷客户经理柜员编号';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.crdt_cust_mgr_belong_org_name is '信贷客户经理所属机构名称';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.froz_flg is '冻结标志';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.ast_bill_lmt_ocup_info_h.etl_timestamp is 'ETL处理时间戳';
