/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a77tfreezeqryfk
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
create table ${iol_schema}.mpcs_a77tfreezeqryfk_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a77tfreezeqryfk;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a77tfreezeqryfk_op purge;
drop table ${iol_schema}.mpcs_a77tfreezeqryfk_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a77tfreezeqryfk_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a77tfreezeqryfk where 0=1;

create table ${iol_schema}.mpcs_a77tfreezeqryfk_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a77tfreezeqryfk where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a77tfreezeqryfk_cl(
            docno -- 协作编号
            ,caseno -- 案件编号
            ,uniqueid -- 唯一标识
            ,froseq -- 冻结流水号
            ,account -- 账号
            ,currency -- 币种
            ,exchangetype -- 汇钞类型
            ,frotype -- 冻结类型 1 普通冻结 2 轮候冻结 3 续冻
            ,fromode -- 冻结方式 1 按金额冻结 2 按账号冻结
            ,frobanlance -- 冻结金额
            ,froflag -- 冻结标志 1已冻结 2未冻结
            ,frobanlance_1 -- 应冻结金额
            ,frobanlance_2 -- 已冻结金额
            ,frobanlance_3 -- 未冻结金额
            ,frobanlance_4 -- 冻结额度
            ,frostartdate -- 冻结开始时间
            ,froenddate -- 冻结结束时间
            ,memo -- 原因
            ,openbr -- 账户开户行
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台交易流水
            ,isdeal -- 是否已处理 0-未处理 1-已处理
            ,beforefro -- 在先冻结机关
            ,beforefroban -- 在先冻结金额
            ,beforefrodate -- 在先冻结到期日
            ,banlance -- 账户余额
            ,canbanlance -- 账户可用余额
            ,cardno -- 卡号
            ,hzwjdoc -- 系统自动生成的WORD回执文件全路径
            ,hzwjpdf -- PDF回执文件名
            ,filetype -- 文件格式
            ,docnum -- 文书文号
            ,xtbz -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a77tfreezeqryfk_op(
            docno -- 协作编号
            ,caseno -- 案件编号
            ,uniqueid -- 唯一标识
            ,froseq -- 冻结流水号
            ,account -- 账号
            ,currency -- 币种
            ,exchangetype -- 汇钞类型
            ,frotype -- 冻结类型 1 普通冻结 2 轮候冻结 3 续冻
            ,fromode -- 冻结方式 1 按金额冻结 2 按账号冻结
            ,frobanlance -- 冻结金额
            ,froflag -- 冻结标志 1已冻结 2未冻结
            ,frobanlance_1 -- 应冻结金额
            ,frobanlance_2 -- 已冻结金额
            ,frobanlance_3 -- 未冻结金额
            ,frobanlance_4 -- 冻结额度
            ,frostartdate -- 冻结开始时间
            ,froenddate -- 冻结结束时间
            ,memo -- 原因
            ,openbr -- 账户开户行
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台交易流水
            ,isdeal -- 是否已处理 0-未处理 1-已处理
            ,beforefro -- 在先冻结机关
            ,beforefroban -- 在先冻结金额
            ,beforefrodate -- 在先冻结到期日
            ,banlance -- 账户余额
            ,canbanlance -- 账户可用余额
            ,cardno -- 卡号
            ,hzwjdoc -- 系统自动生成的WORD回执文件全路径
            ,hzwjpdf -- PDF回执文件名
            ,filetype -- 文件格式
            ,docnum -- 文书文号
            ,xtbz -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.docno, o.docno) as docno -- 协作编号
    ,nvl(n.caseno, o.caseno) as caseno -- 案件编号
    ,nvl(n.uniqueid, o.uniqueid) as uniqueid -- 唯一标识
    ,nvl(n.froseq, o.froseq) as froseq -- 冻结流水号
    ,nvl(n.account, o.account) as account -- 账号
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.exchangetype, o.exchangetype) as exchangetype -- 汇钞类型
    ,nvl(n.frotype, o.frotype) as frotype -- 冻结类型 1 普通冻结 2 轮候冻结 3 续冻
    ,nvl(n.fromode, o.fromode) as fromode -- 冻结方式 1 按金额冻结 2 按账号冻结
    ,nvl(n.frobanlance, o.frobanlance) as frobanlance -- 冻结金额
    ,nvl(n.froflag, o.froflag) as froflag -- 冻结标志 1已冻结 2未冻结
    ,nvl(n.frobanlance_1, o.frobanlance_1) as frobanlance_1 -- 应冻结金额
    ,nvl(n.frobanlance_2, o.frobanlance_2) as frobanlance_2 -- 已冻结金额
    ,nvl(n.frobanlance_3, o.frobanlance_3) as frobanlance_3 -- 未冻结金额
    ,nvl(n.frobanlance_4, o.frobanlance_4) as frobanlance_4 -- 冻结额度
    ,nvl(n.frostartdate, o.frostartdate) as frostartdate -- 冻结开始时间
    ,nvl(n.froenddate, o.froenddate) as froenddate -- 冻结结束时间
    ,nvl(n.memo, o.memo) as memo -- 原因
    ,nvl(n.openbr, o.openbr) as openbr -- 账户开户行
    ,nvl(n.hostdt, o.hostdt) as hostdt -- 核心交易日期
    ,nvl(n.hostseqno, o.hostseqno) as hostseqno -- 核心交易流水
    ,nvl(n.dataid, o.dataid) as dataid -- 中台交易流水
    ,nvl(n.isdeal, o.isdeal) as isdeal -- 是否已处理 0-未处理 1-已处理
    ,nvl(n.beforefro, o.beforefro) as beforefro -- 在先冻结机关
    ,nvl(n.beforefroban, o.beforefroban) as beforefroban -- 在先冻结金额
    ,nvl(n.beforefrodate, o.beforefrodate) as beforefrodate -- 在先冻结到期日
    ,nvl(n.banlance, o.banlance) as banlance -- 账户余额
    ,nvl(n.canbanlance, o.canbanlance) as canbanlance -- 账户可用余额
    ,nvl(n.cardno, o.cardno) as cardno -- 卡号
    ,nvl(n.hzwjdoc, o.hzwjdoc) as hzwjdoc -- 系统自动生成的WORD回执文件全路径
    ,nvl(n.hzwjpdf, o.hzwjpdf) as hzwjpdf -- PDF回执文件名
    ,nvl(n.filetype, o.filetype) as filetype -- 文件格式
    ,nvl(n.docnum, o.docnum) as docnum -- 文书文号
    ,nvl(n.xtbz, o.xtbz) as xtbz -- 
    ,case when
            n.docno is null
            and n.caseno is null
            and n.uniqueid is null
            and n.froseq is null
            and n.account is null
            and n.xtbz is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.docno is null
            and n.caseno is null
            and n.uniqueid is null
            and n.froseq is null
            and n.account is null
            and n.xtbz is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.docno is null
            and n.caseno is null
            and n.uniqueid is null
            and n.froseq is null
            and n.account is null
            and n.xtbz is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a77tfreezeqryfk_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a77tfreezeqryfk where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.docno = n.docno
            and o.caseno = n.caseno
            and o.uniqueid = n.uniqueid
            and o.froseq = n.froseq
            and o.account = n.account
            and o.xtbz = n.xtbz
where (
        o.docno is null
        and o.caseno is null
        and o.uniqueid is null
        and o.froseq is null
        and o.account is null
        and o.xtbz is null
    )
    or (
        n.docno is null
        and n.caseno is null
        and n.uniqueid is null
        and n.froseq is null
        and n.account is null
        and n.xtbz is null
    )
    or (
        o.currency <> n.currency
        or o.exchangetype <> n.exchangetype
        or o.frotype <> n.frotype
        or o.fromode <> n.fromode
        or o.frobanlance <> n.frobanlance
        or o.froflag <> n.froflag
        or o.frobanlance_1 <> n.frobanlance_1
        or o.frobanlance_2 <> n.frobanlance_2
        or o.frobanlance_3 <> n.frobanlance_3
        or o.frobanlance_4 <> n.frobanlance_4
        or o.frostartdate <> n.frostartdate
        or o.froenddate <> n.froenddate
        or o.memo <> n.memo
        or o.openbr <> n.openbr
        or o.hostdt <> n.hostdt
        or o.hostseqno <> n.hostseqno
        or o.dataid <> n.dataid
        or o.isdeal <> n.isdeal
        or o.beforefro <> n.beforefro
        or o.beforefroban <> n.beforefroban
        or o.beforefrodate <> n.beforefrodate
        or o.banlance <> n.banlance
        or o.canbanlance <> n.canbanlance
        or o.cardno <> n.cardno
        or o.hzwjdoc <> n.hzwjdoc
        or o.hzwjpdf <> n.hzwjpdf
        or o.filetype <> n.filetype
        or o.docnum <> n.docnum
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a77tfreezeqryfk_cl(
            docno -- 协作编号
            ,caseno -- 案件编号
            ,uniqueid -- 唯一标识
            ,froseq -- 冻结流水号
            ,account -- 账号
            ,currency -- 币种
            ,exchangetype -- 汇钞类型
            ,frotype -- 冻结类型 1 普通冻结 2 轮候冻结 3 续冻
            ,fromode -- 冻结方式 1 按金额冻结 2 按账号冻结
            ,frobanlance -- 冻结金额
            ,froflag -- 冻结标志 1已冻结 2未冻结
            ,frobanlance_1 -- 应冻结金额
            ,frobanlance_2 -- 已冻结金额
            ,frobanlance_3 -- 未冻结金额
            ,frobanlance_4 -- 冻结额度
            ,frostartdate -- 冻结开始时间
            ,froenddate -- 冻结结束时间
            ,memo -- 原因
            ,openbr -- 账户开户行
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台交易流水
            ,isdeal -- 是否已处理 0-未处理 1-已处理
            ,beforefro -- 在先冻结机关
            ,beforefroban -- 在先冻结金额
            ,beforefrodate -- 在先冻结到期日
            ,banlance -- 账户余额
            ,canbanlance -- 账户可用余额
            ,cardno -- 卡号
            ,hzwjdoc -- 系统自动生成的WORD回执文件全路径
            ,hzwjpdf -- PDF回执文件名
            ,filetype -- 文件格式
            ,docnum -- 文书文号
            ,xtbz -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a77tfreezeqryfk_op(
            docno -- 协作编号
            ,caseno -- 案件编号
            ,uniqueid -- 唯一标识
            ,froseq -- 冻结流水号
            ,account -- 账号
            ,currency -- 币种
            ,exchangetype -- 汇钞类型
            ,frotype -- 冻结类型 1 普通冻结 2 轮候冻结 3 续冻
            ,fromode -- 冻结方式 1 按金额冻结 2 按账号冻结
            ,frobanlance -- 冻结金额
            ,froflag -- 冻结标志 1已冻结 2未冻结
            ,frobanlance_1 -- 应冻结金额
            ,frobanlance_2 -- 已冻结金额
            ,frobanlance_3 -- 未冻结金额
            ,frobanlance_4 -- 冻结额度
            ,frostartdate -- 冻结开始时间
            ,froenddate -- 冻结结束时间
            ,memo -- 原因
            ,openbr -- 账户开户行
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台交易流水
            ,isdeal -- 是否已处理 0-未处理 1-已处理
            ,beforefro -- 在先冻结机关
            ,beforefroban -- 在先冻结金额
            ,beforefrodate -- 在先冻结到期日
            ,banlance -- 账户余额
            ,canbanlance -- 账户可用余额
            ,cardno -- 卡号
            ,hzwjdoc -- 系统自动生成的WORD回执文件全路径
            ,hzwjpdf -- PDF回执文件名
            ,filetype -- 文件格式
            ,docnum -- 文书文号
            ,xtbz -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.docno -- 协作编号
    ,o.caseno -- 案件编号
    ,o.uniqueid -- 唯一标识
    ,o.froseq -- 冻结流水号
    ,o.account -- 账号
    ,o.currency -- 币种
    ,o.exchangetype -- 汇钞类型
    ,o.frotype -- 冻结类型 1 普通冻结 2 轮候冻结 3 续冻
    ,o.fromode -- 冻结方式 1 按金额冻结 2 按账号冻结
    ,o.frobanlance -- 冻结金额
    ,o.froflag -- 冻结标志 1已冻结 2未冻结
    ,o.frobanlance_1 -- 应冻结金额
    ,o.frobanlance_2 -- 已冻结金额
    ,o.frobanlance_3 -- 未冻结金额
    ,o.frobanlance_4 -- 冻结额度
    ,o.frostartdate -- 冻结开始时间
    ,o.froenddate -- 冻结结束时间
    ,o.memo -- 原因
    ,o.openbr -- 账户开户行
    ,o.hostdt -- 核心交易日期
    ,o.hostseqno -- 核心交易流水
    ,o.dataid -- 中台交易流水
    ,o.isdeal -- 是否已处理 0-未处理 1-已处理
    ,o.beforefro -- 在先冻结机关
    ,o.beforefroban -- 在先冻结金额
    ,o.beforefrodate -- 在先冻结到期日
    ,o.banlance -- 账户余额
    ,o.canbanlance -- 账户可用余额
    ,o.cardno -- 卡号
    ,o.hzwjdoc -- 系统自动生成的WORD回执文件全路径
    ,o.hzwjpdf -- PDF回执文件名
    ,o.filetype -- 文件格式
    ,o.docnum -- 文书文号
    ,o.xtbz -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a77tfreezeqryfk_bk o
    left join ${iol_schema}.mpcs_a77tfreezeqryfk_op n
        on
            o.docno = n.docno
            and o.caseno = n.caseno
            and o.uniqueid = n.uniqueid
            and o.froseq = n.froseq
            and o.account = n.account
            and o.xtbz = n.xtbz
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a77tfreezeqryfk_cl d
        on
            o.docno = d.docno
            and o.caseno = d.caseno
            and o.uniqueid = d.uniqueid
            and o.froseq = d.froseq
            and o.account = d.account
            and o.xtbz = d.xtbz
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a77tfreezeqryfk;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a77tfreezeqryfk exchange partition p_19000101 with table ${iol_schema}.mpcs_a77tfreezeqryfk_cl;
alter table ${iol_schema}.mpcs_a77tfreezeqryfk exchange partition p_20991231 with table ${iol_schema}.mpcs_a77tfreezeqryfk_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a77tfreezeqryfk to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a77tfreezeqryfk_op purge;
drop table ${iol_schema}.mpcs_a77tfreezeqryfk_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a77tfreezeqryfk_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a77tfreezeqryfk',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
