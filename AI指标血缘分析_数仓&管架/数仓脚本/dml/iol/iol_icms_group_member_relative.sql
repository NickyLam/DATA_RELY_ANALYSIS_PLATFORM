/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_group_member_relative
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
create table ${iol_schema}.icms_group_member_relative_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_group_member_relative
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_group_member_relative_op purge;
drop table ${iol_schema}.icms_group_member_relative_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_group_member_relative_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_group_member_relative where 0=1;

create table ${iol_schema}.icms_group_member_relative_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_group_member_relative where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_group_member_relative_cl(
            serialno -- 流水号
            ,oldmembercustomerid -- 原集团成员编号
            ,updateuserid -- 更新人
            ,membertype -- 成员类型
            ,updatedate -- 更新日期
            ,parentmemberid -- 父成员编号
            ,oldparentrelationtype -- 原父成员关系类型
            ,groupid -- 客户编号
            ,oldmembername -- 原成员名称
            ,oldmembertype -- 原成员类型
            ,inputuserid -- 登记人
            ,migtflag -- 
            ,inputdate -- 登记日期
            ,parentrelationtype -- 父成员关系类型
            ,membername -- 成员单位名称
            ,reviseflag -- 修订标志
            ,membercustomerid -- 成员客户编号
            ,membercertid -- 成员证件号
            ,inputorgid -- 登记单位
            ,remark -- 备注
            ,groupcustomertype -- 集团客户类型
            ,certid_ent04 -- 组织机构代码证(风险预警)
            ,updateorgid -- 更新机构
            ,sharevalue -- 持股比例
            ,membercerttype -- 成员证件类型
            ,oldsharevalue -- 原持股比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_group_member_relative_op(
            serialno -- 流水号
            ,oldmembercustomerid -- 原集团成员编号
            ,updateuserid -- 更新人
            ,membertype -- 成员类型
            ,updatedate -- 更新日期
            ,parentmemberid -- 父成员编号
            ,oldparentrelationtype -- 原父成员关系类型
            ,groupid -- 客户编号
            ,oldmembername -- 原成员名称
            ,oldmembertype -- 原成员类型
            ,inputuserid -- 登记人
            ,migtflag -- 
            ,inputdate -- 登记日期
            ,parentrelationtype -- 父成员关系类型
            ,membername -- 成员单位名称
            ,reviseflag -- 修订标志
            ,membercustomerid -- 成员客户编号
            ,membercertid -- 成员证件号
            ,inputorgid -- 登记单位
            ,remark -- 备注
            ,groupcustomertype -- 集团客户类型
            ,certid_ent04 -- 组织机构代码证(风险预警)
            ,updateorgid -- 更新机构
            ,sharevalue -- 持股比例
            ,membercerttype -- 成员证件类型
            ,oldsharevalue -- 原持股比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.oldmembercustomerid, o.oldmembercustomerid) as oldmembercustomerid -- 原集团成员编号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.membertype, o.membertype) as membertype -- 成员类型
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.parentmemberid, o.parentmemberid) as parentmemberid -- 父成员编号
    ,nvl(n.oldparentrelationtype, o.oldparentrelationtype) as oldparentrelationtype -- 原父成员关系类型
    ,nvl(n.groupid, o.groupid) as groupid -- 客户编号
    ,nvl(n.oldmembername, o.oldmembername) as oldmembername -- 原成员名称
    ,nvl(n.oldmembertype, o.oldmembertype) as oldmembertype -- 原成员类型
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.parentrelationtype, o.parentrelationtype) as parentrelationtype -- 父成员关系类型
    ,nvl(n.membername, o.membername) as membername -- 成员单位名称
    ,nvl(n.reviseflag, o.reviseflag) as reviseflag -- 修订标志
    ,nvl(n.membercustomerid, o.membercustomerid) as membercustomerid -- 成员客户编号
    ,nvl(n.membercertid, o.membercertid) as membercertid -- 成员证件号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记单位
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.groupcustomertype, o.groupcustomertype) as groupcustomertype -- 集团客户类型
    ,nvl(n.certid_ent04, o.certid_ent04) as certid_ent04 -- 组织机构代码证(风险预警)
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.sharevalue, o.sharevalue) as sharevalue -- 持股比例
    ,nvl(n.membercerttype, o.membercerttype) as membercerttype -- 成员证件类型
    ,nvl(n.oldsharevalue, o.oldsharevalue) as oldsharevalue -- 原持股比例
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
from (select * from ${iol_schema}.icms_group_member_relative_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_group_member_relative where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.oldmembercustomerid <> n.oldmembercustomerid
        or o.updateuserid <> n.updateuserid
        or o.membertype <> n.membertype
        or o.updatedate <> n.updatedate
        or o.parentmemberid <> n.parentmemberid
        or o.oldparentrelationtype <> n.oldparentrelationtype
        or o.groupid <> n.groupid
        or o.oldmembername <> n.oldmembername
        or o.oldmembertype <> n.oldmembertype
        or o.inputuserid <> n.inputuserid
        or o.migtflag <> n.migtflag
        or o.inputdate <> n.inputdate
        or o.parentrelationtype <> n.parentrelationtype
        or o.membername <> n.membername
        or o.reviseflag <> n.reviseflag
        or o.membercustomerid <> n.membercustomerid
        or o.membercertid <> n.membercertid
        or o.inputorgid <> n.inputorgid
        or o.remark <> n.remark
        or o.groupcustomertype <> n.groupcustomertype
        or o.certid_ent04 <> n.certid_ent04
        or o.updateorgid <> n.updateorgid
        or o.sharevalue <> n.sharevalue
        or o.membercerttype <> n.membercerttype
        or o.oldsharevalue <> n.oldsharevalue
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_group_member_relative_cl(
            serialno -- 流水号
            ,oldmembercustomerid -- 原集团成员编号
            ,updateuserid -- 更新人
            ,membertype -- 成员类型
            ,updatedate -- 更新日期
            ,parentmemberid -- 父成员编号
            ,oldparentrelationtype -- 原父成员关系类型
            ,groupid -- 客户编号
            ,oldmembername -- 原成员名称
            ,oldmembertype -- 原成员类型
            ,inputuserid -- 登记人
            ,migtflag -- 
            ,inputdate -- 登记日期
            ,parentrelationtype -- 父成员关系类型
            ,membername -- 成员单位名称
            ,reviseflag -- 修订标志
            ,membercustomerid -- 成员客户编号
            ,membercertid -- 成员证件号
            ,inputorgid -- 登记单位
            ,remark -- 备注
            ,groupcustomertype -- 集团客户类型
            ,certid_ent04 -- 组织机构代码证(风险预警)
            ,updateorgid -- 更新机构
            ,sharevalue -- 持股比例
            ,membercerttype -- 成员证件类型
            ,oldsharevalue -- 原持股比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_group_member_relative_op(
            serialno -- 流水号
            ,oldmembercustomerid -- 原集团成员编号
            ,updateuserid -- 更新人
            ,membertype -- 成员类型
            ,updatedate -- 更新日期
            ,parentmemberid -- 父成员编号
            ,oldparentrelationtype -- 原父成员关系类型
            ,groupid -- 客户编号
            ,oldmembername -- 原成员名称
            ,oldmembertype -- 原成员类型
            ,inputuserid -- 登记人
            ,migtflag -- 
            ,inputdate -- 登记日期
            ,parentrelationtype -- 父成员关系类型
            ,membername -- 成员单位名称
            ,reviseflag -- 修订标志
            ,membercustomerid -- 成员客户编号
            ,membercertid -- 成员证件号
            ,inputorgid -- 登记单位
            ,remark -- 备注
            ,groupcustomertype -- 集团客户类型
            ,certid_ent04 -- 组织机构代码证(风险预警)
            ,updateorgid -- 更新机构
            ,sharevalue -- 持股比例
            ,membercerttype -- 成员证件类型
            ,oldsharevalue -- 原持股比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.oldmembercustomerid -- 原集团成员编号
    ,o.updateuserid -- 更新人
    ,o.membertype -- 成员类型
    ,o.updatedate -- 更新日期
    ,o.parentmemberid -- 父成员编号
    ,o.oldparentrelationtype -- 原父成员关系类型
    ,o.groupid -- 客户编号
    ,o.oldmembername -- 原成员名称
    ,o.oldmembertype -- 原成员类型
    ,o.inputuserid -- 登记人
    ,o.migtflag -- 
    ,o.inputdate -- 登记日期
    ,o.parentrelationtype -- 父成员关系类型
    ,o.membername -- 成员单位名称
    ,o.reviseflag -- 修订标志
    ,o.membercustomerid -- 成员客户编号
    ,o.membercertid -- 成员证件号
    ,o.inputorgid -- 登记单位
    ,o.remark -- 备注
    ,o.groupcustomertype -- 集团客户类型
    ,o.certid_ent04 -- 组织机构代码证(风险预警)
    ,o.updateorgid -- 更新机构
    ,o.sharevalue -- 持股比例
    ,o.membercerttype -- 成员证件类型
    ,o.oldsharevalue -- 原持股比例
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
from ${iol_schema}.icms_group_member_relative_bk o
    left join ${iol_schema}.icms_group_member_relative_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_group_member_relative_cl d
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
--truncate table ${iol_schema}.icms_group_member_relative;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_group_member_relative') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_group_member_relative drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_group_member_relative add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_group_member_relative exchange partition p_${batch_date} with table ${iol_schema}.icms_group_member_relative_cl;
alter table ${iol_schema}.icms_group_member_relative exchange partition p_20991231 with table ${iol_schema}.icms_group_member_relative_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_group_member_relative to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_group_member_relative_op purge;
drop table ${iol_schema}.icms_group_member_relative_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_group_member_relative_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_group_member_relative',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
