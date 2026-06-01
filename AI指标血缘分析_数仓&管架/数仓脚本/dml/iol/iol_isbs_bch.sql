/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_bch
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
create table ${iol_schema}.isbs_bch_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_bch;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bch_op purge;
drop table ${iol_schema}.isbs_bch_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bch_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bch where 0=1;

create table ${iol_schema}.isbs_bch_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bch where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bch_cl(
            inr -- 内部唯一ID
            ,etyexkey -- 实体关键字
            ,branch -- 机构编码
            ,bchkey -- 经办机构编码
            ,bchname -- 机构名称
            ,lev -- 机构层次
            ,upbranch -- 上级机构编码
            ,bchtyp -- 机构类型
            ,bchflg -- 机构参考号标志
            ,decnum -- 金融机构编码
            ,tel -- 电话
            ,fax -- 传真
            ,adr -- 地址
            ,swfcod -- BIC码
            ,adr2 -- 地址
            ,ver -- 版本号
            ,namen -- 英文名称
            ,adren -- 英文地址
            ,adren2 -- 英文地址
            ,ydjcod -- 外汇管理局印单局代码
            ,tid -- 收单行系统机构代号
            ,upbchkey -- 替该机构经办业务的押汇中心对应的国结系统机构编码，未上收的银行此处是其国结系统分行机构编码
            ,accbch -- 核心机构号
            ,bchref -- 该机构项下的业务，生成参考号时用到的4位机构号码（由业务人员指定）。
            ,bchusr -- 核心虚拟柜员
            ,bchlst -- 包含的分支机构INR
            ,sta -- 状态
            ,ptyinr -- 与pty表inr对应
            ,stpflg -- 是否停用
            ,rmbrpt -- 金融机构识别码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bch_op(
            inr -- 内部唯一ID
            ,etyexkey -- 实体关键字
            ,branch -- 机构编码
            ,bchkey -- 经办机构编码
            ,bchname -- 机构名称
            ,lev -- 机构层次
            ,upbranch -- 上级机构编码
            ,bchtyp -- 机构类型
            ,bchflg -- 机构参考号标志
            ,decnum -- 金融机构编码
            ,tel -- 电话
            ,fax -- 传真
            ,adr -- 地址
            ,swfcod -- BIC码
            ,adr2 -- 地址
            ,ver -- 版本号
            ,namen -- 英文名称
            ,adren -- 英文地址
            ,adren2 -- 英文地址
            ,ydjcod -- 外汇管理局印单局代码
            ,tid -- 收单行系统机构代号
            ,upbchkey -- 替该机构经办业务的押汇中心对应的国结系统机构编码，未上收的银行此处是其国结系统分行机构编码
            ,accbch -- 核心机构号
            ,bchref -- 该机构项下的业务，生成参考号时用到的4位机构号码（由业务人员指定）。
            ,bchusr -- 核心虚拟柜员
            ,bchlst -- 包含的分支机构INR
            ,sta -- 状态
            ,ptyinr -- 与pty表inr对应
            ,stpflg -- 是否停用
            ,rmbrpt -- 金融机构识别码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 内部唯一ID
    ,nvl(n.etyexkey, o.etyexkey) as etyexkey -- 实体关键字
    ,nvl(n.branch, o.branch) as branch -- 机构编码
    ,nvl(n.bchkey, o.bchkey) as bchkey -- 经办机构编码
    ,nvl(n.bchname, o.bchname) as bchname -- 机构名称
    ,nvl(n.lev, o.lev) as lev -- 机构层次
    ,nvl(n.upbranch, o.upbranch) as upbranch -- 上级机构编码
    ,nvl(n.bchtyp, o.bchtyp) as bchtyp -- 机构类型
    ,nvl(n.bchflg, o.bchflg) as bchflg -- 机构参考号标志
    ,nvl(n.decnum, o.decnum) as decnum -- 金融机构编码
    ,nvl(n.tel, o.tel) as tel -- 电话
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.adr, o.adr) as adr -- 地址
    ,nvl(n.swfcod, o.swfcod) as swfcod -- BIC码
    ,nvl(n.adr2, o.adr2) as adr2 -- 地址
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.namen, o.namen) as namen -- 英文名称
    ,nvl(n.adren, o.adren) as adren -- 英文地址
    ,nvl(n.adren2, o.adren2) as adren2 -- 英文地址
    ,nvl(n.ydjcod, o.ydjcod) as ydjcod -- 外汇管理局印单局代码
    ,nvl(n.tid, o.tid) as tid -- 收单行系统机构代号
    ,nvl(n.upbchkey, o.upbchkey) as upbchkey -- 替该机构经办业务的押汇中心对应的国结系统机构编码，未上收的银行此处是其国结系统分行机构编码
    ,nvl(n.accbch, o.accbch) as accbch -- 核心机构号
    ,nvl(n.bchref, o.bchref) as bchref -- 该机构项下的业务，生成参考号时用到的4位机构号码（由业务人员指定）。
    ,nvl(n.bchusr, o.bchusr) as bchusr -- 核心虚拟柜员
    ,nvl(n.bchlst, o.bchlst) as bchlst -- 包含的分支机构INR
    ,nvl(n.sta, o.sta) as sta -- 状态
    ,nvl(n.ptyinr, o.ptyinr) as ptyinr -- 与pty表inr对应
    ,nvl(n.stpflg, o.stpflg) as stpflg -- 是否停用
    ,nvl(n.rmbrpt, o.rmbrpt) as rmbrpt -- 金融机构识别码
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
from (select * from ${iol_schema}.isbs_bch_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_bch where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.etyexkey <> n.etyexkey
        or o.branch <> n.branch
        or o.bchkey <> n.bchkey
        or o.bchname <> n.bchname
        or o.lev <> n.lev
        or o.upbranch <> n.upbranch
        or o.bchtyp <> n.bchtyp
        or o.bchflg <> n.bchflg
        or o.decnum <> n.decnum
        or o.tel <> n.tel
        or o.fax <> n.fax
        or o.adr <> n.adr
        or o.swfcod <> n.swfcod
        or o.adr2 <> n.adr2
        or o.ver <> n.ver
        or o.namen <> n.namen
        or o.adren <> n.adren
        or o.adren2 <> n.adren2
        or o.ydjcod <> n.ydjcod
        or o.tid <> n.tid
        or o.upbchkey <> n.upbchkey
        or o.accbch <> n.accbch
        or o.bchref <> n.bchref
        or o.bchusr <> n.bchusr
        or o.bchlst <> n.bchlst
        or o.sta <> n.sta
        or o.ptyinr <> n.ptyinr
        or o.stpflg <> n.stpflg
        or o.rmbrpt <> n.rmbrpt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bch_cl(
            inr -- 内部唯一ID
            ,etyexkey -- 实体关键字
            ,branch -- 机构编码
            ,bchkey -- 经办机构编码
            ,bchname -- 机构名称
            ,lev -- 机构层次
            ,upbranch -- 上级机构编码
            ,bchtyp -- 机构类型
            ,bchflg -- 机构参考号标志
            ,decnum -- 金融机构编码
            ,tel -- 电话
            ,fax -- 传真
            ,adr -- 地址
            ,swfcod -- BIC码
            ,adr2 -- 地址
            ,ver -- 版本号
            ,namen -- 英文名称
            ,adren -- 英文地址
            ,adren2 -- 英文地址
            ,ydjcod -- 外汇管理局印单局代码
            ,tid -- 收单行系统机构代号
            ,upbchkey -- 替该机构经办业务的押汇中心对应的国结系统机构编码，未上收的银行此处是其国结系统分行机构编码
            ,accbch -- 核心机构号
            ,bchref -- 该机构项下的业务，生成参考号时用到的4位机构号码（由业务人员指定）。
            ,bchusr -- 核心虚拟柜员
            ,bchlst -- 包含的分支机构INR
            ,sta -- 状态
            ,ptyinr -- 与pty表inr对应
            ,stpflg -- 是否停用
            ,rmbrpt -- 金融机构识别码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bch_op(
            inr -- 内部唯一ID
            ,etyexkey -- 实体关键字
            ,branch -- 机构编码
            ,bchkey -- 经办机构编码
            ,bchname -- 机构名称
            ,lev -- 机构层次
            ,upbranch -- 上级机构编码
            ,bchtyp -- 机构类型
            ,bchflg -- 机构参考号标志
            ,decnum -- 金融机构编码
            ,tel -- 电话
            ,fax -- 传真
            ,adr -- 地址
            ,swfcod -- BIC码
            ,adr2 -- 地址
            ,ver -- 版本号
            ,namen -- 英文名称
            ,adren -- 英文地址
            ,adren2 -- 英文地址
            ,ydjcod -- 外汇管理局印单局代码
            ,tid -- 收单行系统机构代号
            ,upbchkey -- 替该机构经办业务的押汇中心对应的国结系统机构编码，未上收的银行此处是其国结系统分行机构编码
            ,accbch -- 核心机构号
            ,bchref -- 该机构项下的业务，生成参考号时用到的4位机构号码（由业务人员指定）。
            ,bchusr -- 核心虚拟柜员
            ,bchlst -- 包含的分支机构INR
            ,sta -- 状态
            ,ptyinr -- 与pty表inr对应
            ,stpflg -- 是否停用
            ,rmbrpt -- 金融机构识别码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 内部唯一ID
    ,o.etyexkey -- 实体关键字
    ,o.branch -- 机构编码
    ,o.bchkey -- 经办机构编码
    ,o.bchname -- 机构名称
    ,o.lev -- 机构层次
    ,o.upbranch -- 上级机构编码
    ,o.bchtyp -- 机构类型
    ,o.bchflg -- 机构参考号标志
    ,o.decnum -- 金融机构编码
    ,o.tel -- 电话
    ,o.fax -- 传真
    ,o.adr -- 地址
    ,o.swfcod -- BIC码
    ,o.adr2 -- 地址
    ,o.ver -- 版本号
    ,o.namen -- 英文名称
    ,o.adren -- 英文地址
    ,o.adren2 -- 英文地址
    ,o.ydjcod -- 外汇管理局印单局代码
    ,o.tid -- 收单行系统机构代号
    ,o.upbchkey -- 替该机构经办业务的押汇中心对应的国结系统机构编码，未上收的银行此处是其国结系统分行机构编码
    ,o.accbch -- 核心机构号
    ,o.bchref -- 该机构项下的业务，生成参考号时用到的4位机构号码（由业务人员指定）。
    ,o.bchusr -- 核心虚拟柜员
    ,o.bchlst -- 包含的分支机构INR
    ,o.sta -- 状态
    ,o.ptyinr -- 与pty表inr对应
    ,o.stpflg -- 是否停用
    ,o.rmbrpt -- 金融机构识别码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_bch_bk o
    left join ${iol_schema}.isbs_bch_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bch_cl d
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
-- truncate table ${iol_schema}.isbs_bch;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_bch exchange partition p_19000101 with table ${iol_schema}.isbs_bch_cl;
alter table ${iol_schema}.isbs_bch exchange partition p_20991231 with table ${iol_schema}.isbs_bch_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_bch to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bch_op purge;
drop table ${iol_schema}.isbs_bch_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_bch_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_bch',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
