/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_sl_appl_info
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
create table ${iol_schema}.icms_sl_appl_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_sl_appl_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_sl_appl_info_op purge;
drop table ${iol_schema}.icms_sl_appl_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sl_appl_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_sl_appl_info where 0=1;

create table ${iol_schema}.icms_sl_appl_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_sl_appl_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_sl_appl_info_cl(
            serialno -- 业务流水号
            ,sltype -- 赎楼类型
            ,housegageowner -- 赎楼对应房产抵押权人
            ,slhouseowner -- 赎楼对应房产产权所有人
            ,priceamt -- 定价金额
            ,isgagests -- 赎楼对应房产抵押状态
            ,capitalsuperamt -- 资金监管金额
            ,cussource -- 客户来源
            ,notarytrstecertno -- 公证受托人身份证号码
            ,oloannature -- 原贷款性质
            ,oldloansplscptl -- 原贷款剩余本金
            ,notarytrstename -- 公证受托人姓名
            ,transactionamt -- 交易价格
            ,slhousename -- 赎楼对应房产名称
            ,notarycltname -- 公证委托人姓名
            ,oldloanbank -- 原贷款银行
            ,nextbkreplyamt -- 下一手银行批复金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,slhousenature -- 赎楼对应房产性质
            ,slhouseownerratio -- 赎楼对应房产产权所有人比例
            ,notarycltcertno -- 公证委托人身份证号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_sl_appl_info_op(
            serialno -- 业务流水号
            ,sltype -- 赎楼类型
            ,housegageowner -- 赎楼对应房产抵押权人
            ,slhouseowner -- 赎楼对应房产产权所有人
            ,priceamt -- 定价金额
            ,isgagests -- 赎楼对应房产抵押状态
            ,capitalsuperamt -- 资金监管金额
            ,cussource -- 客户来源
            ,notarytrstecertno -- 公证受托人身份证号码
            ,oloannature -- 原贷款性质
            ,oldloansplscptl -- 原贷款剩余本金
            ,notarytrstename -- 公证受托人姓名
            ,transactionamt -- 交易价格
            ,slhousename -- 赎楼对应房产名称
            ,notarycltname -- 公证委托人姓名
            ,oldloanbank -- 原贷款银行
            ,nextbkreplyamt -- 下一手银行批复金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,slhousenature -- 赎楼对应房产性质
            ,slhouseownerratio -- 赎楼对应房产产权所有人比例
            ,notarycltcertno -- 公证委托人身份证号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 业务流水号
    ,nvl(n.sltype, o.sltype) as sltype -- 赎楼类型
    ,nvl(n.housegageowner, o.housegageowner) as housegageowner -- 赎楼对应房产抵押权人
    ,nvl(n.slhouseowner, o.slhouseowner) as slhouseowner -- 赎楼对应房产产权所有人
    ,nvl(n.priceamt, o.priceamt) as priceamt -- 定价金额
    ,nvl(n.isgagests, o.isgagests) as isgagests -- 赎楼对应房产抵押状态
    ,nvl(n.capitalsuperamt, o.capitalsuperamt) as capitalsuperamt -- 资金监管金额
    ,nvl(n.cussource, o.cussource) as cussource -- 客户来源
    ,nvl(n.notarytrstecertno, o.notarytrstecertno) as notarytrstecertno -- 公证受托人身份证号码
    ,nvl(n.oloannature, o.oloannature) as oloannature -- 原贷款性质
    ,nvl(n.oldloansplscptl, o.oldloansplscptl) as oldloansplscptl -- 原贷款剩余本金
    ,nvl(n.notarytrstename, o.notarytrstename) as notarytrstename -- 公证受托人姓名
    ,nvl(n.transactionamt, o.transactionamt) as transactionamt -- 交易价格
    ,nvl(n.slhousename, o.slhousename) as slhousename -- 赎楼对应房产名称
    ,nvl(n.notarycltname, o.notarycltname) as notarycltname -- 公证委托人姓名
    ,nvl(n.oldloanbank, o.oldloanbank) as oldloanbank -- 原贷款银行
    ,nvl(n.nextbkreplyamt, o.nextbkreplyamt) as nextbkreplyamt -- 下一手银行批复金额
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.slhousenature, o.slhousenature) as slhousenature -- 赎楼对应房产性质
    ,nvl(n.slhouseownerratio, o.slhouseownerratio) as slhouseownerratio -- 赎楼对应房产产权所有人比例
    ,nvl(n.notarycltcertno, o.notarycltcertno) as notarycltcertno -- 公证委托人身份证号码
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_sl_appl_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_sl_appl_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.sltype <> n.sltype
        or o.housegageowner <> n.housegageowner
        or o.slhouseowner <> n.slhouseowner
        or o.priceamt <> n.priceamt
        or o.isgagests <> n.isgagests
        or o.capitalsuperamt <> n.capitalsuperamt
        or o.cussource <> n.cussource
        or o.notarytrstecertno <> n.notarytrstecertno
        or o.oloannature <> n.oloannature
        or o.oldloansplscptl <> n.oldloansplscptl
        or o.notarytrstename <> n.notarytrstename
        or o.transactionamt <> n.transactionamt
        or o.slhousename <> n.slhousename
        or o.notarycltname <> n.notarycltname
        or o.oldloanbank <> n.oldloanbank
        or o.nextbkreplyamt <> n.nextbkreplyamt
        or o.migtflag <> n.migtflag
        or o.slhousenature <> n.slhousenature
        or o.slhouseownerratio <> n.slhouseownerratio
        or o.notarycltcertno <> n.notarycltcertno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_sl_appl_info_cl(
            serialno -- 业务流水号
            ,sltype -- 赎楼类型
            ,housegageowner -- 赎楼对应房产抵押权人
            ,slhouseowner -- 赎楼对应房产产权所有人
            ,priceamt -- 定价金额
            ,isgagests -- 赎楼对应房产抵押状态
            ,capitalsuperamt -- 资金监管金额
            ,cussource -- 客户来源
            ,notarytrstecertno -- 公证受托人身份证号码
            ,oloannature -- 原贷款性质
            ,oldloansplscptl -- 原贷款剩余本金
            ,notarytrstename -- 公证受托人姓名
            ,transactionamt -- 交易价格
            ,slhousename -- 赎楼对应房产名称
            ,notarycltname -- 公证委托人姓名
            ,oldloanbank -- 原贷款银行
            ,nextbkreplyamt -- 下一手银行批复金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,slhousenature -- 赎楼对应房产性质
            ,slhouseownerratio -- 赎楼对应房产产权所有人比例
            ,notarycltcertno -- 公证委托人身份证号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_sl_appl_info_op(
            serialno -- 业务流水号
            ,sltype -- 赎楼类型
            ,housegageowner -- 赎楼对应房产抵押权人
            ,slhouseowner -- 赎楼对应房产产权所有人
            ,priceamt -- 定价金额
            ,isgagests -- 赎楼对应房产抵押状态
            ,capitalsuperamt -- 资金监管金额
            ,cussource -- 客户来源
            ,notarytrstecertno -- 公证受托人身份证号码
            ,oloannature -- 原贷款性质
            ,oldloansplscptl -- 原贷款剩余本金
            ,notarytrstename -- 公证受托人姓名
            ,transactionamt -- 交易价格
            ,slhousename -- 赎楼对应房产名称
            ,notarycltname -- 公证委托人姓名
            ,oldloanbank -- 原贷款银行
            ,nextbkreplyamt -- 下一手银行批复金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,slhousenature -- 赎楼对应房产性质
            ,slhouseownerratio -- 赎楼对应房产产权所有人比例
            ,notarycltcertno -- 公证委托人身份证号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 业务流水号
    ,o.sltype -- 赎楼类型
    ,o.housegageowner -- 赎楼对应房产抵押权人
    ,o.slhouseowner -- 赎楼对应房产产权所有人
    ,o.priceamt -- 定价金额
    ,o.isgagests -- 赎楼对应房产抵押状态
    ,o.capitalsuperamt -- 资金监管金额
    ,o.cussource -- 客户来源
    ,o.notarytrstecertno -- 公证受托人身份证号码
    ,o.oloannature -- 原贷款性质
    ,o.oldloansplscptl -- 原贷款剩余本金
    ,o.notarytrstename -- 公证受托人姓名
    ,o.transactionamt -- 交易价格
    ,o.slhousename -- 赎楼对应房产名称
    ,o.notarycltname -- 公证委托人姓名
    ,o.oldloanbank -- 原贷款银行
    ,o.nextbkreplyamt -- 下一手银行批复金额
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.slhousenature -- 赎楼对应房产性质
    ,o.slhouseownerratio -- 赎楼对应房产产权所有人比例
    ,o.notarycltcertno -- 公证委托人身份证号码
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
from ${iol_schema}.icms_sl_appl_info_bk o
    left join ${iol_schema}.icms_sl_appl_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_sl_appl_info_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_sl_appl_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_sl_appl_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_sl_appl_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_sl_appl_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_sl_appl_info exchange partition p_${batch_date} with table ${iol_schema}.icms_sl_appl_info_cl;
alter table ${iol_schema}.icms_sl_appl_info exchange partition p_20991231 with table ${iol_schema}.icms_sl_appl_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_sl_appl_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_sl_appl_info_op purge;
drop table ${iol_schema}.icms_sl_appl_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_sl_appl_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_sl_appl_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
