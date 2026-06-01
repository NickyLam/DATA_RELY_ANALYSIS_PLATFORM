/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_djb
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
create table ${iol_schema}.isbs_djb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_djb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_djb_op purge;
drop table ${iol_schema}.isbs_djb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_djb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_djb where 0=1;

create table ${iol_schema}.isbs_djb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_djb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_djb_cl(
            inr -- 主键
            ,trninr -- trn表inr
            ,objinr -- 关联表inr
            ,objtyp -- 关联表类型
            ,thisint -- 本次代付利息金额
            ,thisdefint -- 本次代付罚息
            ,thisamt -- 本次代付本金金额
            ,stttendat -- 付款期限开始时间
            ,ownref -- 业务编号
            ,opertyp -- 操作类型
            ,matdat -- 交易到期
            ,jjh -- 借据号
            ,iflastcol -- 是否最后一次归集
            ,extkey -- 客户号
            ,dfrate -- 代付利率
            ,dfdelrate -- 代付罚息利率
            ,cur -- 代付币种
            ,amt -- 代付金额
            ,irtmic -- 计息基准
            ,intadjamt -- 利息调整金额
            ,deladjamt -- 罚息调整金额
            ,sl_contract_no -- 贷款合同号
            ,home_branch -- 客户管理行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_djb_op(
            inr -- 主键
            ,trninr -- trn表inr
            ,objinr -- 关联表inr
            ,objtyp -- 关联表类型
            ,thisint -- 本次代付利息金额
            ,thisdefint -- 本次代付罚息
            ,thisamt -- 本次代付本金金额
            ,stttendat -- 付款期限开始时间
            ,ownref -- 业务编号
            ,opertyp -- 操作类型
            ,matdat -- 交易到期
            ,jjh -- 借据号
            ,iflastcol -- 是否最后一次归集
            ,extkey -- 客户号
            ,dfrate -- 代付利率
            ,dfdelrate -- 代付罚息利率
            ,cur -- 代付币种
            ,amt -- 代付金额
            ,irtmic -- 计息基准
            ,intadjamt -- 利息调整金额
            ,deladjamt -- 罚息调整金额
            ,sl_contract_no -- 贷款合同号
            ,home_branch -- 客户管理行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 主键
    ,nvl(n.trninr, o.trninr) as trninr -- trn表inr
    ,nvl(n.objinr, o.objinr) as objinr -- 关联表inr
    ,nvl(n.objtyp, o.objtyp) as objtyp -- 关联表类型
    ,nvl(n.thisint, o.thisint) as thisint -- 本次代付利息金额
    ,nvl(n.thisdefint, o.thisdefint) as thisdefint -- 本次代付罚息
    ,nvl(n.thisamt, o.thisamt) as thisamt -- 本次代付本金金额
    ,nvl(n.stttendat, o.stttendat) as stttendat -- 付款期限开始时间
    ,nvl(n.ownref, o.ownref) as ownref -- 业务编号
    ,nvl(n.opertyp, o.opertyp) as opertyp -- 操作类型
    ,nvl(n.matdat, o.matdat) as matdat -- 交易到期
    ,nvl(n.jjh, o.jjh) as jjh -- 借据号
    ,nvl(n.iflastcol, o.iflastcol) as iflastcol -- 是否最后一次归集
    ,nvl(n.extkey, o.extkey) as extkey -- 客户号
    ,nvl(n.dfrate, o.dfrate) as dfrate -- 代付利率
    ,nvl(n.dfdelrate, o.dfdelrate) as dfdelrate -- 代付罚息利率
    ,nvl(n.cur, o.cur) as cur -- 代付币种
    ,nvl(n.amt, o.amt) as amt -- 代付金额
    ,nvl(n.irtmic, o.irtmic) as irtmic -- 计息基准
    ,nvl(n.intadjamt, o.intadjamt) as intadjamt -- 利息调整金额
    ,nvl(n.deladjamt, o.deladjamt) as deladjamt -- 罚息调整金额
    ,nvl(n.sl_contract_no, o.sl_contract_no) as sl_contract_no -- 贷款合同号
    ,nvl(n.home_branch, o.home_branch) as home_branch -- 客户管理行
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_djb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_djb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.trninr <> n.trninr
        or o.objinr <> n.objinr
        or o.objtyp <> n.objtyp
        or o.thisint <> n.thisint
        or o.thisdefint <> n.thisdefint
        or o.thisamt <> n.thisamt
        or o.stttendat <> n.stttendat
        or o.ownref <> n.ownref
        or o.opertyp <> n.opertyp
        or o.matdat <> n.matdat
        or o.jjh <> n.jjh
        or o.iflastcol <> n.iflastcol
        or o.extkey <> n.extkey
        or o.dfrate <> n.dfrate
        or o.dfdelrate <> n.dfdelrate
        or o.cur <> n.cur
        or o.amt <> n.amt
        or o.irtmic <> n.irtmic
        or o.intadjamt <> n.intadjamt
        or o.deladjamt <> n.deladjamt
        or o.sl_contract_no <> n.sl_contract_no
        or o.home_branch <> n.home_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_djb_cl(
            inr -- 主键
            ,trninr -- trn表inr
            ,objinr -- 关联表inr
            ,objtyp -- 关联表类型
            ,thisint -- 本次代付利息金额
            ,thisdefint -- 本次代付罚息
            ,thisamt -- 本次代付本金金额
            ,stttendat -- 付款期限开始时间
            ,ownref -- 业务编号
            ,opertyp -- 操作类型
            ,matdat -- 交易到期
            ,jjh -- 借据号
            ,iflastcol -- 是否最后一次归集
            ,extkey -- 客户号
            ,dfrate -- 代付利率
            ,dfdelrate -- 代付罚息利率
            ,cur -- 代付币种
            ,amt -- 代付金额
            ,irtmic -- 计息基准
            ,intadjamt -- 利息调整金额
            ,deladjamt -- 罚息调整金额
            ,sl_contract_no -- 贷款合同号
            ,home_branch -- 客户管理行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_djb_op(
            inr -- 主键
            ,trninr -- trn表inr
            ,objinr -- 关联表inr
            ,objtyp -- 关联表类型
            ,thisint -- 本次代付利息金额
            ,thisdefint -- 本次代付罚息
            ,thisamt -- 本次代付本金金额
            ,stttendat -- 付款期限开始时间
            ,ownref -- 业务编号
            ,opertyp -- 操作类型
            ,matdat -- 交易到期
            ,jjh -- 借据号
            ,iflastcol -- 是否最后一次归集
            ,extkey -- 客户号
            ,dfrate -- 代付利率
            ,dfdelrate -- 代付罚息利率
            ,cur -- 代付币种
            ,amt -- 代付金额
            ,irtmic -- 计息基准
            ,intadjamt -- 利息调整金额
            ,deladjamt -- 罚息调整金额
            ,sl_contract_no -- 贷款合同号
            ,home_branch -- 客户管理行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 主键
    ,o.trninr -- trn表inr
    ,o.objinr -- 关联表inr
    ,o.objtyp -- 关联表类型
    ,o.thisint -- 本次代付利息金额
    ,o.thisdefint -- 本次代付罚息
    ,o.thisamt -- 本次代付本金金额
    ,o.stttendat -- 付款期限开始时间
    ,o.ownref -- 业务编号
    ,o.opertyp -- 操作类型
    ,o.matdat -- 交易到期
    ,o.jjh -- 借据号
    ,o.iflastcol -- 是否最后一次归集
    ,o.extkey -- 客户号
    ,o.dfrate -- 代付利率
    ,o.dfdelrate -- 代付罚息利率
    ,o.cur -- 代付币种
    ,o.amt -- 代付金额
    ,o.irtmic -- 计息基准
    ,o.intadjamt -- 利息调整金额
    ,o.deladjamt -- 罚息调整金额
    ,o.sl_contract_no -- 贷款合同号
    ,o.home_branch -- 客户管理行
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
from ${iol_schema}.isbs_djb_bk o
    left join ${iol_schema}.isbs_djb_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_djb_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.isbs_djb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_djb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_djb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_djb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_djb exchange partition p_${batch_date} with table ${iol_schema}.isbs_djb_cl;
alter table ${iol_schema}.isbs_djb exchange partition p_20991231 with table ${iol_schema}.isbs_djb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_djb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_djb_op purge;
drop table ${iol_schema}.isbs_djb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_djb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_djb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
