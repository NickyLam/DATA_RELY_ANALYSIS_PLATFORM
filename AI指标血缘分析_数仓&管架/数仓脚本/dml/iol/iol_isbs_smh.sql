/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_smh
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
create table ${iol_schema}.isbs_smh_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_smh;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_smh_op purge;
drop table ${iol_schema}.isbs_smh_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_smh_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_smh where 0=1;

create table ${iol_schema}.isbs_smh_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_smh where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_smh_cl(
            inr -- 内部唯一流水号，主键
            ,objtyp -- 关联对象类型
            ,objinr -- 关联对象INR
            ,trntyp -- 交易类型
            ,trninr -- 交易INR
            ,trnsub -- 交易级别
            ,extkey -- 外部关键字
            ,nam -- 基本信息描述
            ,creusr -- 创建人
            ,crefrm -- 所在交易
            ,credattim -- 创建时间
            ,dir -- 发出或接受标志
            ,docpth -- 存储位置
            ,docfil -- Message的文件名称
            ,docfxt -- 文件后缀
            ,docmac -- MAC
            ,msgpos -- 所在Message的位置
            ,msglen -- 在Message的长度
            ,grpinr -- Message组INR
            ,grpseq -- Message组队列
            ,cortyp -- 类型
            ,cortypsub -- Subtype of Message (Defines SRV)
            ,apf -- 打印格式
            ,sndkey -- Receiver Key
            ,apfcnt -- Count per Form
            ,ptainr -- PTA的INR
            ,oriflg -- Type of Copy
            ,orismhinr -- Message的唯一ID
            ,partflg -- Message的部分标志
            ,msgtyp -- received或sent标志
            ,relcur -- 相关币种
            ,relamt -- 相关金额
            ,sysno -- 清算报文的清算编号
            ,staflg -- flag (M 999加押，T  TELEX加押)
            ,times -- 次数
            ,sndref -- 
            ,ownref -- 
            ,bindflg -- 
            ,cndinr -- 
            ,ackflg -- 
            ,mtdesc -- 
            ,asiflg -- 
            ,matflg -- 
            ,clrflg -- 
            ,msgpri -- 
            ,tag121 -- 
            ,tag111 -- 
            ,sndflg -- 
            ,f79sta -- 
            ,f71f -- 
            ,f71a -- 
            ,f79 -- 
            ,f33b -- 
            ,valdat -- 
            ,cpsflg -- 
            ,gpiflg -- GPI标志
            ,tag52a -- 报文的TAG52A
            ,tag56a -- 报文的TAG56A
            ,tag57a -- 报文的TAG57A
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_smh_op(
            inr -- 内部唯一流水号，主键
            ,objtyp -- 关联对象类型
            ,objinr -- 关联对象INR
            ,trntyp -- 交易类型
            ,trninr -- 交易INR
            ,trnsub -- 交易级别
            ,extkey -- 外部关键字
            ,nam -- 基本信息描述
            ,creusr -- 创建人
            ,crefrm -- 所在交易
            ,credattim -- 创建时间
            ,dir -- 发出或接受标志
            ,docpth -- 存储位置
            ,docfil -- Message的文件名称
            ,docfxt -- 文件后缀
            ,docmac -- MAC
            ,msgpos -- 所在Message的位置
            ,msglen -- 在Message的长度
            ,grpinr -- Message组INR
            ,grpseq -- Message组队列
            ,cortyp -- 类型
            ,cortypsub -- Subtype of Message (Defines SRV)
            ,apf -- 打印格式
            ,sndkey -- Receiver Key
            ,apfcnt -- Count per Form
            ,ptainr -- PTA的INR
            ,oriflg -- Type of Copy
            ,orismhinr -- Message的唯一ID
            ,partflg -- Message的部分标志
            ,msgtyp -- received或sent标志
            ,relcur -- 相关币种
            ,relamt -- 相关金额
            ,sysno -- 清算报文的清算编号
            ,staflg -- flag (M 999加押，T  TELEX加押)
            ,times -- 次数
            ,sndref -- 
            ,ownref -- 
            ,bindflg -- 
            ,cndinr -- 
            ,ackflg -- 
            ,mtdesc -- 
            ,asiflg -- 
            ,matflg -- 
            ,clrflg -- 
            ,msgpri -- 
            ,tag121 -- 
            ,tag111 -- 
            ,sndflg -- 
            ,f79sta -- 
            ,f71f -- 
            ,f71a -- 
            ,f79 -- 
            ,f33b -- 
            ,valdat -- 
            ,cpsflg -- 
            ,gpiflg -- GPI标志
            ,tag52a -- 报文的TAG52A
            ,tag56a -- 报文的TAG56A
            ,tag57a -- 报文的TAG57A
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 内部唯一流水号，主键
    ,nvl(n.objtyp, o.objtyp) as objtyp -- 关联对象类型
    ,nvl(n.objinr, o.objinr) as objinr -- 关联对象INR
    ,nvl(n.trntyp, o.trntyp) as trntyp -- 交易类型
    ,nvl(n.trninr, o.trninr) as trninr -- 交易INR
    ,nvl(n.trnsub, o.trnsub) as trnsub -- 交易级别
    ,nvl(n.extkey, o.extkey) as extkey -- 外部关键字
    ,nvl(n.nam, o.nam) as nam -- 基本信息描述
    ,nvl(n.creusr, o.creusr) as creusr -- 创建人
    ,nvl(n.crefrm, o.crefrm) as crefrm -- 所在交易
    ,nvl(n.credattim, o.credattim) as credattim -- 创建时间
    ,nvl(n.dir, o.dir) as dir -- 发出或接受标志
    ,nvl(n.docpth, o.docpth) as docpth -- 存储位置
    ,nvl(n.docfil, o.docfil) as docfil -- Message的文件名称
    ,nvl(n.docfxt, o.docfxt) as docfxt -- 文件后缀
    ,nvl(n.docmac, o.docmac) as docmac -- MAC
    ,nvl(n.msgpos, o.msgpos) as msgpos -- 所在Message的位置
    ,nvl(n.msglen, o.msglen) as msglen -- 在Message的长度
    ,nvl(n.grpinr, o.grpinr) as grpinr -- Message组INR
    ,nvl(n.grpseq, o.grpseq) as grpseq -- Message组队列
    ,nvl(n.cortyp, o.cortyp) as cortyp -- 类型
    ,nvl(n.cortypsub, o.cortypsub) as cortypsub -- Subtype of Message (Defines SRV)
    ,nvl(n.apf, o.apf) as apf -- 打印格式
    ,nvl(n.sndkey, o.sndkey) as sndkey -- Receiver Key
    ,nvl(n.apfcnt, o.apfcnt) as apfcnt -- Count per Form
    ,nvl(n.ptainr, o.ptainr) as ptainr -- PTA的INR
    ,nvl(n.oriflg, o.oriflg) as oriflg -- Type of Copy
    ,nvl(n.orismhinr, o.orismhinr) as orismhinr -- Message的唯一ID
    ,nvl(n.partflg, o.partflg) as partflg -- Message的部分标志
    ,nvl(n.msgtyp, o.msgtyp) as msgtyp -- received或sent标志
    ,nvl(n.relcur, o.relcur) as relcur -- 相关币种
    ,nvl(n.relamt, o.relamt) as relamt -- 相关金额
    ,nvl(n.sysno, o.sysno) as sysno -- 清算报文的清算编号
    ,nvl(n.staflg, o.staflg) as staflg -- flag (M 999加押，T  TELEX加押)
    ,nvl(n.times, o.times) as times -- 次数
    ,nvl(n.sndref, o.sndref) as sndref -- 
    ,nvl(n.ownref, o.ownref) as ownref -- 
    ,nvl(n.bindflg, o.bindflg) as bindflg -- 
    ,nvl(n.cndinr, o.cndinr) as cndinr -- 
    ,nvl(n.ackflg, o.ackflg) as ackflg -- 
    ,nvl(n.mtdesc, o.mtdesc) as mtdesc -- 
    ,nvl(n.asiflg, o.asiflg) as asiflg -- 
    ,nvl(n.matflg, o.matflg) as matflg -- 
    ,nvl(n.clrflg, o.clrflg) as clrflg -- 
    ,nvl(n.msgpri, o.msgpri) as msgpri -- 
    ,nvl(n.tag121, o.tag121) as tag121 -- 
    ,nvl(n.tag111, o.tag111) as tag111 -- 
    ,nvl(n.sndflg, o.sndflg) as sndflg -- 
    ,nvl(n.f79sta, o.f79sta) as f79sta -- 
    ,nvl(n.f71f, o.f71f) as f71f -- 
    ,nvl(n.f71a, o.f71a) as f71a -- 
    ,nvl(n.f79, o.f79) as f79 -- 
    ,nvl(n.f33b, o.f33b) as f33b -- 
    ,nvl(n.valdat, o.valdat) as valdat -- 
    ,nvl(n.cpsflg, o.cpsflg) as cpsflg -- 
    ,nvl(n.gpiflg, o.gpiflg) as gpiflg -- GPI标志
    ,nvl(n.tag52a, o.tag52a) as tag52a -- 报文的TAG52A
    ,nvl(n.tag56a, o.tag56a) as tag56a -- 报文的TAG56A
    ,nvl(n.tag57a, o.tag57a) as tag57a -- 报文的TAG57A
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
from (select * from ${iol_schema}.isbs_smh_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_smh where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.objtyp <> n.objtyp
        or o.objinr <> n.objinr
        or o.trntyp <> n.trntyp
        or o.trninr <> n.trninr
        or o.trnsub <> n.trnsub
        or o.extkey <> n.extkey
        or o.nam <> n.nam
        or o.creusr <> n.creusr
        or o.crefrm <> n.crefrm
        or o.credattim <> n.credattim
        or o.dir <> n.dir
        or o.docpth <> n.docpth
        or o.docfil <> n.docfil
        or o.docfxt <> n.docfxt
        or o.docmac <> n.docmac
        or o.msgpos <> n.msgpos
        or o.msglen <> n.msglen
        or o.grpinr <> n.grpinr
        or o.grpseq <> n.grpseq
        or o.cortyp <> n.cortyp
        or o.cortypsub <> n.cortypsub
        or o.apf <> n.apf
        or o.sndkey <> n.sndkey
        or o.apfcnt <> n.apfcnt
        or o.ptainr <> n.ptainr
        or o.oriflg <> n.oriflg
        or o.orismhinr <> n.orismhinr
        or o.partflg <> n.partflg
        or o.msgtyp <> n.msgtyp
        or o.relcur <> n.relcur
        or o.relamt <> n.relamt
        or o.sysno <> n.sysno
        or o.staflg <> n.staflg
        or o.times <> n.times
        or o.sndref <> n.sndref
        or o.ownref <> n.ownref
        or o.bindflg <> n.bindflg
        or o.cndinr <> n.cndinr
        or o.ackflg <> n.ackflg
        or o.mtdesc <> n.mtdesc
        or o.asiflg <> n.asiflg
        or o.matflg <> n.matflg
        or o.clrflg <> n.clrflg
        or o.msgpri <> n.msgpri
        or o.tag121 <> n.tag121
        or o.tag111 <> n.tag111
        or o.sndflg <> n.sndflg
        or o.f79sta <> n.f79sta
        or o.f71f <> n.f71f
        or o.f71a <> n.f71a
        or o.f79 <> n.f79
        or o.f33b <> n.f33b
        or o.valdat <> n.valdat
        or o.cpsflg <> n.cpsflg
        or o.gpiflg <> n.gpiflg
        or o.tag52a <> n.tag52a
        or o.tag56a <> n.tag56a
        or o.tag57a <> n.tag57a
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_smh_cl(
            inr -- 内部唯一流水号，主键
            ,objtyp -- 关联对象类型
            ,objinr -- 关联对象INR
            ,trntyp -- 交易类型
            ,trninr -- 交易INR
            ,trnsub -- 交易级别
            ,extkey -- 外部关键字
            ,nam -- 基本信息描述
            ,creusr -- 创建人
            ,crefrm -- 所在交易
            ,credattim -- 创建时间
            ,dir -- 发出或接受标志
            ,docpth -- 存储位置
            ,docfil -- Message的文件名称
            ,docfxt -- 文件后缀
            ,docmac -- MAC
            ,msgpos -- 所在Message的位置
            ,msglen -- 在Message的长度
            ,grpinr -- Message组INR
            ,grpseq -- Message组队列
            ,cortyp -- 类型
            ,cortypsub -- Subtype of Message (Defines SRV)
            ,apf -- 打印格式
            ,sndkey -- Receiver Key
            ,apfcnt -- Count per Form
            ,ptainr -- PTA的INR
            ,oriflg -- Type of Copy
            ,orismhinr -- Message的唯一ID
            ,partflg -- Message的部分标志
            ,msgtyp -- received或sent标志
            ,relcur -- 相关币种
            ,relamt -- 相关金额
            ,sysno -- 清算报文的清算编号
            ,staflg -- flag (M 999加押，T  TELEX加押)
            ,times -- 次数
            ,sndref -- 
            ,ownref -- 
            ,bindflg -- 
            ,cndinr -- 
            ,ackflg -- 
            ,mtdesc -- 
            ,asiflg -- 
            ,matflg -- 
            ,clrflg -- 
            ,msgpri -- 
            ,tag121 -- 
            ,tag111 -- 
            ,sndflg -- 
            ,f79sta -- 
            ,f71f -- 
            ,f71a -- 
            ,f79 -- 
            ,f33b -- 
            ,valdat -- 
            ,cpsflg -- 
            ,gpiflg -- GPI标志
            ,tag52a -- 报文的TAG52A
            ,tag56a -- 报文的TAG56A
            ,tag57a -- 报文的TAG57A
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_smh_op(
            inr -- 内部唯一流水号，主键
            ,objtyp -- 关联对象类型
            ,objinr -- 关联对象INR
            ,trntyp -- 交易类型
            ,trninr -- 交易INR
            ,trnsub -- 交易级别
            ,extkey -- 外部关键字
            ,nam -- 基本信息描述
            ,creusr -- 创建人
            ,crefrm -- 所在交易
            ,credattim -- 创建时间
            ,dir -- 发出或接受标志
            ,docpth -- 存储位置
            ,docfil -- Message的文件名称
            ,docfxt -- 文件后缀
            ,docmac -- MAC
            ,msgpos -- 所在Message的位置
            ,msglen -- 在Message的长度
            ,grpinr -- Message组INR
            ,grpseq -- Message组队列
            ,cortyp -- 类型
            ,cortypsub -- Subtype of Message (Defines SRV)
            ,apf -- 打印格式
            ,sndkey -- Receiver Key
            ,apfcnt -- Count per Form
            ,ptainr -- PTA的INR
            ,oriflg -- Type of Copy
            ,orismhinr -- Message的唯一ID
            ,partflg -- Message的部分标志
            ,msgtyp -- received或sent标志
            ,relcur -- 相关币种
            ,relamt -- 相关金额
            ,sysno -- 清算报文的清算编号
            ,staflg -- flag (M 999加押，T  TELEX加押)
            ,times -- 次数
            ,sndref -- 
            ,ownref -- 
            ,bindflg -- 
            ,cndinr -- 
            ,ackflg -- 
            ,mtdesc -- 
            ,asiflg -- 
            ,matflg -- 
            ,clrflg -- 
            ,msgpri -- 
            ,tag121 -- 
            ,tag111 -- 
            ,sndflg -- 
            ,f79sta -- 
            ,f71f -- 
            ,f71a -- 
            ,f79 -- 
            ,f33b -- 
            ,valdat -- 
            ,cpsflg -- 
            ,gpiflg -- GPI标志
            ,tag52a -- 报文的TAG52A
            ,tag56a -- 报文的TAG56A
            ,tag57a -- 报文的TAG57A
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 内部唯一流水号，主键
    ,o.objtyp -- 关联对象类型
    ,o.objinr -- 关联对象INR
    ,o.trntyp -- 交易类型
    ,o.trninr -- 交易INR
    ,o.trnsub -- 交易级别
    ,o.extkey -- 外部关键字
    ,o.nam -- 基本信息描述
    ,o.creusr -- 创建人
    ,o.crefrm -- 所在交易
    ,o.credattim -- 创建时间
    ,o.dir -- 发出或接受标志
    ,o.docpth -- 存储位置
    ,o.docfil -- Message的文件名称
    ,o.docfxt -- 文件后缀
    ,o.docmac -- MAC
    ,o.msgpos -- 所在Message的位置
    ,o.msglen -- 在Message的长度
    ,o.grpinr -- Message组INR
    ,o.grpseq -- Message组队列
    ,o.cortyp -- 类型
    ,o.cortypsub -- Subtype of Message (Defines SRV)
    ,o.apf -- 打印格式
    ,o.sndkey -- Receiver Key
    ,o.apfcnt -- Count per Form
    ,o.ptainr -- PTA的INR
    ,o.oriflg -- Type of Copy
    ,o.orismhinr -- Message的唯一ID
    ,o.partflg -- Message的部分标志
    ,o.msgtyp -- received或sent标志
    ,o.relcur -- 相关币种
    ,o.relamt -- 相关金额
    ,o.sysno -- 清算报文的清算编号
    ,o.staflg -- flag (M 999加押，T  TELEX加押)
    ,o.times -- 次数
    ,o.sndref -- 
    ,o.ownref -- 
    ,o.bindflg -- 
    ,o.cndinr -- 
    ,o.ackflg -- 
    ,o.mtdesc -- 
    ,o.asiflg -- 
    ,o.matflg -- 
    ,o.clrflg -- 
    ,o.msgpri -- 
    ,o.tag121 -- 
    ,o.tag111 -- 
    ,o.sndflg -- 
    ,o.f79sta -- 
    ,o.f71f -- 
    ,o.f71a -- 
    ,o.f79 -- 
    ,o.f33b -- 
    ,o.valdat -- 
    ,o.cpsflg -- 
    ,o.gpiflg -- GPI标志
    ,o.tag52a -- 报文的TAG52A
    ,o.tag56a -- 报文的TAG56A
    ,o.tag57a -- 报文的TAG57A
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_smh_bk o
    left join ${iol_schema}.isbs_smh_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_smh_cl d
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
-- truncate table ${iol_schema}.isbs_smh;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_smh exchange partition p_19000101 with table ${iol_schema}.isbs_smh_cl;
alter table ${iol_schema}.isbs_smh exchange partition p_20991231 with table ${iol_schema}.isbs_smh_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_smh to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_smh_op purge;
drop table ${iol_schema}.isbs_smh_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_smh_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_smh',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
