/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_e_corp_info
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
create table ${iol_schema}.ppps_e_corp_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ppps_e_corp_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_e_corp_info_op purge;
drop table ${iol_schema}.ppps_e_corp_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_e_corp_info_op nologging
for exchange with table
${iol_schema}.ppps_e_corp_info;

create table ${iol_schema}.ppps_e_corp_info_cl nologging
for exchange with table
${iol_schema}.ppps_e_corp_info;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_e_corp_info_cl(
            id -- 自增主键
            ,issr_id -- 机构标识
            ,issr_name -- 机构名称
            ,permit_code -- 营业执照号码
            ,permit_vaild_date -- 营业执照有效期 YYYYMMDD
            ,regist_fund -- 注册资金
            ,address -- 注册地址
            ,organ_code -- 组织机构代码证
            ,corp_id_type -- 法人证件类型 0-其他，1-身份证，2-军官士兵证，3-港澳台通行证，4-护照
            ,corp_id_no -- 法人证件号码
            ,corporation_name -- 法人姓名
            ,email -- 联系人电子邮箱
            ,linkman -- 联系人姓名
            ,link_tel_no -- 联系电话
            ,contact_address -- 联系人地址
            ,fax -- 传真
            ,status -- 状态 ACTIVE-正常服务,INACTIVE-暂停服务
            ,balance_channel -- 结算通道 1-本行账户，2-他行账户
            ,balance_open_bank -- 结算账户开户行名
            ,create_time -- 创建时间
            ,update_time -- 最后更新时间
            ,delete_status -- 删除状态：0-未删，1-删除
            ,issr_short_name -- 机构简称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_e_corp_info_op(
            id -- 自增主键
            ,issr_id -- 机构标识
            ,issr_name -- 机构名称
            ,permit_code -- 营业执照号码
            ,permit_vaild_date -- 营业执照有效期 YYYYMMDD
            ,regist_fund -- 注册资金
            ,address -- 注册地址
            ,organ_code -- 组织机构代码证
            ,corp_id_type -- 法人证件类型 0-其他，1-身份证，2-军官士兵证，3-港澳台通行证，4-护照
            ,corp_id_no -- 法人证件号码
            ,corporation_name -- 法人姓名
            ,email -- 联系人电子邮箱
            ,linkman -- 联系人姓名
            ,link_tel_no -- 联系电话
            ,contact_address -- 联系人地址
            ,fax -- 传真
            ,status -- 状态 ACTIVE-正常服务,INACTIVE-暂停服务
            ,balance_channel -- 结算通道 1-本行账户，2-他行账户
            ,balance_open_bank -- 结算账户开户行名
            ,create_time -- 创建时间
            ,update_time -- 最后更新时间
            ,delete_status -- 删除状态：0-未删，1-删除
            ,issr_short_name -- 机构简称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 自增主键
    ,nvl(n.issr_id, o.issr_id) as issr_id -- 机构标识
    ,nvl(n.issr_name, o.issr_name) as issr_name -- 机构名称
    ,nvl(n.permit_code, o.permit_code) as permit_code -- 营业执照号码
    ,nvl(n.permit_vaild_date, o.permit_vaild_date) as permit_vaild_date -- 营业执照有效期 YYYYMMDD
    ,nvl(n.regist_fund, o.regist_fund) as regist_fund -- 注册资金
    ,nvl(n.address, o.address) as address -- 注册地址
    ,nvl(n.organ_code, o.organ_code) as organ_code -- 组织机构代码证
    ,nvl(n.corp_id_type, o.corp_id_type) as corp_id_type -- 法人证件类型 0-其他，1-身份证，2-军官士兵证，3-港澳台通行证，4-护照
    ,nvl(n.corp_id_no, o.corp_id_no) as corp_id_no -- 法人证件号码
    ,nvl(n.corporation_name, o.corporation_name) as corporation_name -- 法人姓名
    ,nvl(n.email, o.email) as email -- 联系人电子邮箱
    ,nvl(n.linkman, o.linkman) as linkman -- 联系人姓名
    ,nvl(n.link_tel_no, o.link_tel_no) as link_tel_no -- 联系电话
    ,nvl(n.contact_address, o.contact_address) as contact_address -- 联系人地址
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.status, o.status) as status -- 状态 ACTIVE-正常服务,INACTIVE-暂停服务
    ,nvl(n.balance_channel, o.balance_channel) as balance_channel -- 结算通道 1-本行账户，2-他行账户
    ,nvl(n.balance_open_bank, o.balance_open_bank) as balance_open_bank -- 结算账户开户行名
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 最后更新时间
    ,nvl(n.delete_status, o.delete_status) as delete_status -- 删除状态：0-未删，1-删除
    ,nvl(n.issr_short_name, o.issr_short_name) as issr_short_name -- 机构简称
    ,case when
            n.issr_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.issr_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.issr_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ppps_e_corp_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ppps_e_corp_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.issr_id = n.issr_id
where (
        o.issr_id is null
    )
    or (
        n.issr_id is null
    )
    or (
        o.id <> n.id
        or o.issr_name <> n.issr_name
        or o.permit_code <> n.permit_code
        or o.permit_vaild_date <> n.permit_vaild_date
        or o.regist_fund <> n.regist_fund
        or o.address <> n.address
        or o.organ_code <> n.organ_code
        or o.corp_id_type <> n.corp_id_type
        or o.corp_id_no <> n.corp_id_no
        or o.corporation_name <> n.corporation_name
        or o.email <> n.email
        or o.linkman <> n.linkman
        or o.link_tel_no <> n.link_tel_no
        or o.contact_address <> n.contact_address
        or o.fax <> n.fax
        or o.status <> n.status
        or o.balance_channel <> n.balance_channel
        or o.balance_open_bank <> n.balance_open_bank
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.delete_status <> n.delete_status
        or o.issr_short_name <> n.issr_short_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_e_corp_info_cl(
            id -- 自增主键
            ,issr_id -- 机构标识
            ,issr_name -- 机构名称
            ,permit_code -- 营业执照号码
            ,permit_vaild_date -- 营业执照有效期 YYYYMMDD
            ,regist_fund -- 注册资金
            ,address -- 注册地址
            ,organ_code -- 组织机构代码证
            ,corp_id_type -- 法人证件类型 0-其他，1-身份证，2-军官士兵证，3-港澳台通行证，4-护照
            ,corp_id_no -- 法人证件号码
            ,corporation_name -- 法人姓名
            ,email -- 联系人电子邮箱
            ,linkman -- 联系人姓名
            ,link_tel_no -- 联系电话
            ,contact_address -- 联系人地址
            ,fax -- 传真
            ,status -- 状态 ACTIVE-正常服务,INACTIVE-暂停服务
            ,balance_channel -- 结算通道 1-本行账户，2-他行账户
            ,balance_open_bank -- 结算账户开户行名
            ,create_time -- 创建时间
            ,update_time -- 最后更新时间
            ,delete_status -- 删除状态：0-未删，1-删除
            ,issr_short_name -- 机构简称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_e_corp_info_op(
            id -- 自增主键
            ,issr_id -- 机构标识
            ,issr_name -- 机构名称
            ,permit_code -- 营业执照号码
            ,permit_vaild_date -- 营业执照有效期 YYYYMMDD
            ,regist_fund -- 注册资金
            ,address -- 注册地址
            ,organ_code -- 组织机构代码证
            ,corp_id_type -- 法人证件类型 0-其他，1-身份证，2-军官士兵证，3-港澳台通行证，4-护照
            ,corp_id_no -- 法人证件号码
            ,corporation_name -- 法人姓名
            ,email -- 联系人电子邮箱
            ,linkman -- 联系人姓名
            ,link_tel_no -- 联系电话
            ,contact_address -- 联系人地址
            ,fax -- 传真
            ,status -- 状态 ACTIVE-正常服务,INACTIVE-暂停服务
            ,balance_channel -- 结算通道 1-本行账户，2-他行账户
            ,balance_open_bank -- 结算账户开户行名
            ,create_time -- 创建时间
            ,update_time -- 最后更新时间
            ,delete_status -- 删除状态：0-未删，1-删除
            ,issr_short_name -- 机构简称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 自增主键
    ,o.issr_id -- 机构标识
    ,o.issr_name -- 机构名称
    ,o.permit_code -- 营业执照号码
    ,o.permit_vaild_date -- 营业执照有效期 YYYYMMDD
    ,o.regist_fund -- 注册资金
    ,o.address -- 注册地址
    ,o.organ_code -- 组织机构代码证
    ,o.corp_id_type -- 法人证件类型 0-其他，1-身份证，2-军官士兵证，3-港澳台通行证，4-护照
    ,o.corp_id_no -- 法人证件号码
    ,o.corporation_name -- 法人姓名
    ,o.email -- 联系人电子邮箱
    ,o.linkman -- 联系人姓名
    ,o.link_tel_no -- 联系电话
    ,o.contact_address -- 联系人地址
    ,o.fax -- 传真
    ,o.status -- 状态 ACTIVE-正常服务,INACTIVE-暂停服务
    ,o.balance_channel -- 结算通道 1-本行账户，2-他行账户
    ,o.balance_open_bank -- 结算账户开户行名
    ,o.create_time -- 创建时间
    ,o.update_time -- 最后更新时间
    ,o.delete_status -- 删除状态：0-未删，1-删除
    ,o.issr_short_name -- 机构简称
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
from ${iol_schema}.ppps_e_corp_info_bk o
    left join ${iol_schema}.ppps_e_corp_info_op n
        on
            o.issr_id = n.issr_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ppps_e_corp_info_cl d
        on
            o.issr_id = d.issr_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ppps_e_corp_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ppps_e_corp_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ppps_e_corp_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ppps_e_corp_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ppps_e_corp_info exchange partition p_${batch_date} with table ${iol_schema}.ppps_e_corp_info_cl;
alter table ${iol_schema}.ppps_e_corp_info exchange partition p_20991231 with table ${iol_schema}.ppps_e_corp_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ppps_e_corp_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_e_corp_info_op purge;
drop table ${iol_schema}.ppps_e_corp_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ppps_e_corp_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ppps_e_corp_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
