/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_rcd_ir_tzbl_dkye
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_rcd_ir_tzbl_dkye
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_rcd_ir_tzbl_dkye purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_rcd_ir_tzbl_dkye(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(60) -- 借据号
    ,data_dt varchar2(10) -- 数据日期
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,var0101 number(18,4) -- 当前贷款余额
    ,var0102 number(10) -- 过去三个月贷款余额连续增加月份数
    ,var0103 number(10) -- 过去六个月贷款余额连续增加月份数
    ,var0104 number(10) -- 过去十二个月贷款余额连续增加月份数
    ,exc_id varchar2(60) -- 执行清单表ID
    ,generated_time date -- 生成时间
    ,partition_month varchar2(60) -- 分区月份
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
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_dkye to ${iml_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_dkye to ${icl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_dkye to ${idl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_dkye to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_rcd_ir_tzbl_dkye is '特征变量表_贷款余额';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dkye.key_id is '主键';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dkye.loan_no is '借据号';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dkye.data_dt is '数据日期';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dkye.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dkye.var0101 is '当前贷款余额';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dkye.var0102 is '过去三个月贷款余额连续增加月份数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dkye.var0103 is '过去六个月贷款余额连续增加月份数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dkye.var0104 is '过去十二个月贷款余额连续增加月份数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dkye.exc_id is '执行清单表ID';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dkye.generated_time is '生成时间';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dkye.partition_month is '分区月份';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dkye.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dkye.etl_timestamp is 'ETL处理时间戳';
