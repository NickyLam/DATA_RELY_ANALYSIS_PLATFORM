/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifds_billing_account
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifds_billing_account
whenever sqlerror continue none;
drop table ${iol_schema}.ifds_billing_account purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifds_billing_account(
    billing_account_id varchar2(30) -- E账户编号
    ,billing_account_name varchar2(383) -- E账户名称
    ,account_type varchar2(30) -- 账户类型
    ,account_currency_uom_id varchar2(30) -- E账户币种
    ,media_type_id varchar2(30) -- 媒介类型
    ,party_id varchar2(30) -- E账户所属客户号
    ,status_id varchar2(30) -- E账户状态
    ,account_limit number(18,2) -- E账户限额
    ,external_account_id varchar2(30) -- E账号
    ,account_level varchar2(30) -- E账户等级
    ,net_check_result varchar2(12) -- 联网核查结果
    ,account_branch_id varchar2(30) -- 开户机构
    ,from_date timestamp -- 开户日期
    ,thru_date timestamp -- 销户日期
    ,contact_mech_id varchar2(30) -- 联系人
    ,channel varchar2(30) -- 渠道
    ,description varchar2(383) -- 描述
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,account_category_level varchar2(30) -- 账户等级
    ,account_trans_type varchar2(30) -- 开户交易类型
    ,card_level varchar2(30) -- 卡级别
    ,cash_or_remit_id varchar2(30) -- 钞汇标识
    ,cash_saving_withdw_id varchar2(30) -- 通存通兑标识
    ,chip_card_type varchar2(30) -- 芯片卡标识
    ,cooperate_card_type varchar2(30) -- 合作卡类型
    ,docs_no varchar2(90) -- 凭证号码
    ,docs_status varchar2(30) -- 凭证状态
    ,docs_type varchar2(30) -- 凭证类型
    ,operate_acct_type varchar2(30) -- 账户组织形式
    ,private_acct_id varchar2(30) -- 私密账户标识
    ,seed_stock varchar2(30) -- 储种
    ,withdrawal_method varchar2(30) -- 支取方式
    ,channel_status varchar2(30) -- 交易渠道状态
    ,account_flag varchar2(30) -- 涉案账户标识
    ,flag_date timestamp -- 设置日期
    ,data_source varchar2(30) -- 数据来源
    ,status_update_org varchar2(30) -- 交易渠道状态变更机构
    ,guilt_date timestamp -- 涉案日期
    ,verify_status varchar2(30) -- 核实状态
    ,certification_status varchar2(30) -- 实名认证标识
    ,business_type varchar2(30) -- 业务类型
    ,supplyer_no varchar2(30) -- 商户号
    ,supplyer_name varchar2(383) -- 商户名称
    ,freeze_status varchar2(30) -- 冻结状态
    ,image_retention_status varchar2(30) -- 影像留存标记
    ,un_account_entry_status varchar2(30) -- 非绑定账户入账标志
    ,image_retention_date timestamp -- 影像留存标记时间
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
grant select on ${iol_schema}.ifds_billing_account to ${iml_schema};
grant select on ${iol_schema}.ifds_billing_account to ${icl_schema};
grant select on ${iol_schema}.ifds_billing_account to ${idl_schema};
grant select on ${iol_schema}.ifds_billing_account to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifds_billing_account is 'E账户表';
comment on column ${iol_schema}.ifds_billing_account.billing_account_id is 'E账户编号';
comment on column ${iol_schema}.ifds_billing_account.billing_account_name is 'E账户名称';
comment on column ${iol_schema}.ifds_billing_account.account_type is '账户类型';
comment on column ${iol_schema}.ifds_billing_account.account_currency_uom_id is 'E账户币种';
comment on column ${iol_schema}.ifds_billing_account.media_type_id is '媒介类型';
comment on column ${iol_schema}.ifds_billing_account.party_id is 'E账户所属客户号';
comment on column ${iol_schema}.ifds_billing_account.status_id is 'E账户状态';
comment on column ${iol_schema}.ifds_billing_account.account_limit is 'E账户限额';
comment on column ${iol_schema}.ifds_billing_account.external_account_id is 'E账号';
comment on column ${iol_schema}.ifds_billing_account.account_level is 'E账户等级';
comment on column ${iol_schema}.ifds_billing_account.net_check_result is '联网核查结果';
comment on column ${iol_schema}.ifds_billing_account.account_branch_id is '开户机构';
comment on column ${iol_schema}.ifds_billing_account.from_date is '开户日期';
comment on column ${iol_schema}.ifds_billing_account.thru_date is '销户日期';
comment on column ${iol_schema}.ifds_billing_account.contact_mech_id is '联系人';
comment on column ${iol_schema}.ifds_billing_account.channel is '渠道';
comment on column ${iol_schema}.ifds_billing_account.description is '描述';
comment on column ${iol_schema}.ifds_billing_account.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.ifds_billing_account.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.ifds_billing_account.created_stamp is '创建时间';
comment on column ${iol_schema}.ifds_billing_account.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.ifds_billing_account.account_category_level is '账户等级';
comment on column ${iol_schema}.ifds_billing_account.account_trans_type is '开户交易类型';
comment on column ${iol_schema}.ifds_billing_account.card_level is '卡级别';
comment on column ${iol_schema}.ifds_billing_account.cash_or_remit_id is '钞汇标识';
comment on column ${iol_schema}.ifds_billing_account.cash_saving_withdw_id is '通存通兑标识';
comment on column ${iol_schema}.ifds_billing_account.chip_card_type is '芯片卡标识';
comment on column ${iol_schema}.ifds_billing_account.cooperate_card_type is '合作卡类型';
comment on column ${iol_schema}.ifds_billing_account.docs_no is '凭证号码';
comment on column ${iol_schema}.ifds_billing_account.docs_status is '凭证状态';
comment on column ${iol_schema}.ifds_billing_account.docs_type is '凭证类型';
comment on column ${iol_schema}.ifds_billing_account.operate_acct_type is '账户组织形式';
comment on column ${iol_schema}.ifds_billing_account.private_acct_id is '私密账户标识';
comment on column ${iol_schema}.ifds_billing_account.seed_stock is '储种';
comment on column ${iol_schema}.ifds_billing_account.withdrawal_method is '支取方式';
comment on column ${iol_schema}.ifds_billing_account.channel_status is '交易渠道状态';
comment on column ${iol_schema}.ifds_billing_account.account_flag is '涉案账户标识';
comment on column ${iol_schema}.ifds_billing_account.flag_date is '设置日期';
comment on column ${iol_schema}.ifds_billing_account.data_source is '数据来源';
comment on column ${iol_schema}.ifds_billing_account.status_update_org is '交易渠道状态变更机构';
comment on column ${iol_schema}.ifds_billing_account.guilt_date is '涉案日期';
comment on column ${iol_schema}.ifds_billing_account.verify_status is '核实状态';
comment on column ${iol_schema}.ifds_billing_account.certification_status is '实名认证标识';
comment on column ${iol_schema}.ifds_billing_account.business_type is '业务类型';
comment on column ${iol_schema}.ifds_billing_account.supplyer_no is '商户号';
comment on column ${iol_schema}.ifds_billing_account.supplyer_name is '商户名称';
comment on column ${iol_schema}.ifds_billing_account.freeze_status is '冻结状态';
comment on column ${iol_schema}.ifds_billing_account.image_retention_status is '影像留存标记';
comment on column ${iol_schema}.ifds_billing_account.un_account_entry_status is '非绑定账户入账标志';
comment on column ${iol_schema}.ifds_billing_account.image_retention_date is '影像留存标记时间';
comment on column ${iol_schema}.ifds_billing_account.start_dt is '开始时间';
comment on column ${iol_schema}.ifds_billing_account.end_dt is '结束时间';
comment on column ${iol_schema}.ifds_billing_account.id_mark is '增删标志';
comment on column ${iol_schema}.ifds_billing_account.etl_timestamp is 'ETL处理时间戳';
