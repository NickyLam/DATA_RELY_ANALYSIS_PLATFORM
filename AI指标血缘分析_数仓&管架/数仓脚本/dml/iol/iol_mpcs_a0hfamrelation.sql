/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0hfamrelation
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
create table ${iol_schema}.mpcs_a0hfamrelation_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0hfamrelation;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0hfamrelation_op purge;
drop table ${iol_schema}.mpcs_a0hfamrelation_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0hfamrelation_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0hfamrelation where 0=1;

create table ${iol_schema}.mpcs_a0hfamrelation_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0hfamrelation where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0hfamrelation_cl(
            familyid -- 家庭号
            ,memsignid -- 成员签约编号
            ,custacc -- 卡号
            ,custname -- 持卡人姓名
            ,phonenum -- 手机号
            ,cardgrade -- 等级 00-普通 01-黄金 11-白金 12-钻石
            ,custno -- 客户号
            ,signstate -- 签约状态
            ,cardstate -- 卡状态 0-正常 1-销户 2-挂失
            ,signdate -- 家庭卡签约时间
            ,unsigndate -- 家庭卡解约时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0hfamrelation_op(
            familyid -- 家庭号
            ,memsignid -- 成员签约编号
            ,custacc -- 卡号
            ,custname -- 持卡人姓名
            ,phonenum -- 手机号
            ,cardgrade -- 等级 00-普通 01-黄金 11-白金 12-钻石
            ,custno -- 客户号
            ,signstate -- 签约状态
            ,cardstate -- 卡状态 0-正常 1-销户 2-挂失
            ,signdate -- 家庭卡签约时间
            ,unsigndate -- 家庭卡解约时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.familyid, o.familyid) as familyid -- 家庭号
    ,nvl(n.memsignid, o.memsignid) as memsignid -- 成员签约编号
    ,nvl(n.custacc, o.custacc) as custacc -- 卡号
    ,nvl(n.custname, o.custname) as custname -- 持卡人姓名
    ,nvl(n.phonenum, o.phonenum) as phonenum -- 手机号
    ,nvl(n.cardgrade, o.cardgrade) as cardgrade -- 等级 00-普通 01-黄金 11-白金 12-钻石
    ,nvl(n.custno, o.custno) as custno -- 客户号
    ,nvl(n.signstate, o.signstate) as signstate -- 签约状态
    ,nvl(n.cardstate, o.cardstate) as cardstate -- 卡状态 0-正常 1-销户 2-挂失
    ,nvl(n.signdate, o.signdate) as signdate -- 家庭卡签约时间
    ,nvl(n.unsigndate, o.unsigndate) as unsigndate -- 家庭卡解约时间
    ,case when
            n.familyid is null
            and n.memsignid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.familyid is null
            and n.memsignid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.familyid is null
            and n.memsignid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0hfamrelation_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0hfamrelation where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.familyid = n.familyid
            and o.memsignid = n.memsignid
where (
        o.familyid is null
        and o.memsignid is null
    )
    or (
        n.familyid is null
        and n.memsignid is null
    )
    or (
        o.custacc <> n.custacc
        or o.custname <> n.custname
        or o.phonenum <> n.phonenum
        or o.cardgrade <> n.cardgrade
        or o.custno <> n.custno
        or o.signstate <> n.signstate
        or o.cardstate <> n.cardstate
        or o.signdate <> n.signdate
        or o.unsigndate <> n.unsigndate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0hfamrelation_cl(
            familyid -- 家庭号
            ,memsignid -- 成员签约编号
            ,custacc -- 卡号
            ,custname -- 持卡人姓名
            ,phonenum -- 手机号
            ,cardgrade -- 等级 00-普通 01-黄金 11-白金 12-钻石
            ,custno -- 客户号
            ,signstate -- 签约状态
            ,cardstate -- 卡状态 0-正常 1-销户 2-挂失
            ,signdate -- 家庭卡签约时间
            ,unsigndate -- 家庭卡解约时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0hfamrelation_op(
            familyid -- 家庭号
            ,memsignid -- 成员签约编号
            ,custacc -- 卡号
            ,custname -- 持卡人姓名
            ,phonenum -- 手机号
            ,cardgrade -- 等级 00-普通 01-黄金 11-白金 12-钻石
            ,custno -- 客户号
            ,signstate -- 签约状态
            ,cardstate -- 卡状态 0-正常 1-销户 2-挂失
            ,signdate -- 家庭卡签约时间
            ,unsigndate -- 家庭卡解约时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.familyid -- 家庭号
    ,o.memsignid -- 成员签约编号
    ,o.custacc -- 卡号
    ,o.custname -- 持卡人姓名
    ,o.phonenum -- 手机号
    ,o.cardgrade -- 等级 00-普通 01-黄金 11-白金 12-钻石
    ,o.custno -- 客户号
    ,o.signstate -- 签约状态
    ,o.cardstate -- 卡状态 0-正常 1-销户 2-挂失
    ,o.signdate -- 家庭卡签约时间
    ,o.unsigndate -- 家庭卡解约时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a0hfamrelation_bk o
    left join ${iol_schema}.mpcs_a0hfamrelation_op n
        on
            o.familyid = n.familyid
            and o.memsignid = n.memsignid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0hfamrelation_cl d
        on
            o.familyid = d.familyid
            and o.memsignid = d.memsignid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a0hfamrelation;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a0hfamrelation exchange partition p_19000101 with table ${iol_schema}.mpcs_a0hfamrelation_cl;
alter table ${iol_schema}.mpcs_a0hfamrelation exchange partition p_20991231 with table ${iol_schema}.mpcs_a0hfamrelation_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0hfamrelation to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0hfamrelation_op purge;
drop table ${iol_schema}.mpcs_a0hfamrelation_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0hfamrelation_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0hfamrelation',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
