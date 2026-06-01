/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_pir_adm_pay_ele_channel
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
create table ${iol_schema}.ifcs_pir_adm_pay_ele_channel_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifcs_pir_adm_pay_ele_channel;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifcs_pir_adm_pay_ele_channel_op purge;
drop table ${iol_schema}.ifcs_pir_adm_pay_ele_channel_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_pir_adm_pay_ele_channel_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_pir_adm_pay_ele_channel where 0=1;

create table ${iol_schema}.ifcs_pir_adm_pay_ele_channel_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_pir_adm_pay_ele_channel where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifcs_pir_adm_pay_ele_channel_cl(
            data_dt -- 数据日期
            ,org_num -- 机构号
            ,tran_typ -- 交易类型
            ,tran_num -- 交易笔数
            ,tran_amt -- 交易金额
            ,overbank_flg -- 是否跨行
            ,cust_typ -- 客户类型
            ,pos_bus_typ -- POS签约商户行业代码
            ,pos_typ -- POS业务类型2013-12-09增加
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifcs_pir_adm_pay_ele_channel_op(
            data_dt -- 数据日期
            ,org_num -- 机构号
            ,tran_typ -- 交易类型
            ,tran_num -- 交易笔数
            ,tran_amt -- 交易金额
            ,overbank_flg -- 是否跨行
            ,cust_typ -- 客户类型
            ,pos_bus_typ -- POS签约商户行业代码
            ,pos_typ -- POS业务类型2013-12-09增加
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.data_dt, o.data_dt) as data_dt -- 数据日期
    ,nvl(n.org_num, o.org_num) as org_num -- 机构号
    ,nvl(n.tran_typ, o.tran_typ) as tran_typ -- 交易类型
    ,nvl(n.tran_num, o.tran_num) as tran_num -- 交易笔数
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.overbank_flg, o.overbank_flg) as overbank_flg -- 是否跨行
    ,nvl(n.cust_typ, o.cust_typ) as cust_typ -- 客户类型
    ,nvl(n.pos_bus_typ, o.pos_bus_typ) as pos_bus_typ -- POS签约商户行业代码
    ,nvl(n.pos_typ, o.pos_typ) as pos_typ -- POS业务类型2013-12-09增加
    ,case when
            n.data_dt is null
            and n.org_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.data_dt is null
            and n.org_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.data_dt is null
            and n.org_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifcs_pir_adm_pay_ele_channel_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifcs_pir_adm_pay_ele_channel where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.data_dt = n.data_dt
            and o.org_num = n.org_num
where (
        o.data_dt is null
        and o.org_num is null
    )
    or (
        n.data_dt is null
        and n.org_num is null
    )
    or (
        o.tran_typ <> n.tran_typ
        or o.tran_num <> n.tran_num
        or o.tran_amt <> n.tran_amt
        or o.overbank_flg <> n.overbank_flg
        or o.cust_typ <> n.cust_typ
        or o.pos_bus_typ <> n.pos_bus_typ
        or o.pos_typ <> n.pos_typ
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifcs_pir_adm_pay_ele_channel_cl(
            data_dt -- 数据日期
            ,org_num -- 机构号
            ,tran_typ -- 交易类型
            ,tran_num -- 交易笔数
            ,tran_amt -- 交易金额
            ,overbank_flg -- 是否跨行
            ,cust_typ -- 客户类型
            ,pos_bus_typ -- POS签约商户行业代码
            ,pos_typ -- POS业务类型2013-12-09增加
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifcs_pir_adm_pay_ele_channel_op(
            data_dt -- 数据日期
            ,org_num -- 机构号
            ,tran_typ -- 交易类型
            ,tran_num -- 交易笔数
            ,tran_amt -- 交易金额
            ,overbank_flg -- 是否跨行
            ,cust_typ -- 客户类型
            ,pos_bus_typ -- POS签约商户行业代码
            ,pos_typ -- POS业务类型2013-12-09增加
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.data_dt -- 数据日期
    ,o.org_num -- 机构号
    ,o.tran_typ -- 交易类型
    ,o.tran_num -- 交易笔数
    ,o.tran_amt -- 交易金额
    ,o.overbank_flg -- 是否跨行
    ,o.cust_typ -- 客户类型
    ,o.pos_bus_typ -- POS签约商户行业代码
    ,o.pos_typ -- POS业务类型2013-12-09增加
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifcs_pir_adm_pay_ele_channel_bk o
    left join ${iol_schema}.ifcs_pir_adm_pay_ele_channel_op n
        on
            o.data_dt = n.data_dt
            and o.org_num = n.org_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifcs_pir_adm_pay_ele_channel_cl d
        on
            o.data_dt = d.data_dt
            and o.org_num = d.org_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifcs_pir_adm_pay_ele_channel;

-- 4.2 exchange partition
alter table ${iol_schema}.ifcs_pir_adm_pay_ele_channel exchange partition p_19000101 with table ${iol_schema}.ifcs_pir_adm_pay_ele_channel_cl;
alter table ${iol_schema}.ifcs_pir_adm_pay_ele_channel exchange partition p_20991231 with table ${iol_schema}.ifcs_pir_adm_pay_ele_channel_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_pir_adm_pay_ele_channel to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifcs_pir_adm_pay_ele_channel_op purge;
drop table ${iol_schema}.ifcs_pir_adm_pay_ele_channel_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifcs_pir_adm_pay_ele_channel_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_pir_adm_pay_ele_channel',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
