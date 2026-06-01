/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifds_billing_account
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ifds_billing_account_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifds_billing_account
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifds_billing_account_op purge;
drop table ${iol_schema}.ifds_billing_account_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifds_billing_account_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifds_billing_account where 0=1;

create table ${iol_schema}.ifds_billing_account_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifds_billing_account where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifds_billing_account_cl(
            billing_account_id -- E账户编号
            ,billing_account_name -- E账户名称
            ,account_type -- 账户类型
            ,account_currency_uom_id -- E账户币种
            ,media_type_id -- 媒介类型
            ,party_id -- E账户所属客户号
            ,status_id -- E账户状态
            ,account_limit -- E账户限额
            ,external_account_id -- E账号
            ,account_level -- E账户等级
            ,net_check_result -- 联网核查结果
            ,account_branch_id -- 开户机构
            ,from_date -- 开户日期
            ,thru_date -- 销户日期
            ,contact_mech_id -- 联系人
            ,channel -- 渠道
            ,description -- 描述
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,account_category_level -- 账户等级
            ,account_trans_type -- 开户交易类型
            ,card_level -- 卡级别
            ,cash_or_remit_id -- 钞汇标识
            ,cash_saving_withdw_id -- 通存通兑标识
            ,chip_card_type -- 芯片卡标识
            ,cooperate_card_type -- 合作卡类型
            ,docs_no -- 凭证号码
            ,docs_status -- 凭证状态
            ,docs_type -- 凭证类型
            ,operate_acct_type -- 账户组织形式
            ,private_acct_id -- 私密账户标识
            ,seed_stock -- 储种
            ,withdrawal_method -- 支取方式
            ,channel_status -- 交易渠道状态
            ,account_flag -- 涉案账户标识
            ,flag_date -- 设置日期
            ,data_source -- 数据来源
            ,status_update_org -- 交易渠道状态变更机构
            ,guilt_date -- 涉案日期
            ,verify_status -- 核实状态
            ,certification_status -- 实名认证标识
            ,business_type -- 业务类型
            ,supplyer_no -- 商户号
            ,supplyer_name -- 商户名称
            ,freeze_status -- 冻结状态
            ,image_retention_status -- 影像留存标记
            ,un_account_entry_status -- 非绑定账户入账标志
            ,image_retention_date -- 影像留存标记时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifds_billing_account_op(
            billing_account_id -- E账户编号
            ,billing_account_name -- E账户名称
            ,account_type -- 账户类型
            ,account_currency_uom_id -- E账户币种
            ,media_type_id -- 媒介类型
            ,party_id -- E账户所属客户号
            ,status_id -- E账户状态
            ,account_limit -- E账户限额
            ,external_account_id -- E账号
            ,account_level -- E账户等级
            ,net_check_result -- 联网核查结果
            ,account_branch_id -- 开户机构
            ,from_date -- 开户日期
            ,thru_date -- 销户日期
            ,contact_mech_id -- 联系人
            ,channel -- 渠道
            ,description -- 描述
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,account_category_level -- 账户等级
            ,account_trans_type -- 开户交易类型
            ,card_level -- 卡级别
            ,cash_or_remit_id -- 钞汇标识
            ,cash_saving_withdw_id -- 通存通兑标识
            ,chip_card_type -- 芯片卡标识
            ,cooperate_card_type -- 合作卡类型
            ,docs_no -- 凭证号码
            ,docs_status -- 凭证状态
            ,docs_type -- 凭证类型
            ,operate_acct_type -- 账户组织形式
            ,private_acct_id -- 私密账户标识
            ,seed_stock -- 储种
            ,withdrawal_method -- 支取方式
            ,channel_status -- 交易渠道状态
            ,account_flag -- 涉案账户标识
            ,flag_date -- 设置日期
            ,data_source -- 数据来源
            ,status_update_org -- 交易渠道状态变更机构
            ,guilt_date -- 涉案日期
            ,verify_status -- 核实状态
            ,certification_status -- 实名认证标识
            ,business_type -- 业务类型
            ,supplyer_no -- 商户号
            ,supplyer_name -- 商户名称
            ,freeze_status -- 冻结状态
            ,image_retention_status -- 影像留存标记
            ,un_account_entry_status -- 非绑定账户入账标志
            ,image_retention_date -- 影像留存标记时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.billing_account_id, o.billing_account_id) as billing_account_id -- E账户编号
    ,nvl(n.billing_account_name, o.billing_account_name) as billing_account_name -- E账户名称
    ,nvl(n.account_type, o.account_type) as account_type -- 账户类型
    ,nvl(n.account_currency_uom_id, o.account_currency_uom_id) as account_currency_uom_id -- E账户币种
    ,nvl(n.media_type_id, o.media_type_id) as media_type_id -- 媒介类型
    ,nvl(n.party_id, o.party_id) as party_id -- E账户所属客户号
    ,nvl(n.status_id, o.status_id) as status_id -- E账户状态
    ,nvl(n.account_limit, o.account_limit) as account_limit -- E账户限额
    ,nvl(n.external_account_id, o.external_account_id) as external_account_id -- E账号
    ,nvl(n.account_level, o.account_level) as account_level -- E账户等级
    ,nvl(n.net_check_result, o.net_check_result) as net_check_result -- 联网核查结果
    ,nvl(n.account_branch_id, o.account_branch_id) as account_branch_id -- 开户机构
    ,nvl(n.from_date, o.from_date) as from_date -- 开户日期
    ,nvl(n.thru_date, o.thru_date) as thru_date -- 销户日期
    ,nvl(n.contact_mech_id, o.contact_mech_id) as contact_mech_id -- 联系人
    ,nvl(n.channel, o.channel) as channel -- 渠道
    ,nvl(n.description, o.description) as description -- 描述
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 最后更新时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 最后更新事务时间
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 创建时间
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 创建事务时间
    ,nvl(n.account_category_level, o.account_category_level) as account_category_level -- 账户等级
    ,nvl(n.account_trans_type, o.account_trans_type) as account_trans_type -- 开户交易类型
    ,nvl(n.card_level, o.card_level) as card_level -- 卡级别
    ,nvl(n.cash_or_remit_id, o.cash_or_remit_id) as cash_or_remit_id -- 钞汇标识
    ,nvl(n.cash_saving_withdw_id, o.cash_saving_withdw_id) as cash_saving_withdw_id -- 通存通兑标识
    ,nvl(n.chip_card_type, o.chip_card_type) as chip_card_type -- 芯片卡标识
    ,nvl(n.cooperate_card_type, o.cooperate_card_type) as cooperate_card_type -- 合作卡类型
    ,nvl(n.docs_no, o.docs_no) as docs_no -- 凭证号码
    ,nvl(n.docs_status, o.docs_status) as docs_status -- 凭证状态
    ,nvl(n.docs_type, o.docs_type) as docs_type -- 凭证类型
    ,nvl(n.operate_acct_type, o.operate_acct_type) as operate_acct_type -- 账户组织形式
    ,nvl(n.private_acct_id, o.private_acct_id) as private_acct_id -- 私密账户标识
    ,nvl(n.seed_stock, o.seed_stock) as seed_stock -- 储种
    ,nvl(n.withdrawal_method, o.withdrawal_method) as withdrawal_method -- 支取方式
    ,nvl(n.channel_status, o.channel_status) as channel_status -- 交易渠道状态
    ,nvl(n.account_flag, o.account_flag) as account_flag -- 涉案账户标识
    ,nvl(n.flag_date, o.flag_date) as flag_date -- 设置日期
    ,nvl(n.data_source, o.data_source) as data_source -- 数据来源
    ,nvl(n.status_update_org, o.status_update_org) as status_update_org -- 交易渠道状态变更机构
    ,nvl(n.guilt_date, o.guilt_date) as guilt_date -- 涉案日期
    ,nvl(n.verify_status, o.verify_status) as verify_status -- 核实状态
    ,nvl(n.certification_status, o.certification_status) as certification_status -- 实名认证标识
    ,nvl(n.business_type, o.business_type) as business_type -- 业务类型
    ,nvl(n.supplyer_no, o.supplyer_no) as supplyer_no -- 商户号
    ,nvl(n.supplyer_name, o.supplyer_name) as supplyer_name -- 商户名称
    ,nvl(n.freeze_status, o.freeze_status) as freeze_status -- 冻结状态
    ,nvl(n.image_retention_status, o.image_retention_status) as image_retention_status -- 影像留存标记
    ,nvl(n.un_account_entry_status, o.un_account_entry_status) as un_account_entry_status -- 非绑定账户入账标志
    ,nvl(n.image_retention_date, o.image_retention_date) as image_retention_date -- 影像留存标记时间
    ,case when
            n.billing_account_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.billing_account_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.billing_account_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifds_billing_account_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifds_billing_account where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.billing_account_id = n.billing_account_id
where (
        o.billing_account_id is null
    )
    or (
        n.billing_account_id is null
    )
    or (
        o.billing_account_name <> n.billing_account_name
        or o.account_type <> n.account_type
        or o.account_currency_uom_id <> n.account_currency_uom_id
        or o.media_type_id <> n.media_type_id
        or o.party_id <> n.party_id
        or o.status_id <> n.status_id
        or o.account_limit <> n.account_limit
        or o.external_account_id <> n.external_account_id
        or o.account_level <> n.account_level
        or o.net_check_result <> n.net_check_result
        or o.account_branch_id <> n.account_branch_id
        or o.from_date <> n.from_date
        or o.thru_date <> n.thru_date
        or o.contact_mech_id <> n.contact_mech_id
        or o.channel <> n.channel
        or o.description <> n.description
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.account_category_level <> n.account_category_level
        or o.account_trans_type <> n.account_trans_type
        or o.card_level <> n.card_level
        or o.cash_or_remit_id <> n.cash_or_remit_id
        or o.cash_saving_withdw_id <> n.cash_saving_withdw_id
        or o.chip_card_type <> n.chip_card_type
        or o.cooperate_card_type <> n.cooperate_card_type
        or o.docs_no <> n.docs_no
        or o.docs_status <> n.docs_status
        or o.docs_type <> n.docs_type
        or o.operate_acct_type <> n.operate_acct_type
        or o.private_acct_id <> n.private_acct_id
        or o.seed_stock <> n.seed_stock
        or o.withdrawal_method <> n.withdrawal_method
        or o.channel_status <> n.channel_status
        or o.account_flag <> n.account_flag
        or o.flag_date <> n.flag_date
        or o.data_source <> n.data_source
        or o.status_update_org <> n.status_update_org
        or o.guilt_date <> n.guilt_date
        or o.verify_status <> n.verify_status
        or o.certification_status <> n.certification_status
        or o.business_type <> n.business_type
        or o.supplyer_no <> n.supplyer_no
        or o.supplyer_name <> n.supplyer_name
        or o.freeze_status <> n.freeze_status
        or o.image_retention_status <> n.image_retention_status
        or o.un_account_entry_status <> n.un_account_entry_status
        or o.image_retention_date <> n.image_retention_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifds_billing_account_cl(
            billing_account_id -- E账户编号
            ,billing_account_name -- E账户名称
            ,account_type -- 账户类型
            ,account_currency_uom_id -- E账户币种
            ,media_type_id -- 媒介类型
            ,party_id -- E账户所属客户号
            ,status_id -- E账户状态
            ,account_limit -- E账户限额
            ,external_account_id -- E账号
            ,account_level -- E账户等级
            ,net_check_result -- 联网核查结果
            ,account_branch_id -- 开户机构
            ,from_date -- 开户日期
            ,thru_date -- 销户日期
            ,contact_mech_id -- 联系人
            ,channel -- 渠道
            ,description -- 描述
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,account_category_level -- 账户等级
            ,account_trans_type -- 开户交易类型
            ,card_level -- 卡级别
            ,cash_or_remit_id -- 钞汇标识
            ,cash_saving_withdw_id -- 通存通兑标识
            ,chip_card_type -- 芯片卡标识
            ,cooperate_card_type -- 合作卡类型
            ,docs_no -- 凭证号码
            ,docs_status -- 凭证状态
            ,docs_type -- 凭证类型
            ,operate_acct_type -- 账户组织形式
            ,private_acct_id -- 私密账户标识
            ,seed_stock -- 储种
            ,withdrawal_method -- 支取方式
            ,channel_status -- 交易渠道状态
            ,account_flag -- 涉案账户标识
            ,flag_date -- 设置日期
            ,data_source -- 数据来源
            ,status_update_org -- 交易渠道状态变更机构
            ,guilt_date -- 涉案日期
            ,verify_status -- 核实状态
            ,certification_status -- 实名认证标识
            ,business_type -- 业务类型
            ,supplyer_no -- 商户号
            ,supplyer_name -- 商户名称
            ,freeze_status -- 冻结状态
            ,image_retention_status -- 影像留存标记
            ,un_account_entry_status -- 非绑定账户入账标志
            ,image_retention_date -- 影像留存标记时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifds_billing_account_op(
            billing_account_id -- E账户编号
            ,billing_account_name -- E账户名称
            ,account_type -- 账户类型
            ,account_currency_uom_id -- E账户币种
            ,media_type_id -- 媒介类型
            ,party_id -- E账户所属客户号
            ,status_id -- E账户状态
            ,account_limit -- E账户限额
            ,external_account_id -- E账号
            ,account_level -- E账户等级
            ,net_check_result -- 联网核查结果
            ,account_branch_id -- 开户机构
            ,from_date -- 开户日期
            ,thru_date -- 销户日期
            ,contact_mech_id -- 联系人
            ,channel -- 渠道
            ,description -- 描述
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,account_category_level -- 账户等级
            ,account_trans_type -- 开户交易类型
            ,card_level -- 卡级别
            ,cash_or_remit_id -- 钞汇标识
            ,cash_saving_withdw_id -- 通存通兑标识
            ,chip_card_type -- 芯片卡标识
            ,cooperate_card_type -- 合作卡类型
            ,docs_no -- 凭证号码
            ,docs_status -- 凭证状态
            ,docs_type -- 凭证类型
            ,operate_acct_type -- 账户组织形式
            ,private_acct_id -- 私密账户标识
            ,seed_stock -- 储种
            ,withdrawal_method -- 支取方式
            ,channel_status -- 交易渠道状态
            ,account_flag -- 涉案账户标识
            ,flag_date -- 设置日期
            ,data_source -- 数据来源
            ,status_update_org -- 交易渠道状态变更机构
            ,guilt_date -- 涉案日期
            ,verify_status -- 核实状态
            ,certification_status -- 实名认证标识
            ,business_type -- 业务类型
            ,supplyer_no -- 商户号
            ,supplyer_name -- 商户名称
            ,freeze_status -- 冻结状态
            ,image_retention_status -- 影像留存标记
            ,un_account_entry_status -- 非绑定账户入账标志
            ,image_retention_date -- 影像留存标记时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.billing_account_id -- E账户编号
    ,o.billing_account_name -- E账户名称
    ,o.account_type -- 账户类型
    ,o.account_currency_uom_id -- E账户币种
    ,o.media_type_id -- 媒介类型
    ,o.party_id -- E账户所属客户号
    ,o.status_id -- E账户状态
    ,o.account_limit -- E账户限额
    ,o.external_account_id -- E账号
    ,o.account_level -- E账户等级
    ,o.net_check_result -- 联网核查结果
    ,o.account_branch_id -- 开户机构
    ,o.from_date -- 开户日期
    ,o.thru_date -- 销户日期
    ,o.contact_mech_id -- 联系人
    ,o.channel -- 渠道
    ,o.description -- 描述
    ,o.last_updated_stamp -- 最后更新时间
    ,o.last_updated_tx_stamp -- 最后更新事务时间
    ,o.created_stamp -- 创建时间
    ,o.created_tx_stamp -- 创建事务时间
    ,o.account_category_level -- 账户等级
    ,o.account_trans_type -- 开户交易类型
    ,o.card_level -- 卡级别
    ,o.cash_or_remit_id -- 钞汇标识
    ,o.cash_saving_withdw_id -- 通存通兑标识
    ,o.chip_card_type -- 芯片卡标识
    ,o.cooperate_card_type -- 合作卡类型
    ,o.docs_no -- 凭证号码
    ,o.docs_status -- 凭证状态
    ,o.docs_type -- 凭证类型
    ,o.operate_acct_type -- 账户组织形式
    ,o.private_acct_id -- 私密账户标识
    ,o.seed_stock -- 储种
    ,o.withdrawal_method -- 支取方式
    ,o.channel_status -- 交易渠道状态
    ,o.account_flag -- 涉案账户标识
    ,o.flag_date -- 设置日期
    ,o.data_source -- 数据来源
    ,o.status_update_org -- 交易渠道状态变更机构
    ,o.guilt_date -- 涉案日期
    ,o.verify_status -- 核实状态
    ,o.certification_status -- 实名认证标识
    ,o.business_type -- 业务类型
    ,o.supplyer_no -- 商户号
    ,o.supplyer_name -- 商户名称
    ,o.freeze_status -- 冻结状态
    ,o.image_retention_status -- 影像留存标记
    ,o.un_account_entry_status -- 非绑定账户入账标志
    ,o.image_retention_date -- 影像留存标记时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ifds_billing_account_bk o
    left join ${iol_schema}.ifds_billing_account_op n
        on
            o.billing_account_id = n.billing_account_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifds_billing_account_cl d
        on
            o.billing_account_id = d.billing_account_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifds_billing_account;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifds_billing_account') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifds_billing_account drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifds_billing_account add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifds_billing_account exchange partition p_${batch_date} with table ${iol_schema}.ifds_billing_account_cl;
alter table ${iol_schema}.ifds_billing_account exchange partition p_20991231 with table ${iol_schema}.ifds_billing_account_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifds_billing_account to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifds_billing_account_op purge;
drop table ${iol_schema}.ifds_billing_account_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifds_billing_account_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifds_billing_account',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
