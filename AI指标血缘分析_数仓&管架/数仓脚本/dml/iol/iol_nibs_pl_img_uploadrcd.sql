/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_pl_img_uploadrcd
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
create table ${iol_schema}.nibs_pl_img_uploadrcd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nibs_pl_img_uploadrcd
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_pl_img_uploadrcd_op purge;
drop table ${iol_schema}.nibs_pl_img_uploadrcd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_pl_img_uploadrcd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_pl_img_uploadrcd where 0=1;

create table ${iol_schema}.nibs_pl_img_uploadrcd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_pl_img_uploadrcd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_pl_img_uploadrcd_cl(
            channelcode -- 渠道编号
            ,modelcode -- 影像模型
            ,busi_date -- 业务日期
            ,busi_time -- 业务时间
            ,busi_serial_no -- 业务流水号
            ,uploadfile -- 上传文件列表
            ,content_id -- 影像批次号
            ,securitycode -- 防伪码
            ,eipaddr -- 影像地址
            ,uploaddate -- 更新日期
            ,uploadtime -- 更新时间
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_pl_img_uploadrcd_op(
            channelcode -- 渠道编号
            ,modelcode -- 影像模型
            ,busi_date -- 业务日期
            ,busi_time -- 业务时间
            ,busi_serial_no -- 业务流水号
            ,uploadfile -- 上传文件列表
            ,content_id -- 影像批次号
            ,securitycode -- 防伪码
            ,eipaddr -- 影像地址
            ,uploaddate -- 更新日期
            ,uploadtime -- 更新时间
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.channelcode, o.channelcode) as channelcode -- 渠道编号
    ,nvl(n.modelcode, o.modelcode) as modelcode -- 影像模型
    ,nvl(n.busi_date, o.busi_date) as busi_date -- 业务日期
    ,nvl(n.busi_time, o.busi_time) as busi_time -- 业务时间
    ,nvl(n.busi_serial_no, o.busi_serial_no) as busi_serial_no -- 业务流水号
    ,nvl(n.uploadfile, o.uploadfile) as uploadfile -- 上传文件列表
    ,nvl(n.content_id, o.content_id) as content_id -- 影像批次号
    ,nvl(n.securitycode, o.securitycode) as securitycode -- 防伪码
    ,nvl(n.eipaddr, o.eipaddr) as eipaddr -- 影像地址
    ,nvl(n.uploaddate, o.uploaddate) as uploaddate -- 更新日期
    ,nvl(n.uploadtime, o.uploadtime) as uploadtime -- 更新时间
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.channelcode is null
            and n.busi_date is null
            and n.busi_serial_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.channelcode is null
            and n.busi_date is null
            and n.busi_serial_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.channelcode is null
            and n.busi_date is null
            and n.busi_serial_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nibs_pl_img_uploadrcd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nibs_pl_img_uploadrcd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.channelcode = n.channelcode
            and o.busi_date = n.busi_date
            and o.busi_serial_no = n.busi_serial_no
where (
        o.channelcode is null
        and o.busi_date is null
        and o.busi_serial_no is null
    )
    or (
        n.channelcode is null
        and n.busi_date is null
        and n.busi_serial_no is null
    )
    or (
        o.modelcode <> n.modelcode
        or o.busi_time <> n.busi_time
        or o.uploadfile <> n.uploadfile
        or o.content_id <> n.content_id
        or o.securitycode <> n.securitycode
        or o.eipaddr <> n.eipaddr
        or o.uploaddate <> n.uploaddate
        or o.uploadtime <> n.uploadtime
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_pl_img_uploadrcd_cl(
            channelcode -- 渠道编号
            ,modelcode -- 影像模型
            ,busi_date -- 业务日期
            ,busi_time -- 业务时间
            ,busi_serial_no -- 业务流水号
            ,uploadfile -- 上传文件列表
            ,content_id -- 影像批次号
            ,securitycode -- 防伪码
            ,eipaddr -- 影像地址
            ,uploaddate -- 更新日期
            ,uploadtime -- 更新时间
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_pl_img_uploadrcd_op(
            channelcode -- 渠道编号
            ,modelcode -- 影像模型
            ,busi_date -- 业务日期
            ,busi_time -- 业务时间
            ,busi_serial_no -- 业务流水号
            ,uploadfile -- 上传文件列表
            ,content_id -- 影像批次号
            ,securitycode -- 防伪码
            ,eipaddr -- 影像地址
            ,uploaddate -- 更新日期
            ,uploadtime -- 更新时间
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.channelcode -- 渠道编号
    ,o.modelcode -- 影像模型
    ,o.busi_date -- 业务日期
    ,o.busi_time -- 业务时间
    ,o.busi_serial_no -- 业务流水号
    ,o.uploadfile -- 上传文件列表
    ,o.content_id -- 影像批次号
    ,o.securitycode -- 防伪码
    ,o.eipaddr -- 影像地址
    ,o.uploaddate -- 更新日期
    ,o.uploadtime -- 更新时间
    ,o.remark -- 备注
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
from ${iol_schema}.nibs_pl_img_uploadrcd_bk o
    left join ${iol_schema}.nibs_pl_img_uploadrcd_op n
        on
            o.channelcode = n.channelcode
            and o.busi_date = n.busi_date
            and o.busi_serial_no = n.busi_serial_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nibs_pl_img_uploadrcd_cl d
        on
            o.channelcode = d.channelcode
            and o.busi_date = d.busi_date
            and o.busi_serial_no = d.busi_serial_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nibs_pl_img_uploadrcd;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nibs_pl_img_uploadrcd') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nibs_pl_img_uploadrcd drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nibs_pl_img_uploadrcd add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nibs_pl_img_uploadrcd exchange partition p_${batch_date} with table ${iol_schema}.nibs_pl_img_uploadrcd_cl;
alter table ${iol_schema}.nibs_pl_img_uploadrcd exchange partition p_20991231 with table ${iol_schema}.nibs_pl_img_uploadrcd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_pl_img_uploadrcd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_pl_img_uploadrcd_op purge;
drop table ${iol_schema}.nibs_pl_img_uploadrcd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nibs_pl_img_uploadrcd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_pl_img_uploadrcd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
