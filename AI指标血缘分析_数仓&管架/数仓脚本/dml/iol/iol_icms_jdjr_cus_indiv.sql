/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_jdjr_cus_indiv
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.icms_jdjr_cus_indiv_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_jdjr_cus_indiv
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_jdjr_cus_indiv_op purge;
drop table ${iol_schema}.icms_jdjr_cus_indiv_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jdjr_cus_indiv_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_jdjr_cus_indiv where 0=1;

create table ${iol_schema}.icms_jdjr_cus_indiv_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_jdjr_cus_indiv where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.icms_jdjr_cus_indiv_op(
        cusno -- 京东pin
        ,cusname -- 客户姓名
        ,usearea -- 境内境外标志
        ,certtype -- 证件类型
        ,migtflag -- 
        ,bankname -- 绑定银行卡行名
        ,birthdt -- 出生日期
        ,prdcode -- 产品编号
        ,cussex -- 性别
        ,bussdate -- 数据日期
        ,certno -- 证件号码
        ,localfalg -- 居民标志
        ,adress -- 通讯地址
        ,bandaccountno -- 绑定银行卡卡号
        ,cusstatus -- 客户状态
        ,telephone -- 手机号码
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.cusno -- 京东pin
    ,n.cusname -- 客户姓名
    ,n.usearea -- 境内境外标志
    ,n.certtype -- 证件类型
    ,n.migtflag -- 
    ,n.bankname -- 绑定银行卡行名
    ,n.birthdt -- 出生日期
    ,n.prdcode -- 产品编号
    ,n.cussex -- 性别
    ,n.bussdate -- 数据日期
    ,n.certno -- 证件号码
    ,n.localfalg -- 居民标志
    ,n.adress -- 通讯地址
    ,n.bandaccountno -- 绑定银行卡卡号
    ,n.cusstatus -- 客户状态
    ,n.telephone -- 手机号码
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_jdjr_cus_indiv_bk o
    right join (select * from ${itl_schema}.icms_jdjr_cus_indiv where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cusno = n.cusno
where (
        o.cusno is null
    )
    or (
        o.cusname <> n.cusname
        or o.usearea <> n.usearea
        or o.certtype <> n.certtype
        or o.migtflag <> n.migtflag
        or o.bankname <> n.bankname
        or o.birthdt <> n.birthdt
        or o.prdcode <> n.prdcode
        or o.cussex <> n.cussex
        or o.bussdate <> n.bussdate
        or o.certno <> n.certno
        or o.localfalg <> n.localfalg
        or o.adress <> n.adress
        or o.bandaccountno <> n.bandaccountno
        or o.cusstatus <> n.cusstatus
        or o.telephone <> n.telephone
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_jdjr_cus_indiv_cl(
            cusno -- 京东pin
        ,cusname -- 客户姓名
        ,usearea -- 境内境外标志
        ,certtype -- 证件类型
        ,migtflag -- 
        ,bankname -- 绑定银行卡行名
        ,birthdt -- 出生日期
        ,prdcode -- 产品编号
        ,cussex -- 性别
        ,bussdate -- 数据日期
        ,certno -- 证件号码
        ,localfalg -- 居民标志
        ,adress -- 通讯地址
        ,bandaccountno -- 绑定银行卡卡号
        ,cusstatus -- 客户状态
        ,telephone -- 手机号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_jdjr_cus_indiv_op(
            cusno -- 京东pin
        ,cusname -- 客户姓名
        ,usearea -- 境内境外标志
        ,certtype -- 证件类型
        ,migtflag -- 
        ,bankname -- 绑定银行卡行名
        ,birthdt -- 出生日期
        ,prdcode -- 产品编号
        ,cussex -- 性别
        ,bussdate -- 数据日期
        ,certno -- 证件号码
        ,localfalg -- 居民标志
        ,adress -- 通讯地址
        ,bandaccountno -- 绑定银行卡卡号
        ,cusstatus -- 客户状态
        ,telephone -- 手机号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cusno -- 京东pin
    ,o.cusname -- 客户姓名
    ,o.usearea -- 境内境外标志
    ,o.certtype -- 证件类型
    ,o.migtflag -- 
    ,o.bankname -- 绑定银行卡行名
    ,o.birthdt -- 出生日期
    ,o.prdcode -- 产品编号
    ,o.cussex -- 性别
    ,o.bussdate -- 数据日期
    ,o.certno -- 证件号码
    ,o.localfalg -- 居民标志
    ,o.adress -- 通讯地址
    ,o.bandaccountno -- 绑定银行卡卡号
    ,o.cusstatus -- 客户状态
    ,o.telephone -- 手机号码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_jdjr_cus_indiv_bk o
    left join ${iol_schema}.icms_jdjr_cus_indiv_op n
        on
            o.cusno = n.cusno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_jdjr_cus_indiv;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_jdjr_cus_indiv') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_jdjr_cus_indiv drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_jdjr_cus_indiv add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_jdjr_cus_indiv exchange partition p_${batch_date} with table ${iol_schema}.icms_jdjr_cus_indiv_cl;
alter table ${iol_schema}.icms_jdjr_cus_indiv exchange partition p_20991231 with table ${iol_schema}.icms_jdjr_cus_indiv_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_jdjr_cus_indiv to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_jdjr_cus_indiv_op purge;
drop table ${iol_schema}.icms_jdjr_cus_indiv_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_jdjr_cus_indiv_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_jdjr_cus_indiv',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
