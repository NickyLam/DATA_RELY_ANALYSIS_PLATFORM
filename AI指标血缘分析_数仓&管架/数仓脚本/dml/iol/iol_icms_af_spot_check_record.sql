/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_af_spot_check_record
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
create table ${iol_schema}.icms_af_spot_check_record_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_af_spot_check_record
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_af_spot_check_record_op purge;
drop table ${iol_schema}.icms_af_spot_check_record_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_af_spot_check_record_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_af_spot_check_record where 0=1;

create table ${iol_schema}.icms_af_spot_check_record_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_af_spot_check_record where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_af_spot_check_record_cl(
            serialno -- 流水号
            ,applyno -- 关联方流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,objecttype -- 对象类型
            ,objectno -- 关联对象编号
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,signtime -- 签到时间
            ,signaddress -- 签到地址
            ,attendeeid -- 到场用户Id集合
            ,peersremark -- 同行人员备注
            ,remark -- 图片拍摄备注说明
            ,tasktype -- 任务模式 1-信贷任务模式 2-展业新建任务模式
            ,workandsigndistance -- 签到地址与办公地距离
            ,registerandsigndistance -- 签到地址与注册地距离
            ,ispresent -- 分配角色是否到场(code:YesNo)
            ,signreason -- 签到原因说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_af_spot_check_record_op(
            serialno -- 流水号
            ,applyno -- 关联方流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,objecttype -- 对象类型
            ,objectno -- 关联对象编号
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,signtime -- 签到时间
            ,signaddress -- 签到地址
            ,attendeeid -- 到场用户Id集合
            ,peersremark -- 同行人员备注
            ,remark -- 图片拍摄备注说明
            ,tasktype -- 任务模式 1-信贷任务模式 2-展业新建任务模式
            ,workandsigndistance -- 签到地址与办公地距离
            ,registerandsigndistance -- 签到地址与注册地距离
            ,ispresent -- 分配角色是否到场(code:YesNo)
            ,signreason -- 签到原因说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.applyno, o.applyno) as applyno -- 关联方流水号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.objectno, o.objectno) as objectno -- 关联对象编号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.signtime, o.signtime) as signtime -- 签到时间
    ,nvl(n.signaddress, o.signaddress) as signaddress -- 签到地址
    ,nvl(n.attendeeid, o.attendeeid) as attendeeid -- 到场用户Id集合
    ,nvl(n.peersremark, o.peersremark) as peersremark -- 同行人员备注
    ,nvl(n.remark, o.remark) as remark -- 图片拍摄备注说明
    ,nvl(n.tasktype, o.tasktype) as tasktype -- 任务模式 1-信贷任务模式 2-展业新建任务模式
    ,nvl(n.workandsigndistance, o.workandsigndistance) as workandsigndistance -- 签到地址与办公地距离
    ,nvl(n.registerandsigndistance, o.registerandsigndistance) as registerandsigndistance -- 签到地址与注册地距离
    ,nvl(n.ispresent, o.ispresent) as ispresent -- 分配角色是否到场(code:YesNo)
    ,nvl(n.signreason, o.signreason) as signreason -- 签到原因说明
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
from (select * from ${iol_schema}.icms_af_spot_check_record_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_af_spot_check_record where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.applyno <> n.applyno
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.objecttype <> n.objecttype
        or o.objectno <> n.objectno
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.signtime <> n.signtime
        or o.signaddress <> n.signaddress
        or o.attendeeid <> n.attendeeid
        or o.peersremark <> n.peersremark
        or o.remark <> n.remark
        or o.tasktype <> n.tasktype
        or o.workandsigndistance <> n.workandsigndistance
        or o.registerandsigndistance <> n.registerandsigndistance
        or o.ispresent <> n.ispresent
        or o.signreason <> n.signreason
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_af_spot_check_record_cl(
            serialno -- 流水号
            ,applyno -- 关联方流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,objecttype -- 对象类型
            ,objectno -- 关联对象编号
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,signtime -- 签到时间
            ,signaddress -- 签到地址
            ,attendeeid -- 到场用户Id集合
            ,peersremark -- 同行人员备注
            ,remark -- 图片拍摄备注说明
            ,tasktype -- 任务模式 1-信贷任务模式 2-展业新建任务模式
            ,workandsigndistance -- 签到地址与办公地距离
            ,registerandsigndistance -- 签到地址与注册地距离
            ,ispresent -- 分配角色是否到场(code:YesNo)
            ,signreason -- 签到原因说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_af_spot_check_record_op(
            serialno -- 流水号
            ,applyno -- 关联方流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,objecttype -- 对象类型
            ,objectno -- 关联对象编号
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,signtime -- 签到时间
            ,signaddress -- 签到地址
            ,attendeeid -- 到场用户Id集合
            ,peersremark -- 同行人员备注
            ,remark -- 图片拍摄备注说明
            ,tasktype -- 任务模式 1-信贷任务模式 2-展业新建任务模式
            ,workandsigndistance -- 签到地址与办公地距离
            ,registerandsigndistance -- 签到地址与注册地距离
            ,ispresent -- 分配角色是否到场(code:YesNo)
            ,signreason -- 签到原因说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.applyno -- 关联方流水号
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.objecttype -- 对象类型
    ,o.objectno -- 关联对象编号
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.signtime -- 签到时间
    ,o.signaddress -- 签到地址
    ,o.attendeeid -- 到场用户Id集合
    ,o.peersremark -- 同行人员备注
    ,o.remark -- 图片拍摄备注说明
    ,o.tasktype -- 任务模式 1-信贷任务模式 2-展业新建任务模式
    ,o.workandsigndistance -- 签到地址与办公地距离
    ,o.registerandsigndistance -- 签到地址与注册地距离
    ,o.ispresent -- 分配角色是否到场(code:YesNo)
    ,o.signreason -- 签到原因说明
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
from ${iol_schema}.icms_af_spot_check_record_bk o
    left join ${iol_schema}.icms_af_spot_check_record_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_af_spot_check_record_cl d
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
--truncate table ${iol_schema}.icms_af_spot_check_record;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_af_spot_check_record') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_af_spot_check_record drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_af_spot_check_record add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_af_spot_check_record exchange partition p_${batch_date} with table ${iol_schema}.icms_af_spot_check_record_cl;
alter table ${iol_schema}.icms_af_spot_check_record exchange partition p_20991231 with table ${iol_schema}.icms_af_spot_check_record_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_af_spot_check_record to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_af_spot_check_record_op purge;
drop table ${iol_schema}.icms_af_spot_check_record_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_af_spot_check_record_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_af_spot_check_record',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
