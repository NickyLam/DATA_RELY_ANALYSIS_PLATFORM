/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybk_guaranty_contract
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
create table ${iol_schema}.icms_mybk_guaranty_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_mybk_guaranty_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybk_guaranty_contract_op purge;
drop table ${iol_schema}.icms_mybk_guaranty_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_guaranty_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_guaranty_contract where 0=1;

create table ${iol_schema}.icms_mybk_guaranty_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_guaranty_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybk_guaranty_contract_cl(
            guarantyno -- 担保合同编号
            ,guarantytype -- 担保合同类型(一般担保合同、最高额担保合同)
            ,guarantystyle -- 担保方式
            ,guarantystatus -- 担保合同状态
            ,signdate -- 协议签定日期
            ,begindate -- 合同生效日
            ,enddate -- 合同到期日
            ,customerid -- 被担保人客户号
            ,guarantorid -- 担保人编号
            ,guarantorname -- 担保人名称
            ,certtype -- 担保人证件类型
            ,certid -- 担保人证件号码
            ,guaranteeform -- 保证担保形式
            ,guaorgname -- 担保机构名称
            ,guapromisebookid -- 担保事项承诺书编号
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,guarantycurrency -- 担保币种
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,usesum -- 担保金额
            ,isguarantyplatformloan -- 是否政府性融资担保公司保证
            ,isbackguaranty -- 是否反担保
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybk_guaranty_contract_op(
            guarantyno -- 担保合同编号
            ,guarantytype -- 担保合同类型(一般担保合同、最高额担保合同)
            ,guarantystyle -- 担保方式
            ,guarantystatus -- 担保合同状态
            ,signdate -- 协议签定日期
            ,begindate -- 合同生效日
            ,enddate -- 合同到期日
            ,customerid -- 被担保人客户号
            ,guarantorid -- 担保人编号
            ,guarantorname -- 担保人名称
            ,certtype -- 担保人证件类型
            ,certid -- 担保人证件号码
            ,guaranteeform -- 保证担保形式
            ,guaorgname -- 担保机构名称
            ,guapromisebookid -- 担保事项承诺书编号
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,guarantycurrency -- 担保币种
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,usesum -- 担保金额
            ,isguarantyplatformloan -- 是否政府性融资担保公司保证
            ,isbackguaranty -- 是否反担保
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.guarantyno, o.guarantyno) as guarantyno -- 担保合同编号
    ,nvl(n.guarantytype, o.guarantytype) as guarantytype -- 担保合同类型(一般担保合同、最高额担保合同)
    ,nvl(n.guarantystyle, o.guarantystyle) as guarantystyle -- 担保方式
    ,nvl(n.guarantystatus, o.guarantystatus) as guarantystatus -- 担保合同状态
    ,nvl(n.signdate, o.signdate) as signdate -- 协议签定日期
    ,nvl(n.begindate, o.begindate) as begindate -- 合同生效日
    ,nvl(n.enddate, o.enddate) as enddate -- 合同到期日
    ,nvl(n.customerid, o.customerid) as customerid -- 被担保人客户号
    ,nvl(n.guarantorid, o.guarantorid) as guarantorid -- 担保人编号
    ,nvl(n.guarantorname, o.guarantorname) as guarantorname -- 担保人名称
    ,nvl(n.certtype, o.certtype) as certtype -- 担保人证件类型
    ,nvl(n.certid, o.certid) as certid -- 担保人证件号码
    ,nvl(n.guaranteeform, o.guaranteeform) as guaranteeform -- 保证担保形式
    ,nvl(n.guaorgname, o.guaorgname) as guaorgname -- 担保机构名称
    ,nvl(n.guapromisebookid, o.guapromisebookid) as guapromisebookid -- 担保事项承诺书编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.guarantycurrency, o.guarantycurrency) as guarantycurrency -- 担保币种
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.usesum, o.usesum) as usesum -- 担保金额
    ,nvl(n.isguarantyplatformloan, o.isguarantyplatformloan) as isguarantyplatformloan -- 是否政府性融资担保公司保证
    ,nvl(n.isbackguaranty, o.isbackguaranty) as isbackguaranty -- 是否反担保
    ,case when
            n.guarantyno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.guarantyno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.guarantyno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_mybk_guaranty_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_mybk_guaranty_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.guarantyno = n.guarantyno
where (
        o.guarantyno is null
    )
    or (
        n.guarantyno is null
    )
    or (
        o.guarantytype <> n.guarantytype
        or o.guarantystyle <> n.guarantystyle
        or o.guarantystatus <> n.guarantystatus
        or o.signdate <> n.signdate
        or o.begindate <> n.begindate
        or o.enddate <> n.enddate
        or o.customerid <> n.customerid
        or o.guarantorid <> n.guarantorid
        or o.guarantorname <> n.guarantorname
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.guaranteeform <> n.guaranteeform
        or o.guaorgname <> n.guaorgname
        or o.guapromisebookid <> n.guapromisebookid
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.guarantycurrency <> n.guarantycurrency
        or o.migtflag <> n.migtflag
        or o.usesum <> n.usesum
        or o.isguarantyplatformloan <> n.isguarantyplatformloan
        or o.isbackguaranty <> n.isbackguaranty
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybk_guaranty_contract_cl(
            guarantyno -- 担保合同编号
            ,guarantytype -- 担保合同类型(一般担保合同、最高额担保合同)
            ,guarantystyle -- 担保方式
            ,guarantystatus -- 担保合同状态
            ,signdate -- 协议签定日期
            ,begindate -- 合同生效日
            ,enddate -- 合同到期日
            ,customerid -- 被担保人客户号
            ,guarantorid -- 担保人编号
            ,guarantorname -- 担保人名称
            ,certtype -- 担保人证件类型
            ,certid -- 担保人证件号码
            ,guaranteeform -- 保证担保形式
            ,guaorgname -- 担保机构名称
            ,guapromisebookid -- 担保事项承诺书编号
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,guarantycurrency -- 担保币种
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,usesum -- 担保金额
            ,isguarantyplatformloan -- 是否政府性融资担保公司保证
            ,isbackguaranty -- 是否反担保
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybk_guaranty_contract_op(
            guarantyno -- 担保合同编号
            ,guarantytype -- 担保合同类型(一般担保合同、最高额担保合同)
            ,guarantystyle -- 担保方式
            ,guarantystatus -- 担保合同状态
            ,signdate -- 协议签定日期
            ,begindate -- 合同生效日
            ,enddate -- 合同到期日
            ,customerid -- 被担保人客户号
            ,guarantorid -- 担保人编号
            ,guarantorname -- 担保人名称
            ,certtype -- 担保人证件类型
            ,certid -- 担保人证件号码
            ,guaranteeform -- 保证担保形式
            ,guaorgname -- 担保机构名称
            ,guapromisebookid -- 担保事项承诺书编号
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,guarantycurrency -- 担保币种
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,usesum -- 担保金额
            ,isguarantyplatformloan -- 是否政府性融资担保公司保证
            ,isbackguaranty -- 是否反担保
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.guarantyno -- 担保合同编号
    ,o.guarantytype -- 担保合同类型(一般担保合同、最高额担保合同)
    ,o.guarantystyle -- 担保方式
    ,o.guarantystatus -- 担保合同状态
    ,o.signdate -- 协议签定日期
    ,o.begindate -- 合同生效日
    ,o.enddate -- 合同到期日
    ,o.customerid -- 被担保人客户号
    ,o.guarantorid -- 担保人编号
    ,o.guarantorname -- 担保人名称
    ,o.certtype -- 担保人证件类型
    ,o.certid -- 担保人证件号码
    ,o.guaranteeform -- 保证担保形式
    ,o.guaorgname -- 担保机构名称
    ,o.guapromisebookid -- 担保事项承诺书编号
    ,o.inputorgid -- 登记机构
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.guarantycurrency -- 担保币种
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.usesum -- 担保金额
    ,o.isguarantyplatformloan -- 是否政府性融资担保公司保证
    ,o.isbackguaranty -- 是否反担保
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
from ${iol_schema}.icms_mybk_guaranty_contract_bk o
    left join ${iol_schema}.icms_mybk_guaranty_contract_op n
        on
            o.guarantyno = n.guarantyno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_mybk_guaranty_contract_cl d
        on
            o.guarantyno = d.guarantyno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_mybk_guaranty_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_mybk_guaranty_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_mybk_guaranty_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_mybk_guaranty_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_mybk_guaranty_contract exchange partition p_${batch_date} with table ${iol_schema}.icms_mybk_guaranty_contract_cl;
alter table ${iol_schema}.icms_mybk_guaranty_contract exchange partition p_20991231 with table ${iol_schema}.icms_mybk_guaranty_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybk_guaranty_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybk_guaranty_contract_op purge;
drop table ${iol_schema}.icms_mybk_guaranty_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_mybk_guaranty_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybk_guaranty_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
