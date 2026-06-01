/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_entry_credit_info
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
create table ${iol_schema}.icms_entry_credit_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_entry_credit_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_entry_credit_info_op purge;
drop table ${iol_schema}.icms_entry_credit_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_entry_credit_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_entry_credit_info where 0=1;

create table ${iol_schema}.icms_entry_credit_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_entry_credit_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_entry_credit_info_cl(
            serialno -- 流水号
            ,occurdate -- 发生日期
            ,productid -- 业务品种
            ,issmeandretail -- 是否我行小微企业并且走零售条线
            ,inputorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,authvouchtype -- 授权权限_担保方式
            ,currency -- 业务币种
            ,belonguser -- 贷后管理人员
            ,inputuserid -- 登记人
            ,othercondition -- 额度使用条件
            ,linelatestduedate -- 额度项下业务最迟到期日期
            ,inputdate -- 登记日期
            ,riskattribute -- 风险类型
            ,updatedate -- 更新日期
            ,iscycle -- 是否循环
            ,updateuserid -- 更新人
            ,linelatestdate -- 额度使用最迟日期
            ,otherlimittype -- 他用额度类型
            ,majorbusinessloanstype -- 专业贷款分类
            ,belongorg -- 贷后管理机构
            ,vouchtype -- 主要担保方式
            ,vouchflag -- 有无其他担保方式
            ,otherlimitno -- 他用额度流水号
            ,vouchtypeinner -- 担保方式（内部口径）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_entry_credit_info_op(
            serialno -- 流水号
            ,occurdate -- 发生日期
            ,productid -- 业务品种
            ,issmeandretail -- 是否我行小微企业并且走零售条线
            ,inputorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,authvouchtype -- 授权权限_担保方式
            ,currency -- 业务币种
            ,belonguser -- 贷后管理人员
            ,inputuserid -- 登记人
            ,othercondition -- 额度使用条件
            ,linelatestduedate -- 额度项下业务最迟到期日期
            ,inputdate -- 登记日期
            ,riskattribute -- 风险类型
            ,updatedate -- 更新日期
            ,iscycle -- 是否循环
            ,updateuserid -- 更新人
            ,linelatestdate -- 额度使用最迟日期
            ,otherlimittype -- 他用额度类型
            ,majorbusinessloanstype -- 专业贷款分类
            ,belongorg -- 贷后管理机构
            ,vouchtype -- 主要担保方式
            ,vouchflag -- 有无其他担保方式
            ,otherlimitno -- 他用额度流水号
            ,vouchtypeinner -- 担保方式（内部口径）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 发生日期
    ,nvl(n.productid, o.productid) as productid -- 业务品种
    ,nvl(n.issmeandretail, o.issmeandretail) as issmeandretail -- 是否我行小微企业并且走零售条线
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.authvouchtype, o.authvouchtype) as authvouchtype -- 授权权限_担保方式
    ,nvl(n.currency, o.currency) as currency -- 业务币种
    ,nvl(n.belonguser, o.belonguser) as belonguser -- 贷后管理人员
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.othercondition, o.othercondition) as othercondition -- 额度使用条件
    ,nvl(n.linelatestduedate, o.linelatestduedate) as linelatestduedate -- 额度项下业务最迟到期日期
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.riskattribute, o.riskattribute) as riskattribute -- 风险类型
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.iscycle, o.iscycle) as iscycle -- 是否循环
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.linelatestdate, o.linelatestdate) as linelatestdate -- 额度使用最迟日期
    ,nvl(n.otherlimittype, o.otherlimittype) as otherlimittype -- 他用额度类型
    ,nvl(n.majorbusinessloanstype, o.majorbusinessloanstype) as majorbusinessloanstype -- 专业贷款分类
    ,nvl(n.belongorg, o.belongorg) as belongorg -- 贷后管理机构
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 主要担保方式
    ,nvl(n.vouchflag, o.vouchflag) as vouchflag -- 有无其他担保方式
    ,nvl(n.otherlimitno, o.otherlimitno) as otherlimitno -- 他用额度流水号
    ,nvl(n.vouchtypeinner, o.vouchtypeinner) as vouchtypeinner -- 担保方式（内部口径）
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
from (select * from ${iol_schema}.icms_entry_credit_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_entry_credit_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.occurdate <> n.occurdate
        or o.productid <> n.productid
        or o.issmeandretail <> n.issmeandretail
        or o.inputorgid <> n.inputorgid
        or o.updateorgid <> n.updateorgid
        or o.authvouchtype <> n.authvouchtype
        or o.currency <> n.currency
        or o.belonguser <> n.belonguser
        or o.inputuserid <> n.inputuserid
        or o.othercondition <> n.othercondition
        or o.linelatestduedate <> n.linelatestduedate
        or o.inputdate <> n.inputdate
        or o.riskattribute <> n.riskattribute
        or o.updatedate <> n.updatedate
        or o.iscycle <> n.iscycle
        or o.updateuserid <> n.updateuserid
        or o.linelatestdate <> n.linelatestdate
        or o.otherlimittype <> n.otherlimittype
        or o.majorbusinessloanstype <> n.majorbusinessloanstype
        or o.belongorg <> n.belongorg
        or o.vouchtype <> n.vouchtype
        or o.vouchflag <> n.vouchflag
        or o.otherlimitno <> n.otherlimitno
        or o.vouchtypeinner <> n.vouchtypeinner
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_entry_credit_info_cl(
            serialno -- 流水号
            ,occurdate -- 发生日期
            ,productid -- 业务品种
            ,issmeandretail -- 是否我行小微企业并且走零售条线
            ,inputorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,authvouchtype -- 授权权限_担保方式
            ,currency -- 业务币种
            ,belonguser -- 贷后管理人员
            ,inputuserid -- 登记人
            ,othercondition -- 额度使用条件
            ,linelatestduedate -- 额度项下业务最迟到期日期
            ,inputdate -- 登记日期
            ,riskattribute -- 风险类型
            ,updatedate -- 更新日期
            ,iscycle -- 是否循环
            ,updateuserid -- 更新人
            ,linelatestdate -- 额度使用最迟日期
            ,otherlimittype -- 他用额度类型
            ,majorbusinessloanstype -- 专业贷款分类
            ,belongorg -- 贷后管理机构
            ,vouchtype -- 主要担保方式
            ,vouchflag -- 有无其他担保方式
            ,otherlimitno -- 他用额度流水号
            ,vouchtypeinner -- 担保方式（内部口径）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_entry_credit_info_op(
            serialno -- 流水号
            ,occurdate -- 发生日期
            ,productid -- 业务品种
            ,issmeandretail -- 是否我行小微企业并且走零售条线
            ,inputorgid -- 登记机构
            ,updateorgid -- 更新机构
            ,authvouchtype -- 授权权限_担保方式
            ,currency -- 业务币种
            ,belonguser -- 贷后管理人员
            ,inputuserid -- 登记人
            ,othercondition -- 额度使用条件
            ,linelatestduedate -- 额度项下业务最迟到期日期
            ,inputdate -- 登记日期
            ,riskattribute -- 风险类型
            ,updatedate -- 更新日期
            ,iscycle -- 是否循环
            ,updateuserid -- 更新人
            ,linelatestdate -- 额度使用最迟日期
            ,otherlimittype -- 他用额度类型
            ,majorbusinessloanstype -- 专业贷款分类
            ,belongorg -- 贷后管理机构
            ,vouchtype -- 主要担保方式
            ,vouchflag -- 有无其他担保方式
            ,otherlimitno -- 他用额度流水号
            ,vouchtypeinner -- 担保方式（内部口径）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.occurdate -- 发生日期
    ,o.productid -- 业务品种
    ,o.issmeandretail -- 是否我行小微企业并且走零售条线
    ,o.inputorgid -- 登记机构
    ,o.updateorgid -- 更新机构
    ,o.authvouchtype -- 授权权限_担保方式
    ,o.currency -- 业务币种
    ,o.belonguser -- 贷后管理人员
    ,o.inputuserid -- 登记人
    ,o.othercondition -- 额度使用条件
    ,o.linelatestduedate -- 额度项下业务最迟到期日期
    ,o.inputdate -- 登记日期
    ,o.riskattribute -- 风险类型
    ,o.updatedate -- 更新日期
    ,o.iscycle -- 是否循环
    ,o.updateuserid -- 更新人
    ,o.linelatestdate -- 额度使用最迟日期
    ,o.otherlimittype -- 他用额度类型
    ,o.majorbusinessloanstype -- 专业贷款分类
    ,o.belongorg -- 贷后管理机构
    ,o.vouchtype -- 主要担保方式
    ,o.vouchflag -- 有无其他担保方式
    ,o.otherlimitno -- 他用额度流水号
    ,o.vouchtypeinner -- 担保方式（内部口径）
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
from ${iol_schema}.icms_entry_credit_info_bk o
    left join ${iol_schema}.icms_entry_credit_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_entry_credit_info_cl d
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
--truncate table ${iol_schema}.icms_entry_credit_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_entry_credit_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_entry_credit_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_entry_credit_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_entry_credit_info exchange partition p_${batch_date} with table ${iol_schema}.icms_entry_credit_info_cl;
alter table ${iol_schema}.icms_entry_credit_info exchange partition p_20991231 with table ${iol_schema}.icms_entry_credit_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_entry_credit_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_entry_credit_info_op purge;
drop table ${iol_schema}.icms_entry_credit_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_entry_credit_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_entry_credit_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
