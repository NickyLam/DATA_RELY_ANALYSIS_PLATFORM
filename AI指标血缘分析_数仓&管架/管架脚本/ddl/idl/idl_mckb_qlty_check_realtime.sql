/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mckb_qlty_check_realtime
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mckb_qlty_check_realtime
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_qlty_check_realtime purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mckb_qlty_check_realtime(
    ped_no varchar2(10) -- 周期编号(099累计 001当日 002当月 003当季 004当年 005当周）
    ,ped_name varchar2(20) -- 周期名称
    ,rank number(10) -- 排名
    ,org_no varchar2(50) -- 机构编号
    ,org_name varchar2(200) -- 机构名称
    ,qlty_check_person_no varchar2(50) -- 质检人员编号
    ,qlty_check_person_name varchar2(200) -- 质检人员名称
    ,avg_aging number(38,8) -- 平均时效
    ,avg_rtn_cnt number(38,8) -- 平均退回次数
    ,avg_rtn_rat number(38,8) -- 平均退回率
    ,lp_cls_id varchar2(10) -- 法人分类编号（1企业 2个人 0合计）
    ,lp_cls_name varchar2(20) -- 法人分类名称
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)

storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mckb_qlty_check_realtime to ${iel_schema};

-- comment
comment on table ${idl_schema}.mckb_qlty_check_realtime is '质检看板_准实时';
comment on column ${idl_schema}.mckb_qlty_check_realtime.ped_no is '周期编号(099累计 001当日 002当月 003当季 004当年 005当周）';
comment on column ${idl_schema}.mckb_qlty_check_realtime.ped_name is '周期名称';
comment on column ${idl_schema}.mckb_qlty_check_realtime.rank is '排名';
comment on column ${idl_schema}.mckb_qlty_check_realtime.org_no is '机构编号';
comment on column ${idl_schema}.mckb_qlty_check_realtime.org_name is '机构名称';
comment on column ${idl_schema}.mckb_qlty_check_realtime.qlty_check_person_no is '质检人员编号';
comment on column ${idl_schema}.mckb_qlty_check_realtime.qlty_check_person_name is '质检人员名称';
comment on column ${idl_schema}.mckb_qlty_check_realtime.avg_aging is '平均时效';
comment on column ${idl_schema}.mckb_qlty_check_realtime.avg_rtn_cnt is '平均退回次数';
comment on column ${idl_schema}.mckb_qlty_check_realtime.avg_rtn_rat is '平均退回率';
comment on column ${idl_schema}.mckb_qlty_check_realtime.lp_cls_id is '法人分类编号（1企业 2个人 0合计）';
comment on column ${idl_schema}.mckb_qlty_check_realtime.lp_cls_name is '法人分类名称';
comment on column ${idl_schema}.mckb_qlty_check_realtime.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mckb_qlty_check_realtime.etl_timestamp is 'ETL处理时间戳';