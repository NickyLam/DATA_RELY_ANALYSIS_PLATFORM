/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_cld
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
create table ${iol_schema}.isbs_cld_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_cld;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_cld_op purge;
drop table ${iol_schema}.isbs_cld_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cld_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_cld where 0=1;

create table ${iol_schema}.isbs_cld_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_cld where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_cld_cl(
            inr -- 唯一ID
            ,ownusr -- 经办人
            ,chktyp -- 票据类型
            ,colptyinr -- 代收行INR
            ,colptynam -- 代收行名称
            ,ownref -- 打包托收的业务参考号
            ,colptyref -- 代收行的编号
            ,opndat -- 开立日期
            ,clsdat -- 闭卷日期
            ,ver -- 版本号
            ,credat -- 创建日期
            ,colptainr -- 代收行地址INR
            ,nam -- 打包托收交易名
            ,colflg -- 付款方式
            ,valdat -- 起息日
            ,count -- 打包的票据总数
            ,colref -- 代收行参考号
            ,creact -- 贷记账号类型
            ,acno -- 账号
            ,regref -- 收单行系统业务代号
            ,bchkeyinr -- 业务经办机构INR
            ,branchinr -- 业务所属机构INR
            ,etyextkey -- 实体组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_cld_op(
            inr -- 唯一ID
            ,ownusr -- 经办人
            ,chktyp -- 票据类型
            ,colptyinr -- 代收行INR
            ,colptynam -- 代收行名称
            ,ownref -- 打包托收的业务参考号
            ,colptyref -- 代收行的编号
            ,opndat -- 开立日期
            ,clsdat -- 闭卷日期
            ,ver -- 版本号
            ,credat -- 创建日期
            ,colptainr -- 代收行地址INR
            ,nam -- 打包托收交易名
            ,colflg -- 付款方式
            ,valdat -- 起息日
            ,count -- 打包的票据总数
            ,colref -- 代收行参考号
            ,creact -- 贷记账号类型
            ,acno -- 账号
            ,regref -- 收单行系统业务代号
            ,bchkeyinr -- 业务经办机构INR
            ,branchinr -- 业务所属机构INR
            ,etyextkey -- 实体组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 唯一ID
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 经办人
    ,nvl(n.chktyp, o.chktyp) as chktyp -- 票据类型
    ,nvl(n.colptyinr, o.colptyinr) as colptyinr -- 代收行INR
    ,nvl(n.colptynam, o.colptynam) as colptynam -- 代收行名称
    ,nvl(n.ownref, o.ownref) as ownref -- 打包托收的业务参考号
    ,nvl(n.colptyref, o.colptyref) as colptyref -- 代收行的编号
    ,nvl(n.opndat, o.opndat) as opndat -- 开立日期
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 闭卷日期
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.credat, o.credat) as credat -- 创建日期
    ,nvl(n.colptainr, o.colptainr) as colptainr -- 代收行地址INR
    ,nvl(n.nam, o.nam) as nam -- 打包托收交易名
    ,nvl(n.colflg, o.colflg) as colflg -- 付款方式
    ,nvl(n.valdat, o.valdat) as valdat -- 起息日
    ,nvl(n.count, o.count) as count -- 打包的票据总数
    ,nvl(n.colref, o.colref) as colref -- 代收行参考号
    ,nvl(n.creact, o.creact) as creact -- 贷记账号类型
    ,nvl(n.acno, o.acno) as acno -- 账号
    ,nvl(n.regref, o.regref) as regref -- 收单行系统业务代号
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 业务经办机构INR
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 业务所属机构INR
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 实体组
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
from (select * from ${iol_schema}.isbs_cld_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_cld where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.ownusr <> n.ownusr
        or o.chktyp <> n.chktyp
        or o.colptyinr <> n.colptyinr
        or o.colptynam <> n.colptynam
        or o.ownref <> n.ownref
        or o.colptyref <> n.colptyref
        or o.opndat <> n.opndat
        or o.clsdat <> n.clsdat
        or o.ver <> n.ver
        or o.credat <> n.credat
        or o.colptainr <> n.colptainr
        or o.nam <> n.nam
        or o.colflg <> n.colflg
        or o.valdat <> n.valdat
        or o.count <> n.count
        or o.colref <> n.colref
        or o.creact <> n.creact
        or o.acno <> n.acno
        or o.regref <> n.regref
        or o.bchkeyinr <> n.bchkeyinr
        or o.branchinr <> n.branchinr
        or o.etyextkey <> n.etyextkey
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_cld_cl(
            inr -- 唯一ID
            ,ownusr -- 经办人
            ,chktyp -- 票据类型
            ,colptyinr -- 代收行INR
            ,colptynam -- 代收行名称
            ,ownref -- 打包托收的业务参考号
            ,colptyref -- 代收行的编号
            ,opndat -- 开立日期
            ,clsdat -- 闭卷日期
            ,ver -- 版本号
            ,credat -- 创建日期
            ,colptainr -- 代收行地址INR
            ,nam -- 打包托收交易名
            ,colflg -- 付款方式
            ,valdat -- 起息日
            ,count -- 打包的票据总数
            ,colref -- 代收行参考号
            ,creact -- 贷记账号类型
            ,acno -- 账号
            ,regref -- 收单行系统业务代号
            ,bchkeyinr -- 业务经办机构INR
            ,branchinr -- 业务所属机构INR
            ,etyextkey -- 实体组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_cld_op(
            inr -- 唯一ID
            ,ownusr -- 经办人
            ,chktyp -- 票据类型
            ,colptyinr -- 代收行INR
            ,colptynam -- 代收行名称
            ,ownref -- 打包托收的业务参考号
            ,colptyref -- 代收行的编号
            ,opndat -- 开立日期
            ,clsdat -- 闭卷日期
            ,ver -- 版本号
            ,credat -- 创建日期
            ,colptainr -- 代收行地址INR
            ,nam -- 打包托收交易名
            ,colflg -- 付款方式
            ,valdat -- 起息日
            ,count -- 打包的票据总数
            ,colref -- 代收行参考号
            ,creact -- 贷记账号类型
            ,acno -- 账号
            ,regref -- 收单行系统业务代号
            ,bchkeyinr -- 业务经办机构INR
            ,branchinr -- 业务所属机构INR
            ,etyextkey -- 实体组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 唯一ID
    ,o.ownusr -- 经办人
    ,o.chktyp -- 票据类型
    ,o.colptyinr -- 代收行INR
    ,o.colptynam -- 代收行名称
    ,o.ownref -- 打包托收的业务参考号
    ,o.colptyref -- 代收行的编号
    ,o.opndat -- 开立日期
    ,o.clsdat -- 闭卷日期
    ,o.ver -- 版本号
    ,o.credat -- 创建日期
    ,o.colptainr -- 代收行地址INR
    ,o.nam -- 打包托收交易名
    ,o.colflg -- 付款方式
    ,o.valdat -- 起息日
    ,o.count -- 打包的票据总数
    ,o.colref -- 代收行参考号
    ,o.creact -- 贷记账号类型
    ,o.acno -- 账号
    ,o.regref -- 收单行系统业务代号
    ,o.bchkeyinr -- 业务经办机构INR
    ,o.branchinr -- 业务所属机构INR
    ,o.etyextkey -- 实体组
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_cld_bk o
    left join ${iol_schema}.isbs_cld_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_cld_cl d
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
-- truncate table ${iol_schema}.isbs_cld;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_cld exchange partition p_19000101 with table ${iol_schema}.isbs_cld_cl;
alter table ${iol_schema}.isbs_cld exchange partition p_20991231 with table ${iol_schema}.isbs_cld_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_cld to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_cld_op purge;
drop table ${iol_schema}.isbs_cld_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_cld_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_cld',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
