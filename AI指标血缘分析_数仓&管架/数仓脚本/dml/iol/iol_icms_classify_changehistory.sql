/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_classify_changehistory
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
create table ${iol_schema}.icms_classify_changehistory_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_classify_changehistory
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_classify_changehistory_op purge;
drop table ${iol_schema}.icms_classify_changehistory_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_classify_changehistory_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_classify_changehistory where 0=1;

create table ${iol_schema}.icms_classify_changehistory_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_classify_changehistory where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_classify_changehistory_cl(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,relativetype -- 关联流程类型(1-风险分类发起2-风险分类调整申请)
            ,changetime -- 调整时间
            ,flowinputuserid -- 流程发起人
            ,objectno -- 对象值(额度合同号或业务合同号或客户号)
            ,businesstype -- 业务类型
            ,operateorgid -- 管护机构
            ,lastclassifyeleven -- 调整前十一级分类
            ,balance -- 余额
            ,lastclassifyfive -- 调整前五级分类
            ,operateuserid -- 管护人
            ,relativeserialno -- 关联流程编号
            ,businesscurrency -- 业务币种
            ,contractserialno -- 业务合同号
            ,afterclassifyfive -- 调整后五级分类
            ,afterclassifyeleven -- 调整后十一级分类
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,objectype -- 对象类型(01-针对额度合同02-业务合同03-客户)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_classify_changehistory_op(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,relativetype -- 关联流程类型(1-风险分类发起2-风险分类调整申请)
            ,changetime -- 调整时间
            ,flowinputuserid -- 流程发起人
            ,objectno -- 对象值(额度合同号或业务合同号或客户号)
            ,businesstype -- 业务类型
            ,operateorgid -- 管护机构
            ,lastclassifyeleven -- 调整前十一级分类
            ,balance -- 余额
            ,lastclassifyfive -- 调整前五级分类
            ,operateuserid -- 管护人
            ,relativeserialno -- 关联流程编号
            ,businesscurrency -- 业务币种
            ,contractserialno -- 业务合同号
            ,afterclassifyfive -- 调整后五级分类
            ,afterclassifyeleven -- 调整后十一级分类
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,objectype -- 对象类型(01-针对额度合同02-业务合同03-客户)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.relativetype, o.relativetype) as relativetype -- 关联流程类型(1-风险分类发起2-风险分类调整申请)
    ,nvl(n.changetime, o.changetime) as changetime -- 调整时间
    ,nvl(n.flowinputuserid, o.flowinputuserid) as flowinputuserid -- 流程发起人
    ,nvl(n.objectno, o.objectno) as objectno -- 对象值(额度合同号或业务合同号或客户号)
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务类型
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 管护机构
    ,nvl(n.lastclassifyeleven, o.lastclassifyeleven) as lastclassifyeleven -- 调整前十一级分类
    ,nvl(n.balance, o.balance) as balance -- 余额
    ,nvl(n.lastclassifyfive, o.lastclassifyfive) as lastclassifyfive -- 调整前五级分类
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 管护人
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 关联流程编号
    ,nvl(n.businesscurrency, o.businesscurrency) as businesscurrency -- 业务币种
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 业务合同号
    ,nvl(n.afterclassifyfive, o.afterclassifyfive) as afterclassifyfive -- 调整后五级分类
    ,nvl(n.afterclassifyeleven, o.afterclassifyeleven) as afterclassifyeleven -- 调整后十一级分类
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.objectype, o.objectype) as objectype -- 对象类型(01-针对额度合同02-业务合同03-客户)
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_classify_changehistory_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_classify_changehistory where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.migtflag <> n.migtflag
        or o.relativetype <> n.relativetype
        or o.changetime <> n.changetime
        or o.flowinputuserid <> n.flowinputuserid
        or o.objectno <> n.objectno
        or o.businesstype <> n.businesstype
        or o.operateorgid <> n.operateorgid
        or o.lastclassifyeleven <> n.lastclassifyeleven
        or o.balance <> n.balance
        or o.lastclassifyfive <> n.lastclassifyfive
        or o.operateuserid <> n.operateuserid
        or o.relativeserialno <> n.relativeserialno
        or o.businesscurrency <> n.businesscurrency
        or o.contractserialno <> n.contractserialno
        or o.afterclassifyfive <> n.afterclassifyfive
        or o.afterclassifyeleven <> n.afterclassifyeleven
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.objectype <> n.objectype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_classify_changehistory_cl(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,relativetype -- 关联流程类型(1-风险分类发起2-风险分类调整申请)
            ,changetime -- 调整时间
            ,flowinputuserid -- 流程发起人
            ,objectno -- 对象值(额度合同号或业务合同号或客户号)
            ,businesstype -- 业务类型
            ,operateorgid -- 管护机构
            ,lastclassifyeleven -- 调整前十一级分类
            ,balance -- 余额
            ,lastclassifyfive -- 调整前五级分类
            ,operateuserid -- 管护人
            ,relativeserialno -- 关联流程编号
            ,businesscurrency -- 业务币种
            ,contractserialno -- 业务合同号
            ,afterclassifyfive -- 调整后五级分类
            ,afterclassifyeleven -- 调整后十一级分类
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,objectype -- 对象类型(01-针对额度合同02-业务合同03-客户)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_classify_changehistory_op(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,relativetype -- 关联流程类型(1-风险分类发起2-风险分类调整申请)
            ,changetime -- 调整时间
            ,flowinputuserid -- 流程发起人
            ,objectno -- 对象值(额度合同号或业务合同号或客户号)
            ,businesstype -- 业务类型
            ,operateorgid -- 管护机构
            ,lastclassifyeleven -- 调整前十一级分类
            ,balance -- 余额
            ,lastclassifyfive -- 调整前五级分类
            ,operateuserid -- 管护人
            ,relativeserialno -- 关联流程编号
            ,businesscurrency -- 业务币种
            ,contractserialno -- 业务合同号
            ,afterclassifyfive -- 调整后五级分类
            ,afterclassifyeleven -- 调整后十一级分类
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,objectype -- 对象类型(01-针对额度合同02-业务合同03-客户)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.relativetype -- 关联流程类型(1-风险分类发起2-风险分类调整申请)
    ,o.changetime -- 调整时间
    ,o.flowinputuserid -- 流程发起人
    ,o.objectno -- 对象值(额度合同号或业务合同号或客户号)
    ,o.businesstype -- 业务类型
    ,o.operateorgid -- 管护机构
    ,o.lastclassifyeleven -- 调整前十一级分类
    ,o.balance -- 余额
    ,o.lastclassifyfive -- 调整前五级分类
    ,o.operateuserid -- 管护人
    ,o.relativeserialno -- 关联流程编号
    ,o.businesscurrency -- 业务币种
    ,o.contractserialno -- 业务合同号
    ,o.afterclassifyfive -- 调整后五级分类
    ,o.afterclassifyeleven -- 调整后十一级分类
    ,o.customerid -- 客户号
    ,o.customername -- 客户名称
    ,o.objectype -- 对象类型(01-针对额度合同02-业务合同03-客户)
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
from ${iol_schema}.icms_classify_changehistory_bk o
    left join ${iol_schema}.icms_classify_changehistory_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_classify_changehistory_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_classify_changehistory;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_classify_changehistory') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_classify_changehistory drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_classify_changehistory add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_classify_changehistory exchange partition p_${batch_date} with table ${iol_schema}.icms_classify_changehistory_cl;
alter table ${iol_schema}.icms_classify_changehistory exchange partition p_20991231 with table ${iol_schema}.icms_classify_changehistory_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_classify_changehistory to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_classify_changehistory_op purge;
drop table ${iol_schema}.icms_classify_changehistory_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_classify_changehistory_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_classify_changehistory',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
