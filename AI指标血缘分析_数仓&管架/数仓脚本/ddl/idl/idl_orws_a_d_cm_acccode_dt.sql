/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_a_d_cm_acccode_dt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_a_d_cm_acccode_dt
whenever sqlerror continue none;
drop table ${idl_schema}.orws_a_d_cm_acccode_dt purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_a_d_cm_acccode_dt(
    etl_dt date -- 数据日期
    ,date_id varchar2(8) -- 会计日期
    ,acc_code varchar2(16) -- 科目编码
    ,acc_name varchar2(120) -- 科目名称
    ,acc_level integer -- 科目层级
    ,parent_id varchar2(16) -- 父级科目编码
    ,in_out_flag varchar2(1) -- 表内表外标志
    ,acc_blncdn varchar2(1) -- 科目方向
    ,detail_flag varchar2(1) -- 明细科目标志
    ,profit_flag varchar2(1) -- 损益项目标志
    ,acc_sour varchar2(2) -- 科目来源分类
    ,acc_tg varchar2(2) -- 科目性质
    ,overdraw_flag varchar2(1) -- 允许透支标志
    ,bal_tg varchar2(2) -- 余额性质
    ,bak_1 varchar2(100) -- 备用字段1
    ,bak_2 varchar2(100) -- 备用字段2
    ,bak_3 varchar2(100) -- 备用字段3
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.orws_a_d_cm_acccode_dt to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_a_d_cm_acccode_dt is '科目表';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.etl_dt is '数据日期';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.date_id is '会计日期';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.acc_code is '科目编码';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.acc_name is '科目名称';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.acc_level is '科目层级';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.parent_id is '父级科目编码';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.in_out_flag is '表内表外标志';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.acc_blncdn is '科目方向';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.detail_flag is '明细科目标志';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.profit_flag is '损益项目标志';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.acc_sour is '科目来源分类';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.acc_tg is '科目性质';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.overdraw_flag is '允许透支标志';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.bal_tg is '余额性质';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.bak_1 is '备用字段1';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.bak_2 is '备用字段2';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.bak_3 is '备用字段3';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.job_cd is '任务代码';
comment on column ${idl_schema}.orws_a_d_cm_acccode_dt.etl_timestamp is '数据处理时间';
