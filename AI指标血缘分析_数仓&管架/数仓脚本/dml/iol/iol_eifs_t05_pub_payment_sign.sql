/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t05_pub_payment_sign
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
create table ${iol_schema}.eifs_t05_pub_payment_sign_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t05_pub_payment_sign
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t05_pub_payment_sign_op purge;
drop table ${iol_schema}.eifs_t05_pub_payment_sign_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t05_pub_payment_sign_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t05_pub_payment_sign where 0=1;

create table ${iol_schema}.eifs_t05_pub_payment_sign_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t05_pub_payment_sign where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t05_pub_payment_sign_cl(
            sign_contract_id -- 签约id
            ,agreement_id -- 签约编号
            ,agreement_item_seq_id -- 协议项编号
            ,payment_id -- 中间业务标识号
            ,legal_address_type -- 地址类型
            ,idtype -- 标识类型（证件标识）
            ,sign_id -- 协议书编号
            ,sp_id -- 第三方代码
            ,sp_sign_id -- 第三方协议号
            ,txn_limit -- 交易限额
            ,payment_mode -- 扣款方式
            ,day_limit -- 客户日累计限额
            ,month_limit -- 客户月累计限额
            ,service_num -- 委托服务号码
            ,service_name -- 委托服务户名
            ,service_type -- 委托服务类型
            ,sign_kind -- 协议类型
            ,sp_child_id -- 分局编号
            ,entente_dt -- 协约日期
            ,involce_cd -- 取发票方式
            ,sign_control_ind -- 签约服务控制码
            ,curr_cd -- 币种
            ,cash_trans_cd -- 钞汇标志
            ,service_unit_name -- 委托单位名称
            ,service_unit_tpfa -- 委托单位第三方资金账号
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t05_pub_payment_sign_op(
            sign_contract_id -- 签约id
            ,agreement_id -- 签约编号
            ,agreement_item_seq_id -- 协议项编号
            ,payment_id -- 中间业务标识号
            ,legal_address_type -- 地址类型
            ,idtype -- 标识类型（证件标识）
            ,sign_id -- 协议书编号
            ,sp_id -- 第三方代码
            ,sp_sign_id -- 第三方协议号
            ,txn_limit -- 交易限额
            ,payment_mode -- 扣款方式
            ,day_limit -- 客户日累计限额
            ,month_limit -- 客户月累计限额
            ,service_num -- 委托服务号码
            ,service_name -- 委托服务户名
            ,service_type -- 委托服务类型
            ,sign_kind -- 协议类型
            ,sp_child_id -- 分局编号
            ,entente_dt -- 协约日期
            ,involce_cd -- 取发票方式
            ,sign_control_ind -- 签约服务控制码
            ,curr_cd -- 币种
            ,cash_trans_cd -- 钞汇标志
            ,service_unit_name -- 委托单位名称
            ,service_unit_tpfa -- 委托单位第三方资金账号
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sign_contract_id, o.sign_contract_id) as sign_contract_id -- 签约id
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 签约编号
    ,nvl(n.agreement_item_seq_id, o.agreement_item_seq_id) as agreement_item_seq_id -- 协议项编号
    ,nvl(n.payment_id, o.payment_id) as payment_id -- 中间业务标识号
    ,nvl(n.legal_address_type, o.legal_address_type) as legal_address_type -- 地址类型
    ,nvl(n.idtype, o.idtype) as idtype -- 标识类型（证件标识）
    ,nvl(n.sign_id, o.sign_id) as sign_id -- 协议书编号
    ,nvl(n.sp_id, o.sp_id) as sp_id -- 第三方代码
    ,nvl(n.sp_sign_id, o.sp_sign_id) as sp_sign_id -- 第三方协议号
    ,nvl(n.txn_limit, o.txn_limit) as txn_limit -- 交易限额
    ,nvl(n.payment_mode, o.payment_mode) as payment_mode -- 扣款方式
    ,nvl(n.day_limit, o.day_limit) as day_limit -- 客户日累计限额
    ,nvl(n.month_limit, o.month_limit) as month_limit -- 客户月累计限额
    ,nvl(n.service_num, o.service_num) as service_num -- 委托服务号码
    ,nvl(n.service_name, o.service_name) as service_name -- 委托服务户名
    ,nvl(n.service_type, o.service_type) as service_type -- 委托服务类型
    ,nvl(n.sign_kind, o.sign_kind) as sign_kind -- 协议类型
    ,nvl(n.sp_child_id, o.sp_child_id) as sp_child_id -- 分局编号
    ,nvl(n.entente_dt, o.entente_dt) as entente_dt -- 协约日期
    ,nvl(n.involce_cd, o.involce_cd) as involce_cd -- 取发票方式
    ,nvl(n.sign_control_ind, o.sign_control_ind) as sign_control_ind -- 签约服务控制码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种
    ,nvl(n.cash_trans_cd, o.cash_trans_cd) as cash_trans_cd -- 钞汇标志
    ,nvl(n.service_unit_name, o.service_unit_name) as service_unit_name -- 委托单位名称
    ,nvl(n.service_unit_tpfa, o.service_unit_tpfa) as service_unit_tpfa -- 委托单位第三方资金账号
    ,nvl(n.create_te, o.create_te) as create_te -- 创建柜员
    ,nvl(n.create_org, o.create_org) as create_org -- 创建机构号
    ,nvl(n.init_system_id, o.init_system_id) as init_system_id -- 创建渠道
    ,nvl(n.init_created_ts, o.init_created_ts) as init_created_ts -- 源系统创建时间
    ,nvl(n.created_ts, o.created_ts) as created_ts -- 进入ecif的时间
    ,nvl(n.updated_ts, o.updated_ts) as updated_ts -- 在ecif中失效的时间
    ,nvl(n.last_updated_te, o.last_updated_te) as last_updated_te -- 最新更新柜员
    ,nvl(n.last_updated_org, o.last_updated_org) as last_updated_org -- 最新更新机构号
    ,nvl(n.last_system_id, o.last_system_id) as last_system_id -- 最新更新渠道
    ,nvl(n.last_updated_ts, o.last_updated_ts) as last_updated_ts -- 最新更新时间
    ,nvl(n.src_sys_num, o.src_sys_num) as src_sys_num -- 来源系统编号
    ,nvl(n.last_updated_src_sys_num, o.last_updated_src_sys_num) as last_updated_src_sys_num -- 最新更新源系统编号
    ,case when
            n.sign_contract_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sign_contract_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sign_contract_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t05_pub_payment_sign_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t05_pub_payment_sign where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sign_contract_id = n.sign_contract_id
where (
        o.sign_contract_id is null
    )
    or (
        n.sign_contract_id is null
    )
    or (
        o.agreement_id <> n.agreement_id
        or o.agreement_item_seq_id <> n.agreement_item_seq_id
        or o.payment_id <> n.payment_id
        or o.legal_address_type <> n.legal_address_type
        or o.idtype <> n.idtype
        or o.sign_id <> n.sign_id
        or o.sp_id <> n.sp_id
        or o.sp_sign_id <> n.sp_sign_id
        or o.txn_limit <> n.txn_limit
        or o.payment_mode <> n.payment_mode
        or o.day_limit <> n.day_limit
        or o.month_limit <> n.month_limit
        or o.service_num <> n.service_num
        or o.service_name <> n.service_name
        or o.service_type <> n.service_type
        or o.sign_kind <> n.sign_kind
        or o.sp_child_id <> n.sp_child_id
        or o.entente_dt <> n.entente_dt
        or o.involce_cd <> n.involce_cd
        or o.sign_control_ind <> n.sign_control_ind
        or o.curr_cd <> n.curr_cd
        or o.cash_trans_cd <> n.cash_trans_cd
        or o.service_unit_name <> n.service_unit_name
        or o.service_unit_tpfa <> n.service_unit_tpfa
        or o.create_te <> n.create_te
        or o.create_org <> n.create_org
        or o.init_system_id <> n.init_system_id
        or o.init_created_ts <> n.init_created_ts
        or o.created_ts <> n.created_ts
        or o.updated_ts <> n.updated_ts
        or o.last_updated_te <> n.last_updated_te
        or o.last_updated_org <> n.last_updated_org
        or o.last_system_id <> n.last_system_id
        or o.last_updated_ts <> n.last_updated_ts
        or o.src_sys_num <> n.src_sys_num
        or o.last_updated_src_sys_num <> n.last_updated_src_sys_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t05_pub_payment_sign_cl(
            sign_contract_id -- 签约id
            ,agreement_id -- 签约编号
            ,agreement_item_seq_id -- 协议项编号
            ,payment_id -- 中间业务标识号
            ,legal_address_type -- 地址类型
            ,idtype -- 标识类型（证件标识）
            ,sign_id -- 协议书编号
            ,sp_id -- 第三方代码
            ,sp_sign_id -- 第三方协议号
            ,txn_limit -- 交易限额
            ,payment_mode -- 扣款方式
            ,day_limit -- 客户日累计限额
            ,month_limit -- 客户月累计限额
            ,service_num -- 委托服务号码
            ,service_name -- 委托服务户名
            ,service_type -- 委托服务类型
            ,sign_kind -- 协议类型
            ,sp_child_id -- 分局编号
            ,entente_dt -- 协约日期
            ,involce_cd -- 取发票方式
            ,sign_control_ind -- 签约服务控制码
            ,curr_cd -- 币种
            ,cash_trans_cd -- 钞汇标志
            ,service_unit_name -- 委托单位名称
            ,service_unit_tpfa -- 委托单位第三方资金账号
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t05_pub_payment_sign_op(
            sign_contract_id -- 签约id
            ,agreement_id -- 签约编号
            ,agreement_item_seq_id -- 协议项编号
            ,payment_id -- 中间业务标识号
            ,legal_address_type -- 地址类型
            ,idtype -- 标识类型（证件标识）
            ,sign_id -- 协议书编号
            ,sp_id -- 第三方代码
            ,sp_sign_id -- 第三方协议号
            ,txn_limit -- 交易限额
            ,payment_mode -- 扣款方式
            ,day_limit -- 客户日累计限额
            ,month_limit -- 客户月累计限额
            ,service_num -- 委托服务号码
            ,service_name -- 委托服务户名
            ,service_type -- 委托服务类型
            ,sign_kind -- 协议类型
            ,sp_child_id -- 分局编号
            ,entente_dt -- 协约日期
            ,involce_cd -- 取发票方式
            ,sign_control_ind -- 签约服务控制码
            ,curr_cd -- 币种
            ,cash_trans_cd -- 钞汇标志
            ,service_unit_name -- 委托单位名称
            ,service_unit_tpfa -- 委托单位第三方资金账号
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sign_contract_id -- 签约id
    ,o.agreement_id -- 签约编号
    ,o.agreement_item_seq_id -- 协议项编号
    ,o.payment_id -- 中间业务标识号
    ,o.legal_address_type -- 地址类型
    ,o.idtype -- 标识类型（证件标识）
    ,o.sign_id -- 协议书编号
    ,o.sp_id -- 第三方代码
    ,o.sp_sign_id -- 第三方协议号
    ,o.txn_limit -- 交易限额
    ,o.payment_mode -- 扣款方式
    ,o.day_limit -- 客户日累计限额
    ,o.month_limit -- 客户月累计限额
    ,o.service_num -- 委托服务号码
    ,o.service_name -- 委托服务户名
    ,o.service_type -- 委托服务类型
    ,o.sign_kind -- 协议类型
    ,o.sp_child_id -- 分局编号
    ,o.entente_dt -- 协约日期
    ,o.involce_cd -- 取发票方式
    ,o.sign_control_ind -- 签约服务控制码
    ,o.curr_cd -- 币种
    ,o.cash_trans_cd -- 钞汇标志
    ,o.service_unit_name -- 委托单位名称
    ,o.service_unit_tpfa -- 委托单位第三方资金账号
    ,o.create_te -- 创建柜员
    ,o.create_org -- 创建机构号
    ,o.init_system_id -- 创建渠道
    ,o.init_created_ts -- 源系统创建时间
    ,o.created_ts -- 进入ecif的时间
    ,o.updated_ts -- 在ecif中失效的时间
    ,o.last_updated_te -- 最新更新柜员
    ,o.last_updated_org -- 最新更新机构号
    ,o.last_system_id -- 最新更新渠道
    ,o.last_updated_ts -- 最新更新时间
    ,o.src_sys_num -- 来源系统编号
    ,o.last_updated_src_sys_num -- 最新更新源系统编号
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
from ${iol_schema}.eifs_t05_pub_payment_sign_bk o
    left join ${iol_schema}.eifs_t05_pub_payment_sign_op n
        on
            o.sign_contract_id = n.sign_contract_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t05_pub_payment_sign_cl d
        on
            o.sign_contract_id = d.sign_contract_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t05_pub_payment_sign;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t05_pub_payment_sign') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t05_pub_payment_sign drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t05_pub_payment_sign add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t05_pub_payment_sign exchange partition p_${batch_date} with table ${iol_schema}.eifs_t05_pub_payment_sign_cl;
alter table ${iol_schema}.eifs_t05_pub_payment_sign exchange partition p_20991231 with table ${iol_schema}.eifs_t05_pub_payment_sign_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t05_pub_payment_sign to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t05_pub_payment_sign_op purge;
drop table ${iol_schema}.eifs_t05_pub_payment_sign_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t05_pub_payment_sign_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t05_pub_payment_sign',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
