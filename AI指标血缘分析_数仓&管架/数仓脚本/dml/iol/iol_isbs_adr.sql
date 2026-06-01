/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_adr
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
create table ${iol_schema}.isbs_adr_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_adr;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_adr_op purge;
drop table ${iol_schema}.isbs_adr_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_adr_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_adr where 0=1;

create table ${iol_schema}.isbs_adr_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_adr where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_adr_cl(
            inr -- 内部唯一ID号
            ,extkey -- 地址关键字
            ,nam -- 地址名称
            ,bic -- 通知行SWIFT代码
            ,bicaut -- SWIFT连接标志
            ,bid -- 支行权限
            ,blz -- 德国的空代码
            ,clc -- 国家的空代码
            ,dpt -- 机构
            ,eml -- 邮件信箱
            ,fax1 -- 电传1
            ,fax2 -- 电传2
            ,nam1 -- 名称1
            ,nam2 -- 名称2
            ,nam3 -- 名称3
            ,str1 -- 街道1
            ,str2 -- 街道2
            ,loczip -- 邮政编码
            ,loctxt -- 城市名称
            ,loc2 -- 城市区域
            ,loccty -- 住址
            ,cortyp -- 通信方式
            ,pob -- 邮箱号码
            ,pobzip -- 邮政编码
            ,pobtxt -- 国家名称
            ,tel1 -- 电话1
            ,tel2 -- 电话2
            ,tid -- 收单行机构代码
            ,tlx -- 电报号码
            ,tlxaut -- 电报权限修改
            ,uil -- 默认语种
            ,ver -- 版本号
            ,manmod -- 手动更改标志
            ,rtgflg -- RTGS标志
            ,tarflg -- TARGET标志
            ,dtacid -- DTA messages的客户地址
            ,dtecid -- DTE messages的客户地址
            ,etgextkey -- 用户组别关键字
            ,adr1 -- 地址1
            ,adr2 -- 地址2
            ,adr3 -- 地址3
            ,adr4 -- 地址4
            ,namelc  -- 人行名称
            ,adrelc  -- 人行地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_adr_op(
            inr -- 内部唯一ID号
            ,extkey -- 地址关键字
            ,nam -- 地址名称
            ,bic -- 通知行SWIFT代码
            ,bicaut -- SWIFT连接标志
            ,bid -- 支行权限
            ,blz -- 德国的空代码
            ,clc -- 国家的空代码
            ,dpt -- 机构
            ,eml -- 邮件信箱
            ,fax1 -- 电传1
            ,fax2 -- 电传2
            ,nam1 -- 名称1
            ,nam2 -- 名称2
            ,nam3 -- 名称3
            ,str1 -- 街道1
            ,str2 -- 街道2
            ,loczip -- 邮政编码
            ,loctxt -- 城市名称
            ,loc2 -- 城市区域
            ,loccty -- 住址
            ,cortyp -- 通信方式
            ,pob -- 邮箱号码
            ,pobzip -- 邮政编码
            ,pobtxt -- 国家名称
            ,tel1 -- 电话1
            ,tel2 -- 电话2
            ,tid -- 收单行机构代码
            ,tlx -- 电报号码
            ,tlxaut -- 电报权限修改
            ,uil -- 默认语种
            ,ver -- 版本号
            ,manmod -- 手动更改标志
            ,rtgflg -- RTGS标志
            ,tarflg -- TARGET标志
            ,dtacid -- DTA messages的客户地址
            ,dtecid -- DTE messages的客户地址
            ,etgextkey -- 用户组别关键字
            ,adr1 -- 地址1
            ,adr2 -- 地址2
            ,adr3 -- 地址3
            ,adr4 -- 地址4
            ,namelc  -- 人行名称
            ,adrelc  -- 人行地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 内部唯一ID号
    ,nvl(n.extkey, o.extkey) as extkey -- 地址关键字
    ,nvl(n.nam, o.nam) as nam -- 地址名称
    ,nvl(n.bic, o.bic) as bic -- 通知行SWIFT代码
    ,nvl(n.bicaut, o.bicaut) as bicaut -- SWIFT连接标志
    ,nvl(n.bid, o.bid) as bid -- 支行权限
    ,nvl(n.blz, o.blz) as blz -- 德国的空代码
    ,nvl(n.clc, o.clc) as clc -- 国家的空代码
    ,nvl(n.dpt, o.dpt) as dpt -- 机构
    ,nvl(n.eml, o.eml) as eml -- 邮件信箱
    ,nvl(n.fax1, o.fax1) as fax1 -- 电传1
    ,nvl(n.fax2, o.fax2) as fax2 -- 电传2
    ,nvl(n.nam1, o.nam1) as nam1 -- 名称1
    ,nvl(n.nam2, o.nam2) as nam2 -- 名称2
    ,nvl(n.nam3, o.nam3) as nam3 -- 名称3
    ,nvl(n.str1, o.str1) as str1 -- 街道1
    ,nvl(n.str2, o.str2) as str2 -- 街道2
    ,nvl(n.loczip, o.loczip) as loczip -- 邮政编码
    ,nvl(n.loctxt, o.loctxt) as loctxt -- 城市名称
    ,nvl(n.loc2, o.loc2) as loc2 -- 城市区域
    ,nvl(n.loccty, o.loccty) as loccty -- 住址
    ,nvl(n.cortyp, o.cortyp) as cortyp -- 通信方式
    ,nvl(n.pob, o.pob) as pob -- 邮箱号码
    ,nvl(n.pobzip, o.pobzip) as pobzip -- 邮政编码
    ,nvl(n.pobtxt, o.pobtxt) as pobtxt -- 国家名称
    ,nvl(n.tel1, o.tel1) as tel1 -- 电话1
    ,nvl(n.tel2, o.tel2) as tel2 -- 电话2
    ,nvl(n.tid, o.tid) as tid -- 收单行机构代码
    ,nvl(n.tlx, o.tlx) as tlx -- 电报号码
    ,nvl(n.tlxaut, o.tlxaut) as tlxaut -- 电报权限修改
    ,nvl(n.uil, o.uil) as uil -- 默认语种
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.manmod, o.manmod) as manmod -- 手动更改标志
    ,nvl(n.rtgflg, o.rtgflg) as rtgflg -- RTGS标志
    ,nvl(n.tarflg, o.tarflg) as tarflg -- TARGET标志
    ,nvl(n.dtacid, o.dtacid) as dtacid -- DTA messages的客户地址
    ,nvl(n.dtecid, o.dtecid) as dtecid -- DTE messages的客户地址
    ,nvl(n.etgextkey, o.etgextkey) as etgextkey -- 用户组别关键字
    ,nvl(n.adr1, o.adr1) as adr1 -- 地址1
    ,nvl(n.adr2, o.adr2) as adr2 -- 地址2
    ,nvl(n.adr3, o.adr3) as adr3 -- 地址3
    ,nvl(n.adr4, o.adr4) as adr4 -- 地址4
    ,nvl(n.namelc , o.namelc ) as namelc  -- 人行名称
    ,nvl(n.adrelc , o.adrelc ) as adrelc  -- 人行地址
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
from (select * from ${iol_schema}.isbs_adr_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_adr where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.extkey <> n.extkey
        or o.nam <> n.nam
        or o.bic <> n.bic
        or o.bicaut <> n.bicaut
        or o.bid <> n.bid
        or o.blz <> n.blz
        or o.clc <> n.clc
        or o.dpt <> n.dpt
        or o.eml <> n.eml
        or o.fax1 <> n.fax1
        or o.fax2 <> n.fax2
        or o.nam1 <> n.nam1
        or o.nam2 <> n.nam2
        or o.nam3 <> n.nam3
        or o.str1 <> n.str1
        or o.str2 <> n.str2
        or o.loczip <> n.loczip
        or o.loctxt <> n.loctxt
        or o.loc2 <> n.loc2
        or o.loccty <> n.loccty
        or o.cortyp <> n.cortyp
        or o.pob <> n.pob
        or o.pobzip <> n.pobzip
        or o.pobtxt <> n.pobtxt
        or o.tel1 <> n.tel1
        or o.tel2 <> n.tel2
        or o.tid <> n.tid
        or o.tlx <> n.tlx
        or o.tlxaut <> n.tlxaut
        or o.uil <> n.uil
        or o.ver <> n.ver
        or o.manmod <> n.manmod
        or o.rtgflg <> n.rtgflg
        or o.tarflg <> n.tarflg
        or o.dtacid <> n.dtacid
        or o.dtecid <> n.dtecid
        or o.etgextkey <> n.etgextkey
        or o.adr1 <> n.adr1
        or o.adr2 <> n.adr2
        or o.adr3 <> n.adr3
        or o.adr4 <> n.adr4
        or o.namelc  <> n.namelc 
        or o.adrelc  <> n.adrelc 
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_adr_cl(
            inr -- 内部唯一ID号
            ,extkey -- 地址关键字
            ,nam -- 地址名称
            ,bic -- 通知行SWIFT代码
            ,bicaut -- SWIFT连接标志
            ,bid -- 支行权限
            ,blz -- 德国的空代码
            ,clc -- 国家的空代码
            ,dpt -- 机构
            ,eml -- 邮件信箱
            ,fax1 -- 电传1
            ,fax2 -- 电传2
            ,nam1 -- 名称1
            ,nam2 -- 名称2
            ,nam3 -- 名称3
            ,str1 -- 街道1
            ,str2 -- 街道2
            ,loczip -- 邮政编码
            ,loctxt -- 城市名称
            ,loc2 -- 城市区域
            ,loccty -- 住址
            ,cortyp -- 通信方式
            ,pob -- 邮箱号码
            ,pobzip -- 邮政编码
            ,pobtxt -- 国家名称
            ,tel1 -- 电话1
            ,tel2 -- 电话2
            ,tid -- 收单行机构代码
            ,tlx -- 电报号码
            ,tlxaut -- 电报权限修改
            ,uil -- 默认语种
            ,ver -- 版本号
            ,manmod -- 手动更改标志
            ,rtgflg -- RTGS标志
            ,tarflg -- TARGET标志
            ,dtacid -- DTA messages的客户地址
            ,dtecid -- DTE messages的客户地址
            ,etgextkey -- 用户组别关键字
            ,adr1 -- 地址1
            ,adr2 -- 地址2
            ,adr3 -- 地址3
            ,adr4 -- 地址4
            ,namelc  -- 人行名称
            ,adrelc  -- 人行地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_adr_op(
            inr -- 内部唯一ID号
            ,extkey -- 地址关键字
            ,nam -- 地址名称
            ,bic -- 通知行SWIFT代码
            ,bicaut -- SWIFT连接标志
            ,bid -- 支行权限
            ,blz -- 德国的空代码
            ,clc -- 国家的空代码
            ,dpt -- 机构
            ,eml -- 邮件信箱
            ,fax1 -- 电传1
            ,fax2 -- 电传2
            ,nam1 -- 名称1
            ,nam2 -- 名称2
            ,nam3 -- 名称3
            ,str1 -- 街道1
            ,str2 -- 街道2
            ,loczip -- 邮政编码
            ,loctxt -- 城市名称
            ,loc2 -- 城市区域
            ,loccty -- 住址
            ,cortyp -- 通信方式
            ,pob -- 邮箱号码
            ,pobzip -- 邮政编码
            ,pobtxt -- 国家名称
            ,tel1 -- 电话1
            ,tel2 -- 电话2
            ,tid -- 收单行机构代码
            ,tlx -- 电报号码
            ,tlxaut -- 电报权限修改
            ,uil -- 默认语种
            ,ver -- 版本号
            ,manmod -- 手动更改标志
            ,rtgflg -- RTGS标志
            ,tarflg -- TARGET标志
            ,dtacid -- DTA messages的客户地址
            ,dtecid -- DTE messages的客户地址
            ,etgextkey -- 用户组别关键字
            ,adr1 -- 地址1
            ,adr2 -- 地址2
            ,adr3 -- 地址3
            ,adr4 -- 地址4
            ,namelc  -- 人行名称
            ,adrelc  -- 人行地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 内部唯一ID号
    ,o.extkey -- 地址关键字
    ,o.nam -- 地址名称
    ,o.bic -- 通知行SWIFT代码
    ,o.bicaut -- SWIFT连接标志
    ,o.bid -- 支行权限
    ,o.blz -- 德国的空代码
    ,o.clc -- 国家的空代码
    ,o.dpt -- 机构
    ,o.eml -- 邮件信箱
    ,o.fax1 -- 电传1
    ,o.fax2 -- 电传2
    ,o.nam1 -- 名称1
    ,o.nam2 -- 名称2
    ,o.nam3 -- 名称3
    ,o.str1 -- 街道1
    ,o.str2 -- 街道2
    ,o.loczip -- 邮政编码
    ,o.loctxt -- 城市名称
    ,o.loc2 -- 城市区域
    ,o.loccty -- 住址
    ,o.cortyp -- 通信方式
    ,o.pob -- 邮箱号码
    ,o.pobzip -- 邮政编码
    ,o.pobtxt -- 国家名称
    ,o.tel1 -- 电话1
    ,o.tel2 -- 电话2
    ,o.tid -- 收单行机构代码
    ,o.tlx -- 电报号码
    ,o.tlxaut -- 电报权限修改
    ,o.uil -- 默认语种
    ,o.ver -- 版本号
    ,o.manmod -- 手动更改标志
    ,o.rtgflg -- RTGS标志
    ,o.tarflg -- TARGET标志
    ,o.dtacid -- DTA messages的客户地址
    ,o.dtecid -- DTE messages的客户地址
    ,o.etgextkey -- 用户组别关键字
    ,o.adr1 -- 地址1
    ,o.adr2 -- 地址2
    ,o.adr3 -- 地址3
    ,o.adr4 -- 地址4
    ,o.namelc  -- 人行名称
    ,o.adrelc  -- 人行地址
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_adr_bk o
    left join ${iol_schema}.isbs_adr_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_adr_cl d
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
-- truncate table ${iol_schema}.isbs_adr;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_adr exchange partition p_19000101 with table ${iol_schema}.isbs_adr_cl;
alter table ${iol_schema}.isbs_adr exchange partition p_20991231 with table ${iol_schema}.isbs_adr_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_adr to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_adr_op purge;
drop table ${iol_schema}.isbs_adr_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_adr_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_adr',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
