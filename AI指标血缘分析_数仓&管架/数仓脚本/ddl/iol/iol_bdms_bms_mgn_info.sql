/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_mgn_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_mgn_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_mgn_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_mgn_info(
    id varchar2(60) -- 
    ,manager_no varchar2(30) -- 客户经理编号
    ,manager_name varchar2(300) -- 客户经理名称
    ,department_no varchar2(30) -- 所属部门编号
    ,branch_no varchar2(30) -- 所属机构编号
    ,top_branch_no varchar2(30) -- 所属总行机构
    ,status varchar2(2) -- 状态
    ,dualcontrol_lockstatus varchar2(2) -- 双岗复核锁标记
    ,last_operator_no varchar2(45) -- 最后操作员编号
    ,last_txn_date timestamp -- 最后操作日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdms_bms_mgn_info to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_mgn_info to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_mgn_info to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_mgn_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_mgn_info is '客户经理信息表';
comment on column ${iol_schema}.bdms_bms_mgn_info.id is '';
comment on column ${iol_schema}.bdms_bms_mgn_info.manager_no is '客户经理编号';
comment on column ${iol_schema}.bdms_bms_mgn_info.manager_name is '客户经理名称';
comment on column ${iol_schema}.bdms_bms_mgn_info.department_no is '所属部门编号';
comment on column ${iol_schema}.bdms_bms_mgn_info.branch_no is '所属机构编号';
comment on column ${iol_schema}.bdms_bms_mgn_info.top_branch_no is '所属总行机构';
comment on column ${iol_schema}.bdms_bms_mgn_info.status is '状态';
comment on column ${iol_schema}.bdms_bms_mgn_info.dualcontrol_lockstatus is '双岗复核锁标记';
comment on column ${iol_schema}.bdms_bms_mgn_info.last_operator_no is '最后操作员编号';
comment on column ${iol_schema}.bdms_bms_mgn_info.last_txn_date is '最后操作日期';
comment on column ${iol_schema}.bdms_bms_mgn_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_mgn_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_mgn_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_mgn_info.etl_timestamp is 'ETL处理时间戳';
