/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_bth_wft_pay_settle
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_bth_wft_pay_settle
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_bth_wft_pay_settle purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_bth_wft_pay_settle(
    clean_date varchar2(21) -- 清分日期
    ,clean_id varchar2(30) -- 清分id明细序号
    ,mcht_channel varchar2(30) -- 商户号/渠道号
    ,branch_no varchar2(18) -- 联行号/网点号
    ,receipt_name varchar2(219) -- 收款人姓名
    ,receipt_account varchar2(60) -- 收款人账号
    ,receipt_acctype varchar2(2) -- 收款人账号类型0-对公，1-对私，2-内部户
    ,clean_amt varchar2(30) -- 清分金额
    ,resevel varchar2(30) -- 摘要
    ,remark varchar2(90) -- 备注
    ,md5 varchar2(48) -- 待处理md5
    ,ok_file_name varchar2(90) -- ok文件名称
    ,clear_file_name varchar2(48) -- 清算文件名
    ,remark1 varchar2(90) -- 备注1
    ,remark2 varchar2(90) -- 备注2
    ,remark3 varchar2(90) -- 备注3
    ,remark4 varchar2(150) -- 备注4
    ,remark5 varchar2(300) -- 备注5
    ,ret_serial_no varchar2(30) -- 流水号和返回流水
    ,ret_code varchar2(12) -- 返回码000 为成功；其他为失败
    ,ret_msg varchar2(383) -- 返回信息
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
grant select on ${iol_schema}.mrms_bth_wft_pay_settle to ${iml_schema};
grant select on ${iol_schema}.mrms_bth_wft_pay_settle to ${icl_schema};
grant select on ${iol_schema}.mrms_bth_wft_pay_settle to ${idl_schema};
grant select on ${iol_schema}.mrms_bth_wft_pay_settle to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_bth_wft_pay_settle is '威富通日终清算表';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.clean_date is '清分日期';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.clean_id is '清分id明细序号';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.mcht_channel is '商户号/渠道号';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.branch_no is '联行号/网点号';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.receipt_name is '收款人姓名';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.receipt_account is '收款人账号';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.receipt_acctype is '收款人账号类型0-对公，1-对私，2-内部户';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.clean_amt is '清分金额';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.resevel is '摘要';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.remark is '备注';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.md5 is '待处理md5';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.ok_file_name is 'ok文件名称';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.clear_file_name is '清算文件名';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.remark1 is '备注1';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.remark2 is '备注2';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.remark3 is '备注3';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.remark4 is '备注4';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.remark5 is '备注5';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.ret_serial_no is '流水号和返回流水';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.ret_code is '返回码000 为成功；其他为失败';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.ret_msg is '返回信息';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mrms_bth_wft_pay_settle.etl_timestamp is 'ETL处理时间戳';
