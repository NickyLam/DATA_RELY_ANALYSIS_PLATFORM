/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_fpd
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
create table ${iol_schema}.isbs_fpd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_fpd
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fpd_op purge;
drop table ${iol_schema}.isbs_fpd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fpd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fpd where 0=1;

create table ${iol_schema}.isbs_fpd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fpd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fpd_cl(
            inr -- 主键
            ,perint -- 福费廷利率
            ,silflg -- 是否关闭
            ,rdsflg -- 是否可读
            ,funflg -- 是否固定
            ,cnfflg -- 是否资金
            ,ownref -- 参考号
            ,invref -- 信用证业务编号
            ,nam -- 交易简述
            ,amedat -- 修改日期
            ,amenbr -- 修改次数
            ,opndat -- 开立日期
            ,clsdat -- 关闭日期
            ,credat -- 登记日期
            ,expdat -- 开立到期日
            ,nomspc -- 是否上浮
            ,nomtop -- 上浮比例
            ,nomton -- 下浮比例
            ,ownusr -- 经办人
            ,stacty -- 国家代码
            ,opndatlc -- 父业务开立日期
            ,expdatlc -- 父业务结束日期
            ,selnam -- 交单角色名称
            ,invnam -- NV角色名称
            ,selref -- 交单编号
            ,grcdys -- 承诺天数
            ,selopnnbr -- 卖出数量
            ,selnegnbr -- 协议卖出数量
            ,valdat -- 起息日
            ,irtcod -- 浮动类型
            ,ratcal -- 计算费率
            ,ver -- 版本号
            ,pntref -- 父类参考号
            ,pnttyp -- 父类交易类型
            ,pntinr -- 父类交易inr号
            ,pntnam -- 父类交易名称
            ,etyextkey -- 实体关键字
            ,bmhlst -- 包买行集合
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fpd_op(
            inr -- 主键
            ,perint -- 福费廷利率
            ,silflg -- 是否关闭
            ,rdsflg -- 是否可读
            ,funflg -- 是否固定
            ,cnfflg -- 是否资金
            ,ownref -- 参考号
            ,invref -- 信用证业务编号
            ,nam -- 交易简述
            ,amedat -- 修改日期
            ,amenbr -- 修改次数
            ,opndat -- 开立日期
            ,clsdat -- 关闭日期
            ,credat -- 登记日期
            ,expdat -- 开立到期日
            ,nomspc -- 是否上浮
            ,nomtop -- 上浮比例
            ,nomton -- 下浮比例
            ,ownusr -- 经办人
            ,stacty -- 国家代码
            ,opndatlc -- 父业务开立日期
            ,expdatlc -- 父业务结束日期
            ,selnam -- 交单角色名称
            ,invnam -- NV角色名称
            ,selref -- 交单编号
            ,grcdys -- 承诺天数
            ,selopnnbr -- 卖出数量
            ,selnegnbr -- 协议卖出数量
            ,valdat -- 起息日
            ,irtcod -- 浮动类型
            ,ratcal -- 计算费率
            ,ver -- 版本号
            ,pntref -- 父类参考号
            ,pnttyp -- 父类交易类型
            ,pntinr -- 父类交易inr号
            ,pntnam -- 父类交易名称
            ,etyextkey -- 实体关键字
            ,bmhlst -- 包买行集合
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 主键
    ,nvl(n.perint, o.perint) as perint -- 福费廷利率
    ,nvl(n.silflg, o.silflg) as silflg -- 是否关闭
    ,nvl(n.rdsflg, o.rdsflg) as rdsflg -- 是否可读
    ,nvl(n.funflg, o.funflg) as funflg -- 是否固定
    ,nvl(n.cnfflg, o.cnfflg) as cnfflg -- 是否资金
    ,nvl(n.ownref, o.ownref) as ownref -- 参考号
    ,nvl(n.invref, o.invref) as invref -- 信用证业务编号
    ,nvl(n.nam, o.nam) as nam -- 交易简述
    ,nvl(n.amedat, o.amedat) as amedat -- 修改日期
    ,nvl(n.amenbr, o.amenbr) as amenbr -- 修改次数
    ,nvl(n.opndat, o.opndat) as opndat -- 开立日期
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 关闭日期
    ,nvl(n.credat, o.credat) as credat -- 登记日期
    ,nvl(n.expdat, o.expdat) as expdat -- 开立到期日
    ,nvl(n.nomspc, o.nomspc) as nomspc -- 是否上浮
    ,nvl(n.nomtop, o.nomtop) as nomtop -- 上浮比例
    ,nvl(n.nomton, o.nomton) as nomton -- 下浮比例
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 经办人
    ,nvl(n.stacty, o.stacty) as stacty -- 国家代码
    ,nvl(n.opndatlc, o.opndatlc) as opndatlc -- 父业务开立日期
    ,nvl(n.expdatlc, o.expdatlc) as expdatlc -- 父业务结束日期
    ,nvl(n.selnam, o.selnam) as selnam -- 交单角色名称
    ,nvl(n.invnam, o.invnam) as invnam -- NV角色名称
    ,nvl(n.selref, o.selref) as selref -- 交单编号
    ,nvl(n.grcdys, o.grcdys) as grcdys -- 承诺天数
    ,nvl(n.selopnnbr, o.selopnnbr) as selopnnbr -- 卖出数量
    ,nvl(n.selnegnbr, o.selnegnbr) as selnegnbr -- 协议卖出数量
    ,nvl(n.valdat, o.valdat) as valdat -- 起息日
    ,nvl(n.irtcod, o.irtcod) as irtcod -- 浮动类型
    ,nvl(n.ratcal, o.ratcal) as ratcal -- 计算费率
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.pntref, o.pntref) as pntref -- 父类参考号
    ,nvl(n.pnttyp, o.pnttyp) as pnttyp -- 父类交易类型
    ,nvl(n.pntinr, o.pntinr) as pntinr -- 父类交易inr号
    ,nvl(n.pntnam, o.pntnam) as pntnam -- 父类交易名称
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 实体关键字
    ,nvl(n.bmhlst, o.bmhlst) as bmhlst -- 包买行集合
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
from (select * from ${iol_schema}.isbs_fpd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_fpd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.perint <> n.perint
        or o.silflg <> n.silflg
        or o.rdsflg <> n.rdsflg
        or o.funflg <> n.funflg
        or o.cnfflg <> n.cnfflg
        or o.ownref <> n.ownref
        or o.invref <> n.invref
        or o.nam <> n.nam
        or o.amedat <> n.amedat
        or o.amenbr <> n.amenbr
        or o.opndat <> n.opndat
        or o.clsdat <> n.clsdat
        or o.credat <> n.credat
        or o.expdat <> n.expdat
        or o.nomspc <> n.nomspc
        or o.nomtop <> n.nomtop
        or o.nomton <> n.nomton
        or o.ownusr <> n.ownusr
        or o.stacty <> n.stacty
        or o.opndatlc <> n.opndatlc
        or o.expdatlc <> n.expdatlc
        or o.selnam <> n.selnam
        or o.invnam <> n.invnam
        or o.selref <> n.selref
        or o.grcdys <> n.grcdys
        or o.selopnnbr <> n.selopnnbr
        or o.selnegnbr <> n.selnegnbr
        or o.valdat <> n.valdat
        or o.irtcod <> n.irtcod
        or o.ratcal <> n.ratcal
        or o.ver <> n.ver
        or o.pntref <> n.pntref
        or o.pnttyp <> n.pnttyp
        or o.pntinr <> n.pntinr
        or o.pntnam <> n.pntnam
        or o.etyextkey <> n.etyextkey
        or o.bmhlst <> n.bmhlst
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fpd_cl(
            inr -- 主键
            ,perint -- 福费廷利率
            ,silflg -- 是否关闭
            ,rdsflg -- 是否可读
            ,funflg -- 是否固定
            ,cnfflg -- 是否资金
            ,ownref -- 参考号
            ,invref -- 信用证业务编号
            ,nam -- 交易简述
            ,amedat -- 修改日期
            ,amenbr -- 修改次数
            ,opndat -- 开立日期
            ,clsdat -- 关闭日期
            ,credat -- 登记日期
            ,expdat -- 开立到期日
            ,nomspc -- 是否上浮
            ,nomtop -- 上浮比例
            ,nomton -- 下浮比例
            ,ownusr -- 经办人
            ,stacty -- 国家代码
            ,opndatlc -- 父业务开立日期
            ,expdatlc -- 父业务结束日期
            ,selnam -- 交单角色名称
            ,invnam -- NV角色名称
            ,selref -- 交单编号
            ,grcdys -- 承诺天数
            ,selopnnbr -- 卖出数量
            ,selnegnbr -- 协议卖出数量
            ,valdat -- 起息日
            ,irtcod -- 浮动类型
            ,ratcal -- 计算费率
            ,ver -- 版本号
            ,pntref -- 父类参考号
            ,pnttyp -- 父类交易类型
            ,pntinr -- 父类交易inr号
            ,pntnam -- 父类交易名称
            ,etyextkey -- 实体关键字
            ,bmhlst -- 包买行集合
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fpd_op(
            inr -- 主键
            ,perint -- 福费廷利率
            ,silflg -- 是否关闭
            ,rdsflg -- 是否可读
            ,funflg -- 是否固定
            ,cnfflg -- 是否资金
            ,ownref -- 参考号
            ,invref -- 信用证业务编号
            ,nam -- 交易简述
            ,amedat -- 修改日期
            ,amenbr -- 修改次数
            ,opndat -- 开立日期
            ,clsdat -- 关闭日期
            ,credat -- 登记日期
            ,expdat -- 开立到期日
            ,nomspc -- 是否上浮
            ,nomtop -- 上浮比例
            ,nomton -- 下浮比例
            ,ownusr -- 经办人
            ,stacty -- 国家代码
            ,opndatlc -- 父业务开立日期
            ,expdatlc -- 父业务结束日期
            ,selnam -- 交单角色名称
            ,invnam -- NV角色名称
            ,selref -- 交单编号
            ,grcdys -- 承诺天数
            ,selopnnbr -- 卖出数量
            ,selnegnbr -- 协议卖出数量
            ,valdat -- 起息日
            ,irtcod -- 浮动类型
            ,ratcal -- 计算费率
            ,ver -- 版本号
            ,pntref -- 父类参考号
            ,pnttyp -- 父类交易类型
            ,pntinr -- 父类交易inr号
            ,pntnam -- 父类交易名称
            ,etyextkey -- 实体关键字
            ,bmhlst -- 包买行集合
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 主键
    ,o.perint -- 福费廷利率
    ,o.silflg -- 是否关闭
    ,o.rdsflg -- 是否可读
    ,o.funflg -- 是否固定
    ,o.cnfflg -- 是否资金
    ,o.ownref -- 参考号
    ,o.invref -- 信用证业务编号
    ,o.nam -- 交易简述
    ,o.amedat -- 修改日期
    ,o.amenbr -- 修改次数
    ,o.opndat -- 开立日期
    ,o.clsdat -- 关闭日期
    ,o.credat -- 登记日期
    ,o.expdat -- 开立到期日
    ,o.nomspc -- 是否上浮
    ,o.nomtop -- 上浮比例
    ,o.nomton -- 下浮比例
    ,o.ownusr -- 经办人
    ,o.stacty -- 国家代码
    ,o.opndatlc -- 父业务开立日期
    ,o.expdatlc -- 父业务结束日期
    ,o.selnam -- 交单角色名称
    ,o.invnam -- NV角色名称
    ,o.selref -- 交单编号
    ,o.grcdys -- 承诺天数
    ,o.selopnnbr -- 卖出数量
    ,o.selnegnbr -- 协议卖出数量
    ,o.valdat -- 起息日
    ,o.irtcod -- 浮动类型
    ,o.ratcal -- 计算费率
    ,o.ver -- 版本号
    ,o.pntref -- 父类参考号
    ,o.pnttyp -- 父类交易类型
    ,o.pntinr -- 父类交易inr号
    ,o.pntnam -- 父类交易名称
    ,o.etyextkey -- 实体关键字
    ,o.bmhlst -- 包买行集合
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
from ${iol_schema}.isbs_fpd_bk o
    left join ${iol_schema}.isbs_fpd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_fpd_cl d
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
--truncate table ${iol_schema}.isbs_fpd;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_fpd') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_fpd drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_fpd add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_fpd exchange partition p_${batch_date} with table ${iol_schema}.isbs_fpd_cl;
alter table ${iol_schema}.isbs_fpd exchange partition p_20991231 with table ${iol_schema}.isbs_fpd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_fpd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fpd_op purge;
drop table ${iol_schema}.isbs_fpd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_fpd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_fpd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
