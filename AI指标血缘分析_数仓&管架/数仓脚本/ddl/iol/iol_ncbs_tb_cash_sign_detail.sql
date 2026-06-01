/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_cash_sign_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_cash_sign_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_cash_sign_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_sign_detail(
    base_acct_no varchar2(64) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_name varchar2(200) -- 客户名称
    ,file_path varchar2(200) -- 文件路径
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,cash_sign_type varchar2(1) -- 长短款标记
    ,cash_sign_id varchar2(50) -- 现金长短款汇总编号
    ,cash_sign_no varchar2(50) -- 长短款明细编号
    ,cash_sign_status varchar2(1) -- 现金状态
    ,company varchar2(20) -- 法人
    ,reason_id varchar2(200) -- 长短款原因
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,cash_sign_branch varchar2(12) -- 长短款登记机构
    ,cash_sign_user varchar2(8) -- 长短款登记柜员
    ,cash_sign_dealed_amt number(17,2) -- 长短款已处理金额
    ,leaderr_cash_branch varchar2(12) -- 导致长短钞差错机构
    ,leaderr_user_id varchar2(8) -- 导致长短钞差错柜员
    ,leaderr_reference varchar2(50) -- 登记导致错误的交易参考号
    ,cash_sign_detail_amt number(17,2) -- 现金长短款挂账明细金额
    ,leaderr_tran_date varchar2(10) -- 导致长短款的历史错误交易的交易日期
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
grant select on ${iol_schema}.ncbs_tb_cash_sign_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_cash_sign_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_sign_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_sign_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_cash_sign_detail is '现金长短款挂账登记明细表';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.file_path is '文件路径';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.cash_sign_type is '长短款标记';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.cash_sign_id is '现金长短款汇总编号';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.cash_sign_no is '长短款明细编号';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.cash_sign_status is '现金状态';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.company is '法人';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.reason_id is '长短款原因';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.cash_sign_branch is '长短款登记机构';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.cash_sign_user is '长短款登记柜员';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.cash_sign_dealed_amt is '长短款已处理金额';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.leaderr_cash_branch is '导致长短钞差错机构';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.leaderr_user_id is '导致长短钞差错柜员';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.leaderr_reference is '登记导致错误的交易参考号';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.cash_sign_detail_amt is '现金长短款挂账明细金额';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.leaderr_tran_date is '导致长短款的历史错误交易的交易日期';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_cash_sign_detail.etl_timestamp is 'ETL处理时间戳';
