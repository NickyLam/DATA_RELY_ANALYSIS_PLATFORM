/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_acc_secu
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
create table ${iol_schema}.ibms_ttrd_acc_secu_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_acc_secu;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_acc_secu_op purge;
drop table ${iol_schema}.ibms_ttrd_acc_secu_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_acc_secu_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_acc_secu where 0=1;

create table ${iol_schema}.ibms_ttrd_acc_secu_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_acc_secu where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_acc_secu_cl(
            accid -- 账户代码
            ,accname -- 账户名称
            ,cash_accid -- 二级资金账户
            ,owner -- 所有者
            ,trdkind -- 交易目的
            ,trdgrpid -- 交易组
            ,ps1 -- 证券账户属性1  理财销售账户对应理财产品i_code,其他账户则该字段为0
            ,ps2 -- 证券账户属性2 对应的会计账号id
            ,ps3 -- 证券账户属性3 理财产品账号对应的理财产品的外部资金账号
            ,ps4 -- 证券账户属性4
            ,status -- 账户状态 0新建 11 正常 3已停用
            ,trdgrp_auto -- 是否自动创建交易组
            ,is_lock -- 是否锁定
            ,lockstatus -- 锁定状态
            ,accfiscasubject -- 等待补充
            ,ps5 -- 等待补充
            ,ps6 -- 等待补充
            ,ps7 -- 等待补充
            ,ps8 -- 等待补充
            ,invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
            ,acting_type -- 会计分类:1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类
            ,i_id -- 机构号
            ,unit_id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_acc_secu_op(
            accid -- 账户代码
            ,accname -- 账户名称
            ,cash_accid -- 二级资金账户
            ,owner -- 所有者
            ,trdkind -- 交易目的
            ,trdgrpid -- 交易组
            ,ps1 -- 证券账户属性1  理财销售账户对应理财产品i_code,其他账户则该字段为0
            ,ps2 -- 证券账户属性2 对应的会计账号id
            ,ps3 -- 证券账户属性3 理财产品账号对应的理财产品的外部资金账号
            ,ps4 -- 证券账户属性4
            ,status -- 账户状态 0新建 11 正常 3已停用
            ,trdgrp_auto -- 是否自动创建交易组
            ,is_lock -- 是否锁定
            ,lockstatus -- 锁定状态
            ,accfiscasubject -- 等待补充
            ,ps5 -- 等待补充
            ,ps6 -- 等待补充
            ,ps7 -- 等待补充
            ,ps8 -- 等待补充
            ,invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
            ,acting_type -- 会计分类:1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类
            ,i_id -- 机构号
            ,unit_id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.accid, o.accid) as accid -- 账户代码
    ,nvl(n.accname, o.accname) as accname -- 账户名称
    ,nvl(n.cash_accid, o.cash_accid) as cash_accid -- 二级资金账户
    ,nvl(n.owner, o.owner) as owner -- 所有者
    ,nvl(n.trdkind, o.trdkind) as trdkind -- 交易目的
    ,nvl(n.trdgrpid, o.trdgrpid) as trdgrpid -- 交易组
    ,nvl(n.ps1, o.ps1) as ps1 -- 证券账户属性1  理财销售账户对应理财产品i_code,其他账户则该字段为0
    ,nvl(n.ps2, o.ps2) as ps2 -- 证券账户属性2 对应的会计账号id
    ,nvl(n.ps3, o.ps3) as ps3 -- 证券账户属性3 理财产品账号对应的理财产品的外部资金账号
    ,nvl(n.ps4, o.ps4) as ps4 -- 证券账户属性4
    ,nvl(n.status, o.status) as status -- 账户状态 0新建 11 正常 3已停用
    ,nvl(n.trdgrp_auto, o.trdgrp_auto) as trdgrp_auto -- 是否自动创建交易组
    ,nvl(n.is_lock, o.is_lock) as is_lock -- 是否锁定
    ,nvl(n.lockstatus, o.lockstatus) as lockstatus -- 锁定状态
    ,nvl(n.accfiscasubject, o.accfiscasubject) as accfiscasubject -- 等待补充
    ,nvl(n.ps5, o.ps5) as ps5 -- 等待补充
    ,nvl(n.ps6, o.ps6) as ps6 -- 等待补充
    ,nvl(n.ps7, o.ps7) as ps7 -- 等待补充
    ,nvl(n.ps8, o.ps8) as ps8 -- 等待补充
    ,nvl(n.invest_type, o.invest_type) as invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
    ,nvl(n.acting_type, o.acting_type) as acting_type -- 会计分类:1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类
    ,nvl(n.i_id, o.i_id) as i_id -- 机构号
    ,nvl(n.unit_id, o.unit_id) as unit_id -- 
    ,case when
            n.accid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.accid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.accid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_acc_secu_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_acc_secu where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.accid = n.accid
where (
        o.accid is null
    )
    or (
        n.accid is null
    )
    or (
        o.accname <> n.accname
        or o.cash_accid <> n.cash_accid
        or o.owner <> n.owner
        or o.trdkind <> n.trdkind
        or o.trdgrpid <> n.trdgrpid
        or o.ps1 <> n.ps1
        or o.ps2 <> n.ps2
        or o.ps3 <> n.ps3
        or o.ps4 <> n.ps4
        or o.status <> n.status
        or o.trdgrp_auto <> n.trdgrp_auto
        or o.is_lock <> n.is_lock
        or o.lockstatus <> n.lockstatus
        or o.accfiscasubject <> n.accfiscasubject
        or o.ps5 <> n.ps5
        or o.ps6 <> n.ps6
        or o.ps7 <> n.ps7
        or o.ps8 <> n.ps8
        or o.invest_type <> n.invest_type
        or o.acting_type <> n.acting_type
        or o.i_id <> n.i_id
        or o.unit_id <> n.unit_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_acc_secu_cl(
            accid -- 账户代码
            ,accname -- 账户名称
            ,cash_accid -- 二级资金账户
            ,owner -- 所有者
            ,trdkind -- 交易目的
            ,trdgrpid -- 交易组
            ,ps1 -- 证券账户属性1  理财销售账户对应理财产品i_code,其他账户则该字段为0
            ,ps2 -- 证券账户属性2 对应的会计账号id
            ,ps3 -- 证券账户属性3 理财产品账号对应的理财产品的外部资金账号
            ,ps4 -- 证券账户属性4
            ,status -- 账户状态 0新建 11 正常 3已停用
            ,trdgrp_auto -- 是否自动创建交易组
            ,is_lock -- 是否锁定
            ,lockstatus -- 锁定状态
            ,accfiscasubject -- 等待补充
            ,ps5 -- 等待补充
            ,ps6 -- 等待补充
            ,ps7 -- 等待补充
            ,ps8 -- 等待补充
            ,invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
            ,acting_type -- 会计分类:1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类
            ,i_id -- 机构号
            ,unit_id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_acc_secu_op(
            accid -- 账户代码
            ,accname -- 账户名称
            ,cash_accid -- 二级资金账户
            ,owner -- 所有者
            ,trdkind -- 交易目的
            ,trdgrpid -- 交易组
            ,ps1 -- 证券账户属性1  理财销售账户对应理财产品i_code,其他账户则该字段为0
            ,ps2 -- 证券账户属性2 对应的会计账号id
            ,ps3 -- 证券账户属性3 理财产品账号对应的理财产品的外部资金账号
            ,ps4 -- 证券账户属性4
            ,status -- 账户状态 0新建 11 正常 3已停用
            ,trdgrp_auto -- 是否自动创建交易组
            ,is_lock -- 是否锁定
            ,lockstatus -- 锁定状态
            ,accfiscasubject -- 等待补充
            ,ps5 -- 等待补充
            ,ps6 -- 等待补充
            ,ps7 -- 等待补充
            ,ps8 -- 等待补充
            ,invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
            ,acting_type -- 会计分类:1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类
            ,i_id -- 机构号
            ,unit_id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.accid -- 账户代码
    ,o.accname -- 账户名称
    ,o.cash_accid -- 二级资金账户
    ,o.owner -- 所有者
    ,o.trdkind -- 交易目的
    ,o.trdgrpid -- 交易组
    ,o.ps1 -- 证券账户属性1  理财销售账户对应理财产品i_code,其他账户则该字段为0
    ,o.ps2 -- 证券账户属性2 对应的会计账号id
    ,o.ps3 -- 证券账户属性3 理财产品账号对应的理财产品的外部资金账号
    ,o.ps4 -- 证券账户属性4
    ,o.status -- 账户状态 0新建 11 正常 3已停用
    ,o.trdgrp_auto -- 是否自动创建交易组
    ,o.is_lock -- 是否锁定
    ,o.lockstatus -- 锁定状态
    ,o.accfiscasubject -- 等待补充
    ,o.ps5 -- 等待补充
    ,o.ps6 -- 等待补充
    ,o.ps7 -- 等待补充
    ,o.ps8 -- 等待补充
    ,o.invest_type -- 0自有资产（自营业务）、1客户资产（代客、理财）
    ,o.acting_type -- 会计分类:1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类
    ,o.i_id -- 机构号
    ,o.unit_id -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_acc_secu_bk o
    left join ${iol_schema}.ibms_ttrd_acc_secu_op n
        on
            o.accid = n.accid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_acc_secu_cl d
        on
            o.accid = d.accid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_acc_secu;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_acc_secu exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_acc_secu_cl;
alter table ${iol_schema}.ibms_ttrd_acc_secu exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_acc_secu_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_acc_secu to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_acc_secu_op purge;
drop table ${iol_schema}.ibms_ttrd_acc_secu_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_acc_secu_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_acc_secu',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
