/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_pbs_account_inf
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
create table ${iol_schema}.osbs_pbs_account_inf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_pbs_account_inf
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_pbs_account_inf_op purge;
drop table ${iol_schema}.osbs_pbs_account_inf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_account_inf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_pbs_account_inf where 0=1;

create table ${iol_schema}.osbs_pbs_account_inf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_pbs_account_inf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_pbs_account_inf_cl(
            pai_ecifno -- 全行统一客户号
            ,pai_userno -- 用户顺序号
            ,pai_accno -- 账号
            ,pai_acctype -- 账号类型
            ,pai_accname -- 账户名称
            ,pai_currency -- 币种
            ,pai_authorization -- 账户权限
            ,pai_opendate -- 账户挂入日期
            ,pai_opennode -- 账户开户机构
            ,pai_openbranch -- 账户开户网点名称
            ,pai_addnode -- 账户加挂机构
            ,pai_addbranch -- 账户加挂网点名称
            ,pai_state -- 状态
            ,pai_accalias -- 账户别名
            ,pai_signway -- 签约方式
            ,pai_signchannel -- 签约渠道
            ,pai_pauserremark -- 账户暂停原因
            ,pai_cardtype -- 合作卡类型
            ,pai_accountorder -- 
            ,pai_asacno -- 卡折关联账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_pbs_account_inf_op(
            pai_ecifno -- 全行统一客户号
            ,pai_userno -- 用户顺序号
            ,pai_accno -- 账号
            ,pai_acctype -- 账号类型
            ,pai_accname -- 账户名称
            ,pai_currency -- 币种
            ,pai_authorization -- 账户权限
            ,pai_opendate -- 账户挂入日期
            ,pai_opennode -- 账户开户机构
            ,pai_openbranch -- 账户开户网点名称
            ,pai_addnode -- 账户加挂机构
            ,pai_addbranch -- 账户加挂网点名称
            ,pai_state -- 状态
            ,pai_accalias -- 账户别名
            ,pai_signway -- 签约方式
            ,pai_signchannel -- 签约渠道
            ,pai_pauserremark -- 账户暂停原因
            ,pai_cardtype -- 合作卡类型
            ,pai_accountorder -- 
            ,pai_asacno -- 卡折关联账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pai_ecifno, o.pai_ecifno) as pai_ecifno -- 全行统一客户号
    ,nvl(n.pai_userno, o.pai_userno) as pai_userno -- 用户顺序号
    ,nvl(n.pai_accno, o.pai_accno) as pai_accno -- 账号
    ,nvl(n.pai_acctype, o.pai_acctype) as pai_acctype -- 账号类型
    ,nvl(n.pai_accname, o.pai_accname) as pai_accname -- 账户名称
    ,nvl(n.pai_currency, o.pai_currency) as pai_currency -- 币种
    ,nvl(n.pai_authorization, o.pai_authorization) as pai_authorization -- 账户权限
    ,nvl(n.pai_opendate, o.pai_opendate) as pai_opendate -- 账户挂入日期
    ,nvl(n.pai_opennode, o.pai_opennode) as pai_opennode -- 账户开户机构
    ,nvl(n.pai_openbranch, o.pai_openbranch) as pai_openbranch -- 账户开户网点名称
    ,nvl(n.pai_addnode, o.pai_addnode) as pai_addnode -- 账户加挂机构
    ,nvl(n.pai_addbranch, o.pai_addbranch) as pai_addbranch -- 账户加挂网点名称
    ,nvl(n.pai_state, o.pai_state) as pai_state -- 状态
    ,nvl(n.pai_accalias, o.pai_accalias) as pai_accalias -- 账户别名
    ,nvl(n.pai_signway, o.pai_signway) as pai_signway -- 签约方式
    ,nvl(n.pai_signchannel, o.pai_signchannel) as pai_signchannel -- 签约渠道
    ,nvl(n.pai_pauserremark, o.pai_pauserremark) as pai_pauserremark -- 账户暂停原因
    ,nvl(n.pai_cardtype, o.pai_cardtype) as pai_cardtype -- 合作卡类型
    ,nvl(n.pai_accountorder, o.pai_accountorder) as pai_accountorder -- 
    ,nvl(n.pai_asacno, o.pai_asacno) as pai_asacno -- 卡折关联账号
    ,case when
            n.pai_ecifno is null
            and n.pai_accno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pai_ecifno is null
            and n.pai_accno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pai_ecifno is null
            and n.pai_accno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_pbs_account_inf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_pbs_account_inf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pai_ecifno = n.pai_ecifno
            and o.pai_accno = n.pai_accno
where (
        o.pai_ecifno is null
        and o.pai_accno is null
    )
    or (
        n.pai_ecifno is null
        and n.pai_accno is null
    )
    or (
        o.pai_userno <> n.pai_userno
        or o.pai_acctype <> n.pai_acctype
        or o.pai_accname <> n.pai_accname
        or o.pai_currency <> n.pai_currency
        or o.pai_authorization <> n.pai_authorization
        or o.pai_opendate <> n.pai_opendate
        or o.pai_opennode <> n.pai_opennode
        or o.pai_openbranch <> n.pai_openbranch
        or o.pai_addnode <> n.pai_addnode
        or o.pai_addbranch <> n.pai_addbranch
        or o.pai_state <> n.pai_state
        or o.pai_accalias <> n.pai_accalias
        or o.pai_signway <> n.pai_signway
        or o.pai_signchannel <> n.pai_signchannel
        or o.pai_pauserremark <> n.pai_pauserremark
        or o.pai_cardtype <> n.pai_cardtype
        or o.pai_accountorder <> n.pai_accountorder
        or o.pai_asacno <> n.pai_asacno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_pbs_account_inf_cl(
            pai_ecifno -- 全行统一客户号
            ,pai_userno -- 用户顺序号
            ,pai_accno -- 账号
            ,pai_acctype -- 账号类型
            ,pai_accname -- 账户名称
            ,pai_currency -- 币种
            ,pai_authorization -- 账户权限
            ,pai_opendate -- 账户挂入日期
            ,pai_opennode -- 账户开户机构
            ,pai_openbranch -- 账户开户网点名称
            ,pai_addnode -- 账户加挂机构
            ,pai_addbranch -- 账户加挂网点名称
            ,pai_state -- 状态
            ,pai_accalias -- 账户别名
            ,pai_signway -- 签约方式
            ,pai_signchannel -- 签约渠道
            ,pai_pauserremark -- 账户暂停原因
            ,pai_cardtype -- 合作卡类型
            ,pai_accountorder -- 
            ,pai_asacno -- 卡折关联账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_pbs_account_inf_op(
            pai_ecifno -- 全行统一客户号
            ,pai_userno -- 用户顺序号
            ,pai_accno -- 账号
            ,pai_acctype -- 账号类型
            ,pai_accname -- 账户名称
            ,pai_currency -- 币种
            ,pai_authorization -- 账户权限
            ,pai_opendate -- 账户挂入日期
            ,pai_opennode -- 账户开户机构
            ,pai_openbranch -- 账户开户网点名称
            ,pai_addnode -- 账户加挂机构
            ,pai_addbranch -- 账户加挂网点名称
            ,pai_state -- 状态
            ,pai_accalias -- 账户别名
            ,pai_signway -- 签约方式
            ,pai_signchannel -- 签约渠道
            ,pai_pauserremark -- 账户暂停原因
            ,pai_cardtype -- 合作卡类型
            ,pai_accountorder -- 
            ,pai_asacno -- 卡折关联账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pai_ecifno -- 全行统一客户号
    ,o.pai_userno -- 用户顺序号
    ,o.pai_accno -- 账号
    ,o.pai_acctype -- 账号类型
    ,o.pai_accname -- 账户名称
    ,o.pai_currency -- 币种
    ,o.pai_authorization -- 账户权限
    ,o.pai_opendate -- 账户挂入日期
    ,o.pai_opennode -- 账户开户机构
    ,o.pai_openbranch -- 账户开户网点名称
    ,o.pai_addnode -- 账户加挂机构
    ,o.pai_addbranch -- 账户加挂网点名称
    ,o.pai_state -- 状态
    ,o.pai_accalias -- 账户别名
    ,o.pai_signway -- 签约方式
    ,o.pai_signchannel -- 签约渠道
    ,o.pai_pauserremark -- 账户暂停原因
    ,o.pai_cardtype -- 合作卡类型
    ,o.pai_accountorder -- 
    ,o.pai_asacno -- 卡折关联账号
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
from ${iol_schema}.osbs_pbs_account_inf_bk o
    left join ${iol_schema}.osbs_pbs_account_inf_op n
        on
            o.pai_ecifno = n.pai_ecifno
            and o.pai_accno = n.pai_accno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_pbs_account_inf_cl d
        on
            o.pai_ecifno = d.pai_ecifno
            and o.pai_accno = d.pai_accno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.osbs_pbs_account_inf;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('osbs_pbs_account_inf') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.osbs_pbs_account_inf drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.osbs_pbs_account_inf add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.osbs_pbs_account_inf exchange partition p_${batch_date} with table ${iol_schema}.osbs_pbs_account_inf_cl;
alter table ${iol_schema}.osbs_pbs_account_inf exchange partition p_20991231 with table ${iol_schema}.osbs_pbs_account_inf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_pbs_account_inf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_pbs_account_inf_op purge;
drop table ${iol_schema}.osbs_pbs_account_inf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_pbs_account_inf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_pbs_account_inf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
