/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_nct_todolist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_nct_todolist
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_nct_todolist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_nct_todolist(
    task_id varchar2(100) -- 任务id
    ,enclosure varchar2(1024) -- 附件（影像id）
    ,teller_name varchar2(200) -- 发起人柜员名称
    ,teller_post varchar2(50) -- 发起人柜员岗位
    ,branch_no varchar2(12) -- 机构编号
    ,manager_id varchar2(10) -- 审批人编号
    ,manager_name varchar2(150) -- 审批人名称
    ,manager_post varchar2(50) -- 审批人岗位
    ,reason varchar2(1000) -- 申请原因
    ,apply_date date -- 申请日期 yyyymmdd
    ,create_date date -- 创建日期 yyyymmdd
    ,create_time date -- 创建时间 hhmmss
    ,update_date date -- 更新日期 yyyymmdd
    ,update_time date -- 更新时间 hhmmss
    ,remark varchar2(100) -- 标题
    ,status varchar2(1) -- 1：审批中，2：审批通过，3：已拒绝，4-已取消
    ,busitype varchar2(1) -- 业务类型 1-机构重新签到 2-柜员免签退 3-查证信息补录
    ,teller_no varchar2(8) -- 发起人柜员编号
    ,currhandletype varchar2(2) -- 当前处理状态-P正在处理
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nibs_nct_todolist to ${iml_schema};
grant select on ${iol_schema}.nibs_nct_todolist to ${icl_schema};
grant select on ${iol_schema}.nibs_nct_todolist to ${idl_schema};
grant select on ${iol_schema}.nibs_nct_todolist to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_nct_todolist is '待办任务表';
comment on column ${iol_schema}.nibs_nct_todolist.task_id is '任务id';
comment on column ${iol_schema}.nibs_nct_todolist.enclosure is '附件（影像id）';
comment on column ${iol_schema}.nibs_nct_todolist.teller_name is '发起人柜员名称';
comment on column ${iol_schema}.nibs_nct_todolist.teller_post is '发起人柜员岗位';
comment on column ${iol_schema}.nibs_nct_todolist.branch_no is '机构编号';
comment on column ${iol_schema}.nibs_nct_todolist.manager_id is '审批人编号';
comment on column ${iol_schema}.nibs_nct_todolist.manager_name is '审批人名称';
comment on column ${iol_schema}.nibs_nct_todolist.manager_post is '审批人岗位';
comment on column ${iol_schema}.nibs_nct_todolist.reason is '申请原因';
comment on column ${iol_schema}.nibs_nct_todolist.apply_date is '申请日期 yyyymmdd';
comment on column ${iol_schema}.nibs_nct_todolist.create_date is '创建日期 yyyymmdd';
comment on column ${iol_schema}.nibs_nct_todolist.create_time is '创建时间 hhmmss';
comment on column ${iol_schema}.nibs_nct_todolist.update_date is '更新日期 yyyymmdd';
comment on column ${iol_schema}.nibs_nct_todolist.update_time is '更新时间 hhmmss';
comment on column ${iol_schema}.nibs_nct_todolist.remark is '标题';
comment on column ${iol_schema}.nibs_nct_todolist.status is '1：审批中，2：审批通过，3：已拒绝，4-已取消';
comment on column ${iol_schema}.nibs_nct_todolist.busitype is '业务类型 1-机构重新签到 2-柜员免签退 3-查证信息补录';
comment on column ${iol_schema}.nibs_nct_todolist.teller_no is '发起人柜员编号';
comment on column ${iol_schema}.nibs_nct_todolist.currhandletype is '当前处理状态-P正在处理';
comment on column ${iol_schema}.nibs_nct_todolist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_nct_todolist.etl_timestamp is 'ETL处理时间戳';
