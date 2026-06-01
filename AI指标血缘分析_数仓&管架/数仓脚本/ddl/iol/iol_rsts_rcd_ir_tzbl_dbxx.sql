/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_rcd_ir_tzbl_dbxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_rcd_ir_tzbl_dbxx
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_rcd_ir_tzbl_dbxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_rcd_ir_tzbl_dbxx(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(60) -- 借据号
    ,data_dt varchar2(10) -- 数据日期
    ,cont_no varchar2(60) -- 合同号
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,loan_contr_guar_mode_cd varchar2(10) -- 担保方式代码
    ,guar_total_val number(18,4) -- 担保总价值
    ,guar_rate number(18,4) -- 担保率
    ,var0003 number(18,4) -- 担保总价值占当前贷款余额的百分比
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
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_dbxx to ${iml_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_dbxx to ${icl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_dbxx to ${idl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_dbxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_rcd_ir_tzbl_dbxx is '特征变量表_担保信息';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dbxx.key_id is '主键';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dbxx.loan_no is '借据号';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dbxx.data_dt is '数据日期';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dbxx.cont_no is '合同号';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dbxx.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dbxx.loan_contr_guar_mode_cd is '担保方式代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dbxx.guar_total_val is '担保总价值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dbxx.guar_rate is '担保率';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dbxx.var0003 is '担保总价值占当前贷款余额的百分比';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dbxx.exc_id is '执行清单表ID';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dbxx.generated_time is '生成时间';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dbxx.partition_month is '分区月份';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dbxx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_dbxx.etl_timestamp is 'ETL处理时间戳';
