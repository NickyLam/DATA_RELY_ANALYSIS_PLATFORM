/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mckb_all_flow_realtime
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mckb_all_flow_realtime
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_all_flow_realtime purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mckb_all_flow_realtime(
    ped_no varchar2(10) -- 周期编号
    ,ped_name varchar2(20) -- 周期名称
    ,grouping varchar2(10) -- 分组
    ,org_no varchar2(50) -- 机构编号
    ,org_name varchar2(200) -- 机构名称
    ,acvmnt_data_acct_cnt number(38,8) -- 业绩数据户数
    ,acvmnt_data_amt number(38,8) -- 业绩数据金额
    ,acvmnt_data_net_incremt number(38,8) -- 业绩数据净增
    ,acvmnt_data_target number(38,8) -- 业绩数据目标
    ,acvmnt_data_arrive_rat number(38,8) -- 业绩数据达成率
    ,lp_cls_id varchar2(10) -- 法人分类编号
    ,lp_cls_name varchar2(20) -- 法人分类名称
    ,enter_cnt number(38,8) -- 进件数
    ,enter_pass_cnt number(38,8) -- 进件通过数
    ,enter_refuse_cnt number(38,8) -- 进件拒绝数
    ,sys_apv_acct_cnt number(38,8) -- 系统审批户数
    ,sys_apv_amt number(38,8) -- 系统审批金额
    ,lp_cls_prod varchar2(10) -- 产品分类
    ,prep_tel_cnt number(38,8) -- 调查_待电调
    ,prep_actl_cnt number(38,8) -- 调查_待实调
    ,invstg_pass_cnt number(38,8) -- 调查_通过
    ,invstg_refuse_cnt number(38,8) -- 调查_拒绝
    ,qlty_check_cnt number(38,8) -- 质检通过
    ,qlty_check_flow_cnt number(38,8) -- 质检流程中
    ,sign_cust_cnt number(38,8) -- 签约客户数
    ,sign_amt number(38,8) -- 签约金额
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mckb_all_flow_realtime to ${iel_schema};

-- comment
comment on table ${idl_schema}.mckb_all_flow_realtime is '全流程看板_准实时';
comment on column ${idl_schema}.mckb_all_flow_realtime.ped_no is '周期编号';
comment on column ${idl_schema}.mckb_all_flow_realtime.ped_name is '周期名称';
comment on column ${idl_schema}.mckb_all_flow_realtime.grouping is '分组';
comment on column ${idl_schema}.mckb_all_flow_realtime.org_no is '机构编号';
comment on column ${idl_schema}.mckb_all_flow_realtime.org_name is '机构名称';
comment on column ${idl_schema}.mckb_all_flow_realtime.acvmnt_data_acct_cnt is '业绩数据户数';
comment on column ${idl_schema}.mckb_all_flow_realtime.acvmnt_data_amt is '业绩数据金额';
comment on column ${idl_schema}.mckb_all_flow_realtime.acvmnt_data_net_incremt is '业绩数据净增';
comment on column ${idl_schema}.mckb_all_flow_realtime.acvmnt_data_target is '业绩数据目标';
comment on column ${idl_schema}.mckb_all_flow_realtime.acvmnt_data_arrive_rat is '业绩数据达成率';
comment on column ${idl_schema}.mckb_all_flow_realtime.lp_cls_id is '法人分类编号';
comment on column ${idl_schema}.mckb_all_flow_realtime.lp_cls_name is '法人分类名称';
comment on column ${idl_schema}.mckb_all_flow_realtime.enter_cnt is '进件数';
comment on column ${idl_schema}.mckb_all_flow_realtime.enter_pass_cnt is '进件通过数';
comment on column ${idl_schema}.mckb_all_flow_realtime.enter_refuse_cnt is '进件拒绝数';
comment on column ${idl_schema}.mckb_all_flow_realtime.sys_apv_acct_cnt is '系统审批户数';
comment on column ${idl_schema}.mckb_all_flow_realtime.sys_apv_amt is '系统审批金额';
comment on column ${idl_schema}.mckb_all_flow_realtime.lp_cls_prod is '产品分类';
comment on column ${idl_schema}.mckb_all_flow_realtime.prep_tel_cnt is '调查_待电调';
comment on column ${idl_schema}.mckb_all_flow_realtime.prep_actl_cnt is '调查_待实调';
comment on column ${idl_schema}.mckb_all_flow_realtime.invstg_pass_cnt is '调查_通过';
comment on column ${idl_schema}.mckb_all_flow_realtime.invstg_refuse_cnt is '调查_拒绝';
comment on column ${idl_schema}.mckb_all_flow_realtime.qlty_check_cnt is '质检通过';
comment on column ${idl_schema}.mckb_all_flow_realtime.qlty_check_flow_cnt is '质检流程中';
comment on column ${idl_schema}.mckb_all_flow_realtime.sign_cust_cnt is '签约客户数';
comment on column ${idl_schema}.mckb_all_flow_realtime.sign_amt is '签约金额';
comment on column ${idl_schema}.mckb_all_flow_realtime.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mckb_all_flow_realtime.etl_timestamp is 'ETL处理时间戳';