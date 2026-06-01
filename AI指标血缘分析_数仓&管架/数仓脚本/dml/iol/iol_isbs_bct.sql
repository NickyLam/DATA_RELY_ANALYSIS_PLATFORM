/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_bct
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
create table ${iol_schema}.isbs_bct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_bct;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bct_op purge;
drop table ${iol_schema}.isbs_bct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bct where 0=1;

create table ${iol_schema}.isbs_bct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bct_cl(
            inr -- 代收ID号
            ,resrej -- 拒付/据单的原因
            ,bcgque -- 查询
            ,bcgans -- 回答
            ,docpre -- 提示单据
            ,bcgdet -- 代收细节
            ,othins -- 其他指示
            ,bctfre -- 自由文本信息
            ,vesselnam -- 船名
            ,covgod -- 头寸货物
            ,colins -- 收货说明
            ,dftins -- 票据说明
            ,chgtxt -- 费用文本
            ,intins -- 利息说明
            ,fldmodblk -- 修改域的列表
            ,reladr -- 放货地址
            ,colinssnm -- 托收说明
            ,proins -- 不符点
            ,contag72 -- tag72的记录
            ,contag79 -- tag79的记录
            ,bcgdetdef -- 要求说明
            ,bcgdetflg -- 要求修改的标志
            ,agtaut -- 420电文的43G
            ,agtinf -- 420电文的43H
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bct_op(
            inr -- 代收ID号
            ,resrej -- 拒付/据单的原因
            ,bcgque -- 查询
            ,bcgans -- 回答
            ,docpre -- 提示单据
            ,bcgdet -- 代收细节
            ,othins -- 其他指示
            ,bctfre -- 自由文本信息
            ,vesselnam -- 船名
            ,covgod -- 头寸货物
            ,colins -- 收货说明
            ,dftins -- 票据说明
            ,chgtxt -- 费用文本
            ,intins -- 利息说明
            ,fldmodblk -- 修改域的列表
            ,reladr -- 放货地址
            ,colinssnm -- 托收说明
            ,proins -- 不符点
            ,contag72 -- tag72的记录
            ,contag79 -- tag79的记录
            ,bcgdetdef -- 要求说明
            ,bcgdetflg -- 要求修改的标志
            ,agtaut -- 420电文的43G
            ,agtinf -- 420电文的43H
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 代收ID号
    ,nvl(n.resrej, o.resrej) as resrej -- 拒付/据单的原因
    ,nvl(n.bcgque, o.bcgque) as bcgque -- 查询
    ,nvl(n.bcgans, o.bcgans) as bcgans -- 回答
    ,nvl(n.docpre, o.docpre) as docpre -- 提示单据
    ,nvl(n.bcgdet, o.bcgdet) as bcgdet -- 代收细节
    ,nvl(n.othins, o.othins) as othins -- 其他指示
    ,nvl(n.bctfre, o.bctfre) as bctfre -- 自由文本信息
    ,nvl(n.vesselnam, o.vesselnam) as vesselnam -- 船名
    ,nvl(n.covgod, o.covgod) as covgod -- 头寸货物
    ,nvl(n.colins, o.colins) as colins -- 收货说明
    ,nvl(n.dftins, o.dftins) as dftins -- 票据说明
    ,nvl(n.chgtxt, o.chgtxt) as chgtxt -- 费用文本
    ,nvl(n.intins, o.intins) as intins -- 利息说明
    ,nvl(n.fldmodblk, o.fldmodblk) as fldmodblk -- 修改域的列表
    ,nvl(n.reladr, o.reladr) as reladr -- 放货地址
    ,nvl(n.colinssnm, o.colinssnm) as colinssnm -- 托收说明
    ,nvl(n.proins, o.proins) as proins -- 不符点
    ,nvl(n.contag72, o.contag72) as contag72 -- tag72的记录
    ,nvl(n.contag79, o.contag79) as contag79 -- tag79的记录
    ,nvl(n.bcgdetdef, o.bcgdetdef) as bcgdetdef -- 要求说明
    ,nvl(n.bcgdetflg, o.bcgdetflg) as bcgdetflg -- 要求修改的标志
    ,nvl(n.agtaut, o.agtaut) as agtaut -- 420电文的43G
    ,nvl(n.agtinf, o.agtinf) as agtinf -- 420电文的43H
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
from (select * from ${iol_schema}.isbs_bct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_bct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.resrej <> n.resrej
        or o.bcgque <> n.bcgque
        or o.bcgans <> n.bcgans
        or o.docpre <> n.docpre
        or o.bcgdet <> n.bcgdet
        or o.othins <> n.othins
        or o.bctfre <> n.bctfre
        or o.vesselnam <> n.vesselnam
        or o.covgod <> n.covgod
        or o.colins <> n.colins
        or o.dftins <> n.dftins
        or o.chgtxt <> n.chgtxt
        or o.intins <> n.intins
        or o.fldmodblk <> n.fldmodblk
        or o.reladr <> n.reladr
        or o.colinssnm <> n.colinssnm
        or o.proins <> n.proins
        or o.contag72 <> n.contag72
        or o.contag79 <> n.contag79
        or o.bcgdetdef <> n.bcgdetdef
        or o.bcgdetflg <> n.bcgdetflg
        or o.agtaut <> n.agtaut
        or o.agtinf <> n.agtinf
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bct_cl(
            inr -- 代收ID号
            ,resrej -- 拒付/据单的原因
            ,bcgque -- 查询
            ,bcgans -- 回答
            ,docpre -- 提示单据
            ,bcgdet -- 代收细节
            ,othins -- 其他指示
            ,bctfre -- 自由文本信息
            ,vesselnam -- 船名
            ,covgod -- 头寸货物
            ,colins -- 收货说明
            ,dftins -- 票据说明
            ,chgtxt -- 费用文本
            ,intins -- 利息说明
            ,fldmodblk -- 修改域的列表
            ,reladr -- 放货地址
            ,colinssnm -- 托收说明
            ,proins -- 不符点
            ,contag72 -- tag72的记录
            ,contag79 -- tag79的记录
            ,bcgdetdef -- 要求说明
            ,bcgdetflg -- 要求修改的标志
            ,agtaut -- 420电文的43G
            ,agtinf -- 420电文的43H
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bct_op(
            inr -- 代收ID号
            ,resrej -- 拒付/据单的原因
            ,bcgque -- 查询
            ,bcgans -- 回答
            ,docpre -- 提示单据
            ,bcgdet -- 代收细节
            ,othins -- 其他指示
            ,bctfre -- 自由文本信息
            ,vesselnam -- 船名
            ,covgod -- 头寸货物
            ,colins -- 收货说明
            ,dftins -- 票据说明
            ,chgtxt -- 费用文本
            ,intins -- 利息说明
            ,fldmodblk -- 修改域的列表
            ,reladr -- 放货地址
            ,colinssnm -- 托收说明
            ,proins -- 不符点
            ,contag72 -- tag72的记录
            ,contag79 -- tag79的记录
            ,bcgdetdef -- 要求说明
            ,bcgdetflg -- 要求修改的标志
            ,agtaut -- 420电文的43G
            ,agtinf -- 420电文的43H
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 代收ID号
    ,o.resrej -- 拒付/据单的原因
    ,o.bcgque -- 查询
    ,o.bcgans -- 回答
    ,o.docpre -- 提示单据
    ,o.bcgdet -- 代收细节
    ,o.othins -- 其他指示
    ,o.bctfre -- 自由文本信息
    ,o.vesselnam -- 船名
    ,o.covgod -- 头寸货物
    ,o.colins -- 收货说明
    ,o.dftins -- 票据说明
    ,o.chgtxt -- 费用文本
    ,o.intins -- 利息说明
    ,o.fldmodblk -- 修改域的列表
    ,o.reladr -- 放货地址
    ,o.colinssnm -- 托收说明
    ,o.proins -- 不符点
    ,o.contag72 -- tag72的记录
    ,o.contag79 -- tag79的记录
    ,o.bcgdetdef -- 要求说明
    ,o.bcgdetflg -- 要求修改的标志
    ,o.agtaut -- 420电文的43G
    ,o.agtinf -- 420电文的43H
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_bct_bk o
    left join ${iol_schema}.isbs_bct_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bct_cl d
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
-- truncate table ${iol_schema}.isbs_bct;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_bct exchange partition p_19000101 with table ${iol_schema}.isbs_bct_cl;
alter table ${iol_schema}.isbs_bct exchange partition p_20991231 with table ${iol_schema}.isbs_bct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_bct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bct_op purge;
drop table ${iol_schema}.isbs_bct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_bct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_bct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
