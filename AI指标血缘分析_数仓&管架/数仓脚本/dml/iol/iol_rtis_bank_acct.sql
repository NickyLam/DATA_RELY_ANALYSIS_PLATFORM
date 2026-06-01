/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rtis_bank_acct
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
create table ${iol_schema}.rtis_bank_acct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rtis_bank_acct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rtis_bank_acct_op purge;
drop table ${iol_schema}.rtis_bank_acct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_bank_acct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_bank_acct where 0=1;

create table ${iol_schema}.rtis_bank_acct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_bank_acct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rtis_bank_acct_cl(
            acct_cls_cd -- 账户分类代码
            ,froz_status_cd -- 
            ,asset_under_management -- 资产管理规模AUM值
            ,emply_flg -- 员工标识:1-是,0-否
            ,m_avg_bal -- 账户月日均余额
            ,aum_m_avg_bal -- AUM月均值
            ,acct_belong_org_id -- 账户所属机构号
            ,control_type -- 交易渠道状态代码
            ,restraint_type -- 账户限制类型
            ,cust_id -- 客户号
            ,card_no -- 账户号（卡号）
            ,open_inst_no -- 开户机构编号
            ,acct_opene_at -- 开户时间
            ,acct_type -- 账户类型
            ,card_type -- 卡类型
            ,acct_medium -- 账户介质
            ,daily_balance -- 日终余额
            ,id_card_type -- 证件类型
            ,id_card_number -- 证件号码
            ,create_at -- 入库时间
            ,create_by -- 入库人
            ,last_update_at -- 入库后最后变更时间
            ,last_update_by -- 最后变更人
            ,acct_stat -- 账户状态
            ,cry_type -- 币种
            ,acct_kind -- 公私标识
            ,open_inst_name -- 开户机构名称
            ,open_agent -- 开户代办人
            ,open_agent_id_type -- 开户代办人证件类型
            ,open_agent_id_no -- 开户代办人证件号码
            ,open_agent_tel -- 开户代办人电话
            ,company_contact -- 单位联系人
            ,company_contact_id_type -- 单位联系人证件类型
            ,company_contact_id_no -- 单位联系人证件号码
            ,company_contact_tel -- 单位联系人电话
            ,cust_name -- 持卡人姓名
            ,card_city -- 银行卡发卡城市
            ,card_indate -- 卡有效期
            ,limit_amount -- 信用卡额度,厘
            ,phone_number -- 预留手机号码
            ,last_update_time -- 账户最后更新时间
            ,is_dormancy_account -- 是否为睡眠户
            ,e_acct_type -- 电子账户类型
            ,cust_type -- 客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rtis_bank_acct_op(
            acct_cls_cd -- 账户分类代码
            ,froz_status_cd -- 
            ,asset_under_management -- 资产管理规模AUM值
            ,emply_flg -- 员工标识:1-是,0-否
            ,m_avg_bal -- 账户月日均余额
            ,aum_m_avg_bal -- AUM月均值
            ,acct_belong_org_id -- 账户所属机构号
            ,control_type -- 交易渠道状态代码
            ,restraint_type -- 账户限制类型
            ,cust_id -- 客户号
            ,card_no -- 账户号（卡号）
            ,open_inst_no -- 开户机构编号
            ,acct_opene_at -- 开户时间
            ,acct_type -- 账户类型
            ,card_type -- 卡类型
            ,acct_medium -- 账户介质
            ,daily_balance -- 日终余额
            ,id_card_type -- 证件类型
            ,id_card_number -- 证件号码
            ,create_at -- 入库时间
            ,create_by -- 入库人
            ,last_update_at -- 入库后最后变更时间
            ,last_update_by -- 最后变更人
            ,acct_stat -- 账户状态
            ,cry_type -- 币种
            ,acct_kind -- 公私标识
            ,open_inst_name -- 开户机构名称
            ,open_agent -- 开户代办人
            ,open_agent_id_type -- 开户代办人证件类型
            ,open_agent_id_no -- 开户代办人证件号码
            ,open_agent_tel -- 开户代办人电话
            ,company_contact -- 单位联系人
            ,company_contact_id_type -- 单位联系人证件类型
            ,company_contact_id_no -- 单位联系人证件号码
            ,company_contact_tel -- 单位联系人电话
            ,cust_name -- 持卡人姓名
            ,card_city -- 银行卡发卡城市
            ,card_indate -- 卡有效期
            ,limit_amount -- 信用卡额度,厘
            ,phone_number -- 预留手机号码
            ,last_update_time -- 账户最后更新时间
            ,is_dormancy_account -- 是否为睡眠户
            ,e_acct_type -- 电子账户类型
            ,cust_type -- 客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_cls_cd, o.acct_cls_cd) as acct_cls_cd -- 账户分类代码
    ,nvl(n.froz_status_cd, o.froz_status_cd) as froz_status_cd -- 
    ,nvl(n.asset_under_management, o.asset_under_management) as asset_under_management -- 资产管理规模AUM值
    ,nvl(n.emply_flg, o.emply_flg) as emply_flg -- 员工标识:1-是,0-否
    ,nvl(n.m_avg_bal, o.m_avg_bal) as m_avg_bal -- 账户月日均余额
    ,nvl(n.aum_m_avg_bal, o.aum_m_avg_bal) as aum_m_avg_bal -- AUM月均值
    ,nvl(n.acct_belong_org_id, o.acct_belong_org_id) as acct_belong_org_id -- 账户所属机构号
    ,nvl(n.control_type, o.control_type) as control_type -- 交易渠道状态代码
    ,nvl(n.restraint_type, o.restraint_type) as restraint_type -- 账户限制类型
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户号
    ,nvl(n.card_no, o.card_no) as card_no -- 账户号（卡号）
    ,nvl(n.open_inst_no, o.open_inst_no) as open_inst_no -- 开户机构编号
    ,nvl(n.acct_opene_at, o.acct_opene_at) as acct_opene_at -- 开户时间
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户类型
    ,nvl(n.card_type, o.card_type) as card_type -- 卡类型
    ,nvl(n.acct_medium, o.acct_medium) as acct_medium -- 账户介质
    ,nvl(n.daily_balance, o.daily_balance) as daily_balance -- 日终余额
    ,nvl(n.id_card_type, o.id_card_type) as id_card_type -- 证件类型
    ,nvl(n.id_card_number, o.id_card_number) as id_card_number -- 证件号码
    ,nvl(n.create_at, o.create_at) as create_at -- 入库时间
    ,nvl(n.create_by, o.create_by) as create_by -- 入库人
    ,nvl(n.last_update_at, o.last_update_at) as last_update_at -- 入库后最后变更时间
    ,nvl(n.last_update_by, o.last_update_by) as last_update_by -- 最后变更人
    ,nvl(n.acct_stat, o.acct_stat) as acct_stat -- 账户状态
    ,nvl(n.cry_type, o.cry_type) as cry_type -- 币种
    ,nvl(n.acct_kind, o.acct_kind) as acct_kind -- 公私标识
    ,nvl(n.open_inst_name, o.open_inst_name) as open_inst_name -- 开户机构名称
    ,nvl(n.open_agent, o.open_agent) as open_agent -- 开户代办人
    ,nvl(n.open_agent_id_type, o.open_agent_id_type) as open_agent_id_type -- 开户代办人证件类型
    ,nvl(n.open_agent_id_no, o.open_agent_id_no) as open_agent_id_no -- 开户代办人证件号码
    ,nvl(n.open_agent_tel, o.open_agent_tel) as open_agent_tel -- 开户代办人电话
    ,nvl(n.company_contact, o.company_contact) as company_contact -- 单位联系人
    ,nvl(n.company_contact_id_type, o.company_contact_id_type) as company_contact_id_type -- 单位联系人证件类型
    ,nvl(n.company_contact_id_no, o.company_contact_id_no) as company_contact_id_no -- 单位联系人证件号码
    ,nvl(n.company_contact_tel, o.company_contact_tel) as company_contact_tel -- 单位联系人电话
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 持卡人姓名
    ,nvl(n.card_city, o.card_city) as card_city -- 银行卡发卡城市
    ,nvl(n.card_indate, o.card_indate) as card_indate -- 卡有效期
    ,nvl(n.limit_amount, o.limit_amount) as limit_amount -- 信用卡额度,厘
    ,nvl(n.phone_number, o.phone_number) as phone_number -- 预留手机号码
    ,nvl(n.last_update_time, o.last_update_time) as last_update_time -- 账户最后更新时间
    ,nvl(n.is_dormancy_account, o.is_dormancy_account) as is_dormancy_account -- 是否为睡眠户
    ,nvl(n.e_acct_type, o.e_acct_type) as e_acct_type -- 电子账户类型
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 客户类型
    ,case when
            n.card_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.card_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.card_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rtis_bank_acct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rtis_bank_acct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.card_no = n.card_no
where (
        o.card_no is null
    )
    or (
        n.card_no is null
    )
    or (
        o.acct_cls_cd <> n.acct_cls_cd
        or o.froz_status_cd <> n.froz_status_cd
        or o.asset_under_management <> n.asset_under_management
        or o.emply_flg <> n.emply_flg
        or o.m_avg_bal <> n.m_avg_bal
        or o.aum_m_avg_bal <> n.aum_m_avg_bal
        or o.acct_belong_org_id <> n.acct_belong_org_id
        or o.control_type <> n.control_type
        or o.restraint_type <> n.restraint_type
        or o.cust_id <> n.cust_id
        or o.open_inst_no <> n.open_inst_no
        or o.acct_opene_at <> n.acct_opene_at
        or o.acct_type <> n.acct_type
        or o.card_type <> n.card_type
        or o.acct_medium <> n.acct_medium
        or o.daily_balance <> n.daily_balance
        or o.id_card_type <> n.id_card_type
        or o.id_card_number <> n.id_card_number
        or o.create_at <> n.create_at
        or o.create_by <> n.create_by
        or o.last_update_at <> n.last_update_at
        or o.last_update_by <> n.last_update_by
        or o.acct_stat <> n.acct_stat
        or o.cry_type <> n.cry_type
        or o.acct_kind <> n.acct_kind
        or o.open_inst_name <> n.open_inst_name
        or o.open_agent <> n.open_agent
        or o.open_agent_id_type <> n.open_agent_id_type
        or o.open_agent_id_no <> n.open_agent_id_no
        or o.open_agent_tel <> n.open_agent_tel
        or o.company_contact <> n.company_contact
        or o.company_contact_id_type <> n.company_contact_id_type
        or o.company_contact_id_no <> n.company_contact_id_no
        or o.company_contact_tel <> n.company_contact_tel
        or o.cust_name <> n.cust_name
        or o.card_city <> n.card_city
        or o.card_indate <> n.card_indate
        or o.limit_amount <> n.limit_amount
        or o.phone_number <> n.phone_number
        or o.last_update_time <> n.last_update_time
        or o.is_dormancy_account <> n.is_dormancy_account
        or o.e_acct_type <> n.e_acct_type
        or o.cust_type <> n.cust_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rtis_bank_acct_cl(
            acct_cls_cd -- 账户分类代码
            ,froz_status_cd -- 
            ,asset_under_management -- 资产管理规模AUM值
            ,emply_flg -- 员工标识:1-是,0-否
            ,m_avg_bal -- 账户月日均余额
            ,aum_m_avg_bal -- AUM月均值
            ,acct_belong_org_id -- 账户所属机构号
            ,control_type -- 交易渠道状态代码
            ,restraint_type -- 账户限制类型
            ,cust_id -- 客户号
            ,card_no -- 账户号（卡号）
            ,open_inst_no -- 开户机构编号
            ,acct_opene_at -- 开户时间
            ,acct_type -- 账户类型
            ,card_type -- 卡类型
            ,acct_medium -- 账户介质
            ,daily_balance -- 日终余额
            ,id_card_type -- 证件类型
            ,id_card_number -- 证件号码
            ,create_at -- 入库时间
            ,create_by -- 入库人
            ,last_update_at -- 入库后最后变更时间
            ,last_update_by -- 最后变更人
            ,acct_stat -- 账户状态
            ,cry_type -- 币种
            ,acct_kind -- 公私标识
            ,open_inst_name -- 开户机构名称
            ,open_agent -- 开户代办人
            ,open_agent_id_type -- 开户代办人证件类型
            ,open_agent_id_no -- 开户代办人证件号码
            ,open_agent_tel -- 开户代办人电话
            ,company_contact -- 单位联系人
            ,company_contact_id_type -- 单位联系人证件类型
            ,company_contact_id_no -- 单位联系人证件号码
            ,company_contact_tel -- 单位联系人电话
            ,cust_name -- 持卡人姓名
            ,card_city -- 银行卡发卡城市
            ,card_indate -- 卡有效期
            ,limit_amount -- 信用卡额度,厘
            ,phone_number -- 预留手机号码
            ,last_update_time -- 账户最后更新时间
            ,is_dormancy_account -- 是否为睡眠户
            ,e_acct_type -- 电子账户类型
            ,cust_type -- 客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rtis_bank_acct_op(
            acct_cls_cd -- 账户分类代码
            ,froz_status_cd -- 
            ,asset_under_management -- 资产管理规模AUM值
            ,emply_flg -- 员工标识:1-是,0-否
            ,m_avg_bal -- 账户月日均余额
            ,aum_m_avg_bal -- AUM月均值
            ,acct_belong_org_id -- 账户所属机构号
            ,control_type -- 交易渠道状态代码
            ,restraint_type -- 账户限制类型
            ,cust_id -- 客户号
            ,card_no -- 账户号（卡号）
            ,open_inst_no -- 开户机构编号
            ,acct_opene_at -- 开户时间
            ,acct_type -- 账户类型
            ,card_type -- 卡类型
            ,acct_medium -- 账户介质
            ,daily_balance -- 日终余额
            ,id_card_type -- 证件类型
            ,id_card_number -- 证件号码
            ,create_at -- 入库时间
            ,create_by -- 入库人
            ,last_update_at -- 入库后最后变更时间
            ,last_update_by -- 最后变更人
            ,acct_stat -- 账户状态
            ,cry_type -- 币种
            ,acct_kind -- 公私标识
            ,open_inst_name -- 开户机构名称
            ,open_agent -- 开户代办人
            ,open_agent_id_type -- 开户代办人证件类型
            ,open_agent_id_no -- 开户代办人证件号码
            ,open_agent_tel -- 开户代办人电话
            ,company_contact -- 单位联系人
            ,company_contact_id_type -- 单位联系人证件类型
            ,company_contact_id_no -- 单位联系人证件号码
            ,company_contact_tel -- 单位联系人电话
            ,cust_name -- 持卡人姓名
            ,card_city -- 银行卡发卡城市
            ,card_indate -- 卡有效期
            ,limit_amount -- 信用卡额度,厘
            ,phone_number -- 预留手机号码
            ,last_update_time -- 账户最后更新时间
            ,is_dormancy_account -- 是否为睡眠户
            ,e_acct_type -- 电子账户类型
            ,cust_type -- 客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_cls_cd -- 账户分类代码
    ,o.froz_status_cd -- 
    ,o.asset_under_management -- 资产管理规模AUM值
    ,o.emply_flg -- 员工标识:1-是,0-否
    ,o.m_avg_bal -- 账户月日均余额
    ,o.aum_m_avg_bal -- AUM月均值
    ,o.acct_belong_org_id -- 账户所属机构号
    ,o.control_type -- 交易渠道状态代码
    ,o.restraint_type -- 账户限制类型
    ,o.cust_id -- 客户号
    ,o.card_no -- 账户号（卡号）
    ,o.open_inst_no -- 开户机构编号
    ,o.acct_opene_at -- 开户时间
    ,o.acct_type -- 账户类型
    ,o.card_type -- 卡类型
    ,o.acct_medium -- 账户介质
    ,o.daily_balance -- 日终余额
    ,o.id_card_type -- 证件类型
    ,o.id_card_number -- 证件号码
    ,o.create_at -- 入库时间
    ,o.create_by -- 入库人
    ,o.last_update_at -- 入库后最后变更时间
    ,o.last_update_by -- 最后变更人
    ,o.acct_stat -- 账户状态
    ,o.cry_type -- 币种
    ,o.acct_kind -- 公私标识
    ,o.open_inst_name -- 开户机构名称
    ,o.open_agent -- 开户代办人
    ,o.open_agent_id_type -- 开户代办人证件类型
    ,o.open_agent_id_no -- 开户代办人证件号码
    ,o.open_agent_tel -- 开户代办人电话
    ,o.company_contact -- 单位联系人
    ,o.company_contact_id_type -- 单位联系人证件类型
    ,o.company_contact_id_no -- 单位联系人证件号码
    ,o.company_contact_tel -- 单位联系人电话
    ,o.cust_name -- 持卡人姓名
    ,o.card_city -- 银行卡发卡城市
    ,o.card_indate -- 卡有效期
    ,o.limit_amount -- 信用卡额度,厘
    ,o.phone_number -- 预留手机号码
    ,o.last_update_time -- 账户最后更新时间
    ,o.is_dormancy_account -- 是否为睡眠户
    ,o.e_acct_type -- 电子账户类型
    ,o.cust_type -- 客户类型
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
from ${iol_schema}.rtis_bank_acct_bk o
    left join ${iol_schema}.rtis_bank_acct_op n
        on
            o.card_no = n.card_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rtis_bank_acct_cl d
        on
            o.card_no = d.card_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rtis_bank_acct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rtis_bank_acct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rtis_bank_acct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rtis_bank_acct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rtis_bank_acct exchange partition p_${batch_date} with table ${iol_schema}.rtis_bank_acct_cl;
alter table ${iol_schema}.rtis_bank_acct exchange partition p_20991231 with table ${iol_schema}.rtis_bank_acct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rtis_bank_acct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rtis_bank_acct_op purge;
drop table ${iol_schema}.rtis_bank_acct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rtis_bank_acct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rtis_bank_acct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
