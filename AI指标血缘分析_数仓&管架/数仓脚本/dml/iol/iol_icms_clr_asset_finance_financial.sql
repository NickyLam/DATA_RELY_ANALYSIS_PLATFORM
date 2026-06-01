/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_finance_financial
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
create table ${iol_schema}.icms_clr_asset_finance_financial_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_finance_financial
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_finance_financial_op purge;
drop table ${iol_schema}.icms_clr_asset_finance_financial_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_financial_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_finance_financial where 0=1;

create table ${iol_schema}.icms_clr_asset_finance_financial_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_finance_financial where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_finance_financial_cl(
            accountday -- 资金到帐天数
            ,accountname -- 专用账户名称
            ,accountno -- 银行账号
            ,address -- 银行注册地所在国家或地区
            ,allnum -- 总份额
            ,backnbr -- 理财冻结流水号
            ,cashaccount -- 保证金账号
            ,cfmno -- 确认流水号
            ,clrid -- 押品编号
            ,customertype -- 理财系统客户类型
            ,depositstatus -- 冻结状态
            ,enddate -- 到期日期
            ,impawnnum -- 质押份额
            ,incometype -- 收益类型
            ,inratingdate -- 银行的内部评级日期
            ,inratingresult -- 银行的内部评级结果
            ,isowner -- 是否本行理财
            ,istermright -- 提前终止权
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,outratingdate -- 银行的外部评级日期
            ,outratingresult -- 银行的外部评级结果
            ,predictyield -- 预期收益率
            ,productcode -- 理财产品编码
            ,productname -- 理财产品名称
            ,remark -- 其他说明
            ,startdate -- 起始日期
            ,tdcurrency -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_finance_financial_op(
            accountday -- 资金到帐天数
            ,accountname -- 专用账户名称
            ,accountno -- 银行账号
            ,address -- 银行注册地所在国家或地区
            ,allnum -- 总份额
            ,backnbr -- 理财冻结流水号
            ,cashaccount -- 保证金账号
            ,cfmno -- 确认流水号
            ,clrid -- 押品编号
            ,customertype -- 理财系统客户类型
            ,depositstatus -- 冻结状态
            ,enddate -- 到期日期
            ,impawnnum -- 质押份额
            ,incometype -- 收益类型
            ,inratingdate -- 银行的内部评级日期
            ,inratingresult -- 银行的内部评级结果
            ,isowner -- 是否本行理财
            ,istermright -- 提前终止权
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,outratingdate -- 银行的外部评级日期
            ,outratingresult -- 银行的外部评级结果
            ,predictyield -- 预期收益率
            ,productcode -- 理财产品编码
            ,productname -- 理财产品名称
            ,remark -- 其他说明
            ,startdate -- 起始日期
            ,tdcurrency -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.accountday, o.accountday) as accountday -- 资金到帐天数
    ,nvl(n.accountname, o.accountname) as accountname -- 专用账户名称
    ,nvl(n.accountno, o.accountno) as accountno -- 银行账号
    ,nvl(n.address, o.address) as address -- 银行注册地所在国家或地区
    ,nvl(n.allnum, o.allnum) as allnum -- 总份额
    ,nvl(n.backnbr, o.backnbr) as backnbr -- 理财冻结流水号
    ,nvl(n.cashaccount, o.cashaccount) as cashaccount -- 保证金账号
    ,nvl(n.cfmno, o.cfmno) as cfmno -- 确认流水号
    ,nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.customertype, o.customertype) as customertype -- 理财系统客户类型
    ,nvl(n.depositstatus, o.depositstatus) as depositstatus -- 冻结状态
    ,nvl(n.enddate, o.enddate) as enddate -- 到期日期
    ,nvl(n.impawnnum, o.impawnnum) as impawnnum -- 质押份额
    ,nvl(n.incometype, o.incometype) as incometype -- 收益类型
    ,nvl(n.inratingdate, o.inratingdate) as inratingdate -- 银行的内部评级日期
    ,nvl(n.inratingresult, o.inratingresult) as inratingresult -- 银行的内部评级结果
    ,nvl(n.isowner, o.isowner) as isowner -- 是否本行理财
    ,nvl(n.istermright, o.istermright) as istermright -- 提前终止权
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,nvl(n.outratingdate, o.outratingdate) as outratingdate -- 银行的外部评级日期
    ,nvl(n.outratingresult, o.outratingresult) as outratingresult -- 银行的外部评级结果
    ,nvl(n.predictyield, o.predictyield) as predictyield -- 预期收益率
    ,nvl(n.productcode, o.productcode) as productcode -- 理财产品编码
    ,nvl(n.productname, o.productname) as productname -- 理财产品名称
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.startdate, o.startdate) as startdate -- 起始日期
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 币种
    ,case when
            n.clrid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.clrid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.clrid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_asset_finance_financial_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_finance_financial where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.accountday <> n.accountday
        or o.accountname <> n.accountname
        or o.accountno <> n.accountno
        or o.address <> n.address
        or o.allnum <> n.allnum
        or o.backnbr <> n.backnbr
        or o.cashaccount <> n.cashaccount
        or o.cfmno <> n.cfmno
        or o.customertype <> n.customertype
        or o.depositstatus <> n.depositstatus
        or o.enddate <> n.enddate
        or o.impawnnum <> n.impawnnum
        or o.incometype <> n.incometype
        or o.inratingdate <> n.inratingdate
        or o.inratingresult <> n.inratingresult
        or o.isowner <> n.isowner
        or o.istermright <> n.istermright
        or o.migtflag <> n.migtflag
        or o.outratingdate <> n.outratingdate
        or o.outratingresult <> n.outratingresult
        or o.predictyield <> n.predictyield
        or o.productcode <> n.productcode
        or o.productname <> n.productname
        or o.remark <> n.remark
        or o.startdate <> n.startdate
        or o.tdcurrency <> n.tdcurrency
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_finance_financial_cl(
            accountday -- 资金到帐天数
            ,accountname -- 专用账户名称
            ,accountno -- 银行账号
            ,address -- 银行注册地所在国家或地区
            ,allnum -- 总份额
            ,backnbr -- 理财冻结流水号
            ,cashaccount -- 保证金账号
            ,cfmno -- 确认流水号
            ,clrid -- 押品编号
            ,customertype -- 理财系统客户类型
            ,depositstatus -- 冻结状态
            ,enddate -- 到期日期
            ,impawnnum -- 质押份额
            ,incometype -- 收益类型
            ,inratingdate -- 银行的内部评级日期
            ,inratingresult -- 银行的内部评级结果
            ,isowner -- 是否本行理财
            ,istermright -- 提前终止权
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,outratingdate -- 银行的外部评级日期
            ,outratingresult -- 银行的外部评级结果
            ,predictyield -- 预期收益率
            ,productcode -- 理财产品编码
            ,productname -- 理财产品名称
            ,remark -- 其他说明
            ,startdate -- 起始日期
            ,tdcurrency -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_finance_financial_op(
            accountday -- 资金到帐天数
            ,accountname -- 专用账户名称
            ,accountno -- 银行账号
            ,address -- 银行注册地所在国家或地区
            ,allnum -- 总份额
            ,backnbr -- 理财冻结流水号
            ,cashaccount -- 保证金账号
            ,cfmno -- 确认流水号
            ,clrid -- 押品编号
            ,customertype -- 理财系统客户类型
            ,depositstatus -- 冻结状态
            ,enddate -- 到期日期
            ,impawnnum -- 质押份额
            ,incometype -- 收益类型
            ,inratingdate -- 银行的内部评级日期
            ,inratingresult -- 银行的内部评级结果
            ,isowner -- 是否本行理财
            ,istermright -- 提前终止权
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,outratingdate -- 银行的外部评级日期
            ,outratingresult -- 银行的外部评级结果
            ,predictyield -- 预期收益率
            ,productcode -- 理财产品编码
            ,productname -- 理财产品名称
            ,remark -- 其他说明
            ,startdate -- 起始日期
            ,tdcurrency -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.accountday -- 资金到帐天数
    ,o.accountname -- 专用账户名称
    ,o.accountno -- 银行账号
    ,o.address -- 银行注册地所在国家或地区
    ,o.allnum -- 总份额
    ,o.backnbr -- 理财冻结流水号
    ,o.cashaccount -- 保证金账号
    ,o.cfmno -- 确认流水号
    ,o.clrid -- 押品编号
    ,o.customertype -- 理财系统客户类型
    ,o.depositstatus -- 冻结状态
    ,o.enddate -- 到期日期
    ,o.impawnnum -- 质押份额
    ,o.incometype -- 收益类型
    ,o.inratingdate -- 银行的内部评级日期
    ,o.inratingresult -- 银行的内部评级结果
    ,o.isowner -- 是否本行理财
    ,o.istermright -- 提前终止权
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
    ,o.outratingdate -- 银行的外部评级日期
    ,o.outratingresult -- 银行的外部评级结果
    ,o.predictyield -- 预期收益率
    ,o.productcode -- 理财产品编码
    ,o.productname -- 理财产品名称
    ,o.remark -- 其他说明
    ,o.startdate -- 起始日期
    ,o.tdcurrency -- 币种
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
from ${iol_schema}.icms_clr_asset_finance_financial_bk o
    left join ${iol_schema}.icms_clr_asset_finance_financial_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_finance_financial_cl d
        on
            o.clrid = d.clrid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_asset_finance_financial;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_finance_financial') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_finance_financial drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_finance_financial add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_finance_financial exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_finance_financial_cl;
alter table ${iol_schema}.icms_clr_asset_finance_financial exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_finance_financial_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_finance_financial to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_finance_financial_op purge;
drop table ${iol_schema}.icms_clr_asset_finance_financial_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_finance_financial_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_finance_financial',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
