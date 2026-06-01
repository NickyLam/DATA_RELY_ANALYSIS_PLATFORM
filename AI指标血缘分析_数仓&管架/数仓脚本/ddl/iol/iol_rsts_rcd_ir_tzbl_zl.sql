/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_rcd_ir_tzbl_zl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_rcd_ir_tzbl_zl
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_rcd_ir_tzbl_zl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_rcd_ir_tzbl_zl(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(60) -- 借据号
    ,data_dt varchar2(12) -- 数据日期
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,var0000 number(22,4) -- 当前账龄占贷款期限的百分比
    ,var0001 varchar2(8) -- 当前账龄
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
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_zl to ${iml_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_zl to ${icl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_zl to ${idl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_zl to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_rcd_ir_tzbl_zl is '特征变量表_账龄';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_zl.key_id is '主键';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_zl.loan_no is '借据号';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_zl.data_dt is '数据日期';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_zl.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_zl.var0000 is '当前账龄占贷款期限的百分比';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_zl.var0001 is '当前账龄';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_zl.exc_id is '执行清单表ID';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_zl.generated_time is '生成时间';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_zl.partition_month is '分区月份';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_zl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_zl.etl_timestamp is 'ETL处理时间戳';
