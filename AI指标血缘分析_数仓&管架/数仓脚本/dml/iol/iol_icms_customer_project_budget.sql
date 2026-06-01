/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_project_budget
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
create table ${iol_schema}.icms_customer_project_budget_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_project_budget
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_project_budget_op purge;
drop table ${iol_schema}.icms_customer_project_budget_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_project_budget_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_project_budget where 0=1;

create table ${iol_schema}.icms_customer_project_budget_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_project_budget where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_project_budget_cl(
            projectno -- 项目编号
            ,exestype -- 费用类型
            ,inputorgid -- 登记机构
            ,othercost -- 其他费用
            ,remark -- 备注
            ,risepreparecost -- 涨价预备费
            ,housetotal -- 住宅销售合计
            ,expectbenefit -- 预计效益情况
            ,landcost -- 土地费用
            ,shopsaverage -- 商铺销售均价
            ,shopstotal -- 商铺销售合计
            ,officetotal -- 写字间销售合计
            ,updateuserid -- 更新人
            ,constructionperiodinterest -- 建设期利息
            ,unforeseencost -- 不可预见费
            ,carportaverage -- 车库销售均价
            ,total -- 合计
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,exesname -- 费用名称
            ,exescurrency -- 费用币种
            ,workingcapital -- 流动资金
            ,totalcost -- 总计
            ,investpayback -- 投资回收期
            ,loanpayback -- 贷款回收期
            ,corporgid -- 法人机构编号
            ,subsidiarydevelopcost -- 附属工程开发费
            ,taxation -- 税费
            ,earlyprojectcost -- 前期工程费
            ,inputdate -- 登记日期
            ,equipmentcost -- 设备费用
            ,carporttotal -- 车库销售合计
            ,landtotal -- 土地销售收入合计
            ,updatedate -- 更新日期
            ,migtflag -- 
            ,civilengineeringdevelopcost -- 土建工程开发费
            ,installdevelopcost -- 建筑安装工程开发费
            ,managecost -- 管理费用
            ,landaverage -- 土地销售均价
            ,sellingcost -- 销售费用
            ,officeaverage -- 写字间销售均价
            ,projectcost -- 工程费用
            ,financecost -- 财务费用
            ,houseaverage -- 住宅销售均价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_project_budget_op(
            projectno -- 项目编号
            ,exestype -- 费用类型
            ,inputorgid -- 登记机构
            ,othercost -- 其他费用
            ,remark -- 备注
            ,risepreparecost -- 涨价预备费
            ,housetotal -- 住宅销售合计
            ,expectbenefit -- 预计效益情况
            ,landcost -- 土地费用
            ,shopsaverage -- 商铺销售均价
            ,shopstotal -- 商铺销售合计
            ,officetotal -- 写字间销售合计
            ,updateuserid -- 更新人
            ,constructionperiodinterest -- 建设期利息
            ,unforeseencost -- 不可预见费
            ,carportaverage -- 车库销售均价
            ,total -- 合计
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,exesname -- 费用名称
            ,exescurrency -- 费用币种
            ,workingcapital -- 流动资金
            ,totalcost -- 总计
            ,investpayback -- 投资回收期
            ,loanpayback -- 贷款回收期
            ,corporgid -- 法人机构编号
            ,subsidiarydevelopcost -- 附属工程开发费
            ,taxation -- 税费
            ,earlyprojectcost -- 前期工程费
            ,inputdate -- 登记日期
            ,equipmentcost -- 设备费用
            ,carporttotal -- 车库销售合计
            ,landtotal -- 土地销售收入合计
            ,updatedate -- 更新日期
            ,migtflag -- 
            ,civilengineeringdevelopcost -- 土建工程开发费
            ,installdevelopcost -- 建筑安装工程开发费
            ,managecost -- 管理费用
            ,landaverage -- 土地销售均价
            ,sellingcost -- 销售费用
            ,officeaverage -- 写字间销售均价
            ,projectcost -- 工程费用
            ,financecost -- 财务费用
            ,houseaverage -- 住宅销售均价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.projectno, o.projectno) as projectno -- 项目编号
    ,nvl(n.exestype, o.exestype) as exestype -- 费用类型
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.othercost, o.othercost) as othercost -- 其他费用
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.risepreparecost, o.risepreparecost) as risepreparecost -- 涨价预备费
    ,nvl(n.housetotal, o.housetotal) as housetotal -- 住宅销售合计
    ,nvl(n.expectbenefit, o.expectbenefit) as expectbenefit -- 预计效益情况
    ,nvl(n.landcost, o.landcost) as landcost -- 土地费用
    ,nvl(n.shopsaverage, o.shopsaverage) as shopsaverage -- 商铺销售均价
    ,nvl(n.shopstotal, o.shopstotal) as shopstotal -- 商铺销售合计
    ,nvl(n.officetotal, o.officetotal) as officetotal -- 写字间销售合计
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.constructionperiodinterest, o.constructionperiodinterest) as constructionperiodinterest -- 建设期利息
    ,nvl(n.unforeseencost, o.unforeseencost) as unforeseencost -- 不可预见费
    ,nvl(n.carportaverage, o.carportaverage) as carportaverage -- 车库销售均价
    ,nvl(n.total, o.total) as total -- 合计
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.exesname, o.exesname) as exesname -- 费用名称
    ,nvl(n.exescurrency, o.exescurrency) as exescurrency -- 费用币种
    ,nvl(n.workingcapital, o.workingcapital) as workingcapital -- 流动资金
    ,nvl(n.totalcost, o.totalcost) as totalcost -- 总计
    ,nvl(n.investpayback, o.investpayback) as investpayback -- 投资回收期
    ,nvl(n.loanpayback, o.loanpayback) as loanpayback -- 贷款回收期
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.subsidiarydevelopcost, o.subsidiarydevelopcost) as subsidiarydevelopcost -- 附属工程开发费
    ,nvl(n.taxation, o.taxation) as taxation -- 税费
    ,nvl(n.earlyprojectcost, o.earlyprojectcost) as earlyprojectcost -- 前期工程费
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.equipmentcost, o.equipmentcost) as equipmentcost -- 设备费用
    ,nvl(n.carporttotal, o.carporttotal) as carporttotal -- 车库销售合计
    ,nvl(n.landtotal, o.landtotal) as landtotal -- 土地销售收入合计
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.civilengineeringdevelopcost, o.civilengineeringdevelopcost) as civilengineeringdevelopcost -- 土建工程开发费
    ,nvl(n.installdevelopcost, o.installdevelopcost) as installdevelopcost -- 建筑安装工程开发费
    ,nvl(n.managecost, o.managecost) as managecost -- 管理费用
    ,nvl(n.landaverage, o.landaverage) as landaverage -- 土地销售均价
    ,nvl(n.sellingcost, o.sellingcost) as sellingcost -- 销售费用
    ,nvl(n.officeaverage, o.officeaverage) as officeaverage -- 写字间销售均价
    ,nvl(n.projectcost, o.projectcost) as projectcost -- 工程费用
    ,nvl(n.financecost, o.financecost) as financecost -- 财务费用
    ,nvl(n.houseaverage, o.houseaverage) as houseaverage -- 住宅销售均价
    ,case when
            n.projectno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.projectno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.projectno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_customer_project_budget_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_project_budget where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.projectno = n.projectno
where (
        o.projectno is null
    )
    or (
        n.projectno is null
    )
    or (
        o.exestype <> n.exestype
        or o.inputorgid <> n.inputorgid
        or o.othercost <> n.othercost
        or o.remark <> n.remark
        or o.risepreparecost <> n.risepreparecost
        or o.housetotal <> n.housetotal
        or o.expectbenefit <> n.expectbenefit
        or o.landcost <> n.landcost
        or o.shopsaverage <> n.shopsaverage
        or o.shopstotal <> n.shopstotal
        or o.officetotal <> n.officetotal
        or o.updateuserid <> n.updateuserid
        or o.constructionperiodinterest <> n.constructionperiodinterest
        or o.unforeseencost <> n.unforeseencost
        or o.carportaverage <> n.carportaverage
        or o.total <> n.total
        or o.inputuserid <> n.inputuserid
        or o.updateorgid <> n.updateorgid
        or o.exesname <> n.exesname
        or o.exescurrency <> n.exescurrency
        or o.workingcapital <> n.workingcapital
        or o.totalcost <> n.totalcost
        or o.investpayback <> n.investpayback
        or o.loanpayback <> n.loanpayback
        or o.corporgid <> n.corporgid
        or o.subsidiarydevelopcost <> n.subsidiarydevelopcost
        or o.taxation <> n.taxation
        or o.earlyprojectcost <> n.earlyprojectcost
        or o.inputdate <> n.inputdate
        or o.equipmentcost <> n.equipmentcost
        or o.carporttotal <> n.carporttotal
        or o.landtotal <> n.landtotal
        or o.updatedate <> n.updatedate
        or o.migtflag <> n.migtflag
        or o.civilengineeringdevelopcost <> n.civilengineeringdevelopcost
        or o.installdevelopcost <> n.installdevelopcost
        or o.managecost <> n.managecost
        or o.landaverage <> n.landaverage
        or o.sellingcost <> n.sellingcost
        or o.officeaverage <> n.officeaverage
        or o.projectcost <> n.projectcost
        or o.financecost <> n.financecost
        or o.houseaverage <> n.houseaverage
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_project_budget_cl(
            projectno -- 项目编号
            ,exestype -- 费用类型
            ,inputorgid -- 登记机构
            ,othercost -- 其他费用
            ,remark -- 备注
            ,risepreparecost -- 涨价预备费
            ,housetotal -- 住宅销售合计
            ,expectbenefit -- 预计效益情况
            ,landcost -- 土地费用
            ,shopsaverage -- 商铺销售均价
            ,shopstotal -- 商铺销售合计
            ,officetotal -- 写字间销售合计
            ,updateuserid -- 更新人
            ,constructionperiodinterest -- 建设期利息
            ,unforeseencost -- 不可预见费
            ,carportaverage -- 车库销售均价
            ,total -- 合计
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,exesname -- 费用名称
            ,exescurrency -- 费用币种
            ,workingcapital -- 流动资金
            ,totalcost -- 总计
            ,investpayback -- 投资回收期
            ,loanpayback -- 贷款回收期
            ,corporgid -- 法人机构编号
            ,subsidiarydevelopcost -- 附属工程开发费
            ,taxation -- 税费
            ,earlyprojectcost -- 前期工程费
            ,inputdate -- 登记日期
            ,equipmentcost -- 设备费用
            ,carporttotal -- 车库销售合计
            ,landtotal -- 土地销售收入合计
            ,updatedate -- 更新日期
            ,migtflag -- 
            ,civilengineeringdevelopcost -- 土建工程开发费
            ,installdevelopcost -- 建筑安装工程开发费
            ,managecost -- 管理费用
            ,landaverage -- 土地销售均价
            ,sellingcost -- 销售费用
            ,officeaverage -- 写字间销售均价
            ,projectcost -- 工程费用
            ,financecost -- 财务费用
            ,houseaverage -- 住宅销售均价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_project_budget_op(
            projectno -- 项目编号
            ,exestype -- 费用类型
            ,inputorgid -- 登记机构
            ,othercost -- 其他费用
            ,remark -- 备注
            ,risepreparecost -- 涨价预备费
            ,housetotal -- 住宅销售合计
            ,expectbenefit -- 预计效益情况
            ,landcost -- 土地费用
            ,shopsaverage -- 商铺销售均价
            ,shopstotal -- 商铺销售合计
            ,officetotal -- 写字间销售合计
            ,updateuserid -- 更新人
            ,constructionperiodinterest -- 建设期利息
            ,unforeseencost -- 不可预见费
            ,carportaverage -- 车库销售均价
            ,total -- 合计
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,exesname -- 费用名称
            ,exescurrency -- 费用币种
            ,workingcapital -- 流动资金
            ,totalcost -- 总计
            ,investpayback -- 投资回收期
            ,loanpayback -- 贷款回收期
            ,corporgid -- 法人机构编号
            ,subsidiarydevelopcost -- 附属工程开发费
            ,taxation -- 税费
            ,earlyprojectcost -- 前期工程费
            ,inputdate -- 登记日期
            ,equipmentcost -- 设备费用
            ,carporttotal -- 车库销售合计
            ,landtotal -- 土地销售收入合计
            ,updatedate -- 更新日期
            ,migtflag -- 
            ,civilengineeringdevelopcost -- 土建工程开发费
            ,installdevelopcost -- 建筑安装工程开发费
            ,managecost -- 管理费用
            ,landaverage -- 土地销售均价
            ,sellingcost -- 销售费用
            ,officeaverage -- 写字间销售均价
            ,projectcost -- 工程费用
            ,financecost -- 财务费用
            ,houseaverage -- 住宅销售均价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.projectno -- 项目编号
    ,o.exestype -- 费用类型
    ,o.inputorgid -- 登记机构
    ,o.othercost -- 其他费用
    ,o.remark -- 备注
    ,o.risepreparecost -- 涨价预备费
    ,o.housetotal -- 住宅销售合计
    ,o.expectbenefit -- 预计效益情况
    ,o.landcost -- 土地费用
    ,o.shopsaverage -- 商铺销售均价
    ,o.shopstotal -- 商铺销售合计
    ,o.officetotal -- 写字间销售合计
    ,o.updateuserid -- 更新人
    ,o.constructionperiodinterest -- 建设期利息
    ,o.unforeseencost -- 不可预见费
    ,o.carportaverage -- 车库销售均价
    ,o.total -- 合计
    ,o.inputuserid -- 登记人
    ,o.updateorgid -- 更新机构
    ,o.exesname -- 费用名称
    ,o.exescurrency -- 费用币种
    ,o.workingcapital -- 流动资金
    ,o.totalcost -- 总计
    ,o.investpayback -- 投资回收期
    ,o.loanpayback -- 贷款回收期
    ,o.corporgid -- 法人机构编号
    ,o.subsidiarydevelopcost -- 附属工程开发费
    ,o.taxation -- 税费
    ,o.earlyprojectcost -- 前期工程费
    ,o.inputdate -- 登记日期
    ,o.equipmentcost -- 设备费用
    ,o.carporttotal -- 车库销售合计
    ,o.landtotal -- 土地销售收入合计
    ,o.updatedate -- 更新日期
    ,o.migtflag -- 
    ,o.civilengineeringdevelopcost -- 土建工程开发费
    ,o.installdevelopcost -- 建筑安装工程开发费
    ,o.managecost -- 管理费用
    ,o.landaverage -- 土地销售均价
    ,o.sellingcost -- 销售费用
    ,o.officeaverage -- 写字间销售均价
    ,o.projectcost -- 工程费用
    ,o.financecost -- 财务费用
    ,o.houseaverage -- 住宅销售均价
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
from ${iol_schema}.icms_customer_project_budget_bk o
    left join ${iol_schema}.icms_customer_project_budget_op n
        on
            o.projectno = n.projectno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_project_budget_cl d
        on
            o.projectno = d.projectno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_customer_project_budget;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_project_budget') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_project_budget drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_project_budget add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_project_budget exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_project_budget_cl;
alter table ${iol_schema}.icms_customer_project_budget exchange partition p_20991231 with table ${iol_schema}.icms_customer_project_budget_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_project_budget to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_project_budget_op purge;
drop table ${iol_schema}.icms_customer_project_budget_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_project_budget_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_project_budget',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
