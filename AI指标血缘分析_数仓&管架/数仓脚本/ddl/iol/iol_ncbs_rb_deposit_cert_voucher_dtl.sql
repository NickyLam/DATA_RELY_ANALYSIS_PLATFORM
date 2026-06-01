/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_deposit_cert_voucher_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl(
    client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,company varchar2(20) -- 法人
    ,deposit_cert_no varchar2(50) -- 存款证明编号
    ,deposit_cert_operate_type varchar2(2) -- 存款证明操作类型
    ,prefix varchar2(10) -- 前缀
    ,seq_no varchar2(50) -- 序号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,del_auth_user_id varchar2(8) -- 删除授权柜员
    ,del_user_id varchar2(8) -- 删除柜员
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
grant select on ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl is '存款证明凭证明细信息';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.company is '法人';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.deposit_cert_no is '存款证明编号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.deposit_cert_operate_type is '存款证明操作类型';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.del_auth_user_id is '删除授权柜员';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.del_user_id is '删除柜员';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_voucher_dtl.etl_timestamp is 'ETL处理时间戳';
