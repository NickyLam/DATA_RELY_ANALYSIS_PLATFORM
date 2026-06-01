/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_party_risk_info_h_eifsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_party_risk_info_h add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_party_risk_info_h_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_risk_info_h partition for ('eifsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_party_risk_info_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_party_risk_info_h_eifsf1_op purge;
drop table ${iml_schema}.pty_party_risk_info_h_eifsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_risk_info_h_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,bd_blklist_flg -- 大数黑名单标志
    ,risk_rest_cd -- 风险结果代码
    ,risk_type_cd -- 风险类型代码
    ,blklist_cust_flg -- 黑名单客户标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_risk_info_h partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_party_risk_info_h_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_risk_info_h partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_party_risk_info_h_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_risk_info_h partition for ('eifsf1') where 0=1;

-- 3.1 get new data into table
-- eifs_customer_supplement_info-
insert into ${iml_schema}.pty_party_risk_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,bd_blklist_flg -- 大数黑名单标志
    ,risk_rest_cd -- 风险结果代码
    ,risk_type_cd -- 风险类型代码
    ,blklist_cust_flg -- 黑名单客户标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p1.CUSTNO -- 当事人编号
    ,'9999' -- 法人编号
    ,' ' -- 大数黑名单标志
    ,NVL(TRIM(p1.RISKLV),'0') -- 风险结果代码
    ,' ' -- 风险类型代码
    ,' ' -- 黑名单客户标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_customer_supplement_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_customer_supplement_info p1
    inner join ${iol_schema}.eifs_party p2 on p1.CUSTNO=p2.PARTY_ID 
and p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd')
and p2.Party_Type_Id IN ('PRIVATE_TYPE','GUARANTEE_PRI_TYPE')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_risk_info_h_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,bd_blklist_flg -- 大数黑名单标志
    ,risk_rest_cd -- 风险结果代码
    ,risk_type_cd -- 风险类型代码
    ,blklist_cust_flg -- 黑名单客户标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_risk_info_h_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,bd_blklist_flg -- 大数黑名单标志
    ,risk_rest_cd -- 风险结果代码
    ,risk_type_cd -- 风险类型代码
    ,blklist_cust_flg -- 黑名单客户标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bd_blklist_flg, o.bd_blklist_flg) as bd_blklist_flg -- 大数黑名单标志
    ,nvl(n.risk_rest_cd, o.risk_rest_cd) as risk_rest_cd -- 风险结果代码
    ,nvl(n.risk_type_cd, o.risk_type_cd) as risk_type_cd -- 风险类型代码
    ,nvl(n.blklist_cust_flg, o.blklist_cust_flg) as blklist_cust_flg -- 黑名单客户标志
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.risk_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.risk_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.risk_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_risk_info_h_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_party_risk_info_h_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.risk_type_cd = n.risk_type_cd
where (
        o.party_id is null
        and o.lp_id is null
        and o.risk_type_cd is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.risk_type_cd is null
    )
    or (
        o.bd_blklist_flg <> n.bd_blklist_flg
        or o.risk_rest_cd <> n.risk_rest_cd
        or o.blklist_cust_flg <> n.blklist_cust_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_risk_info_h_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,bd_blklist_flg -- 大数黑名单标志
    ,risk_rest_cd -- 风险结果代码
    ,risk_type_cd -- 风险类型代码
    ,blklist_cust_flg -- 黑名单客户标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_risk_info_h_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,bd_blklist_flg -- 大数黑名单标志
    ,risk_rest_cd -- 风险结果代码
    ,risk_type_cd -- 风险类型代码
    ,blklist_cust_flg -- 黑名单客户标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.bd_blklist_flg -- 大数黑名单标志
    ,o.risk_rest_cd -- 风险结果代码
    ,o.risk_type_cd -- 风险类型代码
    ,o.blklist_cust_flg -- 黑名单客户标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_risk_info_h_eifsf1_bk o
    left join ${iml_schema}.pty_party_risk_info_h_eifsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.risk_type_cd = n.risk_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_party_risk_info_h_eifsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.risk_type_cd = d.risk_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_party_risk_info_h;
alter table ${iml_schema}.pty_party_risk_info_h truncate partition for ('eifsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.pty_party_risk_info_h exchange subpartition p_eifsf1_19000101 with table ${iml_schema}.pty_party_risk_info_h_eifsf1_cl;
alter table ${iml_schema}.pty_party_risk_info_h exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_party_risk_info_h_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_party_risk_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_party_risk_info_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_party_risk_info_h_eifsf1_op purge;
drop table ${iml_schema}.pty_party_risk_info_h_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_party_risk_info_h_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_party_risk_info_h', partname => 'p_eifsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
