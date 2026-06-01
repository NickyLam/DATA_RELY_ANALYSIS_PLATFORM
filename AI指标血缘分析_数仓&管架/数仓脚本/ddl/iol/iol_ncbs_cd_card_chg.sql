/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cd_card_chg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cd_card_chg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cd_card_chg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_card_chg(
    address varchar2(400) -- 地址
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,card_change_reason varchar2(1) -- 卡片更换原因
    ,change_status varchar2(1) -- 变更类型状态
    ,company varchar2(20) -- 法人
    ,contact_tel varchar2(20) -- 客户联系电话
    ,gain_type varchar2(1) -- 卡片领取方式
    ,lost_no varchar2(50) -- 挂失编号
    ,postal_code varchar2(10) -- 邮政编码
    ,same_no_flag varchar2(1) -- 同号换卡标识
    ,urgent_flag varchar2(3) -- 加急标识
    ,apply_date date -- 申请日期
    ,promissory_date date -- 约定的领卡日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,apply_user_id varchar2(8) -- 申请柜员
    ,new_card_no varchar2(50) -- 新卡号
    ,old_card_no varchar2(50) -- 原卡号
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,deal_status varchar2(1) -- 处理状态
    ,msg_notice_type varchar2(2) -- 通知类型
    ,fee_reference varchar2(50) -- 
    ,package_no varchar2(50) -- 
    ,apply_no varchar2(50) -- 
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
grant select on ${iol_schema}.ncbs_cd_card_chg to ${iml_schema};
grant select on ${iol_schema}.ncbs_cd_card_chg to ${icl_schema};
grant select on ${iol_schema}.ncbs_cd_card_chg to ${idl_schema};
grant select on ${iol_schema}.ncbs_cd_card_chg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cd_card_chg is '卡片更换登记簿';
comment on column ${iol_schema}.ncbs_cd_card_chg.address is '地址';
comment on column ${iol_schema}.ncbs_cd_card_chg.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_cd_card_chg.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cd_card_chg.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cd_card_chg.remark is '备注';
comment on column ${iol_schema}.ncbs_cd_card_chg.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cd_card_chg.card_change_reason is '卡片更换原因';
comment on column ${iol_schema}.ncbs_cd_card_chg.change_status is '变更类型状态';
comment on column ${iol_schema}.ncbs_cd_card_chg.company is '法人';
comment on column ${iol_schema}.ncbs_cd_card_chg.contact_tel is '客户联系电话';
comment on column ${iol_schema}.ncbs_cd_card_chg.gain_type is '卡片领取方式';
comment on column ${iol_schema}.ncbs_cd_card_chg.lost_no is '挂失编号';
comment on column ${iol_schema}.ncbs_cd_card_chg.postal_code is '邮政编码';
comment on column ${iol_schema}.ncbs_cd_card_chg.same_no_flag is '同号换卡标识';
comment on column ${iol_schema}.ncbs_cd_card_chg.urgent_flag is '加急标识';
comment on column ${iol_schema}.ncbs_cd_card_chg.apply_date is '申请日期';
comment on column ${iol_schema}.ncbs_cd_card_chg.promissory_date is '约定的领卡日期';
comment on column ${iol_schema}.ncbs_cd_card_chg.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cd_card_chg.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cd_card_chg.apply_user_id is '申请柜员';
comment on column ${iol_schema}.ncbs_cd_card_chg.new_card_no is '新卡号';
comment on column ${iol_schema}.ncbs_cd_card_chg.old_card_no is '原卡号';
comment on column ${iol_schema}.ncbs_cd_card_chg.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cd_card_chg.deal_status is '处理状态';
comment on column ${iol_schema}.ncbs_cd_card_chg.msg_notice_type is '通知类型';
comment on column ${iol_schema}.ncbs_cd_card_chg.fee_reference is '';
comment on column ${iol_schema}.ncbs_cd_card_chg.package_no is '';
comment on column ${iol_schema}.ncbs_cd_card_chg.apply_no is '';
comment on column ${iol_schema}.ncbs_cd_card_chg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cd_card_chg.etl_timestamp is 'ETL处理时间戳';
