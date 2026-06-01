/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_act
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
create table ${iol_schema}.isbs_act_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_act
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_act_op purge;
drop table ${iol_schema}.isbs_act_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_act_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_act where 0=1;

create table ${iol_schema}.isbs_act_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_act where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_act_cl(
            inr -- 唯一ID号，主键
            ,pri -- 账号优先级
            ,cur -- 账号币种
            ,extkey -- 账号
            ,seracc -- 账号提供机构的账号
            ,sernam -- 账号提供机构名称
            ,serptytyp -- 账号提供机构种类
            ,serptyinr -- 账号提供机构INR号
            ,holacc -- 账号开户机构的账号
            ,holnam -- 账号开户机构名称
            ,holptytyp -- 账号开户机构类型
            ,holptyinr -- 账号开户机构INR号
            ,cvrflg -- 头寸账户标志
            ,rmbflg -- 偿付账户标志
            ,delflg -- 已删账户标志
            ,ver -- 版本文本
            ,dirflg -- 借贷标志
            ,othbnkflg -- 是否账户行账号标志
            ,othptynam -- 账户行名称
            ,othownflg -- 是否我方账户行标志
            ,othbic6 -- 账户行的6位BIC
            ,iban -- 国际银行账户号
            ,etgextkey -- 实体组
            ,nam -- 账号名称
            ,exttyp -- 外部账号类型
            ,typ -- 账号类型
            ,extact -- 外部账号
            ,trmtyp -- 科目代码
            ,acctyp -- 账户类型
            ,bchkeyinr -- 所属机构INR
            ,othbic -- 银行编号
            ,cshflg -- 现金标记
            ,nam1 -- 产品名称
            ,wgzhxz -- 外管账户性质
            ,banktyp -- 银行类型
            ,prdtyp -- 产品类型
            ,seqno -- 账户序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_act_op(
            inr -- 唯一ID号，主键
            ,pri -- 账号优先级
            ,cur -- 账号币种
            ,extkey -- 账号
            ,seracc -- 账号提供机构的账号
            ,sernam -- 账号提供机构名称
            ,serptytyp -- 账号提供机构种类
            ,serptyinr -- 账号提供机构INR号
            ,holacc -- 账号开户机构的账号
            ,holnam -- 账号开户机构名称
            ,holptytyp -- 账号开户机构类型
            ,holptyinr -- 账号开户机构INR号
            ,cvrflg -- 头寸账户标志
            ,rmbflg -- 偿付账户标志
            ,delflg -- 已删账户标志
            ,ver -- 版本文本
            ,dirflg -- 借贷标志
            ,othbnkflg -- 是否账户行账号标志
            ,othptynam -- 账户行名称
            ,othownflg -- 是否我方账户行标志
            ,othbic6 -- 账户行的6位BIC
            ,iban -- 国际银行账户号
            ,etgextkey -- 实体组
            ,nam -- 账号名称
            ,exttyp -- 外部账号类型
            ,typ -- 账号类型
            ,extact -- 外部账号
            ,trmtyp -- 科目代码
            ,acctyp -- 账户类型
            ,bchkeyinr -- 所属机构INR
            ,othbic -- 银行编号
            ,cshflg -- 现金标记
            ,nam1 -- 产品名称
            ,wgzhxz -- 外管账户性质
            ,banktyp -- 银行类型
            ,prdtyp -- 产品类型
            ,seqno -- 账户序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 唯一ID号，主键
    ,nvl(n.pri, o.pri) as pri -- 账号优先级
    ,nvl(n.cur, o.cur) as cur -- 账号币种
    ,nvl(n.extkey, o.extkey) as extkey -- 账号
    ,nvl(n.seracc, o.seracc) as seracc -- 账号提供机构的账号
    ,nvl(n.sernam, o.sernam) as sernam -- 账号提供机构名称
    ,nvl(n.serptytyp, o.serptytyp) as serptytyp -- 账号提供机构种类
    ,nvl(n.serptyinr, o.serptyinr) as serptyinr -- 账号提供机构INR号
    ,nvl(n.holacc, o.holacc) as holacc -- 账号开户机构的账号
    ,nvl(n.holnam, o.holnam) as holnam -- 账号开户机构名称
    ,nvl(n.holptytyp, o.holptytyp) as holptytyp -- 账号开户机构类型
    ,nvl(n.holptyinr, o.holptyinr) as holptyinr -- 账号开户机构INR号
    ,nvl(n.cvrflg, o.cvrflg) as cvrflg -- 头寸账户标志
    ,nvl(n.rmbflg, o.rmbflg) as rmbflg -- 偿付账户标志
    ,nvl(n.delflg, o.delflg) as delflg -- 已删账户标志
    ,nvl(n.ver, o.ver) as ver -- 版本文本
    ,nvl(n.dirflg, o.dirflg) as dirflg -- 借贷标志
    ,nvl(n.othbnkflg, o.othbnkflg) as othbnkflg -- 是否账户行账号标志
    ,nvl(n.othptynam, o.othptynam) as othptynam -- 账户行名称
    ,nvl(n.othownflg, o.othownflg) as othownflg -- 是否我方账户行标志
    ,nvl(n.othbic6, o.othbic6) as othbic6 -- 账户行的6位BIC
    ,nvl(n.iban, o.iban) as iban -- 国际银行账户号
    ,nvl(n.etgextkey, o.etgextkey) as etgextkey -- 实体组
    ,nvl(n.nam, o.nam) as nam -- 账号名称
    ,nvl(n.exttyp, o.exttyp) as exttyp -- 外部账号类型
    ,nvl(n.typ, o.typ) as typ -- 账号类型
    ,nvl(n.extact, o.extact) as extact -- 外部账号
    ,nvl(n.trmtyp, o.trmtyp) as trmtyp -- 科目代码
    ,nvl(n.acctyp, o.acctyp) as acctyp -- 账户类型
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 所属机构INR
    ,nvl(n.othbic, o.othbic) as othbic -- 银行编号
    ,nvl(n.cshflg, o.cshflg) as cshflg -- 现金标记
    ,nvl(n.nam1, o.nam1) as nam1 -- 产品名称
    ,nvl(n.wgzhxz, o.wgzhxz) as wgzhxz -- 外管账户性质
    ,nvl(n.banktyp, o.banktyp) as banktyp -- 银行类型
    ,nvl(n.prdtyp, o.prdtyp) as prdtyp -- 产品类型
    ,nvl(n.seqno, o.seqno) as seqno -- 账户序列号
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
from (select * from ${iol_schema}.isbs_act_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_act where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.pri <> n.pri
        or o.cur <> n.cur
        or o.extkey <> n.extkey
        or o.seracc <> n.seracc
        or o.sernam <> n.sernam
        or o.serptytyp <> n.serptytyp
        or o.serptyinr <> n.serptyinr
        or o.holacc <> n.holacc
        or o.holnam <> n.holnam
        or o.holptytyp <> n.holptytyp
        or o.holptyinr <> n.holptyinr
        or o.cvrflg <> n.cvrflg
        or o.rmbflg <> n.rmbflg
        or o.delflg <> n.delflg
        or o.ver <> n.ver
        or o.dirflg <> n.dirflg
        or o.othbnkflg <> n.othbnkflg
        or o.othptynam <> n.othptynam
        or o.othownflg <> n.othownflg
        or o.othbic6 <> n.othbic6
        or o.iban <> n.iban
        or o.etgextkey <> n.etgextkey
        or o.nam <> n.nam
        or o.exttyp <> n.exttyp
        or o.typ <> n.typ
        or o.extact <> n.extact
        or o.trmtyp <> n.trmtyp
        or o.acctyp <> n.acctyp
        or o.bchkeyinr <> n.bchkeyinr
        or o.othbic <> n.othbic
        or o.cshflg <> n.cshflg
        or o.nam1 <> n.nam1
        or o.wgzhxz <> n.wgzhxz
        or o.banktyp <> n.banktyp
        or o.prdtyp <> n.prdtyp
        or o.seqno <> n.seqno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_act_cl(
            inr -- 唯一ID号，主键
            ,pri -- 账号优先级
            ,cur -- 账号币种
            ,extkey -- 账号
            ,seracc -- 账号提供机构的账号
            ,sernam -- 账号提供机构名称
            ,serptytyp -- 账号提供机构种类
            ,serptyinr -- 账号提供机构INR号
            ,holacc -- 账号开户机构的账号
            ,holnam -- 账号开户机构名称
            ,holptytyp -- 账号开户机构类型
            ,holptyinr -- 账号开户机构INR号
            ,cvrflg -- 头寸账户标志
            ,rmbflg -- 偿付账户标志
            ,delflg -- 已删账户标志
            ,ver -- 版本文本
            ,dirflg -- 借贷标志
            ,othbnkflg -- 是否账户行账号标志
            ,othptynam -- 账户行名称
            ,othownflg -- 是否我方账户行标志
            ,othbic6 -- 账户行的6位BIC
            ,iban -- 国际银行账户号
            ,etgextkey -- 实体组
            ,nam -- 账号名称
            ,exttyp -- 外部账号类型
            ,typ -- 账号类型
            ,extact -- 外部账号
            ,trmtyp -- 科目代码
            ,acctyp -- 账户类型
            ,bchkeyinr -- 所属机构INR
            ,othbic -- 银行编号
            ,cshflg -- 现金标记
            ,nam1 -- 产品名称
            ,wgzhxz -- 外管账户性质
            ,banktyp -- 银行类型
            ,prdtyp -- 产品类型
            ,seqno -- 账户序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_act_op(
            inr -- 唯一ID号，主键
            ,pri -- 账号优先级
            ,cur -- 账号币种
            ,extkey -- 账号
            ,seracc -- 账号提供机构的账号
            ,sernam -- 账号提供机构名称
            ,serptytyp -- 账号提供机构种类
            ,serptyinr -- 账号提供机构INR号
            ,holacc -- 账号开户机构的账号
            ,holnam -- 账号开户机构名称
            ,holptytyp -- 账号开户机构类型
            ,holptyinr -- 账号开户机构INR号
            ,cvrflg -- 头寸账户标志
            ,rmbflg -- 偿付账户标志
            ,delflg -- 已删账户标志
            ,ver -- 版本文本
            ,dirflg -- 借贷标志
            ,othbnkflg -- 是否账户行账号标志
            ,othptynam -- 账户行名称
            ,othownflg -- 是否我方账户行标志
            ,othbic6 -- 账户行的6位BIC
            ,iban -- 国际银行账户号
            ,etgextkey -- 实体组
            ,nam -- 账号名称
            ,exttyp -- 外部账号类型
            ,typ -- 账号类型
            ,extact -- 外部账号
            ,trmtyp -- 科目代码
            ,acctyp -- 账户类型
            ,bchkeyinr -- 所属机构INR
            ,othbic -- 银行编号
            ,cshflg -- 现金标记
            ,nam1 -- 产品名称
            ,wgzhxz -- 外管账户性质
            ,banktyp -- 银行类型
            ,prdtyp -- 产品类型
            ,seqno -- 账户序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 唯一ID号，主键
    ,o.pri -- 账号优先级
    ,o.cur -- 账号币种
    ,o.extkey -- 账号
    ,o.seracc -- 账号提供机构的账号
    ,o.sernam -- 账号提供机构名称
    ,o.serptytyp -- 账号提供机构种类
    ,o.serptyinr -- 账号提供机构INR号
    ,o.holacc -- 账号开户机构的账号
    ,o.holnam -- 账号开户机构名称
    ,o.holptytyp -- 账号开户机构类型
    ,o.holptyinr -- 账号开户机构INR号
    ,o.cvrflg -- 头寸账户标志
    ,o.rmbflg -- 偿付账户标志
    ,o.delflg -- 已删账户标志
    ,o.ver -- 版本文本
    ,o.dirflg -- 借贷标志
    ,o.othbnkflg -- 是否账户行账号标志
    ,o.othptynam -- 账户行名称
    ,o.othownflg -- 是否我方账户行标志
    ,o.othbic6 -- 账户行的6位BIC
    ,o.iban -- 国际银行账户号
    ,o.etgextkey -- 实体组
    ,o.nam -- 账号名称
    ,o.exttyp -- 外部账号类型
    ,o.typ -- 账号类型
    ,o.extact -- 外部账号
    ,o.trmtyp -- 科目代码
    ,o.acctyp -- 账户类型
    ,o.bchkeyinr -- 所属机构INR
    ,o.othbic -- 银行编号
    ,o.cshflg -- 现金标记
    ,o.nam1 -- 产品名称
    ,o.wgzhxz -- 外管账户性质
    ,o.banktyp -- 银行类型
    ,o.prdtyp -- 产品类型
    ,o.seqno -- 账户序列号
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
from ${iol_schema}.isbs_act_bk o
    left join ${iol_schema}.isbs_act_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_act_cl d
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
--truncate table ${iol_schema}.isbs_act;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_act') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_act drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_act add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_act exchange partition p_${batch_date} with table ${iol_schema}.isbs_act_cl;
alter table ${iol_schema}.isbs_act exchange partition p_20991231 with table ${iol_schema}.isbs_act_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_act to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_act_op purge;
drop table ${iol_schema}.isbs_act_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_act_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_act',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
