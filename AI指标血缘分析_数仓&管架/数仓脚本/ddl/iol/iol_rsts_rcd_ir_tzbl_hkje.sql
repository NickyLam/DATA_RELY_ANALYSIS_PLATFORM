/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_rcd_ir_tzbl_hkje
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_rcd_ir_tzbl_hkje
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_rcd_ir_tzbl_hkje purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_rcd_ir_tzbl_hkje(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(60) -- 借据号
    ,data_dt varchar2(10) -- 数据日期
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,var0201 number(18,4) -- 当前月还款金额
    ,var0202 number(18,4) -- 过去3个月还款金额的平均值
    ,var0203 number(18,4) -- 过去6个月还款金额的平均值
    ,var0204 number(18,4) -- 过去12个月还款金额的平均值
    ,var0205 number(18,4) -- 过去3个月还款金额的总和
    ,var0206 number(18,4) -- 过去6个月还款金额的总和
    ,var0207 number(18,4) -- 过去12个月还款金额的总和
    ,var0208 number(18,4) -- 过去3个月还款金额最小值
    ,var0209 number(18,4) -- 过去6个月还款金额最小值
    ,var0210 number(18,4) -- 过去12个月还款金额最小值
    ,var0211 number(18,4) -- 过去3个月还款金额最大值
    ,var0212 number(18,4) -- 过去6个月还款金额最大值
    ,var0213 number(18,4) -- 过去12个月还款金额最大值
    ,var0214 number -- 过去3个月还款金额>0的次数
    ,var0215 number -- 过去6个月还款金额>0的次数
    ,var0216 number -- 过去12个月还款金额>0的次数
    ,var0217 number -- 过去3个月还款金额最后一次>0的距今月数
    ,var0218 number -- 过去6个月还款金额最后一次>0的距今月数
    ,var0219 number -- 过去12个月还款金额最后一次>0的距今月数
    ,exc_id varchar2(60) -- 执行清单表ID
    ,generated_time date -- 生成时间
    ,partition_month varchar2(60) -- 分区月份
    ,repay_mode varchar2(10) -- 还款方式
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
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_hkje to ${iml_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_hkje to ${icl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_hkje to ${idl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_hkje to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_rcd_ir_tzbl_hkje is '特征变量表_还款金额';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.key_id is '主键';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.loan_no is '借据号';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.data_dt is '数据日期';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0201 is '当前月还款金额';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0202 is '过去3个月还款金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0203 is '过去6个月还款金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0204 is '过去12个月还款金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0205 is '过去3个月还款金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0206 is '过去6个月还款金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0207 is '过去12个月还款金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0208 is '过去3个月还款金额最小值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0209 is '过去6个月还款金额最小值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0210 is '过去12个月还款金额最小值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0211 is '过去3个月还款金额最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0212 is '过去6个月还款金额最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0213 is '过去12个月还款金额最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0214 is '过去3个月还款金额>0的次数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0215 is '过去6个月还款金额>0的次数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0216 is '过去12个月还款金额>0的次数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0217 is '过去3个月还款金额最后一次>0的距今月数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0218 is '过去6个月还款金额最后一次>0的距今月数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.var0219 is '过去12个月还款金额最后一次>0的距今月数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.exc_id is '执行清单表ID';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.generated_time is '生成时间';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.partition_month is '分区月份';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.repay_mode is '还款方式';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_hkje.etl_timestamp is 'ETL处理时间戳';
