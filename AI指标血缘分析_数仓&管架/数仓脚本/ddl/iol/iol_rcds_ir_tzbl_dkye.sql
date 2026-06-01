/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_tzbl_dkye
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_tzbl_dkye
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_tzbl_dkye purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_dkye(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(60) -- 借据号
    ,data_dt varchar2(10) -- 数据日期
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,var0101 number(18,2) -- 当前贷款余额
    ,var0102 number(22) -- 过去三个月贷款余额连续增加月份数
    ,var0103 number(22) -- 过去六个月贷款余额连续增加月份数
    ,var0104 number(22) -- 过去十二个月贷款余额连续增加月份数
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
grant select on ${iol_schema}.rcds_ir_tzbl_dkye to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_dkye to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_dkye to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_dkye to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_tzbl_dkye is '特征变量表_贷款余额';
comment on column ${iol_schema}.rcds_ir_tzbl_dkye.key_id is '主键';
comment on column ${iol_schema}.rcds_ir_tzbl_dkye.loan_no is '借据号';
comment on column ${iol_schema}.rcds_ir_tzbl_dkye.data_dt is '数据日期';
comment on column ${iol_schema}.rcds_ir_tzbl_dkye.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rcds_ir_tzbl_dkye.var0101 is '当前贷款余额';
comment on column ${iol_schema}.rcds_ir_tzbl_dkye.var0102 is '过去三个月贷款余额连续增加月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_dkye.var0103 is '过去六个月贷款余额连续增加月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_dkye.var0104 is '过去十二个月贷款余额连续增加月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_dkye.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_tzbl_dkye.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_tzbl_dkye.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_tzbl_dkye.etl_timestamp is 'ETL处理时间戳';
