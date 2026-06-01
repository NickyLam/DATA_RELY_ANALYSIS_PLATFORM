/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_rep_asset_position
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
create table ${iol_schema}.fams_rep_asset_position_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_rep_asset_position
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_rep_asset_position_op purge;
drop table ${iol_schema}.fams_rep_asset_position_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_rep_asset_position_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_rep_asset_position where 0=1;

create table ${iol_schema}.fams_rep_asset_position_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_rep_asset_position where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_rep_asset_position_cl(
            cdate -- 日期
            ,assetcode -- 资产代码
            ,assetname -- 资产名称
            ,vdate -- 首期日
            ,mdate -- 到期日
            ,custrate -- 利率(%)
            ,basis -- 计息基础 枚举值数据字典：BASIS
            ,position -- 持仓余额
            ,criceamt -- 资产价值
            ,tdylossamt -- 资产减值金额
            ,unpayamt -- 应收利息
            ,friceamt -- 资产全价
            ,sppiactmdate -- 实际到期日
            ,accounttype -- 账户类型 枚举值数据字典：AMT_INCOME_TYPE
            ,assettype -- 资产类别 枚举值数据字典：FINPROD_TYPE_TG
            ,detailassettype -- 明细资产类别
            ,profittype -- 收益类型
            ,assettypeone -- 资产分类（一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ONE
            ,assettypetwo -- 资产分类（二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_TWO
            ,assettypethree -- 资产分类（三级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_THREE
            ,assettypefour -- 资产分类（四级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_FOUR
            ,assettypesecone -- 资产分类（债券品种维度一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_ONE
            ,assettypesectwo -- 资产分类（债券品种维度二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_TWO
            ,assettypeissueone -- 资产分类（发行主体维度）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ISSUE_ONE
            ,maingrade -- 债券主体评级 枚举值数据字典：MAIN_GRADE_RESULT
            ,maingradeorg -- 主体评级机构 枚举值数据字典：GRADE_PARTY
            ,creditgrade -- 债券信用评级 枚举值数据字典：MAIN_GRADE_RESULT
            ,creditgradeorg -- 债券评级机构 枚举值数据字典：GRADE_PARTY
            ,termtype -- 剩余期限分类
            ,investnature -- 资产投资性质 枚举值数据字典：INVEST_TYPE
            ,isstandasset -- 是否标准化资产
            ,investmenttype -- 投资方式 枚举值数据字典：INVESTMENT_TYPE
            ,customername -- 基础资产客户名称
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_rep_asset_position_op(
            cdate -- 日期
            ,assetcode -- 资产代码
            ,assetname -- 资产名称
            ,vdate -- 首期日
            ,mdate -- 到期日
            ,custrate -- 利率(%)
            ,basis -- 计息基础 枚举值数据字典：BASIS
            ,position -- 持仓余额
            ,criceamt -- 资产价值
            ,tdylossamt -- 资产减值金额
            ,unpayamt -- 应收利息
            ,friceamt -- 资产全价
            ,sppiactmdate -- 实际到期日
            ,accounttype -- 账户类型 枚举值数据字典：AMT_INCOME_TYPE
            ,assettype -- 资产类别 枚举值数据字典：FINPROD_TYPE_TG
            ,detailassettype -- 明细资产类别
            ,profittype -- 收益类型
            ,assettypeone -- 资产分类（一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ONE
            ,assettypetwo -- 资产分类（二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_TWO
            ,assettypethree -- 资产分类（三级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_THREE
            ,assettypefour -- 资产分类（四级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_FOUR
            ,assettypesecone -- 资产分类（债券品种维度一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_ONE
            ,assettypesectwo -- 资产分类（债券品种维度二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_TWO
            ,assettypeissueone -- 资产分类（发行主体维度）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ISSUE_ONE
            ,maingrade -- 债券主体评级 枚举值数据字典：MAIN_GRADE_RESULT
            ,maingradeorg -- 主体评级机构 枚举值数据字典：GRADE_PARTY
            ,creditgrade -- 债券信用评级 枚举值数据字典：MAIN_GRADE_RESULT
            ,creditgradeorg -- 债券评级机构 枚举值数据字典：GRADE_PARTY
            ,termtype -- 剩余期限分类
            ,investnature -- 资产投资性质 枚举值数据字典：INVEST_TYPE
            ,isstandasset -- 是否标准化资产
            ,investmenttype -- 投资方式 枚举值数据字典：INVESTMENT_TYPE
            ,customername -- 基础资产客户名称
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cdate, o.cdate) as cdate -- 日期
    ,nvl(n.assetcode, o.assetcode) as assetcode -- 资产代码
    ,nvl(n.assetname, o.assetname) as assetname -- 资产名称
    ,nvl(n.vdate, o.vdate) as vdate -- 首期日
    ,nvl(n.mdate, o.mdate) as mdate -- 到期日
    ,nvl(n.custrate, o.custrate) as custrate -- 利率(%)
    ,nvl(n.basis, o.basis) as basis -- 计息基础 枚举值数据字典：BASIS
    ,nvl(n.position, o.position) as position -- 持仓余额
    ,nvl(n.criceamt, o.criceamt) as criceamt -- 资产价值
    ,nvl(n.tdylossamt, o.tdylossamt) as tdylossamt -- 资产减值金额
    ,nvl(n.unpayamt, o.unpayamt) as unpayamt -- 应收利息
    ,nvl(n.friceamt, o.friceamt) as friceamt -- 资产全价
    ,nvl(n.sppiactmdate, o.sppiactmdate) as sppiactmdate -- 实际到期日
    ,nvl(n.accounttype, o.accounttype) as accounttype -- 账户类型 枚举值数据字典：AMT_INCOME_TYPE
    ,nvl(n.assettype, o.assettype) as assettype -- 资产类别 枚举值数据字典：FINPROD_TYPE_TG
    ,nvl(n.detailassettype, o.detailassettype) as detailassettype -- 明细资产类别
    ,nvl(n.profittype, o.profittype) as profittype -- 收益类型
    ,nvl(n.assettypeone, o.assettypeone) as assettypeone -- 资产分类（一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ONE
    ,nvl(n.assettypetwo, o.assettypetwo) as assettypetwo -- 资产分类（二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_TWO
    ,nvl(n.assettypethree, o.assettypethree) as assettypethree -- 资产分类（三级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_THREE
    ,nvl(n.assettypefour, o.assettypefour) as assettypefour -- 资产分类（四级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_FOUR
    ,nvl(n.assettypesecone, o.assettypesecone) as assettypesecone -- 资产分类（债券品种维度一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_ONE
    ,nvl(n.assettypesectwo, o.assettypesectwo) as assettypesectwo -- 资产分类（债券品种维度二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_TWO
    ,nvl(n.assettypeissueone, o.assettypeissueone) as assettypeissueone -- 资产分类（发行主体维度）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ISSUE_ONE
    ,nvl(n.maingrade, o.maingrade) as maingrade -- 债券主体评级 枚举值数据字典：MAIN_GRADE_RESULT
    ,nvl(n.maingradeorg, o.maingradeorg) as maingradeorg -- 主体评级机构 枚举值数据字典：GRADE_PARTY
    ,nvl(n.creditgrade, o.creditgrade) as creditgrade -- 债券信用评级 枚举值数据字典：MAIN_GRADE_RESULT
    ,nvl(n.creditgradeorg, o.creditgradeorg) as creditgradeorg -- 债券评级机构 枚举值数据字典：GRADE_PARTY
    ,nvl(n.termtype, o.termtype) as termtype -- 剩余期限分类
    ,nvl(n.investnature, o.investnature) as investnature -- 资产投资性质 枚举值数据字典：INVEST_TYPE
    ,nvl(n.isstandasset, o.isstandasset) as isstandasset -- 是否标准化资产
    ,nvl(n.investmenttype, o.investmenttype) as investmenttype -- 投资方式 枚举值数据字典：INVESTMENT_TYPE
    ,nvl(n.customername, o.customername) as customername -- 基础资产客户名称
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.cdate is null
            and n.assetcode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cdate is null
            and n.assetcode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cdate is null
            and n.assetcode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_rep_asset_position_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_rep_asset_position where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cdate = n.cdate
            and o.assetcode = n.assetcode
where (
        o.cdate is null
        and o.assetcode is null
    )
    or (
        n.cdate is null
        and n.assetcode is null
    )
    or (
        o.assetname <> n.assetname
        or o.vdate <> n.vdate
        or o.mdate <> n.mdate
        or o.custrate <> n.custrate
        or o.basis <> n.basis
        or o.position <> n.position
        or o.criceamt <> n.criceamt
        or o.tdylossamt <> n.tdylossamt
        or o.unpayamt <> n.unpayamt
        or o.friceamt <> n.friceamt
        or o.sppiactmdate <> n.sppiactmdate
        or o.accounttype <> n.accounttype
        or o.assettype <> n.assettype
        or o.detailassettype <> n.detailassettype
        or o.profittype <> n.profittype
        or o.assettypeone <> n.assettypeone
        or o.assettypetwo <> n.assettypetwo
        or o.assettypethree <> n.assettypethree
        or o.assettypefour <> n.assettypefour
        or o.assettypesecone <> n.assettypesecone
        or o.assettypesectwo <> n.assettypesectwo
        or o.assettypeissueone <> n.assettypeissueone
        or o.maingrade <> n.maingrade
        or o.maingradeorg <> n.maingradeorg
        or o.creditgrade <> n.creditgrade
        or o.creditgradeorg <> n.creditgradeorg
        or o.termtype <> n.termtype
        or o.investnature <> n.investnature
        or o.isstandasset <> n.isstandasset
        or o.investmenttype <> n.investmenttype
        or o.customername <> n.customername
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_rep_asset_position_cl(
            cdate -- 日期
            ,assetcode -- 资产代码
            ,assetname -- 资产名称
            ,vdate -- 首期日
            ,mdate -- 到期日
            ,custrate -- 利率(%)
            ,basis -- 计息基础 枚举值数据字典：BASIS
            ,position -- 持仓余额
            ,criceamt -- 资产价值
            ,tdylossamt -- 资产减值金额
            ,unpayamt -- 应收利息
            ,friceamt -- 资产全价
            ,sppiactmdate -- 实际到期日
            ,accounttype -- 账户类型 枚举值数据字典：AMT_INCOME_TYPE
            ,assettype -- 资产类别 枚举值数据字典：FINPROD_TYPE_TG
            ,detailassettype -- 明细资产类别
            ,profittype -- 收益类型
            ,assettypeone -- 资产分类（一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ONE
            ,assettypetwo -- 资产分类（二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_TWO
            ,assettypethree -- 资产分类（三级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_THREE
            ,assettypefour -- 资产分类（四级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_FOUR
            ,assettypesecone -- 资产分类（债券品种维度一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_ONE
            ,assettypesectwo -- 资产分类（债券品种维度二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_TWO
            ,assettypeissueone -- 资产分类（发行主体维度）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ISSUE_ONE
            ,maingrade -- 债券主体评级 枚举值数据字典：MAIN_GRADE_RESULT
            ,maingradeorg -- 主体评级机构 枚举值数据字典：GRADE_PARTY
            ,creditgrade -- 债券信用评级 枚举值数据字典：MAIN_GRADE_RESULT
            ,creditgradeorg -- 债券评级机构 枚举值数据字典：GRADE_PARTY
            ,termtype -- 剩余期限分类
            ,investnature -- 资产投资性质 枚举值数据字典：INVEST_TYPE
            ,isstandasset -- 是否标准化资产
            ,investmenttype -- 投资方式 枚举值数据字典：INVESTMENT_TYPE
            ,customername -- 基础资产客户名称
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_rep_asset_position_op(
            cdate -- 日期
            ,assetcode -- 资产代码
            ,assetname -- 资产名称
            ,vdate -- 首期日
            ,mdate -- 到期日
            ,custrate -- 利率(%)
            ,basis -- 计息基础 枚举值数据字典：BASIS
            ,position -- 持仓余额
            ,criceamt -- 资产价值
            ,tdylossamt -- 资产减值金额
            ,unpayamt -- 应收利息
            ,friceamt -- 资产全价
            ,sppiactmdate -- 实际到期日
            ,accounttype -- 账户类型 枚举值数据字典：AMT_INCOME_TYPE
            ,assettype -- 资产类别 枚举值数据字典：FINPROD_TYPE_TG
            ,detailassettype -- 明细资产类别
            ,profittype -- 收益类型
            ,assettypeone -- 资产分类（一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ONE
            ,assettypetwo -- 资产分类（二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_TWO
            ,assettypethree -- 资产分类（三级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_THREE
            ,assettypefour -- 资产分类（四级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_FOUR
            ,assettypesecone -- 资产分类（债券品种维度一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_ONE
            ,assettypesectwo -- 资产分类（债券品种维度二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_TWO
            ,assettypeissueone -- 资产分类（发行主体维度）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ISSUE_ONE
            ,maingrade -- 债券主体评级 枚举值数据字典：MAIN_GRADE_RESULT
            ,maingradeorg -- 主体评级机构 枚举值数据字典：GRADE_PARTY
            ,creditgrade -- 债券信用评级 枚举值数据字典：MAIN_GRADE_RESULT
            ,creditgradeorg -- 债券评级机构 枚举值数据字典：GRADE_PARTY
            ,termtype -- 剩余期限分类
            ,investnature -- 资产投资性质 枚举值数据字典：INVEST_TYPE
            ,isstandasset -- 是否标准化资产
            ,investmenttype -- 投资方式 枚举值数据字典：INVESTMENT_TYPE
            ,customername -- 基础资产客户名称
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cdate -- 日期
    ,o.assetcode -- 资产代码
    ,o.assetname -- 资产名称
    ,o.vdate -- 首期日
    ,o.mdate -- 到期日
    ,o.custrate -- 利率(%)
    ,o.basis -- 计息基础 枚举值数据字典：BASIS
    ,o.position -- 持仓余额
    ,o.criceamt -- 资产价值
    ,o.tdylossamt -- 资产减值金额
    ,o.unpayamt -- 应收利息
    ,o.friceamt -- 资产全价
    ,o.sppiactmdate -- 实际到期日
    ,o.accounttype -- 账户类型 枚举值数据字典：AMT_INCOME_TYPE
    ,o.assettype -- 资产类别 枚举值数据字典：FINPROD_TYPE_TG
    ,o.detailassettype -- 明细资产类别
    ,o.profittype -- 收益类型
    ,o.assettypeone -- 资产分类（一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ONE
    ,o.assettypetwo -- 资产分类（二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_TWO
    ,o.assettypethree -- 资产分类（三级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_THREE
    ,o.assettypefour -- 资产分类（四级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_FOUR
    ,o.assettypesecone -- 资产分类（债券品种维度一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_ONE
    ,o.assettypesectwo -- 资产分类（债券品种维度二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_TWO
    ,o.assettypeissueone -- 资产分类（发行主体维度）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ISSUE_ONE
    ,o.maingrade -- 债券主体评级 枚举值数据字典：MAIN_GRADE_RESULT
    ,o.maingradeorg -- 主体评级机构 枚举值数据字典：GRADE_PARTY
    ,o.creditgrade -- 债券信用评级 枚举值数据字典：MAIN_GRADE_RESULT
    ,o.creditgradeorg -- 债券评级机构 枚举值数据字典：GRADE_PARTY
    ,o.termtype -- 剩余期限分类
    ,o.investnature -- 资产投资性质 枚举值数据字典：INVEST_TYPE
    ,o.isstandasset -- 是否标准化资产
    ,o.investmenttype -- 投资方式 枚举值数据字典：INVESTMENT_TYPE
    ,o.customername -- 基础资产客户名称
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
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
from ${iol_schema}.fams_rep_asset_position_bk o
    left join ${iol_schema}.fams_rep_asset_position_op n
        on
            o.cdate = n.cdate
            and o.assetcode = n.assetcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_rep_asset_position_cl d
        on
            o.cdate = d.cdate
            and o.assetcode = d.assetcode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_rep_asset_position;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_rep_asset_position') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_rep_asset_position drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_rep_asset_position add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_rep_asset_position exchange partition p_${batch_date} with table ${iol_schema}.fams_rep_asset_position_cl;
alter table ${iol_schema}.fams_rep_asset_position exchange partition p_20991231 with table ${iol_schema}.fams_rep_asset_position_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_rep_asset_position to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_rep_asset_position_op purge;
drop table ${iol_schema}.fams_rep_asset_position_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_rep_asset_position_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_rep_asset_position',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
