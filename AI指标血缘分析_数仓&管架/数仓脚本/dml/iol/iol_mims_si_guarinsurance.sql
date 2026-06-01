/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_guarinsurance
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
create table ${iol_schema}.mims_si_guarinsurance_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_guarinsurance
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_guarinsurance_op purge;
drop table ${iol_schema}.mims_si_guarinsurance_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_guarinsurance_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_guarinsurance where 0=1;

create table ${iol_schema}.mims_si_guarinsurance_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_guarinsurance where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_guarinsurance_cl(
            sccode -- 押品编号
            ,vouchertype -- 保证人类型
            ,voucherno -- 保证人编号
            ,vouchername -- 保证人名称
            ,cardno -- 保证人组织机构代码
            ,industry -- 保证人国标行业分类
            ,netasset -- 保证人净资产
            ,economic -- 保证人经济成分
            ,independence -- 保证人担保独立性
            ,registcountry -- 保证人注册地所在国家或地区
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,purpose -- 保证目的
            ,insuranceno -- 保证保险保单号码
            ,isstage -- 是否阶段性担保
            ,remark -- 其他说明
            ,tdcurrency -- 币种
            ,isresident -- 是否居民
            ,cardtype -- 证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_guarinsurance_op(
            sccode -- 押品编号
            ,vouchertype -- 保证人类型
            ,voucherno -- 保证人编号
            ,vouchername -- 保证人名称
            ,cardno -- 保证人组织机构代码
            ,industry -- 保证人国标行业分类
            ,netasset -- 保证人净资产
            ,economic -- 保证人经济成分
            ,independence -- 保证人担保独立性
            ,registcountry -- 保证人注册地所在国家或地区
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,purpose -- 保证目的
            ,insuranceno -- 保证保险保单号码
            ,isstage -- 是否阶段性担保
            ,remark -- 其他说明
            ,tdcurrency -- 币种
            ,isresident -- 是否居民
            ,cardtype -- 证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 押品编号
    ,nvl(n.vouchertype, o.vouchertype) as vouchertype -- 保证人类型
    ,nvl(n.voucherno, o.voucherno) as voucherno -- 保证人编号
    ,nvl(n.vouchername, o.vouchername) as vouchername -- 保证人名称
    ,nvl(n.cardno, o.cardno) as cardno -- 保证人组织机构代码
    ,nvl(n.industry, o.industry) as industry -- 保证人国标行业分类
    ,nvl(n.netasset, o.netasset) as netasset -- 保证人净资产
    ,nvl(n.economic, o.economic) as economic -- 保证人经济成分
    ,nvl(n.independence, o.independence) as independence -- 保证人担保独立性
    ,nvl(n.registcountry, o.registcountry) as registcountry -- 保证人注册地所在国家或地区
    ,nvl(n.registcountryresult, o.registcountryresult) as registcountryresult -- 保证人注册地所在国家或地区外部评级结果
    ,nvl(n.outratingdate, o.outratingdate) as outratingdate -- 保证人外部评级日期
    ,nvl(n.outratingresult, o.outratingresult) as outratingresult -- 保证人外部评级结果
    ,nvl(n.inratingdate, o.inratingdate) as inratingdate -- 保证人内部评级日期
    ,nvl(n.inratingresult, o.inratingresult) as inratingresult -- 保证人内部评级结果
    ,nvl(n.purpose, o.purpose) as purpose -- 保证目的
    ,nvl(n.insuranceno, o.insuranceno) as insuranceno -- 保证保险保单号码
    ,nvl(n.isstage, o.isstage) as isstage -- 是否阶段性担保
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 币种
    ,nvl(n.isresident, o.isresident) as isresident -- 是否居民
    ,nvl(n.cardtype, o.cardtype) as cardtype -- 证件类型
    ,case when
            n.sccode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_guarinsurance_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_guarinsurance where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.vouchertype <> n.vouchertype
        or o.voucherno <> n.voucherno
        or o.vouchername <> n.vouchername
        or o.cardno <> n.cardno
        or o.industry <> n.industry
        or o.netasset <> n.netasset
        or o.economic <> n.economic
        or o.independence <> n.independence
        or o.registcountry <> n.registcountry
        or o.registcountryresult <> n.registcountryresult
        or o.outratingdate <> n.outratingdate
        or o.outratingresult <> n.outratingresult
        or o.inratingdate <> n.inratingdate
        or o.inratingresult <> n.inratingresult
        or o.purpose <> n.purpose
        or o.insuranceno <> n.insuranceno
        or o.isstage <> n.isstage
        or o.remark <> n.remark
        or o.tdcurrency <> n.tdcurrency
        or o.isresident <> n.isresident
        or o.cardtype <> n.cardtype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_guarinsurance_cl(
            sccode -- 押品编号
            ,vouchertype -- 保证人类型
            ,voucherno -- 保证人编号
            ,vouchername -- 保证人名称
            ,cardno -- 保证人组织机构代码
            ,industry -- 保证人国标行业分类
            ,netasset -- 保证人净资产
            ,economic -- 保证人经济成分
            ,independence -- 保证人担保独立性
            ,registcountry -- 保证人注册地所在国家或地区
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,purpose -- 保证目的
            ,insuranceno -- 保证保险保单号码
            ,isstage -- 是否阶段性担保
            ,remark -- 其他说明
            ,tdcurrency -- 币种
            ,isresident -- 是否居民
            ,cardtype -- 证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_guarinsurance_op(
            sccode -- 押品编号
            ,vouchertype -- 保证人类型
            ,voucherno -- 保证人编号
            ,vouchername -- 保证人名称
            ,cardno -- 保证人组织机构代码
            ,industry -- 保证人国标行业分类
            ,netasset -- 保证人净资产
            ,economic -- 保证人经济成分
            ,independence -- 保证人担保独立性
            ,registcountry -- 保证人注册地所在国家或地区
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,purpose -- 保证目的
            ,insuranceno -- 保证保险保单号码
            ,isstage -- 是否阶段性担保
            ,remark -- 其他说明
            ,tdcurrency -- 币种
            ,isresident -- 是否居民
            ,cardtype -- 证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 押品编号
    ,o.vouchertype -- 保证人类型
    ,o.voucherno -- 保证人编号
    ,o.vouchername -- 保证人名称
    ,o.cardno -- 保证人组织机构代码
    ,o.industry -- 保证人国标行业分类
    ,o.netasset -- 保证人净资产
    ,o.economic -- 保证人经济成分
    ,o.independence -- 保证人担保独立性
    ,o.registcountry -- 保证人注册地所在国家或地区
    ,o.registcountryresult -- 保证人注册地所在国家或地区外部评级结果
    ,o.outratingdate -- 保证人外部评级日期
    ,o.outratingresult -- 保证人外部评级结果
    ,o.inratingdate -- 保证人内部评级日期
    ,o.inratingresult -- 保证人内部评级结果
    ,o.purpose -- 保证目的
    ,o.insuranceno -- 保证保险保单号码
    ,o.isstage -- 是否阶段性担保
    ,o.remark -- 其他说明
    ,o.tdcurrency -- 币种
    ,o.isresident -- 是否居民
    ,o.cardtype -- 证件类型
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
from ${iol_schema}.mims_si_guarinsurance_bk o
    left join ${iol_schema}.mims_si_guarinsurance_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_guarinsurance_cl d
        on
            o.sccode = d.sccode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_si_guarinsurance;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_si_guarinsurance') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_si_guarinsurance drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_si_guarinsurance add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_si_guarinsurance exchange partition p_${batch_date} with table ${iol_schema}.mims_si_guarinsurance_cl;
alter table ${iol_schema}.mims_si_guarinsurance exchange partition p_20991231 with table ${iol_schema}.mims_si_guarinsurance_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_guarinsurance to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_guarinsurance_op purge;
drop table ${iol_schema}.mims_si_guarinsurance_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_guarinsurance_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_guarinsurance',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
