/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_ccd
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
create table ${iol_schema}.isbs_ccd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_ccd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ccd_op purge;
drop table ${iol_schema}.isbs_ccd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ccd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ccd where 0=1;

create table ${iol_schema}.isbs_ccd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ccd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ccd_cl(
            inr -- 光票托收交易ID号
            ,ownusr -- 经办人
            ,ownref -- 业务参考号
            ,nam -- 光票托收交易名
            ,corptyinr -- 汇票受票行的INR
            ,corptainr -- 汇票受票行地址
            ,cornam -- 汇票受票行名称
            ,corref -- 汇票受票行参考号
            ,nobptyinr -- 清算行的INR
            ,nobptainr -- 清算行地址
            ,nobnam -- 清算行名称
            ,nobref -- 清算行参考号
            ,droptyinr -- 付款行INR
            ,droptainr -- 付款行地址
            ,dronam -- 付款行名称
            ,droref -- 付款行参考号
            ,preptyinr -- 托收人/收款人的INR
            ,preptainr -- 托收人/收款人的地址
            ,prenam -- 托收人/收款人的名称
            ,preref -- 托收人/收款人的参考号
            ,chkdat -- 出票日期
            ,credat -- 创建日期
            ,clsdat -- 结束日期
            ,paydat -- 收款日期
            ,opndat -- 开始日期
            ,stacty -- 国家代码
            ,ngrcod -- 货物代码
            ,infdsp -- 显示信息标志
            ,ccform -- 光票托收形式
            ,purflg -- 付款方式
            ,modset -- 结算方式
            ,tocsel -- 票据类型
            ,brchref -- 支行参考号
            ,chcknum -- 支票号
            ,colref -- 代收行参考号
            ,colnam -- 代收行名称
            ,colptyinr -- 代收行INR
            ,colptainr -- 代收行地址
            ,rptbtchno -- 打包托收的业务参考好
            ,bchkeyinr -- 业务经办机构INR
            ,branchinr -- 业务所属机构INR
            ,vercerref -- 核销单号
            ,decnum -- 申报单号
            ,pretyp -- 托收人/收款人类型
            ,prodat -- 打包托收收款日期
            ,regref -- 收单行系统业务代号
            ,ver -- 版本号
            ,frepayflg -- 自由付款标志
            ,etyextkey -- 实体组
            ,nraflg -- 是否NRA付款
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ccd_op(
            inr -- 光票托收交易ID号
            ,ownusr -- 经办人
            ,ownref -- 业务参考号
            ,nam -- 光票托收交易名
            ,corptyinr -- 汇票受票行的INR
            ,corptainr -- 汇票受票行地址
            ,cornam -- 汇票受票行名称
            ,corref -- 汇票受票行参考号
            ,nobptyinr -- 清算行的INR
            ,nobptainr -- 清算行地址
            ,nobnam -- 清算行名称
            ,nobref -- 清算行参考号
            ,droptyinr -- 付款行INR
            ,droptainr -- 付款行地址
            ,dronam -- 付款行名称
            ,droref -- 付款行参考号
            ,preptyinr -- 托收人/收款人的INR
            ,preptainr -- 托收人/收款人的地址
            ,prenam -- 托收人/收款人的名称
            ,preref -- 托收人/收款人的参考号
            ,chkdat -- 出票日期
            ,credat -- 创建日期
            ,clsdat -- 结束日期
            ,paydat -- 收款日期
            ,opndat -- 开始日期
            ,stacty -- 国家代码
            ,ngrcod -- 货物代码
            ,infdsp -- 显示信息标志
            ,ccform -- 光票托收形式
            ,purflg -- 付款方式
            ,modset -- 结算方式
            ,tocsel -- 票据类型
            ,brchref -- 支行参考号
            ,chcknum -- 支票号
            ,colref -- 代收行参考号
            ,colnam -- 代收行名称
            ,colptyinr -- 代收行INR
            ,colptainr -- 代收行地址
            ,rptbtchno -- 打包托收的业务参考好
            ,bchkeyinr -- 业务经办机构INR
            ,branchinr -- 业务所属机构INR
            ,vercerref -- 核销单号
            ,decnum -- 申报单号
            ,pretyp -- 托收人/收款人类型
            ,prodat -- 打包托收收款日期
            ,regref -- 收单行系统业务代号
            ,ver -- 版本号
            ,frepayflg -- 自由付款标志
            ,etyextkey -- 实体组
            ,nraflg -- 是否NRA付款
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 光票托收交易ID号
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 经办人
    ,nvl(n.ownref, o.ownref) as ownref -- 业务参考号
    ,nvl(n.nam, o.nam) as nam -- 光票托收交易名
    ,nvl(n.corptyinr, o.corptyinr) as corptyinr -- 汇票受票行的INR
    ,nvl(n.corptainr, o.corptainr) as corptainr -- 汇票受票行地址
    ,nvl(n.cornam, o.cornam) as cornam -- 汇票受票行名称
    ,nvl(n.corref, o.corref) as corref -- 汇票受票行参考号
    ,nvl(n.nobptyinr, o.nobptyinr) as nobptyinr -- 清算行的INR
    ,nvl(n.nobptainr, o.nobptainr) as nobptainr -- 清算行地址
    ,nvl(n.nobnam, o.nobnam) as nobnam -- 清算行名称
    ,nvl(n.nobref, o.nobref) as nobref -- 清算行参考号
    ,nvl(n.droptyinr, o.droptyinr) as droptyinr -- 付款行INR
    ,nvl(n.droptainr, o.droptainr) as droptainr -- 付款行地址
    ,nvl(n.dronam, o.dronam) as dronam -- 付款行名称
    ,nvl(n.droref, o.droref) as droref -- 付款行参考号
    ,nvl(n.preptyinr, o.preptyinr) as preptyinr -- 托收人/收款人的INR
    ,nvl(n.preptainr, o.preptainr) as preptainr -- 托收人/收款人的地址
    ,nvl(n.prenam, o.prenam) as prenam -- 托收人/收款人的名称
    ,nvl(n.preref, o.preref) as preref -- 托收人/收款人的参考号
    ,nvl(n.chkdat, o.chkdat) as chkdat -- 出票日期
    ,nvl(n.credat, o.credat) as credat -- 创建日期
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 结束日期
    ,nvl(n.paydat, o.paydat) as paydat -- 收款日期
    ,nvl(n.opndat, o.opndat) as opndat -- 开始日期
    ,nvl(n.stacty, o.stacty) as stacty -- 国家代码
    ,nvl(n.ngrcod, o.ngrcod) as ngrcod -- 货物代码
    ,nvl(n.infdsp, o.infdsp) as infdsp -- 显示信息标志
    ,nvl(n.ccform, o.ccform) as ccform -- 光票托收形式
    ,nvl(n.purflg, o.purflg) as purflg -- 付款方式
    ,nvl(n.modset, o.modset) as modset -- 结算方式
    ,nvl(n.tocsel, o.tocsel) as tocsel -- 票据类型
    ,nvl(n.brchref, o.brchref) as brchref -- 支行参考号
    ,nvl(n.chcknum, o.chcknum) as chcknum -- 支票号
    ,nvl(n.colref, o.colref) as colref -- 代收行参考号
    ,nvl(n.colnam, o.colnam) as colnam -- 代收行名称
    ,nvl(n.colptyinr, o.colptyinr) as colptyinr -- 代收行INR
    ,nvl(n.colptainr, o.colptainr) as colptainr -- 代收行地址
    ,nvl(n.rptbtchno, o.rptbtchno) as rptbtchno -- 打包托收的业务参考好
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 业务经办机构INR
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 业务所属机构INR
    ,nvl(n.vercerref, o.vercerref) as vercerref -- 核销单号
    ,nvl(n.decnum, o.decnum) as decnum -- 申报单号
    ,nvl(n.pretyp, o.pretyp) as pretyp -- 托收人/收款人类型
    ,nvl(n.prodat, o.prodat) as prodat -- 打包托收收款日期
    ,nvl(n.regref, o.regref) as regref -- 收单行系统业务代号
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.frepayflg, o.frepayflg) as frepayflg -- 自由付款标志
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 实体组
    ,nvl(n.nraflg, o.nraflg) as nraflg -- 是否NRA付款
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
from (select * from ${iol_schema}.isbs_ccd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_ccd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.ownref <> n.ownref
        or o.nam <> n.nam
        or o.corptyinr <> n.corptyinr
        or o.corptainr <> n.corptainr
        or o.cornam <> n.cornam
        or o.corref <> n.corref
        or o.nobptyinr <> n.nobptyinr
        or o.nobptainr <> n.nobptainr
        or o.nobnam <> n.nobnam
        or o.nobref <> n.nobref
        or o.droptyinr <> n.droptyinr
        or o.droptainr <> n.droptainr
        or o.dronam <> n.dronam
        or o.droref <> n.droref
        or o.preptyinr <> n.preptyinr
        or o.preptainr <> n.preptainr
        or o.prenam <> n.prenam
        or o.preref <> n.preref
        or o.chkdat <> n.chkdat
        or o.credat <> n.credat
        or o.clsdat <> n.clsdat
        or o.paydat <> n.paydat
        or o.opndat <> n.opndat
        or o.stacty <> n.stacty
        or o.ngrcod <> n.ngrcod
        or o.infdsp <> n.infdsp
        or o.ccform <> n.ccform
        or o.purflg <> n.purflg
        or o.modset <> n.modset
        or o.tocsel <> n.tocsel
        or o.brchref <> n.brchref
        or o.chcknum <> n.chcknum
        or o.colref <> n.colref
        or o.colnam <> n.colnam
        or o.colptyinr <> n.colptyinr
        or o.colptainr <> n.colptainr
        or o.rptbtchno <> n.rptbtchno
        or o.bchkeyinr <> n.bchkeyinr
        or o.branchinr <> n.branchinr
        or o.vercerref <> n.vercerref
        or o.decnum <> n.decnum
        or o.pretyp <> n.pretyp
        or o.prodat <> n.prodat
        or o.regref <> n.regref
        or o.ver <> n.ver
        or o.frepayflg <> n.frepayflg
        or o.etyextkey <> n.etyextkey
        or o.nraflg <> n.nraflg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ccd_cl(
            inr -- 光票托收交易ID号
            ,ownusr -- 经办人
            ,ownref -- 业务参考号
            ,nam -- 光票托收交易名
            ,corptyinr -- 汇票受票行的INR
            ,corptainr -- 汇票受票行地址
            ,cornam -- 汇票受票行名称
            ,corref -- 汇票受票行参考号
            ,nobptyinr -- 清算行的INR
            ,nobptainr -- 清算行地址
            ,nobnam -- 清算行名称
            ,nobref -- 清算行参考号
            ,droptyinr -- 付款行INR
            ,droptainr -- 付款行地址
            ,dronam -- 付款行名称
            ,droref -- 付款行参考号
            ,preptyinr -- 托收人/收款人的INR
            ,preptainr -- 托收人/收款人的地址
            ,prenam -- 托收人/收款人的名称
            ,preref -- 托收人/收款人的参考号
            ,chkdat -- 出票日期
            ,credat -- 创建日期
            ,clsdat -- 结束日期
            ,paydat -- 收款日期
            ,opndat -- 开始日期
            ,stacty -- 国家代码
            ,ngrcod -- 货物代码
            ,infdsp -- 显示信息标志
            ,ccform -- 光票托收形式
            ,purflg -- 付款方式
            ,modset -- 结算方式
            ,tocsel -- 票据类型
            ,brchref -- 支行参考号
            ,chcknum -- 支票号
            ,colref -- 代收行参考号
            ,colnam -- 代收行名称
            ,colptyinr -- 代收行INR
            ,colptainr -- 代收行地址
            ,rptbtchno -- 打包托收的业务参考好
            ,bchkeyinr -- 业务经办机构INR
            ,branchinr -- 业务所属机构INR
            ,vercerref -- 核销单号
            ,decnum -- 申报单号
            ,pretyp -- 托收人/收款人类型
            ,prodat -- 打包托收收款日期
            ,regref -- 收单行系统业务代号
            ,ver -- 版本号
            ,frepayflg -- 自由付款标志
            ,etyextkey -- 实体组
            ,nraflg -- 是否NRA付款
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ccd_op(
            inr -- 光票托收交易ID号
            ,ownusr -- 经办人
            ,ownref -- 业务参考号
            ,nam -- 光票托收交易名
            ,corptyinr -- 汇票受票行的INR
            ,corptainr -- 汇票受票行地址
            ,cornam -- 汇票受票行名称
            ,corref -- 汇票受票行参考号
            ,nobptyinr -- 清算行的INR
            ,nobptainr -- 清算行地址
            ,nobnam -- 清算行名称
            ,nobref -- 清算行参考号
            ,droptyinr -- 付款行INR
            ,droptainr -- 付款行地址
            ,dronam -- 付款行名称
            ,droref -- 付款行参考号
            ,preptyinr -- 托收人/收款人的INR
            ,preptainr -- 托收人/收款人的地址
            ,prenam -- 托收人/收款人的名称
            ,preref -- 托收人/收款人的参考号
            ,chkdat -- 出票日期
            ,credat -- 创建日期
            ,clsdat -- 结束日期
            ,paydat -- 收款日期
            ,opndat -- 开始日期
            ,stacty -- 国家代码
            ,ngrcod -- 货物代码
            ,infdsp -- 显示信息标志
            ,ccform -- 光票托收形式
            ,purflg -- 付款方式
            ,modset -- 结算方式
            ,tocsel -- 票据类型
            ,brchref -- 支行参考号
            ,chcknum -- 支票号
            ,colref -- 代收行参考号
            ,colnam -- 代收行名称
            ,colptyinr -- 代收行INR
            ,colptainr -- 代收行地址
            ,rptbtchno -- 打包托收的业务参考好
            ,bchkeyinr -- 业务经办机构INR
            ,branchinr -- 业务所属机构INR
            ,vercerref -- 核销单号
            ,decnum -- 申报单号
            ,pretyp -- 托收人/收款人类型
            ,prodat -- 打包托收收款日期
            ,regref -- 收单行系统业务代号
            ,ver -- 版本号
            ,frepayflg -- 自由付款标志
            ,etyextkey -- 实体组
            ,nraflg -- 是否NRA付款
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 光票托收交易ID号
    ,o.ownusr -- 经办人
    ,o.ownref -- 业务参考号
    ,o.nam -- 光票托收交易名
    ,o.corptyinr -- 汇票受票行的INR
    ,o.corptainr -- 汇票受票行地址
    ,o.cornam -- 汇票受票行名称
    ,o.corref -- 汇票受票行参考号
    ,o.nobptyinr -- 清算行的INR
    ,o.nobptainr -- 清算行地址
    ,o.nobnam -- 清算行名称
    ,o.nobref -- 清算行参考号
    ,o.droptyinr -- 付款行INR
    ,o.droptainr -- 付款行地址
    ,o.dronam -- 付款行名称
    ,o.droref -- 付款行参考号
    ,o.preptyinr -- 托收人/收款人的INR
    ,o.preptainr -- 托收人/收款人的地址
    ,o.prenam -- 托收人/收款人的名称
    ,o.preref -- 托收人/收款人的参考号
    ,o.chkdat -- 出票日期
    ,o.credat -- 创建日期
    ,o.clsdat -- 结束日期
    ,o.paydat -- 收款日期
    ,o.opndat -- 开始日期
    ,o.stacty -- 国家代码
    ,o.ngrcod -- 货物代码
    ,o.infdsp -- 显示信息标志
    ,o.ccform -- 光票托收形式
    ,o.purflg -- 付款方式
    ,o.modset -- 结算方式
    ,o.tocsel -- 票据类型
    ,o.brchref -- 支行参考号
    ,o.chcknum -- 支票号
    ,o.colref -- 代收行参考号
    ,o.colnam -- 代收行名称
    ,o.colptyinr -- 代收行INR
    ,o.colptainr -- 代收行地址
    ,o.rptbtchno -- 打包托收的业务参考好
    ,o.bchkeyinr -- 业务经办机构INR
    ,o.branchinr -- 业务所属机构INR
    ,o.vercerref -- 核销单号
    ,o.decnum -- 申报单号
    ,o.pretyp -- 托收人/收款人类型
    ,o.prodat -- 打包托收收款日期
    ,o.regref -- 收单行系统业务代号
    ,o.ver -- 版本号
    ,o.frepayflg -- 自由付款标志
    ,o.etyextkey -- 实体组
    ,o.nraflg -- 是否NRA付款
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_ccd_bk o
    left join ${iol_schema}.isbs_ccd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_ccd_cl d
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
-- truncate table ${iol_schema}.isbs_ccd;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_ccd exchange partition p_19000101 with table ${iol_schema}.isbs_ccd_cl;
alter table ${iol_schema}.isbs_ccd exchange partition p_20991231 with table ${iol_schema}.isbs_ccd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_ccd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ccd_op purge;
drop table ${iol_schema}.isbs_ccd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_ccd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_ccd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
