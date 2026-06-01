/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tmss_bis_acc_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tmss_bis_acc_dtl
whenever sqlerror continue none;
drop table ${iol_schema}.tmss_bis_acc_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tmss_bis_acc_dtl(
    id varchar2(144) -- id
    ,bank_acc varchar2(270) -- 本方账号
    ,acc_name varchar2(900) -- 本方账户名
    ,bank_name varchar2(900) -- 本方账户开户行
    ,bif_code varchar2(144) -- 接口代码
    ,opp_acc_no varchar2(270) -- 对方账号
    ,opp_acc_name varchar2(900) -- 对方账户名
    ,opp_acc_bank varchar2(900) -- 对方账户开户行
    ,cd_sign varchar2(5) -- 借贷标志
    ,amt number(19,2) -- 交易金额
    ,bal number(19,2) -- 余额
    ,cur_id varchar2(144) -- 币别ID
    ,uses varchar2(2250) -- 用途
    ,postscript varchar2(2250) -- 附言
    ,remark varchar2(2250) -- 备注
    ,trans_time date -- 交易时间
    ,voucher_no varchar2(135) -- 企业流水号
    ,bank_serial_no varchar2(270) -- 银行流水号
    ,return_time date -- 返回时间
    ,rb_sign varchar2(5) -- 红蓝标志
    ,acc_no varchar2(180) -- 业务单号
    ,import_sign varchar2(1) -- 导出标识
    ,import_date date -- 导出时间
    ,create_date date -- 
    ,create_by varchar2(144) -- 
    ,update_date date -- 
    ,update_by varchar2(144) -- 
    ,fbs_status varchar2(5) -- 资金计划挂接状态 0未确认 1已确认 2已删除
    ,project_remark varchar2(4000) -- 项目信息
    ,settl_type varchar2(5) -- 
    ,blend_sign varchar2(5) -- 
    ,refund_blend_type varchar2(5) -- 
    ,rmk varchar2(2250) -- 
    ,bill_id varchar2(144) -- 
    ,merge_id varchar2(144) -- 
    ,split_id varchar2(144) -- 
    ,status number(22) -- 
    ,bus_type varchar2(144) -- 
    ,claim_id varchar2(144) -- 票据认领中间表id
    ,bis_dtl_no varchar2(450) -- 
    ,bis_ebill_no varchar2(450) -- 
    ,auto_sign varchar2(5) -- 
    ,tenant_id varchar2(144) -- 租户ID
    ,tally_date date -- 记账日期
    ,bank_acc_child varchar2(225) -- 本方账号子账号
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
grant select on ${iol_schema}.tmss_bis_acc_dtl to ${iml_schema};
grant select on ${iol_schema}.tmss_bis_acc_dtl to ${icl_schema};
grant select on ${iol_schema}.tmss_bis_acc_dtl to ${idl_schema};
grant select on ${iol_schema}.tmss_bis_acc_dtl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tmss_bis_acc_dtl is '银行账号流水表';
comment on column ${iol_schema}.tmss_bis_acc_dtl.id is 'id';
comment on column ${iol_schema}.tmss_bis_acc_dtl.bank_acc is '本方账号';
comment on column ${iol_schema}.tmss_bis_acc_dtl.acc_name is '本方账户名';
comment on column ${iol_schema}.tmss_bis_acc_dtl.bank_name is '本方账户开户行';
comment on column ${iol_schema}.tmss_bis_acc_dtl.bif_code is '接口代码';
comment on column ${iol_schema}.tmss_bis_acc_dtl.opp_acc_no is '对方账号';
comment on column ${iol_schema}.tmss_bis_acc_dtl.opp_acc_name is '对方账户名';
comment on column ${iol_schema}.tmss_bis_acc_dtl.opp_acc_bank is '对方账户开户行';
comment on column ${iol_schema}.tmss_bis_acc_dtl.cd_sign is '借贷标志';
comment on column ${iol_schema}.tmss_bis_acc_dtl.amt is '交易金额';
comment on column ${iol_schema}.tmss_bis_acc_dtl.bal is '余额';
comment on column ${iol_schema}.tmss_bis_acc_dtl.cur_id is '币别ID';
comment on column ${iol_schema}.tmss_bis_acc_dtl.uses is '用途';
comment on column ${iol_schema}.tmss_bis_acc_dtl.postscript is '附言';
comment on column ${iol_schema}.tmss_bis_acc_dtl.remark is '备注';
comment on column ${iol_schema}.tmss_bis_acc_dtl.trans_time is '交易时间';
comment on column ${iol_schema}.tmss_bis_acc_dtl.voucher_no is '企业流水号';
comment on column ${iol_schema}.tmss_bis_acc_dtl.bank_serial_no is '银行流水号';
comment on column ${iol_schema}.tmss_bis_acc_dtl.return_time is '返回时间';
comment on column ${iol_schema}.tmss_bis_acc_dtl.rb_sign is '红蓝标志';
comment on column ${iol_schema}.tmss_bis_acc_dtl.acc_no is '业务单号';
comment on column ${iol_schema}.tmss_bis_acc_dtl.import_sign is '导出标识';
comment on column ${iol_schema}.tmss_bis_acc_dtl.import_date is '导出时间';
comment on column ${iol_schema}.tmss_bis_acc_dtl.create_date is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.create_by is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.update_date is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.update_by is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.fbs_status is '资金计划挂接状态 0未确认 1已确认 2已删除';
comment on column ${iol_schema}.tmss_bis_acc_dtl.project_remark is '项目信息';
comment on column ${iol_schema}.tmss_bis_acc_dtl.settl_type is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.blend_sign is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.refund_blend_type is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.rmk is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.bill_id is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.merge_id is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.split_id is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.status is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.bus_type is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.claim_id is '票据认领中间表id';
comment on column ${iol_schema}.tmss_bis_acc_dtl.bis_dtl_no is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.bis_ebill_no is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.auto_sign is '';
comment on column ${iol_schema}.tmss_bis_acc_dtl.tenant_id is '租户ID';
comment on column ${iol_schema}.tmss_bis_acc_dtl.tally_date is '记账日期';
comment on column ${iol_schema}.tmss_bis_acc_dtl.bank_acc_child is '本方账号子账号';
comment on column ${iol_schema}.tmss_bis_acc_dtl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tmss_bis_acc_dtl.etl_timestamp is 'ETL处理时间戳';
