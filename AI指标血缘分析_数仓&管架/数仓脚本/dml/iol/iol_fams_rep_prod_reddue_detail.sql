/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_rep_prod_reddue_detail
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
create table ${iol_schema}.fams_rep_prod_reddue_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_rep_prod_reddue_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_rep_prod_reddue_detail_op purge;
drop table ${iol_schema}.fams_rep_prod_reddue_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_rep_prod_reddue_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_rep_prod_reddue_detail where 0=1;

create table ${iol_schema}.fams_rep_prod_reddue_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_rep_prod_reddue_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_rep_prod_reddue_detail_cl(
            cdate -- 日期
            ,prodid -- 产品标识
            ,prodcode -- 产品代码
            ,prodname -- 产品简称
            ,profittype -- 收益类型代码
            ,profittype_name -- 收益类型标识
            ,prodseries -- 系列代码
            ,prodseries_name -- 系列名称
            ,invnature -- 投资性质代码
            ,invnature_name -- 投资性质名称
            ,operatemode -- 运行方式代码
            ,operatemode_name -- 运行方式名称
            ,periodid -- 期次代码
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,term -- 期限（天）
            ,dueamt -- 到期兑付本金（元）
            ,dueqty -- 总份额（元）
            ,actamt -- 实际兑付金额（元）
            ,jtglfl -- 计提固定管理费率%
            ,yjbjjz -- 业绩比较基准%
            ,ratelower -- 业绩比较基准下限%
            ,ratelimit -- 业绩比较基准上限%
            ,baserule -- 业绩比较基准
            ,yieldtermbef -- 产品实际运作业绩%
            ,yieldterm -- 兑付客户年化收益率%（回补后）
            ,clawamt -- 减免管理费（元）
            ,glfzfamt -- 实收管理费（已支付）
            ,jtglfamt -- 实收管理费（未支付）
            ,ssglfl -- 实收固定管理费率%
            ,ceglfl -- 实收超额管理费率%
            ,sqglfl -- 实际收取管理费率%
            ,manager -- 投资经理
            ,remark -- 备注
            ,is_private_prod -- 是否私行客户
            ,privateprod_flag -- 私行客户标识
            ,is_cust_prod -- 是否定制产品
            ,custprod_flag -- 定制产品标识
            ,custprodtype -- 定制产品代码
            ,custprodtype_name -- 定制产品标识
            ,is_min_hold_period -- 是否最短持有期产品
            ,minholdperiod_flag -- 最短持有期产品标识
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
        into ${iol_schema}.fams_rep_prod_reddue_detail_op(
            cdate -- 日期
            ,prodid -- 产品标识
            ,prodcode -- 产品代码
            ,prodname -- 产品简称
            ,profittype -- 收益类型代码
            ,profittype_name -- 收益类型标识
            ,prodseries -- 系列代码
            ,prodseries_name -- 系列名称
            ,invnature -- 投资性质代码
            ,invnature_name -- 投资性质名称
            ,operatemode -- 运行方式代码
            ,operatemode_name -- 运行方式名称
            ,periodid -- 期次代码
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,term -- 期限（天）
            ,dueamt -- 到期兑付本金（元）
            ,dueqty -- 总份额（元）
            ,actamt -- 实际兑付金额（元）
            ,jtglfl -- 计提固定管理费率%
            ,yjbjjz -- 业绩比较基准%
            ,ratelower -- 业绩比较基准下限%
            ,ratelimit -- 业绩比较基准上限%
            ,baserule -- 业绩比较基准
            ,yieldtermbef -- 产品实际运作业绩%
            ,yieldterm -- 兑付客户年化收益率%（回补后）
            ,clawamt -- 减免管理费（元）
            ,glfzfamt -- 实收管理费（已支付）
            ,jtglfamt -- 实收管理费（未支付）
            ,ssglfl -- 实收固定管理费率%
            ,ceglfl -- 实收超额管理费率%
            ,sqglfl -- 实际收取管理费率%
            ,manager -- 投资经理
            ,remark -- 备注
            ,is_private_prod -- 是否私行客户
            ,privateprod_flag -- 私行客户标识
            ,is_cust_prod -- 是否定制产品
            ,custprod_flag -- 定制产品标识
            ,custprodtype -- 定制产品代码
            ,custprodtype_name -- 定制产品标识
            ,is_min_hold_period -- 是否最短持有期产品
            ,minholdperiod_flag -- 最短持有期产品标识
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
    ,nvl(n.prodid, o.prodid) as prodid -- 产品标识
    ,nvl(n.prodcode, o.prodcode) as prodcode -- 产品代码
    ,nvl(n.prodname, o.prodname) as prodname -- 产品简称
    ,nvl(n.profittype, o.profittype) as profittype -- 收益类型代码
    ,nvl(n.profittype_name, o.profittype_name) as profittype_name -- 收益类型标识
    ,nvl(n.prodseries, o.prodseries) as prodseries -- 系列代码
    ,nvl(n.prodseries_name, o.prodseries_name) as prodseries_name -- 系列名称
    ,nvl(n.invnature, o.invnature) as invnature -- 投资性质代码
    ,nvl(n.invnature_name, o.invnature_name) as invnature_name -- 投资性质名称
    ,nvl(n.operatemode, o.operatemode) as operatemode -- 运行方式代码
    ,nvl(n.operatemode_name, o.operatemode_name) as operatemode_name -- 运行方式名称
    ,nvl(n.periodid, o.periodid) as periodid -- 期次代码
    ,nvl(n.vdate, o.vdate) as vdate -- 起息日
    ,nvl(n.mdate, o.mdate) as mdate -- 到期日
    ,nvl(n.term, o.term) as term -- 期限（天）
    ,nvl(n.dueamt, o.dueamt) as dueamt -- 到期兑付本金（元）
    ,nvl(n.dueqty, o.dueqty) as dueqty -- 总份额（元）
    ,nvl(n.actamt, o.actamt) as actamt -- 实际兑付金额（元）
    ,nvl(n.jtglfl, o.jtglfl) as jtglfl -- 计提固定管理费率%
    ,nvl(n.yjbjjz, o.yjbjjz) as yjbjjz -- 业绩比较基准%
    ,nvl(n.ratelower, o.ratelower) as ratelower -- 业绩比较基准下限%
    ,nvl(n.ratelimit, o.ratelimit) as ratelimit -- 业绩比较基准上限%
    ,nvl(n.baserule, o.baserule) as baserule -- 业绩比较基准
    ,nvl(n.yieldtermbef, o.yieldtermbef) as yieldtermbef -- 产品实际运作业绩%
    ,nvl(n.yieldterm, o.yieldterm) as yieldterm -- 兑付客户年化收益率%（回补后）
    ,nvl(n.clawamt, o.clawamt) as clawamt -- 减免管理费（元）
    ,nvl(n.glfzfamt, o.glfzfamt) as glfzfamt -- 实收管理费（已支付）
    ,nvl(n.jtglfamt, o.jtglfamt) as jtglfamt -- 实收管理费（未支付）
    ,nvl(n.ssglfl, o.ssglfl) as ssglfl -- 实收固定管理费率%
    ,nvl(n.ceglfl, o.ceglfl) as ceglfl -- 实收超额管理费率%
    ,nvl(n.sqglfl, o.sqglfl) as sqglfl -- 实际收取管理费率%
    ,nvl(n.manager, o.manager) as manager -- 投资经理
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.is_private_prod, o.is_private_prod) as is_private_prod -- 是否私行客户
    ,nvl(n.privateprod_flag, o.privateprod_flag) as privateprod_flag -- 私行客户标识
    ,nvl(n.is_cust_prod, o.is_cust_prod) as is_cust_prod -- 是否定制产品
    ,nvl(n.custprod_flag, o.custprod_flag) as custprod_flag -- 定制产品标识
    ,nvl(n.custprodtype, o.custprodtype) as custprodtype -- 定制产品代码
    ,nvl(n.custprodtype_name, o.custprodtype_name) as custprodtype_name -- 定制产品标识
    ,nvl(n.is_min_hold_period, o.is_min_hold_period) as is_min_hold_period -- 是否最短持有期产品
    ,nvl(n.minholdperiod_flag, o.minholdperiod_flag) as minholdperiod_flag -- 最短持有期产品标识
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.cdate is null
            and n.prodid is null
            and n.vdate is null
            and n.mdate is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cdate is null
            and n.prodid is null
            and n.vdate is null
            and n.mdate is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cdate is null
            and n.prodid is null
            and n.vdate is null
            and n.mdate is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_rep_prod_reddue_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_rep_prod_reddue_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cdate = n.cdate
            and o.prodid = n.prodid
            and o.vdate = n.vdate
            and o.mdate = n.mdate
where (
        o.cdate is null
        and o.prodid is null
        and o.vdate is null
        and o.mdate is null
    )
    or (
        n.cdate is null
        and n.prodid is null
        and n.vdate is null
        and n.mdate is null
    )
    or (
        o.prodcode <> n.prodcode
        or o.prodname <> n.prodname
        or o.profittype <> n.profittype
        or o.profittype_name <> n.profittype_name
        or o.prodseries <> n.prodseries
        or o.prodseries_name <> n.prodseries_name
        or o.invnature <> n.invnature
        or o.invnature_name <> n.invnature_name
        or o.operatemode <> n.operatemode
        or o.operatemode_name <> n.operatemode_name
        or o.periodid <> n.periodid
        or o.term <> n.term
        or o.dueamt <> n.dueamt
        or o.dueqty <> n.dueqty
        or o.actamt <> n.actamt
        or o.jtglfl <> n.jtglfl
        or o.yjbjjz <> n.yjbjjz
        or o.ratelower <> n.ratelower
        or o.ratelimit <> n.ratelimit
        or o.baserule <> n.baserule
        or o.yieldtermbef <> n.yieldtermbef
        or o.yieldterm <> n.yieldterm
        or o.clawamt <> n.clawamt
        or o.glfzfamt <> n.glfzfamt
        or o.jtglfamt <> n.jtglfamt
        or o.ssglfl <> n.ssglfl
        or o.ceglfl <> n.ceglfl
        or o.sqglfl <> n.sqglfl
        or o.manager <> n.manager
        or o.remark <> n.remark
        or o.is_private_prod <> n.is_private_prod
        or o.privateprod_flag <> n.privateprod_flag
        or o.is_cust_prod <> n.is_cust_prod
        or o.custprod_flag <> n.custprod_flag
        or o.custprodtype <> n.custprodtype
        or o.custprodtype_name <> n.custprodtype_name
        or o.is_min_hold_period <> n.is_min_hold_period
        or o.minholdperiod_flag <> n.minholdperiod_flag
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
        into ${iol_schema}.fams_rep_prod_reddue_detail_cl(
            cdate -- 日期
            ,prodid -- 产品标识
            ,prodcode -- 产品代码
            ,prodname -- 产品简称
            ,profittype -- 收益类型代码
            ,profittype_name -- 收益类型标识
            ,prodseries -- 系列代码
            ,prodseries_name -- 系列名称
            ,invnature -- 投资性质代码
            ,invnature_name -- 投资性质名称
            ,operatemode -- 运行方式代码
            ,operatemode_name -- 运行方式名称
            ,periodid -- 期次代码
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,term -- 期限（天）
            ,dueamt -- 到期兑付本金（元）
            ,dueqty -- 总份额（元）
            ,actamt -- 实际兑付金额（元）
            ,jtglfl -- 计提固定管理费率%
            ,yjbjjz -- 业绩比较基准%
            ,ratelower -- 业绩比较基准下限%
            ,ratelimit -- 业绩比较基准上限%
            ,baserule -- 业绩比较基准
            ,yieldtermbef -- 产品实际运作业绩%
            ,yieldterm -- 兑付客户年化收益率%（回补后）
            ,clawamt -- 减免管理费（元）
            ,glfzfamt -- 实收管理费（已支付）
            ,jtglfamt -- 实收管理费（未支付）
            ,ssglfl -- 实收固定管理费率%
            ,ceglfl -- 实收超额管理费率%
            ,sqglfl -- 实际收取管理费率%
            ,manager -- 投资经理
            ,remark -- 备注
            ,is_private_prod -- 是否私行客户
            ,privateprod_flag -- 私行客户标识
            ,is_cust_prod -- 是否定制产品
            ,custprod_flag -- 定制产品标识
            ,custprodtype -- 定制产品代码
            ,custprodtype_name -- 定制产品标识
            ,is_min_hold_period -- 是否最短持有期产品
            ,minholdperiod_flag -- 最短持有期产品标识
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
        into ${iol_schema}.fams_rep_prod_reddue_detail_op(
            cdate -- 日期
            ,prodid -- 产品标识
            ,prodcode -- 产品代码
            ,prodname -- 产品简称
            ,profittype -- 收益类型代码
            ,profittype_name -- 收益类型标识
            ,prodseries -- 系列代码
            ,prodseries_name -- 系列名称
            ,invnature -- 投资性质代码
            ,invnature_name -- 投资性质名称
            ,operatemode -- 运行方式代码
            ,operatemode_name -- 运行方式名称
            ,periodid -- 期次代码
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,term -- 期限（天）
            ,dueamt -- 到期兑付本金（元）
            ,dueqty -- 总份额（元）
            ,actamt -- 实际兑付金额（元）
            ,jtglfl -- 计提固定管理费率%
            ,yjbjjz -- 业绩比较基准%
            ,ratelower -- 业绩比较基准下限%
            ,ratelimit -- 业绩比较基准上限%
            ,baserule -- 业绩比较基准
            ,yieldtermbef -- 产品实际运作业绩%
            ,yieldterm -- 兑付客户年化收益率%（回补后）
            ,clawamt -- 减免管理费（元）
            ,glfzfamt -- 实收管理费（已支付）
            ,jtglfamt -- 实收管理费（未支付）
            ,ssglfl -- 实收固定管理费率%
            ,ceglfl -- 实收超额管理费率%
            ,sqglfl -- 实际收取管理费率%
            ,manager -- 投资经理
            ,remark -- 备注
            ,is_private_prod -- 是否私行客户
            ,privateprod_flag -- 私行客户标识
            ,is_cust_prod -- 是否定制产品
            ,custprod_flag -- 定制产品标识
            ,custprodtype -- 定制产品代码
            ,custprodtype_name -- 定制产品标识
            ,is_min_hold_period -- 是否最短持有期产品
            ,minholdperiod_flag -- 最短持有期产品标识
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
    ,o.prodid -- 产品标识
    ,o.prodcode -- 产品代码
    ,o.prodname -- 产品简称
    ,o.profittype -- 收益类型代码
    ,o.profittype_name -- 收益类型标识
    ,o.prodseries -- 系列代码
    ,o.prodseries_name -- 系列名称
    ,o.invnature -- 投资性质代码
    ,o.invnature_name -- 投资性质名称
    ,o.operatemode -- 运行方式代码
    ,o.operatemode_name -- 运行方式名称
    ,o.periodid -- 期次代码
    ,o.vdate -- 起息日
    ,o.mdate -- 到期日
    ,o.term -- 期限（天）
    ,o.dueamt -- 到期兑付本金（元）
    ,o.dueqty -- 总份额（元）
    ,o.actamt -- 实际兑付金额（元）
    ,o.jtglfl -- 计提固定管理费率%
    ,o.yjbjjz -- 业绩比较基准%
    ,o.ratelower -- 业绩比较基准下限%
    ,o.ratelimit -- 业绩比较基准上限%
    ,o.baserule -- 业绩比较基准
    ,o.yieldtermbef -- 产品实际运作业绩%
    ,o.yieldterm -- 兑付客户年化收益率%（回补后）
    ,o.clawamt -- 减免管理费（元）
    ,o.glfzfamt -- 实收管理费（已支付）
    ,o.jtglfamt -- 实收管理费（未支付）
    ,o.ssglfl -- 实收固定管理费率%
    ,o.ceglfl -- 实收超额管理费率%
    ,o.sqglfl -- 实际收取管理费率%
    ,o.manager -- 投资经理
    ,o.remark -- 备注
    ,o.is_private_prod -- 是否私行客户
    ,o.privateprod_flag -- 私行客户标识
    ,o.is_cust_prod -- 是否定制产品
    ,o.custprod_flag -- 定制产品标识
    ,o.custprodtype -- 定制产品代码
    ,o.custprodtype_name -- 定制产品标识
    ,o.is_min_hold_period -- 是否最短持有期产品
    ,o.minholdperiod_flag -- 最短持有期产品标识
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
from ${iol_schema}.fams_rep_prod_reddue_detail_bk o
    left join ${iol_schema}.fams_rep_prod_reddue_detail_op n
        on
            o.cdate = n.cdate
            and o.prodid = n.prodid
            and o.vdate = n.vdate
            and o.mdate = n.mdate
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_rep_prod_reddue_detail_cl d
        on
            o.cdate = d.cdate
            and o.prodid = d.prodid
            and o.vdate = d.vdate
            and o.mdate = d.mdate
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_rep_prod_reddue_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_rep_prod_reddue_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_rep_prod_reddue_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_rep_prod_reddue_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_rep_prod_reddue_detail exchange partition p_${batch_date} with table ${iol_schema}.fams_rep_prod_reddue_detail_cl;
alter table ${iol_schema}.fams_rep_prod_reddue_detail exchange partition p_20991231 with table ${iol_schema}.fams_rep_prod_reddue_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_rep_prod_reddue_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_rep_prod_reddue_detail_op purge;
drop table ${iol_schema}.fams_rep_prod_reddue_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_rep_prod_reddue_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_rep_prod_reddue_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
