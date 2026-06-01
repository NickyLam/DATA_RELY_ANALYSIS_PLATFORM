/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_fep
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
create table ${iol_schema}.isbs_fep_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_fep
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fep_op purge;
drop table ${iol_schema}.isbs_fep_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fep_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fep where 0=1;

create table ${iol_schema}.isbs_fep_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fep where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fep_cl(
            inr -- 内部唯一ID
            ,feecod -- 费用代码
            ,objtyp -- 对象表名称
            ,objinr -- 对象表INR
            ,relobjtyp -- 相关对象类型
            ,relobjinr -- 相关对象的INR
            ,extkey -- 外部可见名
            ,nam -- 费用文本信息
            ,relcur -- 相关币种
            ,relamt -- 相关金额
            ,dat1 -- 费用收取起始日
            ,dat2 -- 费用收取截止日
            ,modflg -- 修改标志（费用变化状态）
            ,unt -- 费用收取的份数
            ,untamt -- 每份费用的金额
            ,ratcal -- 计算使用的费率
            ,rat -- 费率
            ,minmaxflg -- 最低最高费率使用标示
            ,cur -- 费用币种
            ,amt -- 费用金额
            ,xrfcur -- 费用折算后的币种
            ,xrfamt -- 费用折算后的金额
            ,feeacc -- 费用入账的账号
            ,infdetstm -- 费用计算细节
            ,ptyinr -- 支付实体的INR
            ,srctrninr -- 创建或者修改该费用的交易的TRN表INR
            ,srcdat -- 创建日期
            ,rpltrninr -- 取代交易的TRNINR
            ,rpldat -- 取代日期
            ,dontrninr -- 结算费用交易的TRN表INR
            ,dondat -- 结算日期
            ,advtrninr -- 通知费用交易的TRN表INR
            ,advdat -- 通知日期
            ,acrinr -- 循环计算的INR
            ,sepinr -- 对应的临时结算的INR
            ,rol -- 角色
            ,ogiamt -- 应收金额
            ,dctamt -- 优惠金额
            ,amoflg -- 
            ,amoref -- 
            ,amosta -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fep_op(
            inr -- 内部唯一ID
            ,feecod -- 费用代码
            ,objtyp -- 对象表名称
            ,objinr -- 对象表INR
            ,relobjtyp -- 相关对象类型
            ,relobjinr -- 相关对象的INR
            ,extkey -- 外部可见名
            ,nam -- 费用文本信息
            ,relcur -- 相关币种
            ,relamt -- 相关金额
            ,dat1 -- 费用收取起始日
            ,dat2 -- 费用收取截止日
            ,modflg -- 修改标志（费用变化状态）
            ,unt -- 费用收取的份数
            ,untamt -- 每份费用的金额
            ,ratcal -- 计算使用的费率
            ,rat -- 费率
            ,minmaxflg -- 最低最高费率使用标示
            ,cur -- 费用币种
            ,amt -- 费用金额
            ,xrfcur -- 费用折算后的币种
            ,xrfamt -- 费用折算后的金额
            ,feeacc -- 费用入账的账号
            ,infdetstm -- 费用计算细节
            ,ptyinr -- 支付实体的INR
            ,srctrninr -- 创建或者修改该费用的交易的TRN表INR
            ,srcdat -- 创建日期
            ,rpltrninr -- 取代交易的TRNINR
            ,rpldat -- 取代日期
            ,dontrninr -- 结算费用交易的TRN表INR
            ,dondat -- 结算日期
            ,advtrninr -- 通知费用交易的TRN表INR
            ,advdat -- 通知日期
            ,acrinr -- 循环计算的INR
            ,sepinr -- 对应的临时结算的INR
            ,rol -- 角色
            ,ogiamt -- 应收金额
            ,dctamt -- 优惠金额
            ,amoflg -- 
            ,amoref -- 
            ,amosta -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 内部唯一ID
    ,nvl(n.feecod, o.feecod) as feecod -- 费用代码
    ,nvl(n.objtyp, o.objtyp) as objtyp -- 对象表名称
    ,nvl(n.objinr, o.objinr) as objinr -- 对象表INR
    ,nvl(n.relobjtyp, o.relobjtyp) as relobjtyp -- 相关对象类型
    ,nvl(n.relobjinr, o.relobjinr) as relobjinr -- 相关对象的INR
    ,nvl(n.extkey, o.extkey) as extkey -- 外部可见名
    ,nvl(n.nam, o.nam) as nam -- 费用文本信息
    ,nvl(n.relcur, o.relcur) as relcur -- 相关币种
    ,nvl(n.relamt, o.relamt) as relamt -- 相关金额
    ,nvl(n.dat1, o.dat1) as dat1 -- 费用收取起始日
    ,nvl(n.dat2, o.dat2) as dat2 -- 费用收取截止日
    ,nvl(n.modflg, o.modflg) as modflg -- 修改标志（费用变化状态）
    ,nvl(n.unt, o.unt) as unt -- 费用收取的份数
    ,nvl(n.untamt, o.untamt) as untamt -- 每份费用的金额
    ,nvl(n.ratcal, o.ratcal) as ratcal -- 计算使用的费率
    ,nvl(n.rat, o.rat) as rat -- 费率
    ,nvl(n.minmaxflg, o.minmaxflg) as minmaxflg -- 最低最高费率使用标示
    ,nvl(n.cur, o.cur) as cur -- 费用币种
    ,nvl(n.amt, o.amt) as amt -- 费用金额
    ,nvl(n.xrfcur, o.xrfcur) as xrfcur -- 费用折算后的币种
    ,nvl(n.xrfamt, o.xrfamt) as xrfamt -- 费用折算后的金额
    ,nvl(n.feeacc, o.feeacc) as feeacc -- 费用入账的账号
    ,nvl(n.infdetstm, o.infdetstm) as infdetstm -- 费用计算细节
    ,nvl(n.ptyinr, o.ptyinr) as ptyinr -- 支付实体的INR
    ,nvl(n.srctrninr, o.srctrninr) as srctrninr -- 创建或者修改该费用的交易的TRN表INR
    ,nvl(n.srcdat, o.srcdat) as srcdat -- 创建日期
    ,nvl(n.rpltrninr, o.rpltrninr) as rpltrninr -- 取代交易的TRNINR
    ,nvl(n.rpldat, o.rpldat) as rpldat -- 取代日期
    ,nvl(n.dontrninr, o.dontrninr) as dontrninr -- 结算费用交易的TRN表INR
    ,nvl(n.dondat, o.dondat) as dondat -- 结算日期
    ,nvl(n.advtrninr, o.advtrninr) as advtrninr -- 通知费用交易的TRN表INR
    ,nvl(n.advdat, o.advdat) as advdat -- 通知日期
    ,nvl(n.acrinr, o.acrinr) as acrinr -- 循环计算的INR
    ,nvl(n.sepinr, o.sepinr) as sepinr -- 对应的临时结算的INR
    ,nvl(n.rol, o.rol) as rol -- 角色
    ,nvl(n.ogiamt, o.ogiamt) as ogiamt -- 应收金额
    ,nvl(n.dctamt, o.dctamt) as dctamt -- 优惠金额
    ,nvl(n.amoflg, o.amoflg) as amoflg -- 
    ,nvl(n.amoref, o.amoref) as amoref -- 
    ,nvl(n.amosta, o.amosta) as amosta -- 
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
from (select * from ${iol_schema}.isbs_fep_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_fep where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.feecod <> n.feecod
        or o.objtyp <> n.objtyp
        or o.objinr <> n.objinr
        or o.relobjtyp <> n.relobjtyp
        or o.relobjinr <> n.relobjinr
        or o.extkey <> n.extkey
        or o.nam <> n.nam
        or o.relcur <> n.relcur
        or o.relamt <> n.relamt
        or o.dat1 <> n.dat1
        or o.dat2 <> n.dat2
        or o.modflg <> n.modflg
        or o.unt <> n.unt
        or o.untamt <> n.untamt
        or o.ratcal <> n.ratcal
        or o.rat <> n.rat
        or o.minmaxflg <> n.minmaxflg
        or o.cur <> n.cur
        or o.amt <> n.amt
        or o.xrfcur <> n.xrfcur
        or o.xrfamt <> n.xrfamt
        or o.feeacc <> n.feeacc
        or o.infdetstm <> n.infdetstm
        or o.ptyinr <> n.ptyinr
        or o.srctrninr <> n.srctrninr
        or o.srcdat <> n.srcdat
        or o.rpltrninr <> n.rpltrninr
        or o.rpldat <> n.rpldat
        or o.dontrninr <> n.dontrninr
        or o.dondat <> n.dondat
        or o.advtrninr <> n.advtrninr
        or o.advdat <> n.advdat
        or o.acrinr <> n.acrinr
        or o.sepinr <> n.sepinr
        or o.rol <> n.rol
        or o.ogiamt <> n.ogiamt
        or o.dctamt <> n.dctamt
        or o.amoflg <> n.amoflg
        or o.amoref <> n.amoref
        or o.amosta <> n.amosta
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fep_cl(
            inr -- 内部唯一ID
            ,feecod -- 费用代码
            ,objtyp -- 对象表名称
            ,objinr -- 对象表INR
            ,relobjtyp -- 相关对象类型
            ,relobjinr -- 相关对象的INR
            ,extkey -- 外部可见名
            ,nam -- 费用文本信息
            ,relcur -- 相关币种
            ,relamt -- 相关金额
            ,dat1 -- 费用收取起始日
            ,dat2 -- 费用收取截止日
            ,modflg -- 修改标志（费用变化状态）
            ,unt -- 费用收取的份数
            ,untamt -- 每份费用的金额
            ,ratcal -- 计算使用的费率
            ,rat -- 费率
            ,minmaxflg -- 最低最高费率使用标示
            ,cur -- 费用币种
            ,amt -- 费用金额
            ,xrfcur -- 费用折算后的币种
            ,xrfamt -- 费用折算后的金额
            ,feeacc -- 费用入账的账号
            ,infdetstm -- 费用计算细节
            ,ptyinr -- 支付实体的INR
            ,srctrninr -- 创建或者修改该费用的交易的TRN表INR
            ,srcdat -- 创建日期
            ,rpltrninr -- 取代交易的TRNINR
            ,rpldat -- 取代日期
            ,dontrninr -- 结算费用交易的TRN表INR
            ,dondat -- 结算日期
            ,advtrninr -- 通知费用交易的TRN表INR
            ,advdat -- 通知日期
            ,acrinr -- 循环计算的INR
            ,sepinr -- 对应的临时结算的INR
            ,rol -- 角色
            ,ogiamt -- 应收金额
            ,dctamt -- 优惠金额
            ,amoflg -- 
            ,amoref -- 
            ,amosta -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fep_op(
            inr -- 内部唯一ID
            ,feecod -- 费用代码
            ,objtyp -- 对象表名称
            ,objinr -- 对象表INR
            ,relobjtyp -- 相关对象类型
            ,relobjinr -- 相关对象的INR
            ,extkey -- 外部可见名
            ,nam -- 费用文本信息
            ,relcur -- 相关币种
            ,relamt -- 相关金额
            ,dat1 -- 费用收取起始日
            ,dat2 -- 费用收取截止日
            ,modflg -- 修改标志（费用变化状态）
            ,unt -- 费用收取的份数
            ,untamt -- 每份费用的金额
            ,ratcal -- 计算使用的费率
            ,rat -- 费率
            ,minmaxflg -- 最低最高费率使用标示
            ,cur -- 费用币种
            ,amt -- 费用金额
            ,xrfcur -- 费用折算后的币种
            ,xrfamt -- 费用折算后的金额
            ,feeacc -- 费用入账的账号
            ,infdetstm -- 费用计算细节
            ,ptyinr -- 支付实体的INR
            ,srctrninr -- 创建或者修改该费用的交易的TRN表INR
            ,srcdat -- 创建日期
            ,rpltrninr -- 取代交易的TRNINR
            ,rpldat -- 取代日期
            ,dontrninr -- 结算费用交易的TRN表INR
            ,dondat -- 结算日期
            ,advtrninr -- 通知费用交易的TRN表INR
            ,advdat -- 通知日期
            ,acrinr -- 循环计算的INR
            ,sepinr -- 对应的临时结算的INR
            ,rol -- 角色
            ,ogiamt -- 应收金额
            ,dctamt -- 优惠金额
            ,amoflg -- 
            ,amoref -- 
            ,amosta -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 内部唯一ID
    ,o.feecod -- 费用代码
    ,o.objtyp -- 对象表名称
    ,o.objinr -- 对象表INR
    ,o.relobjtyp -- 相关对象类型
    ,o.relobjinr -- 相关对象的INR
    ,o.extkey -- 外部可见名
    ,o.nam -- 费用文本信息
    ,o.relcur -- 相关币种
    ,o.relamt -- 相关金额
    ,o.dat1 -- 费用收取起始日
    ,o.dat2 -- 费用收取截止日
    ,o.modflg -- 修改标志（费用变化状态）
    ,o.unt -- 费用收取的份数
    ,o.untamt -- 每份费用的金额
    ,o.ratcal -- 计算使用的费率
    ,o.rat -- 费率
    ,o.minmaxflg -- 最低最高费率使用标示
    ,o.cur -- 费用币种
    ,o.amt -- 费用金额
    ,o.xrfcur -- 费用折算后的币种
    ,o.xrfamt -- 费用折算后的金额
    ,o.feeacc -- 费用入账的账号
    ,o.infdetstm -- 费用计算细节
    ,o.ptyinr -- 支付实体的INR
    ,o.srctrninr -- 创建或者修改该费用的交易的TRN表INR
    ,o.srcdat -- 创建日期
    ,o.rpltrninr -- 取代交易的TRNINR
    ,o.rpldat -- 取代日期
    ,o.dontrninr -- 结算费用交易的TRN表INR
    ,o.dondat -- 结算日期
    ,o.advtrninr -- 通知费用交易的TRN表INR
    ,o.advdat -- 通知日期
    ,o.acrinr -- 循环计算的INR
    ,o.sepinr -- 对应的临时结算的INR
    ,o.rol -- 角色
    ,o.ogiamt -- 应收金额
    ,o.dctamt -- 优惠金额
    ,o.amoflg -- 
    ,o.amoref -- 
    ,o.amosta -- 
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
from ${iol_schema}.isbs_fep_bk o
    left join ${iol_schema}.isbs_fep_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_fep_cl d
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
--truncate table ${iol_schema}.isbs_fep;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_fep') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_fep drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_fep add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_fep exchange partition p_${batch_date} with table ${iol_schema}.isbs_fep_cl;
alter table ${iol_schema}.isbs_fep exchange partition p_20991231 with table ${iol_schema}.isbs_fep_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_fep to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fep_op purge;
drop table ${iol_schema}.isbs_fep_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_fep_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_fep',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
