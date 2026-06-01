/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_bot
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
create table ${iol_schema}.isbs_bot_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_bot;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bot_op purge;
drop table ${iol_schema}.isbs_bot_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bot_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bot where 0=1;

create table ${iol_schema}.isbs_bot_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bot where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bot_cl(
            inr -- 出口托收交易ID号
            ,resrej -- 拒付原因
            ,docpre -- 提示单据
            ,bogdet -- 出口托收细节
            ,vesselnam -- 船名
            ,goddes -- 货物描述
            ,colins -- 托收说明
            ,dftins -- 单据说明
            ,proins -- 拒付说明
            ,chgtxt -- 费用文本
            ,narhis -- 叙说历史性修改
            ,othins -- 其他说明
            ,fldmodblk -- 修改BOD字段列表
            ,cctinsrcv -- 收到指示
            ,cctinscol -- 托收指示
            ,colinssnm -- 放单指示
            ,intins -- 利息说明
            ,agtaut -- 代理人当局
            ,contag72 -- tag 72内容
            ,contag79 -- tag79内容
            ,bogans -- 422电文的"Answer"
            ,bogque -- 422电文的"Query"
            ,setinsbo -- 付款指示
            ,colinsdef -- 默认放单指示
            ,colinsflg -- 修改放单指示
            ,delins -- 传送说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bot_op(
            inr -- 出口托收交易ID号
            ,resrej -- 拒付原因
            ,docpre -- 提示单据
            ,bogdet -- 出口托收细节
            ,vesselnam -- 船名
            ,goddes -- 货物描述
            ,colins -- 托收说明
            ,dftins -- 单据说明
            ,proins -- 拒付说明
            ,chgtxt -- 费用文本
            ,narhis -- 叙说历史性修改
            ,othins -- 其他说明
            ,fldmodblk -- 修改BOD字段列表
            ,cctinsrcv -- 收到指示
            ,cctinscol -- 托收指示
            ,colinssnm -- 放单指示
            ,intins -- 利息说明
            ,agtaut -- 代理人当局
            ,contag72 -- tag 72内容
            ,contag79 -- tag79内容
            ,bogans -- 422电文的"Answer"
            ,bogque -- 422电文的"Query"
            ,setinsbo -- 付款指示
            ,colinsdef -- 默认放单指示
            ,colinsflg -- 修改放单指示
            ,delins -- 传送说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 出口托收交易ID号
    ,nvl(n.resrej, o.resrej) as resrej -- 拒付原因
    ,nvl(n.docpre, o.docpre) as docpre -- 提示单据
    ,nvl(n.bogdet, o.bogdet) as bogdet -- 出口托收细节
    ,nvl(n.vesselnam, o.vesselnam) as vesselnam -- 船名
    ,nvl(n.goddes, o.goddes) as goddes -- 货物描述
    ,nvl(n.colins, o.colins) as colins -- 托收说明
    ,nvl(n.dftins, o.dftins) as dftins -- 单据说明
    ,nvl(n.proins, o.proins) as proins -- 拒付说明
    ,nvl(n.chgtxt, o.chgtxt) as chgtxt -- 费用文本
    ,nvl(n.narhis, o.narhis) as narhis -- 叙说历史性修改
    ,nvl(n.othins, o.othins) as othins -- 其他说明
    ,nvl(n.fldmodblk, o.fldmodblk) as fldmodblk -- 修改BOD字段列表
    ,nvl(n.cctinsrcv, o.cctinsrcv) as cctinsrcv -- 收到指示
    ,nvl(n.cctinscol, o.cctinscol) as cctinscol -- 托收指示
    ,nvl(n.colinssnm, o.colinssnm) as colinssnm -- 放单指示
    ,nvl(n.intins, o.intins) as intins -- 利息说明
    ,nvl(n.agtaut, o.agtaut) as agtaut -- 代理人当局
    ,nvl(n.contag72, o.contag72) as contag72 -- tag 72内容
    ,nvl(n.contag79, o.contag79) as contag79 -- tag79内容
    ,nvl(n.bogans, o.bogans) as bogans -- 422电文的"Answer"
    ,nvl(n.bogque, o.bogque) as bogque -- 422电文的"Query"
    ,nvl(n.setinsbo, o.setinsbo) as setinsbo -- 付款指示
    ,nvl(n.colinsdef, o.colinsdef) as colinsdef -- 默认放单指示
    ,nvl(n.colinsflg, o.colinsflg) as colinsflg -- 修改放单指示
    ,nvl(n.delins, o.delins) as delins -- 传送说明
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
from (select * from ${iol_schema}.isbs_bot_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_bot where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.docpre <> n.docpre
        or o.bogdet <> n.bogdet
        or o.vesselnam <> n.vesselnam
        or o.goddes <> n.goddes
        or o.colins <> n.colins
        or o.dftins <> n.dftins
        or o.proins <> n.proins
        or o.chgtxt <> n.chgtxt
        or o.narhis <> n.narhis
        or o.othins <> n.othins
        or o.fldmodblk <> n.fldmodblk
        or o.cctinsrcv <> n.cctinsrcv
        or o.cctinscol <> n.cctinscol
        or o.colinssnm <> n.colinssnm
        or o.intins <> n.intins
        or o.agtaut <> n.agtaut
        or o.contag72 <> n.contag72
        or o.contag79 <> n.contag79
        or o.bogans <> n.bogans
        or o.bogque <> n.bogque
        or o.setinsbo <> n.setinsbo
        or o.colinsdef <> n.colinsdef
        or o.colinsflg <> n.colinsflg
        or o.delins <> n.delins
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bot_cl(
            inr -- 出口托收交易ID号
            ,resrej -- 拒付原因
            ,docpre -- 提示单据
            ,bogdet -- 出口托收细节
            ,vesselnam -- 船名
            ,goddes -- 货物描述
            ,colins -- 托收说明
            ,dftins -- 单据说明
            ,proins -- 拒付说明
            ,chgtxt -- 费用文本
            ,narhis -- 叙说历史性修改
            ,othins -- 其他说明
            ,fldmodblk -- 修改BOD字段列表
            ,cctinsrcv -- 收到指示
            ,cctinscol -- 托收指示
            ,colinssnm -- 放单指示
            ,intins -- 利息说明
            ,agtaut -- 代理人当局
            ,contag72 -- tag 72内容
            ,contag79 -- tag79内容
            ,bogans -- 422电文的"Answer"
            ,bogque -- 422电文的"Query"
            ,setinsbo -- 付款指示
            ,colinsdef -- 默认放单指示
            ,colinsflg -- 修改放单指示
            ,delins -- 传送说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bot_op(
            inr -- 出口托收交易ID号
            ,resrej -- 拒付原因
            ,docpre -- 提示单据
            ,bogdet -- 出口托收细节
            ,vesselnam -- 船名
            ,goddes -- 货物描述
            ,colins -- 托收说明
            ,dftins -- 单据说明
            ,proins -- 拒付说明
            ,chgtxt -- 费用文本
            ,narhis -- 叙说历史性修改
            ,othins -- 其他说明
            ,fldmodblk -- 修改BOD字段列表
            ,cctinsrcv -- 收到指示
            ,cctinscol -- 托收指示
            ,colinssnm -- 放单指示
            ,intins -- 利息说明
            ,agtaut -- 代理人当局
            ,contag72 -- tag 72内容
            ,contag79 -- tag79内容
            ,bogans -- 422电文的"Answer"
            ,bogque -- 422电文的"Query"
            ,setinsbo -- 付款指示
            ,colinsdef -- 默认放单指示
            ,colinsflg -- 修改放单指示
            ,delins -- 传送说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 出口托收交易ID号
    ,o.resrej -- 拒付原因
    ,o.docpre -- 提示单据
    ,o.bogdet -- 出口托收细节
    ,o.vesselnam -- 船名
    ,o.goddes -- 货物描述
    ,o.colins -- 托收说明
    ,o.dftins -- 单据说明
    ,o.proins -- 拒付说明
    ,o.chgtxt -- 费用文本
    ,o.narhis -- 叙说历史性修改
    ,o.othins -- 其他说明
    ,o.fldmodblk -- 修改BOD字段列表
    ,o.cctinsrcv -- 收到指示
    ,o.cctinscol -- 托收指示
    ,o.colinssnm -- 放单指示
    ,o.intins -- 利息说明
    ,o.agtaut -- 代理人当局
    ,o.contag72 -- tag 72内容
    ,o.contag79 -- tag79内容
    ,o.bogans -- 422电文的"Answer"
    ,o.bogque -- 422电文的"Query"
    ,o.setinsbo -- 付款指示
    ,o.colinsdef -- 默认放单指示
    ,o.colinsflg -- 修改放单指示
    ,o.delins -- 传送说明
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_bot_bk o
    left join ${iol_schema}.isbs_bot_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bot_cl d
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
-- truncate table ${iol_schema}.isbs_bot;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_bot exchange partition p_19000101 with table ${iol_schema}.isbs_bot_cl;
alter table ${iol_schema}.isbs_bot exchange partition p_20991231 with table ${iol_schema}.isbs_bot_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_bot to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bot_op purge;
drop table ${iol_schema}.isbs_bot_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_bot_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_bot',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
