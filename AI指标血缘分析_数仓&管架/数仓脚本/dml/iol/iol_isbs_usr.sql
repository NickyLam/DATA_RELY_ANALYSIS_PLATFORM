/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_usr
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
create table ${iol_schema}.isbs_usr_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_usr;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_usr_op purge;
drop table ${iol_schema}.isbs_usr_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_usr_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_usr where 0=1;

create table ${iol_schema}.isbs_usr_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_usr where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_usr_cl(
            inr -- 内部唯一Id
            ,extkey -- 用户ID
            ,nam -- 用户名字
            ,lgiflg -- 禁止登录
            ,ssnbegdattim -- 最近登录时间
            ,ssninr -- SSN ID
            ,ver -- 版本号
            ,pri -- 实体标志
            ,ety -- 实体
            ,usg -- 用户组
            ,lstdiadat -- 最近DIA查看时间
            ,relcur -- 授权币种
            ,relamt -- 授权金额
            ,relamt2nd -- 授权金额
            ,relgrp -- 授权组
            ,tel -- 电话
            ,fax -- 传真
            ,eml -- 电子信箱
            ,quepow -- 可用时间
            ,etyextkey -- 实体名称
            ,oenr -- 组织
            ,etaextkey -- 实体地址
            ,resusrflg -- 客户经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_usr_op(
            inr -- 内部唯一Id
            ,extkey -- 用户ID
            ,nam -- 用户名字
            ,lgiflg -- 禁止登录
            ,ssnbegdattim -- 最近登录时间
            ,ssninr -- SSN ID
            ,ver -- 版本号
            ,pri -- 实体标志
            ,ety -- 实体
            ,usg -- 用户组
            ,lstdiadat -- 最近DIA查看时间
            ,relcur -- 授权币种
            ,relamt -- 授权金额
            ,relamt2nd -- 授权金额
            ,relgrp -- 授权组
            ,tel -- 电话
            ,fax -- 传真
            ,eml -- 电子信箱
            ,quepow -- 可用时间
            ,etyextkey -- 实体名称
            ,oenr -- 组织
            ,etaextkey -- 实体地址
            ,resusrflg -- 客户经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 内部唯一Id
    ,nvl(n.extkey, o.extkey) as extkey -- 用户ID
    ,nvl(n.nam, o.nam) as nam -- 用户名字
    ,nvl(n.lgiflg, o.lgiflg) as lgiflg -- 禁止登录
    ,nvl(n.ssnbegdattim, o.ssnbegdattim) as ssnbegdattim -- 最近登录时间
    ,nvl(n.ssninr, o.ssninr) as ssninr -- SSN ID
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.pri, o.pri) as pri -- 实体标志
    ,nvl(n.ety, o.ety) as ety -- 实体
    ,nvl(n.usg, o.usg) as usg -- 用户组
    ,nvl(n.lstdiadat, o.lstdiadat) as lstdiadat -- 最近DIA查看时间
    ,nvl(n.relcur, o.relcur) as relcur -- 授权币种
    ,nvl(n.relamt, o.relamt) as relamt -- 授权金额
    ,nvl(n.relamt2nd, o.relamt2nd) as relamt2nd -- 授权金额
    ,nvl(n.relgrp, o.relgrp) as relgrp -- 授权组
    ,nvl(n.tel, o.tel) as tel -- 电话
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.eml, o.eml) as eml -- 电子信箱
    ,nvl(n.quepow, o.quepow) as quepow -- 可用时间
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 实体名称
    ,nvl(n.oenr, o.oenr) as oenr -- 组织
    ,nvl(n.etaextkey, o.etaextkey) as etaextkey -- 实体地址
    ,nvl(n.resusrflg, o.resusrflg) as resusrflg -- 客户经理
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
from (select * from ${iol_schema}.isbs_usr_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_usr where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.lgiflg <> n.lgiflg
        or o.ssnbegdattim <> n.ssnbegdattim
        or o.ssninr <> n.ssninr
        or o.ver <> n.ver
        or o.pri <> n.pri
        or o.ety <> n.ety
        or o.usg <> n.usg
        or o.lstdiadat <> n.lstdiadat
        or o.relcur <> n.relcur
        or o.relamt <> n.relamt
        or o.relamt2nd <> n.relamt2nd
        or o.relgrp <> n.relgrp
        or o.tel <> n.tel
        or o.fax <> n.fax
        or o.eml <> n.eml
        or o.quepow <> n.quepow
        or o.etyextkey <> n.etyextkey
        or o.oenr <> n.oenr
        or o.etaextkey <> n.etaextkey
        or o.resusrflg <> n.resusrflg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_usr_cl(
            inr -- 内部唯一Id
            ,extkey -- 用户ID
            ,nam -- 用户名字
            ,lgiflg -- 禁止登录
            ,ssnbegdattim -- 最近登录时间
            ,ssninr -- SSN ID
            ,ver -- 版本号
            ,pri -- 实体标志
            ,ety -- 实体
            ,usg -- 用户组
            ,lstdiadat -- 最近DIA查看时间
            ,relcur -- 授权币种
            ,relamt -- 授权金额
            ,relamt2nd -- 授权金额
            ,relgrp -- 授权组
            ,tel -- 电话
            ,fax -- 传真
            ,eml -- 电子信箱
            ,quepow -- 可用时间
            ,etyextkey -- 实体名称
            ,oenr -- 组织
            ,etaextkey -- 实体地址
            ,resusrflg -- 客户经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_usr_op(
            inr -- 内部唯一Id
            ,extkey -- 用户ID
            ,nam -- 用户名字
            ,lgiflg -- 禁止登录
            ,ssnbegdattim -- 最近登录时间
            ,ssninr -- SSN ID
            ,ver -- 版本号
            ,pri -- 实体标志
            ,ety -- 实体
            ,usg -- 用户组
            ,lstdiadat -- 最近DIA查看时间
            ,relcur -- 授权币种
            ,relamt -- 授权金额
            ,relamt2nd -- 授权金额
            ,relgrp -- 授权组
            ,tel -- 电话
            ,fax -- 传真
            ,eml -- 电子信箱
            ,quepow -- 可用时间
            ,etyextkey -- 实体名称
            ,oenr -- 组织
            ,etaextkey -- 实体地址
            ,resusrflg -- 客户经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 内部唯一Id
    ,o.extkey -- 用户ID
    ,o.nam -- 用户名字
    ,o.lgiflg -- 禁止登录
    ,o.ssnbegdattim -- 最近登录时间
    ,o.ssninr -- SSN ID
    ,o.ver -- 版本号
    ,o.pri -- 实体标志
    ,o.ety -- 实体
    ,o.usg -- 用户组
    ,o.lstdiadat -- 最近DIA查看时间
    ,o.relcur -- 授权币种
    ,o.relamt -- 授权金额
    ,o.relamt2nd -- 授权金额
    ,o.relgrp -- 授权组
    ,o.tel -- 电话
    ,o.fax -- 传真
    ,o.eml -- 电子信箱
    ,o.quepow -- 可用时间
    ,o.etyextkey -- 实体名称
    ,o.oenr -- 组织
    ,o.etaextkey -- 实体地址
    ,o.resusrflg -- 客户经理
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_usr_bk o
    left join ${iol_schema}.isbs_usr_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_usr_cl d
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
-- truncate table ${iol_schema}.isbs_usr;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_usr exchange partition p_19000101 with table ${iol_schema}.isbs_usr_cl;
alter table ${iol_schema}.isbs_usr exchange partition p_20991231 with table ${iol_schema}.isbs_usr_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_usr to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_usr_op purge;
drop table ${iol_schema}.isbs_usr_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_usr_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_usr',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
