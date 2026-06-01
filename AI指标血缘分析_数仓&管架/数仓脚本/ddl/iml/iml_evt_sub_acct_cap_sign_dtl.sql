/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_sub_acct_cap_sign_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_sub_acct_cap_sign_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_sub_acct_cap_sign_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_sub_acct_cap_sign_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,plat_dt date -- 平台日期
    ,tran_code varchar2(100) -- 交易码
    ,main_acct_id varchar2(100) -- 主账户编号
    ,main_acct_name varchar2(500) -- 主账户名称
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,open_acct_org_name varchar2(500) -- 开户机构名称
    ,sign_status_cd varchar2(30) -- 签约状态代码
    ,sign_org_id varchar2(100) -- 签约机构编号
    ,oper_teller_id varchar2(100) -- 操作柜员编号
    ,oper_teller_name varchar2(500) -- 操作柜员姓名
    ,remark varchar2(500) -- 备注
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
grant select on ${iml_schema}.evt_sub_acct_cap_sign_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_sub_acct_cap_sign_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_sub_acct_cap_sign_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_sub_acct_cap_sign_dtl is '分账资金签约明细';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.plat_dt is '平台日期';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.tran_code is '交易码';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.main_acct_id is '主账户编号';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.main_acct_name is '主账户名称';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.cust_name is '客户名称';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.open_acct_org_name is '开户机构名称';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.sign_status_cd is '签约状态代码';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.sign_org_id is '签约机构编号';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.oper_teller_id is '操作柜员编号';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.oper_teller_name is '操作柜员姓名';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.remark is '备注';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.start_dt is '开始时间';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.end_dt is '结束时间';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.id_mark is '增删标志';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_sub_acct_cap_sign_dtl.etl_timestamp is 'ETL处理时间戳';
