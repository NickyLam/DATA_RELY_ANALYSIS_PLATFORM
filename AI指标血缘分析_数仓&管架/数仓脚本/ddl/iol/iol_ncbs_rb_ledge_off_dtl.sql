/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_ledge_off_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_ledge_off_dtl
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_ledge_off_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_ledge_off_dtl(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,contract_no varchar2(30) -- 合同编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,batch_file_status varchar2(1) -- 批处理文件处理状态
    ,batch_no varchar2(50) -- 批次号
    ,cmisloan_no varchar2(60) -- 客户借据编号
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,error_msg varchar2(3000) -- 错误代码
    ,res_seq_no varchar2(50) -- 限制编号
    ,seq_no varchar2(50) -- 序号
    ,create_date date -- 创建日期
    ,last_change_date date -- 最后修改日期
    ,run_date date -- 运行日期
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
grant select on ${iol_schema}.ncbs_rb_ledge_off_dtl to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_ledge_off_dtl to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_ledge_off_dtl to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_ledge_off_dtl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_ledge_off_dtl is '存单质押限制解除登记表';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.contract_no is '合同编号';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.batch_file_status is '批处理文件处理状态';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.cmisloan_no is '客户借据编号';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.company is '法人';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.error_msg is '错误代码';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.create_date is '创建日期';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.run_date is '运行日期';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_ledge_off_dtl.etl_timestamp is 'ETL处理时间戳';
