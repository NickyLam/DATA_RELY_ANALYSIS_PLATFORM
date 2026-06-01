/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_branch_holiday
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_branch_holiday
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_branch_holiday purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_branch_holiday(
    branch varchar2(12) -- 机构编号
    ,apply_ind varchar2(1) -- 适用范围
    ,company varchar2(20) -- 法人
    ,holiday_desc varchar2(50) -- 假日描述
    ,holiday_type varchar2(1) -- 假日类型
    ,working_holiday varchar2(1) -- 工作日/假日
    ,holiday_date date -- 假日日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_fm_branch_holiday to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_branch_holiday to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_branch_holiday to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_branch_holiday to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_branch_holiday is '机构假日表';
comment on column ${iol_schema}.ncbs_fm_branch_holiday.branch is '机构编号';
comment on column ${iol_schema}.ncbs_fm_branch_holiday.apply_ind is '适用范围';
comment on column ${iol_schema}.ncbs_fm_branch_holiday.company is '法人';
comment on column ${iol_schema}.ncbs_fm_branch_holiday.holiday_desc is '假日描述';
comment on column ${iol_schema}.ncbs_fm_branch_holiday.holiday_type is '假日类型';
comment on column ${iol_schema}.ncbs_fm_branch_holiday.working_holiday is '工作日/假日';
comment on column ${iol_schema}.ncbs_fm_branch_holiday.holiday_date is '假日日期';
comment on column ${iol_schema}.ncbs_fm_branch_holiday.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_branch_holiday.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_branch_holiday.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_branch_holiday.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_branch_holiday.etl_timestamp is 'ETL处理时间戳';
