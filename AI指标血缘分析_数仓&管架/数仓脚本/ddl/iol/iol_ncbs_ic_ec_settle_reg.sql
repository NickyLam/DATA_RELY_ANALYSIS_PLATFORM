/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_ic_ec_settle_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_ic_ec_settle_reg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_ic_ec_settle_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_ic_ec_settle_reg(
    setl_seq_no varchar2(200) -- 结清序号
    ,glob_seq_num varchar2(132) -- 全局流水号
    ,sys_seq_num varchar2(256) -- 系统流水号
    ,biz_seq_num varchar2(132) -- 业务流水号
    ,setl_dt date -- 结清日期
    ,branch varchar2(36) -- 机构编号
    ,card_no varchar2(76) -- 卡号
    ,ic_card_seq varchar2(12) -- 卡序列号
    ,tran_amt number(17,2) -- 交易金额
    ,client_name varchar2(800) -- 客户名称
    ,document_type varchar2(16) -- 客户证件类型
    ,document_id varchar2(72) -- 客户证件号码
    ,commission_client_name varchar2(800) -- 代办人姓名
    ,commission_document_type varchar2(16) -- 代办人证件类型
    ,commission_document_id varchar2(72) -- 代办人证件号码
    ,cash_tfr_flg varchar2(4) -- 现转标志: 0-现金;1-转账
    ,oth_base_acct_no varchar2(200) -- 交易对手账号
    ,setl_reason varchar2(4) -- 结清原因: 0-正常结清;1-损坏结清;2-挂失结清
    ,remark varchar2(1020) -- 附加备注
    ,begin_time date -- 批处理起始时间
    ,rel_setl_dt date -- 实际结清日期
    ,reference varchar2(200) -- 交易参考号
    ,setl_status varchar2(4) -- 结清状态: 0-待结清;1-处理中;2-已结清
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
grant select on ${iol_schema}.ncbs_ic_ec_settle_reg to ${iml_schema};
grant select on ${iol_schema}.ncbs_ic_ec_settle_reg to ${icl_schema};
grant select on ${iol_schema}.ncbs_ic_ec_settle_reg to ${idl_schema};
grant select on ${iol_schema}.ncbs_ic_ec_settle_reg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_ic_ec_settle_reg is '电子现金结清登记簿';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.setl_seq_no is '结清序号';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.sys_seq_num is '系统流水号';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.biz_seq_num is '业务流水号';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.setl_dt is '结清日期';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.branch is '机构编号';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.card_no is '卡号';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.ic_card_seq is '卡序列号';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.document_id is '客户证件号码';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.commission_client_name is '代办人姓名';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.commission_document_type is '代办人证件类型';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.commission_document_id is '代办人证件号码';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.cash_tfr_flg is '现转标志: 0-现金;1-转账';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.oth_base_acct_no is '交易对手账号';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.setl_reason is '结清原因: 0-正常结清;1-损坏结清;2-挂失结清';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.remark is '附加备注';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.begin_time is '批处理起始时间';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.rel_setl_dt is '实际结清日期';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.setl_status is '结清状态: 0-待结清;1-处理中;2-已结清';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_ic_ec_settle_reg.etl_timestamp is 'ETL处理时间戳';
