/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cc_guarcorres
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
create table ${iol_schema}.icms_cc_guarcorres_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_cc_guarcorres
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cc_guarcorres_op purge;
drop table ${iol_schema}.icms_cc_guarcorres_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cc_guarcorres_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cc_guarcorres where 0=1;

create table ${iol_schema}.icms_cc_guarcorres_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cc_guarcorres where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cc_guarcorres_cl(
            guarno -- 押品编号 抵质押合同-押品编号（SI_SECURITYINFO.SCCODE）      保证合同-保证人编号（SI_GUARUSERINFO.GUARUSERCODE）
            ,bussno -- 对应担保合同号
            ,assconttype -- 担保合同类型 保证合同 1        抵押合同 2        质押合同 3
            ,period -- 对应贷款阶段 信贷字典        01-授信申请/审批阶段        02-合同签订阶段        03-额度启用阶段        04-出账审核阶段        05-风险监测阶段        06-清收处置阶段
            ,useassamt -- 担保金额
            ,useasscurrency -- 担保币种
            ,state -- 生效状态 SAMPLESTATUS      1有效      2无效
            ,state2 -- 到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止      ENDSTATE
            ,guarrate -- 审批抵质押率
            ,adguarrate -- 客户经理建议抵质押率
            ,mainguartype -- 主担保/附属担保 0-主要担保          1-附属担保
            ,isimp -- 首次出账前是否必须落实 1-是；0-否
            ,guarorder -- 是否允许先出账后落实担保 1-是；0-否
            ,guardate -- 担保落实期限（天）
            ,guarvalue -- 审批时押品认定价值
            ,datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
            ,startdate -- 建立日期
            ,barsign -- 条线
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cc_guarcorres_op(
            guarno -- 押品编号 抵质押合同-押品编号（SI_SECURITYINFO.SCCODE）      保证合同-保证人编号（SI_GUARUSERINFO.GUARUSERCODE）
            ,bussno -- 对应担保合同号
            ,assconttype -- 担保合同类型 保证合同 1        抵押合同 2        质押合同 3
            ,period -- 对应贷款阶段 信贷字典        01-授信申请/审批阶段        02-合同签订阶段        03-额度启用阶段        04-出账审核阶段        05-风险监测阶段        06-清收处置阶段
            ,useassamt -- 担保金额
            ,useasscurrency -- 担保币种
            ,state -- 生效状态 SAMPLESTATUS      1有效      2无效
            ,state2 -- 到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止      ENDSTATE
            ,guarrate -- 审批抵质押率
            ,adguarrate -- 客户经理建议抵质押率
            ,mainguartype -- 主担保/附属担保 0-主要担保          1-附属担保
            ,isimp -- 首次出账前是否必须落实 1-是；0-否
            ,guarorder -- 是否允许先出账后落实担保 1-是；0-否
            ,guardate -- 担保落实期限（天）
            ,guarvalue -- 审批时押品认定价值
            ,datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
            ,startdate -- 建立日期
            ,barsign -- 条线
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.guarno, o.guarno) as guarno -- 押品编号 抵质押合同-押品编号（SI_SECURITYINFO.SCCODE）      保证合同-保证人编号（SI_GUARUSERINFO.GUARUSERCODE）
    ,nvl(n.bussno, o.bussno) as bussno -- 对应担保合同号
    ,nvl(n.assconttype, o.assconttype) as assconttype -- 担保合同类型 保证合同 1        抵押合同 2        质押合同 3
    ,nvl(n.period, o.period) as period -- 对应贷款阶段 信贷字典        01-授信申请/审批阶段        02-合同签订阶段        03-额度启用阶段        04-出账审核阶段        05-风险监测阶段        06-清收处置阶段
    ,nvl(n.useassamt, o.useassamt) as useassamt -- 担保金额
    ,nvl(n.useasscurrency, o.useasscurrency) as useasscurrency -- 担保币种
    ,nvl(n.state, o.state) as state -- 生效状态 SAMPLESTATUS      1有效      2无效
    ,nvl(n.state2, o.state2) as state2 -- 到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止      ENDSTATE
    ,nvl(n.guarrate, o.guarrate) as guarrate -- 审批抵质押率
    ,nvl(n.adguarrate, o.adguarrate) as adguarrate -- 客户经理建议抵质押率
    ,nvl(n.mainguartype, o.mainguartype) as mainguartype -- 主担保/附属担保 0-主要担保          1-附属担保
    ,nvl(n.isimp, o.isimp) as isimp -- 首次出账前是否必须落实 1-是；0-否
    ,nvl(n.guarorder, o.guarorder) as guarorder -- 是否允许先出账后落实担保 1-是；0-否
    ,nvl(n.guardate, o.guardate) as guardate -- 担保落实期限（天）
    ,nvl(n.guarvalue, o.guarvalue) as guarvalue -- 审批时押品认定价值
    ,nvl(n.datasourceflag, o.datasourceflag) as datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
    ,nvl(n.startdate, o.startdate) as startdate -- 建立日期
    ,nvl(n.barsign, o.barsign) as barsign -- 条线
    ,case when
            n.guarno is null
            and n.bussno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.guarno is null
            and n.bussno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.guarno is null
            and n.bussno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_cc_guarcorres_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_cc_guarcorres where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.guarno = n.guarno
            and o.bussno = n.bussno
where (
        o.guarno is null
        and o.bussno is null
    )
    or (
        n.guarno is null
        and n.bussno is null
    )
    or (
        o.assconttype <> n.assconttype
        or o.period <> n.period
        or o.useassamt <> n.useassamt
        or o.useasscurrency <> n.useasscurrency
        or o.state <> n.state
        or o.state2 <> n.state2
        or o.guarrate <> n.guarrate
        or o.adguarrate <> n.adguarrate
        or o.mainguartype <> n.mainguartype
        or o.isimp <> n.isimp
        or o.guarorder <> n.guarorder
        or o.guardate <> n.guardate
        or o.guarvalue <> n.guarvalue
        or o.datasourceflag <> n.datasourceflag
        or o.startdate <> n.startdate
        or o.barsign <> n.barsign
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cc_guarcorres_cl(
            guarno -- 押品编号 抵质押合同-押品编号（SI_SECURITYINFO.SCCODE）      保证合同-保证人编号（SI_GUARUSERINFO.GUARUSERCODE）
            ,bussno -- 对应担保合同号
            ,assconttype -- 担保合同类型 保证合同 1        抵押合同 2        质押合同 3
            ,period -- 对应贷款阶段 信贷字典        01-授信申请/审批阶段        02-合同签订阶段        03-额度启用阶段        04-出账审核阶段        05-风险监测阶段        06-清收处置阶段
            ,useassamt -- 担保金额
            ,useasscurrency -- 担保币种
            ,state -- 生效状态 SAMPLESTATUS      1有效      2无效
            ,state2 -- 到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止      ENDSTATE
            ,guarrate -- 审批抵质押率
            ,adguarrate -- 客户经理建议抵质押率
            ,mainguartype -- 主担保/附属担保 0-主要担保          1-附属担保
            ,isimp -- 首次出账前是否必须落实 1-是；0-否
            ,guarorder -- 是否允许先出账后落实担保 1-是；0-否
            ,guardate -- 担保落实期限（天）
            ,guarvalue -- 审批时押品认定价值
            ,datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
            ,startdate -- 建立日期
            ,barsign -- 条线
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cc_guarcorres_op(
            guarno -- 押品编号 抵质押合同-押品编号（SI_SECURITYINFO.SCCODE）      保证合同-保证人编号（SI_GUARUSERINFO.GUARUSERCODE）
            ,bussno -- 对应担保合同号
            ,assconttype -- 担保合同类型 保证合同 1        抵押合同 2        质押合同 3
            ,period -- 对应贷款阶段 信贷字典        01-授信申请/审批阶段        02-合同签订阶段        03-额度启用阶段        04-出账审核阶段        05-风险监测阶段        06-清收处置阶段
            ,useassamt -- 担保金额
            ,useasscurrency -- 担保币种
            ,state -- 生效状态 SAMPLESTATUS      1有效      2无效
            ,state2 -- 到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止      ENDSTATE
            ,guarrate -- 审批抵质押率
            ,adguarrate -- 客户经理建议抵质押率
            ,mainguartype -- 主担保/附属担保 0-主要担保          1-附属担保
            ,isimp -- 首次出账前是否必须落实 1-是；0-否
            ,guarorder -- 是否允许先出账后落实担保 1-是；0-否
            ,guardate -- 担保落实期限（天）
            ,guarvalue -- 审批时押品认定价值
            ,datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
            ,startdate -- 建立日期
            ,barsign -- 条线
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.guarno -- 押品编号 抵质押合同-押品编号（SI_SECURITYINFO.SCCODE）      保证合同-保证人编号（SI_GUARUSERINFO.GUARUSERCODE）
    ,o.bussno -- 对应担保合同号
    ,o.assconttype -- 担保合同类型 保证合同 1        抵押合同 2        质押合同 3
    ,o.period -- 对应贷款阶段 信贷字典        01-授信申请/审批阶段        02-合同签订阶段        03-额度启用阶段        04-出账审核阶段        05-风险监测阶段        06-清收处置阶段
    ,o.useassamt -- 担保金额
    ,o.useasscurrency -- 担保币种
    ,o.state -- 生效状态 SAMPLESTATUS      1有效      2无效
    ,o.state2 -- 到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止      ENDSTATE
    ,o.guarrate -- 审批抵质押率
    ,o.adguarrate -- 客户经理建议抵质押率
    ,o.mainguartype -- 主担保/附属担保 0-主要担保          1-附属担保
    ,o.isimp -- 首次出账前是否必须落实 1-是；0-否
    ,o.guarorder -- 是否允许先出账后落实担保 1-是；0-否
    ,o.guardate -- 担保落实期限（天）
    ,o.guarvalue -- 审批时押品认定价值
    ,o.datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
    ,o.startdate -- 建立日期
    ,o.barsign -- 条线
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
from ${iol_schema}.icms_cc_guarcorres_bk o
    left join ${iol_schema}.icms_cc_guarcorres_op n
        on
            o.guarno = n.guarno
            and o.bussno = n.bussno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_cc_guarcorres_cl d
        on
            o.guarno = d.guarno
            and o.bussno = d.bussno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_cc_guarcorres;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_cc_guarcorres') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_cc_guarcorres drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_cc_guarcorres add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_cc_guarcorres exchange partition p_${batch_date} with table ${iol_schema}.icms_cc_guarcorres_cl;
alter table ${iol_schema}.icms_cc_guarcorres exchange partition p_20991231 with table ${iol_schema}.icms_cc_guarcorres_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cc_guarcorres to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cc_guarcorres_op purge;
drop table ${iol_schema}.icms_cc_guarcorres_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_cc_guarcorres_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cc_guarcorres',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
