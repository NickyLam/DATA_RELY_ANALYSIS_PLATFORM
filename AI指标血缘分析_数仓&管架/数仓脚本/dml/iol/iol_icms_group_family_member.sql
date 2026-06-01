/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_group_family_member
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
create table ${iol_schema}.icms_group_family_member_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_group_family_member
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_group_family_member_op purge;
drop table ${iol_schema}.icms_group_family_member_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_group_family_member_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_group_family_member where 0=1;

create table ${iol_schema}.icms_group_family_member_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_group_family_member where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_group_family_member_cl(
            memberid -- 编号
            ,groupid -- 客户编号
            ,oldmembertype -- 原成员类型
            ,membercustomerid -- 集团成员编号
            ,updateorgid -- 更新机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,membername -- 成员名称
            ,membercertid -- 成员证件号
            ,membercerttype -- 成员证件类型
            ,reviseflag -- 修订标志
            ,inputorgid -- 登记单位
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,parentrelationtype -- 父成员关系类型
            ,remark -- 备注
            ,parentmemberid -- 父成员编号
            ,versionseq -- 版本序号
            ,oldparentrelationtype -- 原父成员关系类型
            ,status -- 状态
            ,joinreason -- 成员加入原因
            ,membertype -- 成员类型
            ,oldsharevalue -- 原持股比例
            ,updatedate -- 更新日期
            ,oldmembercustomerid -- 原集团成员编号
            ,oldmembername -- 原成员名称
            ,sharevalue -- 持股比例
            ,updateuserid -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_group_family_member_op(
            memberid -- 编号
            ,groupid -- 客户编号
            ,oldmembertype -- 原成员类型
            ,membercustomerid -- 集团成员编号
            ,updateorgid -- 更新机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,membername -- 成员名称
            ,membercertid -- 成员证件号
            ,membercerttype -- 成员证件类型
            ,reviseflag -- 修订标志
            ,inputorgid -- 登记单位
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,parentrelationtype -- 父成员关系类型
            ,remark -- 备注
            ,parentmemberid -- 父成员编号
            ,versionseq -- 版本序号
            ,oldparentrelationtype -- 原父成员关系类型
            ,status -- 状态
            ,joinreason -- 成员加入原因
            ,membertype -- 成员类型
            ,oldsharevalue -- 原持股比例
            ,updatedate -- 更新日期
            ,oldmembercustomerid -- 原集团成员编号
            ,oldmembername -- 原成员名称
            ,sharevalue -- 持股比例
            ,updateuserid -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.memberid, o.memberid) as memberid -- 编号
    ,nvl(n.groupid, o.groupid) as groupid -- 客户编号
    ,nvl(n.oldmembertype, o.oldmembertype) as oldmembertype -- 原成员类型
    ,nvl(n.membercustomerid, o.membercustomerid) as membercustomerid -- 集团成员编号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.membername, o.membername) as membername -- 成员名称
    ,nvl(n.membercertid, o.membercertid) as membercertid -- 成员证件号
    ,nvl(n.membercerttype, o.membercerttype) as membercerttype -- 成员证件类型
    ,nvl(n.reviseflag, o.reviseflag) as reviseflag -- 修订标志
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记单位
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.parentrelationtype, o.parentrelationtype) as parentrelationtype -- 父成员关系类型
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.parentmemberid, o.parentmemberid) as parentmemberid -- 父成员编号
    ,nvl(n.versionseq, o.versionseq) as versionseq -- 版本序号
    ,nvl(n.oldparentrelationtype, o.oldparentrelationtype) as oldparentrelationtype -- 原父成员关系类型
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.joinreason, o.joinreason) as joinreason -- 成员加入原因
    ,nvl(n.membertype, o.membertype) as membertype -- 成员类型
    ,nvl(n.oldsharevalue, o.oldsharevalue) as oldsharevalue -- 原持股比例
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.oldmembercustomerid, o.oldmembercustomerid) as oldmembercustomerid -- 原集团成员编号
    ,nvl(n.oldmembername, o.oldmembername) as oldmembername -- 原成员名称
    ,nvl(n.sharevalue, o.sharevalue) as sharevalue -- 持股比例
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,case when
            n.memberid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.memberid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.memberid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_group_family_member_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_group_family_member where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.memberid = n.memberid
where (
        o.memberid is null
    )
    or (
        n.memberid is null
    )
    or (
        o.groupid <> n.groupid
        or o.oldmembertype <> n.oldmembertype
        or o.membercustomerid <> n.membercustomerid
        or o.updateorgid <> n.updateorgid
        or o.migtflag <> n.migtflag
        or o.membername <> n.membername
        or o.membercertid <> n.membercertid
        or o.membercerttype <> n.membercerttype
        or o.reviseflag <> n.reviseflag
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.parentrelationtype <> n.parentrelationtype
        or o.remark <> n.remark
        or o.parentmemberid <> n.parentmemberid
        or o.versionseq <> n.versionseq
        or o.oldparentrelationtype <> n.oldparentrelationtype
        or o.status <> n.status
        or o.joinreason <> n.joinreason
        or o.membertype <> n.membertype
        or o.oldsharevalue <> n.oldsharevalue
        or o.updatedate <> n.updatedate
        or o.oldmembercustomerid <> n.oldmembercustomerid
        or o.oldmembername <> n.oldmembername
        or o.sharevalue <> n.sharevalue
        or o.updateuserid <> n.updateuserid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_group_family_member_cl(
            memberid -- 编号
            ,groupid -- 客户编号
            ,oldmembertype -- 原成员类型
            ,membercustomerid -- 集团成员编号
            ,updateorgid -- 更新机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,membername -- 成员名称
            ,membercertid -- 成员证件号
            ,membercerttype -- 成员证件类型
            ,reviseflag -- 修订标志
            ,inputorgid -- 登记单位
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,parentrelationtype -- 父成员关系类型
            ,remark -- 备注
            ,parentmemberid -- 父成员编号
            ,versionseq -- 版本序号
            ,oldparentrelationtype -- 原父成员关系类型
            ,status -- 状态
            ,joinreason -- 成员加入原因
            ,membertype -- 成员类型
            ,oldsharevalue -- 原持股比例
            ,updatedate -- 更新日期
            ,oldmembercustomerid -- 原集团成员编号
            ,oldmembername -- 原成员名称
            ,sharevalue -- 持股比例
            ,updateuserid -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_group_family_member_op(
            memberid -- 编号
            ,groupid -- 客户编号
            ,oldmembertype -- 原成员类型
            ,membercustomerid -- 集团成员编号
            ,updateorgid -- 更新机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,membername -- 成员名称
            ,membercertid -- 成员证件号
            ,membercerttype -- 成员证件类型
            ,reviseflag -- 修订标志
            ,inputorgid -- 登记单位
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,parentrelationtype -- 父成员关系类型
            ,remark -- 备注
            ,parentmemberid -- 父成员编号
            ,versionseq -- 版本序号
            ,oldparentrelationtype -- 原父成员关系类型
            ,status -- 状态
            ,joinreason -- 成员加入原因
            ,membertype -- 成员类型
            ,oldsharevalue -- 原持股比例
            ,updatedate -- 更新日期
            ,oldmembercustomerid -- 原集团成员编号
            ,oldmembername -- 原成员名称
            ,sharevalue -- 持股比例
            ,updateuserid -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.memberid -- 编号
    ,o.groupid -- 客户编号
    ,o.oldmembertype -- 原成员类型
    ,o.membercustomerid -- 集团成员编号
    ,o.updateorgid -- 更新机构
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.membername -- 成员名称
    ,o.membercertid -- 成员证件号
    ,o.membercerttype -- 成员证件类型
    ,o.reviseflag -- 修订标志
    ,o.inputorgid -- 登记单位
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.parentrelationtype -- 父成员关系类型
    ,o.remark -- 备注
    ,o.parentmemberid -- 父成员编号
    ,o.versionseq -- 版本序号
    ,o.oldparentrelationtype -- 原父成员关系类型
    ,o.status -- 状态
    ,o.joinreason -- 成员加入原因
    ,o.membertype -- 成员类型
    ,o.oldsharevalue -- 原持股比例
    ,o.updatedate -- 更新日期
    ,o.oldmembercustomerid -- 原集团成员编号
    ,o.oldmembername -- 原成员名称
    ,o.sharevalue -- 持股比例
    ,o.updateuserid -- 更新人
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
from ${iol_schema}.icms_group_family_member_bk o
    left join ${iol_schema}.icms_group_family_member_op n
        on
            o.memberid = n.memberid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_group_family_member_cl d
        on
            o.memberid = d.memberid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_group_family_member;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_group_family_member') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_group_family_member drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_group_family_member add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_group_family_member exchange partition p_${batch_date} with table ${iol_schema}.icms_group_family_member_cl;
alter table ${iol_schema}.icms_group_family_member exchange partition p_20991231 with table ${iol_schema}.icms_group_family_member_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_group_family_member to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_group_family_member_op purge;
drop table ${iol_schema}.icms_group_family_member_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_group_family_member_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_group_family_member',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
