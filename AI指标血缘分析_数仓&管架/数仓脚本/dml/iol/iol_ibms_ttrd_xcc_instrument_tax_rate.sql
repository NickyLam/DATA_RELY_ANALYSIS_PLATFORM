/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_xcc_instrument_tax_rate
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
create table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_op purge;
drop table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate where 0=1;

create table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_cl(
            rate_id -- 
            ,p_class -- 
            ,tax_calc_type -- 
            ,tax_output_type -- 
            ,tax_rate_field -- 
            ,tax_rate -- 
            ,p_type -- 
            ,tax_item -- 商品或应税服务名称利息收入(1000_0:地方政府债；1000_1：国债；1000_2：金融同业往来业务；1000_3：利息收入；1000_4：其他贷款服  务)；商品或应税服务名称买卖价差（2000_0：债券转让；2000_1：其他金融商品转让）
            ,tax_billreq -- 业务开票要求( 0：普通发票 1：专用发票 2：不开票 )
            ,tax_methodcal -- 计税方法0：一般计税方法 1：简易计税方法 2：零税率 3：免征 4：减征 5：即征即退
            ,updatetime -- 
            ,userid -- 
            ,tax_type_rate -- 征税类型 0 征税 1 免税 2 不征税
            ,status -- 状态 0 禁用 1 启用
            ,beg_date -- 
            ,end_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_op(
            rate_id -- 
            ,p_class -- 
            ,tax_calc_type -- 
            ,tax_output_type -- 
            ,tax_rate_field -- 
            ,tax_rate -- 
            ,p_type -- 
            ,tax_item -- 商品或应税服务名称利息收入(1000_0:地方政府债；1000_1：国债；1000_2：金融同业往来业务；1000_3：利息收入；1000_4：其他贷款服  务)；商品或应税服务名称买卖价差（2000_0：债券转让；2000_1：其他金融商品转让）
            ,tax_billreq -- 业务开票要求( 0：普通发票 1：专用发票 2：不开票 )
            ,tax_methodcal -- 计税方法0：一般计税方法 1：简易计税方法 2：零税率 3：免征 4：减征 5：即征即退
            ,updatetime -- 
            ,userid -- 
            ,tax_type_rate -- 征税类型 0 征税 1 免税 2 不征税
            ,status -- 状态 0 禁用 1 启用
            ,beg_date -- 
            ,end_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rate_id, o.rate_id) as rate_id -- 
    ,nvl(n.p_class, o.p_class) as p_class -- 
    ,nvl(n.tax_calc_type, o.tax_calc_type) as tax_calc_type -- 
    ,nvl(n.tax_output_type, o.tax_output_type) as tax_output_type -- 
    ,nvl(n.tax_rate_field, o.tax_rate_field) as tax_rate_field -- 
    ,nvl(n.tax_rate, o.tax_rate) as tax_rate -- 
    ,nvl(n.p_type, o.p_type) as p_type -- 
    ,nvl(n.tax_item, o.tax_item) as tax_item -- 商品或应税服务名称利息收入(1000_0:地方政府债；1000_1：国债；1000_2：金融同业往来业务；1000_3：利息收入；1000_4：其他贷款服  务)；商品或应税服务名称买卖价差（2000_0：债券转让；2000_1：其他金融商品转让）
    ,nvl(n.tax_billreq, o.tax_billreq) as tax_billreq -- 业务开票要求( 0：普通发票 1：专用发票 2：不开票 )
    ,nvl(n.tax_methodcal, o.tax_methodcal) as tax_methodcal -- 计税方法0：一般计税方法 1：简易计税方法 2：零税率 3：免征 4：减征 5：即征即退
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 
    ,nvl(n.userid, o.userid) as userid -- 
    ,nvl(n.tax_type_rate, o.tax_type_rate) as tax_type_rate -- 征税类型 0 征税 1 免税 2 不征税
    ,nvl(n.status, o.status) as status -- 状态 0 禁用 1 启用
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 
    ,nvl(n.end_date, o.end_date) as end_date -- 
    ,case when
            n.rate_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rate_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rate_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_xcc_instrument_tax_rate where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.rate_id = n.rate_id
where (
        o.rate_id is null
    )
    or (
        n.rate_id is null
    )
    or (
        o.p_class <> n.p_class
        or o.tax_calc_type <> n.tax_calc_type
        or o.tax_output_type <> n.tax_output_type
        or o.tax_rate_field <> n.tax_rate_field
        or o.tax_rate <> n.tax_rate
        or o.p_type <> n.p_type
        or o.tax_item <> n.tax_item
        or o.tax_billreq <> n.tax_billreq
        or o.tax_methodcal <> n.tax_methodcal
        or o.updatetime <> n.updatetime
        or o.userid <> n.userid
        or o.tax_type_rate <> n.tax_type_rate
        or o.status <> n.status
        or o.beg_date <> n.beg_date
        or o.end_date <> n.end_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_cl(
            rate_id -- 
            ,p_class -- 
            ,tax_calc_type -- 
            ,tax_output_type -- 
            ,tax_rate_field -- 
            ,tax_rate -- 
            ,p_type -- 
            ,tax_item -- 商品或应税服务名称利息收入(1000_0:地方政府债；1000_1：国债；1000_2：金融同业往来业务；1000_3：利息收入；1000_4：其他贷款服  务)；商品或应税服务名称买卖价差（2000_0：债券转让；2000_1：其他金融商品转让）
            ,tax_billreq -- 业务开票要求( 0：普通发票 1：专用发票 2：不开票 )
            ,tax_methodcal -- 计税方法0：一般计税方法 1：简易计税方法 2：零税率 3：免征 4：减征 5：即征即退
            ,updatetime -- 
            ,userid -- 
            ,tax_type_rate -- 征税类型 0 征税 1 免税 2 不征税
            ,status -- 状态 0 禁用 1 启用
            ,beg_date -- 
            ,end_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_op(
            rate_id -- 
            ,p_class -- 
            ,tax_calc_type -- 
            ,tax_output_type -- 
            ,tax_rate_field -- 
            ,tax_rate -- 
            ,p_type -- 
            ,tax_item -- 商品或应税服务名称利息收入(1000_0:地方政府债；1000_1：国债；1000_2：金融同业往来业务；1000_3：利息收入；1000_4：其他贷款服  务)；商品或应税服务名称买卖价差（2000_0：债券转让；2000_1：其他金融商品转让）
            ,tax_billreq -- 业务开票要求( 0：普通发票 1：专用发票 2：不开票 )
            ,tax_methodcal -- 计税方法0：一般计税方法 1：简易计税方法 2：零税率 3：免征 4：减征 5：即征即退
            ,updatetime -- 
            ,userid -- 
            ,tax_type_rate -- 征税类型 0 征税 1 免税 2 不征税
            ,status -- 状态 0 禁用 1 启用
            ,beg_date -- 
            ,end_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rate_id -- 
    ,o.p_class -- 
    ,o.tax_calc_type -- 
    ,o.tax_output_type -- 
    ,o.tax_rate_field -- 
    ,o.tax_rate -- 
    ,o.p_type -- 
    ,o.tax_item -- 商品或应税服务名称利息收入(1000_0:地方政府债；1000_1：国债；1000_2：金融同业往来业务；1000_3：利息收入；1000_4：其他贷款服  务)；商品或应税服务名称买卖价差（2000_0：债券转让；2000_1：其他金融商品转让）
    ,o.tax_billreq -- 业务开票要求( 0：普通发票 1：专用发票 2：不开票 )
    ,o.tax_methodcal -- 计税方法0：一般计税方法 1：简易计税方法 2：零税率 3：免征 4：减征 5：即征即退
    ,o.updatetime -- 
    ,o.userid -- 
    ,o.tax_type_rate -- 征税类型 0 征税 1 免税 2 不征税
    ,o.status -- 状态 0 禁用 1 启用
    ,o.beg_date -- 
    ,o.end_date -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_bk o
    left join ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_op n
        on
            o.rate_id = n.rate_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_cl d
        on
            o.rate_id = d.rate_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_cl;
alter table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_op purge;
drop table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_xcc_instrument_tax_rate_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_xcc_instrument_tax_rate',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
