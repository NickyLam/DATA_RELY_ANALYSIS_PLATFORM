/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_dep_bus_info_modif_oper_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_dep_bus_info_modif_oper_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_dep_bus_info_modif_oper_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dep_bus_info_modif_oper_dtl(
    evt_id varchar2(250) -- 事件编号
    ,modif_flow_num varchar2(100) -- 变更流水号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,acct_modif_type_cd varchar2(30) -- 账户变更类型代码
    ,modif_dt date -- 变更日期
    ,modif_batch_no varchar2(60) -- 变更批次号
    ,modif_bus_cate_cd varchar2(30) -- 变更业务类别代码
    ,cust_acct_num varchar2(60) -- 客户账号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,modif_item varchar2(500) -- 修改项
    ,modif_content_key_val varchar2(60) -- 变更内容关键值
    ,modif_bf_val varchar2(3000) -- 变更前值
    ,modif_post_val varchar2(3000) -- 变更后值
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,check_dt date -- 复核日期
    ,acct_aldy_check_flg varchar2(10) -- 账户已复核标志
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,cust_id varchar2(100) -- 客户编号
    ,tran_tm timestamp -- 交易时间
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_ref_no varchar2(60) -- 交易参考号
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
grant select on ${iml_schema}.evt_dep_bus_info_modif_oper_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_dep_bus_info_modif_oper_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_dep_bus_info_modif_oper_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_dep_bus_info_modif_oper_dtl is '存款业务信息变更操作明细';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.modif_flow_num is '变更流水号';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.acct_modif_type_cd is '账户变更类型代码';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.modif_dt is '变更日期';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.modif_batch_no is '变更批次号';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.modif_bus_cate_cd is '变更业务类别代码';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.prod_id is '产品编号';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.sub_acct_num is '子账号';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.modif_item is '修改项';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.modif_content_key_val is '变更内容关键值';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.modif_bf_val is '变更前值';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.modif_post_val is '变更后值';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.check_dt is '复核日期';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.acct_aldy_check_flg is '账户已复核标志';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_dep_bus_info_modif_oper_dtl.etl_timestamp is 'ETL处理时间戳';
