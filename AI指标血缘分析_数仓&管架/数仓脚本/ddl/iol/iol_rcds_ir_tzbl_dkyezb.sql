/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_tzbl_dkyezb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_tzbl_dkyezb
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_tzbl_dkyezb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_dkyezb(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(60) -- 借据号
    ,data_dt varchar2(10) -- 数据日期
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,var0002 number(11,7) -- 当前贷款余额占贷款金额的百分比
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rcds_ir_tzbl_dkyezb to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_dkyezb to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_dkyezb to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_dkyezb to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_tzbl_dkyezb is '特征变量表_贷款余额占比';
comment on column ${iol_schema}.rcds_ir_tzbl_dkyezb.key_id is '主键';
comment on column ${iol_schema}.rcds_ir_tzbl_dkyezb.loan_no is '借据号';
comment on column ${iol_schema}.rcds_ir_tzbl_dkyezb.data_dt is '数据日期';
comment on column ${iol_schema}.rcds_ir_tzbl_dkyezb.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rcds_ir_tzbl_dkyezb.var0002 is '当前贷款余额占贷款金额的百分比';
comment on column ${iol_schema}.rcds_ir_tzbl_dkyezb.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_tzbl_dkyezb.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_tzbl_dkyezb.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_tzbl_dkyezb.etl_timestamp is 'ETL处理时间戳';
