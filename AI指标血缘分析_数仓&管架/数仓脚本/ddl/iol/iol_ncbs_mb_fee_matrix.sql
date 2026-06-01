/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_fee_matrix
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_fee_matrix
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_fee_matrix purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_fee_matrix(
    int_type varchar2(5) -- 利率类型
    ,boundary number(15) -- 缺口值
    ,company varchar2(20) -- 法人
    ,irl_seq_no varchar2(50) -- 费率编号
    ,matrix_no varchar2(50) -- 阶梯序号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,fee_amt number(17,2) -- 费用金额
    ,fee_rate number(15,8) -- 费率
    ,float_rate number(15,8) -- 浮动利率
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
grant select on ${iol_schema}.ncbs_mb_fee_matrix to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_fee_matrix to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_fee_matrix to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_fee_matrix to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_fee_matrix is '费率矩阵信息';
comment on column ${iol_schema}.ncbs_mb_fee_matrix.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_mb_fee_matrix.boundary is '缺口值';
comment on column ${iol_schema}.ncbs_mb_fee_matrix.company is '法人';
comment on column ${iol_schema}.ncbs_mb_fee_matrix.irl_seq_no is '费率编号';
comment on column ${iol_schema}.ncbs_mb_fee_matrix.matrix_no is '阶梯序号';
comment on column ${iol_schema}.ncbs_mb_fee_matrix.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_fee_matrix.fee_amt is '费用金额';
comment on column ${iol_schema}.ncbs_mb_fee_matrix.fee_rate is '费率';
comment on column ${iol_schema}.ncbs_mb_fee_matrix.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_mb_fee_matrix.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_fee_matrix.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_fee_matrix.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_fee_matrix.etl_timestamp is 'ETL处理时间戳';
