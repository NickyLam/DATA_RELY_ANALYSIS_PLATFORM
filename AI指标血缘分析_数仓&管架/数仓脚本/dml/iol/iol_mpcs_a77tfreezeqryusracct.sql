/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a77tfreezeqryusracct
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
create table ${iol_schema}.mpcs_a77tfreezeqryusracct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a77tfreezeqryusracct;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a77tfreezeqryusracct_op purge;
drop table ${iol_schema}.mpcs_a77tfreezeqryusracct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a77tfreezeqryusracct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a77tfreezeqryusracct where 0=1;

create table ${iol_schema}.mpcs_a77tfreezeqryusracct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a77tfreezeqryusracct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a77tfreezeqryusracct_cl(
            docno -- 协作编号
            ,case_index -- 
            ,caseno -- 案件编号
            ,casename -- 案件名称
            ,exeunit -- 侦办单位名称
            ,unique_index -- 
            ,uniqueid -- 唯一标识
            ,type -- 类型
            ,name -- 名称
            ,idtype -- 证件类型
            ,id -- 证件号码
            ,acct_index -- 
            ,bankcode -- 开户行代码
            ,bankname -- 开户行名称
            ,froseq -- 冻结流水号
            ,oldfroseq -- 原冻结流水号
            ,account -- 账号
            ,currency -- 币种
            ,exchangetype -- 汇钞类型
            ,frotype -- 冻结类型 1 普通冻结 2 轮候冻结 3 续冻
            ,fromode -- 冻结方式 1 按金额冻结 2 按账号冻结
            ,frobanlance -- 冻结金额
            ,freezeappdate -- 冻结申请时间
            ,frostartdate -- 冻结开始日期
            ,froenddate -- 冻结结束日期
            ,fronotifydoc -- 冻结存款通知书
            ,froflag -- 冻结标志 1已冻结 2未冻结
            ,frobanlance_1 -- 应冻结金额
            ,frobanlance_2 -- 已冻结金额
            ,frobanlance_3 -- 未冻结金额
            ,frobanlance_4 -- 冻结额度
            ,frostartdate_1 -- 
            ,froenddate_1 -- 
            ,memo -- 原因
            ,servicetime -- 送达时间
            ,servicedoc -- 送达证
            ,replydoc -- 回执
            ,filetype -- 文件格式
            ,filetype2 -- 回执文件格式
            ,tlrno -- 
            ,tlrdt -- 
            ,tlrtm -- 
            ,tlrjnlno -- 
            ,updt -- 
            ,uptm -- 
            ,isregister -- 
            ,openbr -- 账户开户行
            ,isdeal -- 是否已处理 0-未处理 1-已处理
            ,ischeck -- 是否复核
            ,isneed -- 是否需要查询子户号 0-否 1-是
            ,notifydoc -- 文书名称
            ,docnum -- 文书文号
            ,istransee -- 是否调取电子证据 1-是 2-否
            ,custnm -- 户名
            ,xtbz -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a77tfreezeqryusracct_op(
            docno -- 协作编号
            ,case_index -- 
            ,caseno -- 案件编号
            ,casename -- 案件名称
            ,exeunit -- 侦办单位名称
            ,unique_index -- 
            ,uniqueid -- 唯一标识
            ,type -- 类型
            ,name -- 名称
            ,idtype -- 证件类型
            ,id -- 证件号码
            ,acct_index -- 
            ,bankcode -- 开户行代码
            ,bankname -- 开户行名称
            ,froseq -- 冻结流水号
            ,oldfroseq -- 原冻结流水号
            ,account -- 账号
            ,currency -- 币种
            ,exchangetype -- 汇钞类型
            ,frotype -- 冻结类型 1 普通冻结 2 轮候冻结 3 续冻
            ,fromode -- 冻结方式 1 按金额冻结 2 按账号冻结
            ,frobanlance -- 冻结金额
            ,freezeappdate -- 冻结申请时间
            ,frostartdate -- 冻结开始日期
            ,froenddate -- 冻结结束日期
            ,fronotifydoc -- 冻结存款通知书
            ,froflag -- 冻结标志 1已冻结 2未冻结
            ,frobanlance_1 -- 应冻结金额
            ,frobanlance_2 -- 已冻结金额
            ,frobanlance_3 -- 未冻结金额
            ,frobanlance_4 -- 冻结额度
            ,frostartdate_1 -- 
            ,froenddate_1 -- 
            ,memo -- 原因
            ,servicetime -- 送达时间
            ,servicedoc -- 送达证
            ,replydoc -- 回执
            ,filetype -- 文件格式
            ,filetype2 -- 回执文件格式
            ,tlrno -- 
            ,tlrdt -- 
            ,tlrtm -- 
            ,tlrjnlno -- 
            ,updt -- 
            ,uptm -- 
            ,isregister -- 
            ,openbr -- 账户开户行
            ,isdeal -- 是否已处理 0-未处理 1-已处理
            ,ischeck -- 是否复核
            ,isneed -- 是否需要查询子户号 0-否 1-是
            ,notifydoc -- 文书名称
            ,docnum -- 文书文号
            ,istransee -- 是否调取电子证据 1-是 2-否
            ,custnm -- 户名
            ,xtbz -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.docno, o.docno) as docno -- 协作编号
    ,nvl(n.case_index, o.case_index) as case_index -- 
    ,nvl(n.caseno, o.caseno) as caseno -- 案件编号
    ,nvl(n.casename, o.casename) as casename -- 案件名称
    ,nvl(n.exeunit, o.exeunit) as exeunit -- 侦办单位名称
    ,nvl(n.unique_index, o.unique_index) as unique_index -- 
    ,nvl(n.uniqueid, o.uniqueid) as uniqueid -- 唯一标识
    ,nvl(n.type, o.type) as type -- 类型
    ,nvl(n.name, o.name) as name -- 名称
    ,nvl(n.idtype, o.idtype) as idtype -- 证件类型
    ,nvl(n.id, o.id) as id -- 证件号码
    ,nvl(n.acct_index, o.acct_index) as acct_index -- 
    ,nvl(n.bankcode, o.bankcode) as bankcode -- 开户行代码
    ,nvl(n.bankname, o.bankname) as bankname -- 开户行名称
    ,nvl(n.froseq, o.froseq) as froseq -- 冻结流水号
    ,nvl(n.oldfroseq, o.oldfroseq) as oldfroseq -- 原冻结流水号
    ,nvl(n.account, o.account) as account -- 账号
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.exchangetype, o.exchangetype) as exchangetype -- 汇钞类型
    ,nvl(n.frotype, o.frotype) as frotype -- 冻结类型 1 普通冻结 2 轮候冻结 3 续冻
    ,nvl(n.fromode, o.fromode) as fromode -- 冻结方式 1 按金额冻结 2 按账号冻结
    ,nvl(n.frobanlance, o.frobanlance) as frobanlance -- 冻结金额
    ,nvl(n.freezeappdate, o.freezeappdate) as freezeappdate -- 冻结申请时间
    ,nvl(n.frostartdate, o.frostartdate) as frostartdate -- 冻结开始日期
    ,nvl(n.froenddate, o.froenddate) as froenddate -- 冻结结束日期
    ,nvl(n.fronotifydoc, o.fronotifydoc) as fronotifydoc -- 冻结存款通知书
    ,nvl(n.froflag, o.froflag) as froflag -- 冻结标志 1已冻结 2未冻结
    ,nvl(n.frobanlance_1, o.frobanlance_1) as frobanlance_1 -- 应冻结金额
    ,nvl(n.frobanlance_2, o.frobanlance_2) as frobanlance_2 -- 已冻结金额
    ,nvl(n.frobanlance_3, o.frobanlance_3) as frobanlance_3 -- 未冻结金额
    ,nvl(n.frobanlance_4, o.frobanlance_4) as frobanlance_4 -- 冻结额度
    ,nvl(n.frostartdate_1, o.frostartdate_1) as frostartdate_1 -- 
    ,nvl(n.froenddate_1, o.froenddate_1) as froenddate_1 -- 
    ,nvl(n.memo, o.memo) as memo -- 原因
    ,nvl(n.servicetime, o.servicetime) as servicetime -- 送达时间
    ,nvl(n.servicedoc, o.servicedoc) as servicedoc -- 送达证
    ,nvl(n.replydoc, o.replydoc) as replydoc -- 回执
    ,nvl(n.filetype, o.filetype) as filetype -- 文件格式
    ,nvl(n.filetype2, o.filetype2) as filetype2 -- 回执文件格式
    ,nvl(n.tlrno, o.tlrno) as tlrno -- 
    ,nvl(n.tlrdt, o.tlrdt) as tlrdt -- 
    ,nvl(n.tlrtm, o.tlrtm) as tlrtm -- 
    ,nvl(n.tlrjnlno, o.tlrjnlno) as tlrjnlno -- 
    ,nvl(n.updt, o.updt) as updt -- 
    ,nvl(n.uptm, o.uptm) as uptm -- 
    ,nvl(n.isregister, o.isregister) as isregister -- 
    ,nvl(n.openbr, o.openbr) as openbr -- 账户开户行
    ,nvl(n.isdeal, o.isdeal) as isdeal -- 是否已处理 0-未处理 1-已处理
    ,nvl(n.ischeck, o.ischeck) as ischeck -- 是否复核
    ,nvl(n.isneed, o.isneed) as isneed -- 是否需要查询子户号 0-否 1-是
    ,nvl(n.notifydoc, o.notifydoc) as notifydoc -- 文书名称
    ,nvl(n.docnum, o.docnum) as docnum -- 文书文号
    ,nvl(n.istransee, o.istransee) as istransee -- 是否调取电子证据 1-是 2-否
    ,nvl(n.custnm, o.custnm) as custnm -- 户名
    ,nvl(n.xtbz, o.xtbz) as xtbz -- 
    ,case when
            n.docno is null
            and n.caseno is null
            and n.uniqueid is null
            and n.froseq is null
            and n.xtbz is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.docno is null
            and n.caseno is null
            and n.uniqueid is null
            and n.froseq is null
            and n.xtbz is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.docno is null
            and n.caseno is null
            and n.uniqueid is null
            and n.froseq is null
            and n.xtbz is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a77tfreezeqryusracct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a77tfreezeqryusracct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.docno = n.docno
            and o.caseno = n.caseno
            and o.uniqueid = n.uniqueid
            and o.froseq = n.froseq
            and o.xtbz = n.xtbz
where (
        o.docno is null
        and o.caseno is null
        and o.uniqueid is null
        and o.froseq is null
        and o.xtbz is null
    )
    or (
        n.docno is null
        and n.caseno is null
        and n.uniqueid is null
        and n.froseq is null
        and n.xtbz is null
    )
    or (
        o.case_index <> n.case_index
        or o.casename <> n.casename
        or o.exeunit <> n.exeunit
        or o.unique_index <> n.unique_index
        or o.type <> n.type
        or o.name <> n.name
        or o.idtype <> n.idtype
        or o.id <> n.id
        or o.acct_index <> n.acct_index
        or o.bankcode <> n.bankcode
        or o.bankname <> n.bankname
        or o.oldfroseq <> n.oldfroseq
        or o.account <> n.account
        or o.currency <> n.currency
        or o.exchangetype <> n.exchangetype
        or o.frotype <> n.frotype
        or o.fromode <> n.fromode
        or o.frobanlance <> n.frobanlance
        or o.freezeappdate <> n.freezeappdate
        or o.frostartdate <> n.frostartdate
        or o.froenddate <> n.froenddate
        or o.fronotifydoc <> n.fronotifydoc
        or o.froflag <> n.froflag
        or o.frobanlance_1 <> n.frobanlance_1
        or o.frobanlance_2 <> n.frobanlance_2
        or o.frobanlance_3 <> n.frobanlance_3
        or o.frobanlance_4 <> n.frobanlance_4
        or o.frostartdate_1 <> n.frostartdate_1
        or o.froenddate_1 <> n.froenddate_1
        or o.memo <> n.memo
        or o.servicetime <> n.servicetime
        or o.servicedoc <> n.servicedoc
        or o.replydoc <> n.replydoc
        or o.filetype <> n.filetype
        or o.filetype2 <> n.filetype2
        or o.tlrno <> n.tlrno
        or o.tlrdt <> n.tlrdt
        or o.tlrtm <> n.tlrtm
        or o.tlrjnlno <> n.tlrjnlno
        or o.updt <> n.updt
        or o.uptm <> n.uptm
        or o.isregister <> n.isregister
        or o.openbr <> n.openbr
        or o.isdeal <> n.isdeal
        or o.ischeck <> n.ischeck
        or o.isneed <> n.isneed
        or o.notifydoc <> n.notifydoc
        or o.docnum <> n.docnum
        or o.istransee <> n.istransee
        or o.custnm <> n.custnm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a77tfreezeqryusracct_cl(
            docno -- 协作编号
            ,case_index -- 
            ,caseno -- 案件编号
            ,casename -- 案件名称
            ,exeunit -- 侦办单位名称
            ,unique_index -- 
            ,uniqueid -- 唯一标识
            ,type -- 类型
            ,name -- 名称
            ,idtype -- 证件类型
            ,id -- 证件号码
            ,acct_index -- 
            ,bankcode -- 开户行代码
            ,bankname -- 开户行名称
            ,froseq -- 冻结流水号
            ,oldfroseq -- 原冻结流水号
            ,account -- 账号
            ,currency -- 币种
            ,exchangetype -- 汇钞类型
            ,frotype -- 冻结类型 1 普通冻结 2 轮候冻结 3 续冻
            ,fromode -- 冻结方式 1 按金额冻结 2 按账号冻结
            ,frobanlance -- 冻结金额
            ,freezeappdate -- 冻结申请时间
            ,frostartdate -- 冻结开始日期
            ,froenddate -- 冻结结束日期
            ,fronotifydoc -- 冻结存款通知书
            ,froflag -- 冻结标志 1已冻结 2未冻结
            ,frobanlance_1 -- 应冻结金额
            ,frobanlance_2 -- 已冻结金额
            ,frobanlance_3 -- 未冻结金额
            ,frobanlance_4 -- 冻结额度
            ,frostartdate_1 -- 
            ,froenddate_1 -- 
            ,memo -- 原因
            ,servicetime -- 送达时间
            ,servicedoc -- 送达证
            ,replydoc -- 回执
            ,filetype -- 文件格式
            ,filetype2 -- 回执文件格式
            ,tlrno -- 
            ,tlrdt -- 
            ,tlrtm -- 
            ,tlrjnlno -- 
            ,updt -- 
            ,uptm -- 
            ,isregister -- 
            ,openbr -- 账户开户行
            ,isdeal -- 是否已处理 0-未处理 1-已处理
            ,ischeck -- 是否复核
            ,isneed -- 是否需要查询子户号 0-否 1-是
            ,notifydoc -- 文书名称
            ,docnum -- 文书文号
            ,istransee -- 是否调取电子证据 1-是 2-否
            ,custnm -- 户名
            ,xtbz -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a77tfreezeqryusracct_op(
            docno -- 协作编号
            ,case_index -- 
            ,caseno -- 案件编号
            ,casename -- 案件名称
            ,exeunit -- 侦办单位名称
            ,unique_index -- 
            ,uniqueid -- 唯一标识
            ,type -- 类型
            ,name -- 名称
            ,idtype -- 证件类型
            ,id -- 证件号码
            ,acct_index -- 
            ,bankcode -- 开户行代码
            ,bankname -- 开户行名称
            ,froseq -- 冻结流水号
            ,oldfroseq -- 原冻结流水号
            ,account -- 账号
            ,currency -- 币种
            ,exchangetype -- 汇钞类型
            ,frotype -- 冻结类型 1 普通冻结 2 轮候冻结 3 续冻
            ,fromode -- 冻结方式 1 按金额冻结 2 按账号冻结
            ,frobanlance -- 冻结金额
            ,freezeappdate -- 冻结申请时间
            ,frostartdate -- 冻结开始日期
            ,froenddate -- 冻结结束日期
            ,fronotifydoc -- 冻结存款通知书
            ,froflag -- 冻结标志 1已冻结 2未冻结
            ,frobanlance_1 -- 应冻结金额
            ,frobanlance_2 -- 已冻结金额
            ,frobanlance_3 -- 未冻结金额
            ,frobanlance_4 -- 冻结额度
            ,frostartdate_1 -- 
            ,froenddate_1 -- 
            ,memo -- 原因
            ,servicetime -- 送达时间
            ,servicedoc -- 送达证
            ,replydoc -- 回执
            ,filetype -- 文件格式
            ,filetype2 -- 回执文件格式
            ,tlrno -- 
            ,tlrdt -- 
            ,tlrtm -- 
            ,tlrjnlno -- 
            ,updt -- 
            ,uptm -- 
            ,isregister -- 
            ,openbr -- 账户开户行
            ,isdeal -- 是否已处理 0-未处理 1-已处理
            ,ischeck -- 是否复核
            ,isneed -- 是否需要查询子户号 0-否 1-是
            ,notifydoc -- 文书名称
            ,docnum -- 文书文号
            ,istransee -- 是否调取电子证据 1-是 2-否
            ,custnm -- 户名
            ,xtbz -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.docno -- 协作编号
    ,o.case_index -- 
    ,o.caseno -- 案件编号
    ,o.casename -- 案件名称
    ,o.exeunit -- 侦办单位名称
    ,o.unique_index -- 
    ,o.uniqueid -- 唯一标识
    ,o.type -- 类型
    ,o.name -- 名称
    ,o.idtype -- 证件类型
    ,o.id -- 证件号码
    ,o.acct_index -- 
    ,o.bankcode -- 开户行代码
    ,o.bankname -- 开户行名称
    ,o.froseq -- 冻结流水号
    ,o.oldfroseq -- 原冻结流水号
    ,o.account -- 账号
    ,o.currency -- 币种
    ,o.exchangetype -- 汇钞类型
    ,o.frotype -- 冻结类型 1 普通冻结 2 轮候冻结 3 续冻
    ,o.fromode -- 冻结方式 1 按金额冻结 2 按账号冻结
    ,o.frobanlance -- 冻结金额
    ,o.freezeappdate -- 冻结申请时间
    ,o.frostartdate -- 冻结开始日期
    ,o.froenddate -- 冻结结束日期
    ,o.fronotifydoc -- 冻结存款通知书
    ,o.froflag -- 冻结标志 1已冻结 2未冻结
    ,o.frobanlance_1 -- 应冻结金额
    ,o.frobanlance_2 -- 已冻结金额
    ,o.frobanlance_3 -- 未冻结金额
    ,o.frobanlance_4 -- 冻结额度
    ,o.frostartdate_1 -- 
    ,o.froenddate_1 -- 
    ,o.memo -- 原因
    ,o.servicetime -- 送达时间
    ,o.servicedoc -- 送达证
    ,o.replydoc -- 回执
    ,o.filetype -- 文件格式
    ,o.filetype2 -- 回执文件格式
    ,o.tlrno -- 
    ,o.tlrdt -- 
    ,o.tlrtm -- 
    ,o.tlrjnlno -- 
    ,o.updt -- 
    ,o.uptm -- 
    ,o.isregister -- 
    ,o.openbr -- 账户开户行
    ,o.isdeal -- 是否已处理 0-未处理 1-已处理
    ,o.ischeck -- 是否复核
    ,o.isneed -- 是否需要查询子户号 0-否 1-是
    ,o.notifydoc -- 文书名称
    ,o.docnum -- 文书文号
    ,o.istransee -- 是否调取电子证据 1-是 2-否
    ,o.custnm -- 户名
    ,o.xtbz -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a77tfreezeqryusracct_bk o
    left join ${iol_schema}.mpcs_a77tfreezeqryusracct_op n
        on
            o.docno = n.docno
            and o.caseno = n.caseno
            and o.uniqueid = n.uniqueid
            and o.froseq = n.froseq
            and o.xtbz = n.xtbz
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a77tfreezeqryusracct_cl d
        on
            o.docno = d.docno
            and o.caseno = d.caseno
            and o.uniqueid = d.uniqueid
            and o.froseq = d.froseq
            and o.xtbz = d.xtbz
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a77tfreezeqryusracct;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a77tfreezeqryusracct exchange partition p_19000101 with table ${iol_schema}.mpcs_a77tfreezeqryusracct_cl;
alter table ${iol_schema}.mpcs_a77tfreezeqryusracct exchange partition p_20991231 with table ${iol_schema}.mpcs_a77tfreezeqryusracct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a77tfreezeqryusracct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a77tfreezeqryusracct_op purge;
drop table ${iol_schema}.mpcs_a77tfreezeqryusracct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a77tfreezeqryusracct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a77tfreezeqryusracct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
