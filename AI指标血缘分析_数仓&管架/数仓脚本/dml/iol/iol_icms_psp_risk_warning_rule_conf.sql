/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_psp_risk_warning_rule_conf
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
create table ${iol_schema}.icms_psp_risk_warning_rule_conf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_psp_risk_warning_rule_conf
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_psp_risk_warning_rule_conf_op purge;
drop table ${iol_schema}.icms_psp_risk_warning_rule_conf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_risk_warning_rule_conf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_psp_risk_warning_rule_conf where 0=1;

create table ${iol_schema}.icms_psp_risk_warning_rule_conf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_psp_risk_warning_rule_conf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_psp_risk_warning_rule_conf_cl(
            rangepro -- 适用产品(只有适用范围是部分产品才选择适用产品，产品支持多选)
            ,checkobj -- 检查对象(1借款人及共同借款人2担保人3抵质押物4还款行为5资金用途6渠道)
            ,warningsign -- 预警信号名称
            ,warningrule -- 预警规则
            ,updatehz -- 更新频率(1、按日2、按月3、按季)
            ,signlevel -- 预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)
            ,creatorid -- 创建人
            ,createdate -- 创建时间
            ,lastchangeuser -- 最新修改人
            ,lastchangetime -- 最新修改时间
            ,warningruleno -- 预警规则编号
            ,range -- 适用范围(1、全部产品2、部分产品)
            ,percent -- 比例警戒线
            ,amt -- 金额警戒线
            ,count -- 次数警戒线
            ,status -- 状态
            ,remark -- 备注
            ,warningcode -- 预警信号规则代码
            ,migtflag -- 迁移标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_psp_risk_warning_rule_conf_op(
            rangepro -- 适用产品(只有适用范围是部分产品才选择适用产品，产品支持多选)
            ,checkobj -- 检查对象(1借款人及共同借款人2担保人3抵质押物4还款行为5资金用途6渠道)
            ,warningsign -- 预警信号名称
            ,warningrule -- 预警规则
            ,updatehz -- 更新频率(1、按日2、按月3、按季)
            ,signlevel -- 预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)
            ,creatorid -- 创建人
            ,createdate -- 创建时间
            ,lastchangeuser -- 最新修改人
            ,lastchangetime -- 最新修改时间
            ,warningruleno -- 预警规则编号
            ,range -- 适用范围(1、全部产品2、部分产品)
            ,percent -- 比例警戒线
            ,amt -- 金额警戒线
            ,count -- 次数警戒线
            ,status -- 状态
            ,remark -- 备注
            ,warningcode -- 预警信号规则代码
            ,migtflag -- 迁移标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rangepro, o.rangepro) as rangepro -- 适用产品(只有适用范围是部分产品才选择适用产品，产品支持多选)
    ,nvl(n.checkobj, o.checkobj) as checkobj -- 检查对象(1借款人及共同借款人2担保人3抵质押物4还款行为5资金用途6渠道)
    ,nvl(n.warningsign, o.warningsign) as warningsign -- 预警信号名称
    ,nvl(n.warningrule, o.warningrule) as warningrule -- 预警规则
    ,nvl(n.updatehz, o.updatehz) as updatehz -- 更新频率(1、按日2、按月3、按季)
    ,nvl(n.signlevel, o.signlevel) as signlevel -- 预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)
    ,nvl(n.creatorid, o.creatorid) as creatorid -- 创建人
    ,nvl(n.createdate, o.createdate) as createdate -- 创建时间
    ,nvl(n.lastchangeuser, o.lastchangeuser) as lastchangeuser -- 最新修改人
    ,nvl(n.lastchangetime, o.lastchangetime) as lastchangetime -- 最新修改时间
    ,nvl(n.warningruleno, o.warningruleno) as warningruleno -- 预警规则编号
    ,nvl(n.range, o.range) as range -- 适用范围(1、全部产品2、部分产品)
    ,nvl(n.percent, o.percent) as percent -- 比例警戒线
    ,nvl(n.amt, o.amt) as amt -- 金额警戒线
    ,nvl(n.count, o.count) as count -- 次数警戒线
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.warningcode, o.warningcode) as warningcode -- 预警信号规则代码
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识
    ,case when
            n.warningruleno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.warningruleno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.warningruleno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_psp_risk_warning_rule_conf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_psp_risk_warning_rule_conf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.warningruleno = n.warningruleno
where (
        o.warningruleno is null
    )
    or (
        n.warningruleno is null
    )
    or (
        o.rangepro <> n.rangepro
        or o.checkobj <> n.checkobj
        or o.warningsign <> n.warningsign
        or o.warningrule <> n.warningrule
        or o.updatehz <> n.updatehz
        or o.signlevel <> n.signlevel
        or o.creatorid <> n.creatorid
        or o.createdate <> n.createdate
        or o.lastchangeuser <> n.lastchangeuser
        or o.lastchangetime <> n.lastchangetime
        or o.range <> n.range
        or o.percent <> n.percent
        or o.amt <> n.amt
        or o.count <> n.count
        or o.status <> n.status
        or o.remark <> n.remark
        or o.warningcode <> n.warningcode
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_psp_risk_warning_rule_conf_cl(
            rangepro -- 适用产品(只有适用范围是部分产品才选择适用产品，产品支持多选)
            ,checkobj -- 检查对象(1借款人及共同借款人2担保人3抵质押物4还款行为5资金用途6渠道)
            ,warningsign -- 预警信号名称
            ,warningrule -- 预警规则
            ,updatehz -- 更新频率(1、按日2、按月3、按季)
            ,signlevel -- 预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)
            ,creatorid -- 创建人
            ,createdate -- 创建时间
            ,lastchangeuser -- 最新修改人
            ,lastchangetime -- 最新修改时间
            ,warningruleno -- 预警规则编号
            ,range -- 适用范围(1、全部产品2、部分产品)
            ,percent -- 比例警戒线
            ,amt -- 金额警戒线
            ,count -- 次数警戒线
            ,status -- 状态
            ,remark -- 备注
            ,warningcode -- 预警信号规则代码
            ,migtflag -- 迁移标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_psp_risk_warning_rule_conf_op(
            rangepro -- 适用产品(只有适用范围是部分产品才选择适用产品，产品支持多选)
            ,checkobj -- 检查对象(1借款人及共同借款人2担保人3抵质押物4还款行为5资金用途6渠道)
            ,warningsign -- 预警信号名称
            ,warningrule -- 预警规则
            ,updatehz -- 更新频率(1、按日2、按月3、按季)
            ,signlevel -- 预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)
            ,creatorid -- 创建人
            ,createdate -- 创建时间
            ,lastchangeuser -- 最新修改人
            ,lastchangetime -- 最新修改时间
            ,warningruleno -- 预警规则编号
            ,range -- 适用范围(1、全部产品2、部分产品)
            ,percent -- 比例警戒线
            ,amt -- 金额警戒线
            ,count -- 次数警戒线
            ,status -- 状态
            ,remark -- 备注
            ,warningcode -- 预警信号规则代码
            ,migtflag -- 迁移标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rangepro -- 适用产品(只有适用范围是部分产品才选择适用产品，产品支持多选)
    ,o.checkobj -- 检查对象(1借款人及共同借款人2担保人3抵质押物4还款行为5资金用途6渠道)
    ,o.warningsign -- 预警信号名称
    ,o.warningrule -- 预警规则
    ,o.updatehz -- 更新频率(1、按日2、按月3、按季)
    ,o.signlevel -- 预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)
    ,o.creatorid -- 创建人
    ,o.createdate -- 创建时间
    ,o.lastchangeuser -- 最新修改人
    ,o.lastchangetime -- 最新修改时间
    ,o.warningruleno -- 预警规则编号
    ,o.range -- 适用范围(1、全部产品2、部分产品)
    ,o.percent -- 比例警戒线
    ,o.amt -- 金额警戒线
    ,o.count -- 次数警戒线
    ,o.status -- 状态
    ,o.remark -- 备注
    ,o.warningcode -- 预警信号规则代码
    ,o.migtflag -- 迁移标识
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
from ${iol_schema}.icms_psp_risk_warning_rule_conf_bk o
    left join ${iol_schema}.icms_psp_risk_warning_rule_conf_op n
        on
            o.warningruleno = n.warningruleno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_psp_risk_warning_rule_conf_cl d
        on
            o.warningruleno = d.warningruleno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_psp_risk_warning_rule_conf;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_psp_risk_warning_rule_conf') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_psp_risk_warning_rule_conf drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_psp_risk_warning_rule_conf add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_psp_risk_warning_rule_conf exchange partition p_${batch_date} with table ${iol_schema}.icms_psp_risk_warning_rule_conf_cl;
alter table ${iol_schema}.icms_psp_risk_warning_rule_conf exchange partition p_20991231 with table ${iol_schema}.icms_psp_risk_warning_rule_conf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_psp_risk_warning_rule_conf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_psp_risk_warning_rule_conf_op purge;
drop table ${iol_schema}.icms_psp_risk_warning_rule_conf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_psp_risk_warning_rule_conf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_psp_risk_warning_rule_conf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
