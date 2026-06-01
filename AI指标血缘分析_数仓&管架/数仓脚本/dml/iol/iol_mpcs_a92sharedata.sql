/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a92sharedata
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
create table ${iol_schema}.mpcs_a92sharedata_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a92sharedata;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a92sharedata_op purge;
drop table ${iol_schema}.mpcs_a92sharedata_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92sharedata_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a92sharedata where 0=1;

create table ${iol_schema}.mpcs_a92sharedata_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a92sharedata where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a92sharedata_cl(
            paysys -- 服务方简称
            ,instid -- 接入商户号
            ,shareid -- 份额ID
            ,brokeruserid -- 用户账户ID
            ,accountid -- 盈米账户ID
            ,paymentmethodid -- 支付方式ID
            ,fundcode -- 基金代码
            ,sharetypes -- 收费类型A-前端收费  B-后端收费 C-C类收费
            ,totalshare -- 总份额
            ,freezeshare -- 冻结份额
            ,unpaidincome -- 未付收益
            ,dividendmethod -- 分红方式0-红利资金再投 1-现金分红
            ,remark -- 备注
            ,pocode -- 组合代码
            ,newincome -- 最新收益
            ,accumulateincome -- 累计收益
            ,uptdatetime -- 更新日期
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a92sharedata_op(
            paysys -- 服务方简称
            ,instid -- 接入商户号
            ,shareid -- 份额ID
            ,brokeruserid -- 用户账户ID
            ,accountid -- 盈米账户ID
            ,paymentmethodid -- 支付方式ID
            ,fundcode -- 基金代码
            ,sharetypes -- 收费类型A-前端收费  B-后端收费 C-C类收费
            ,totalshare -- 总份额
            ,freezeshare -- 冻结份额
            ,unpaidincome -- 未付收益
            ,dividendmethod -- 分红方式0-红利资金再投 1-现金分红
            ,remark -- 备注
            ,pocode -- 组合代码
            ,newincome -- 最新收益
            ,accumulateincome -- 累计收益
            ,uptdatetime -- 更新日期
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.paysys, o.paysys) as paysys -- 服务方简称
    ,nvl(n.instid, o.instid) as instid -- 接入商户号
    ,nvl(n.shareid, o.shareid) as shareid -- 份额ID
    ,nvl(n.brokeruserid, o.brokeruserid) as brokeruserid -- 用户账户ID
    ,nvl(n.accountid, o.accountid) as accountid -- 盈米账户ID
    ,nvl(n.paymentmethodid, o.paymentmethodid) as paymentmethodid -- 支付方式ID
    ,nvl(n.fundcode, o.fundcode) as fundcode -- 基金代码
    ,nvl(n.sharetypes, o.sharetypes) as sharetypes -- 收费类型A-前端收费  B-后端收费 C-C类收费
    ,nvl(n.totalshare, o.totalshare) as totalshare -- 总份额
    ,nvl(n.freezeshare, o.freezeshare) as freezeshare -- 冻结份额
    ,nvl(n.unpaidincome, o.unpaidincome) as unpaidincome -- 未付收益
    ,nvl(n.dividendmethod, o.dividendmethod) as dividendmethod -- 分红方式0-红利资金再投 1-现金分红
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.pocode, o.pocode) as pocode -- 组合代码
    ,nvl(n.newincome, o.newincome) as newincome -- 最新收益
    ,nvl(n.accumulateincome, o.accumulateincome) as accumulateincome -- 累计收益
    ,nvl(n.uptdatetime, o.uptdatetime) as uptdatetime -- 更新日期
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用字段2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备用字段3
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 备用字段4
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 备用字段5
    ,nvl(n.reserve6, o.reserve6) as reserve6 -- 备用字段6
    ,case when
            n.shareid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.shareid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.shareid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a92sharedata_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a92sharedata where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.shareid = n.shareid
where (
        o.shareid is null
    )
    or (
        n.shareid is null
    )
    or (
        o.paysys <> n.paysys
        or o.instid <> n.instid
        or o.brokeruserid <> n.brokeruserid
        or o.accountid <> n.accountid
        or o.paymentmethodid <> n.paymentmethodid
        or o.fundcode <> n.fundcode
        or o.sharetypes <> n.sharetypes
        or o.totalshare <> n.totalshare
        or o.freezeshare <> n.freezeshare
        or o.unpaidincome <> n.unpaidincome
        or o.dividendmethod <> n.dividendmethod
        or o.remark <> n.remark
        or o.pocode <> n.pocode
        or o.newincome <> n.newincome
        or o.accumulateincome <> n.accumulateincome
        or o.uptdatetime <> n.uptdatetime
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
        or o.reserve6 <> n.reserve6
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a92sharedata_cl(
            paysys -- 服务方简称
            ,instid -- 接入商户号
            ,shareid -- 份额ID
            ,brokeruserid -- 用户账户ID
            ,accountid -- 盈米账户ID
            ,paymentmethodid -- 支付方式ID
            ,fundcode -- 基金代码
            ,sharetypes -- 收费类型A-前端收费  B-后端收费 C-C类收费
            ,totalshare -- 总份额
            ,freezeshare -- 冻结份额
            ,unpaidincome -- 未付收益
            ,dividendmethod -- 分红方式0-红利资金再投 1-现金分红
            ,remark -- 备注
            ,pocode -- 组合代码
            ,newincome -- 最新收益
            ,accumulateincome -- 累计收益
            ,uptdatetime -- 更新日期
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a92sharedata_op(
            paysys -- 服务方简称
            ,instid -- 接入商户号
            ,shareid -- 份额ID
            ,brokeruserid -- 用户账户ID
            ,accountid -- 盈米账户ID
            ,paymentmethodid -- 支付方式ID
            ,fundcode -- 基金代码
            ,sharetypes -- 收费类型A-前端收费  B-后端收费 C-C类收费
            ,totalshare -- 总份额
            ,freezeshare -- 冻结份额
            ,unpaidincome -- 未付收益
            ,dividendmethod -- 分红方式0-红利资金再投 1-现金分红
            ,remark -- 备注
            ,pocode -- 组合代码
            ,newincome -- 最新收益
            ,accumulateincome -- 累计收益
            ,uptdatetime -- 更新日期
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.paysys -- 服务方简称
    ,o.instid -- 接入商户号
    ,o.shareid -- 份额ID
    ,o.brokeruserid -- 用户账户ID
    ,o.accountid -- 盈米账户ID
    ,o.paymentmethodid -- 支付方式ID
    ,o.fundcode -- 基金代码
    ,o.sharetypes -- 收费类型A-前端收费  B-后端收费 C-C类收费
    ,o.totalshare -- 总份额
    ,o.freezeshare -- 冻结份额
    ,o.unpaidincome -- 未付收益
    ,o.dividendmethod -- 分红方式0-红利资金再投 1-现金分红
    ,o.remark -- 备注
    ,o.pocode -- 组合代码
    ,o.newincome -- 最新收益
    ,o.accumulateincome -- 累计收益
    ,o.uptdatetime -- 更新日期
    ,o.reserve1 -- 备用字段1
    ,o.reserve2 -- 备用字段2
    ,o.reserve3 -- 备用字段3
    ,o.reserve4 -- 备用字段4
    ,o.reserve5 -- 备用字段5
    ,o.reserve6 -- 备用字段6
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a92sharedata_bk o
    left join ${iol_schema}.mpcs_a92sharedata_op n
        on
            o.shareid = n.shareid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a92sharedata_cl d
        on
            o.shareid = d.shareid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a92sharedata;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a92sharedata exchange partition p_19000101 with table ${iol_schema}.mpcs_a92sharedata_cl;
alter table ${iol_schema}.mpcs_a92sharedata exchange partition p_20991231 with table ${iol_schema}.mpcs_a92sharedata_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a92sharedata to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a92sharedata_op purge;
drop table ${iol_schema}.mpcs_a92sharedata_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a92sharedata_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a92sharedata',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
