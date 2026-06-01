/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_doc_attachment
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
create table ${iol_schema}.icms_doc_attachment_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_doc_attachment
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_doc_attachment_op purge;
drop table ${iol_schema}.icms_doc_attachment_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_doc_attachment_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_doc_attachment where 0=1;

create table ${iol_schema}.icms_doc_attachment_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_doc_attachment where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_doc_attachment_cl(
            attachmentno -- 附件编号
            ,filename -- 文件名
            ,contenttype -- 内容类型
            ,contentlength -- 内容长度
            ,contentstatus -- 内容状态
            ,doccontent -- 文档内容
            ,remark -- 备注
            ,filepath -- 文件路径
            ,fullpath -- 文件全路径
            ,filesavemode -- 文件保存类型
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,begintime -- 发送开始时间
            ,endtime -- 发送完成时间
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,filebusicode -- esb文件管理平台唯一标识
            ,oldattachmentno -- 原附件编号
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_doc_attachment_op(
            attachmentno -- 附件编号
            ,filename -- 文件名
            ,contenttype -- 内容类型
            ,contentlength -- 内容长度
            ,contentstatus -- 内容状态
            ,doccontent -- 文档内容
            ,remark -- 备注
            ,filepath -- 文件路径
            ,fullpath -- 文件全路径
            ,filesavemode -- 文件保存类型
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,begintime -- 发送开始时间
            ,endtime -- 发送完成时间
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,filebusicode -- esb文件管理平台唯一标识
            ,oldattachmentno -- 原附件编号
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.attachmentno, o.attachmentno) as attachmentno -- 附件编号
    ,nvl(n.filename, o.filename) as filename -- 文件名
    ,nvl(n.contenttype, o.contenttype) as contenttype -- 内容类型
    ,nvl(n.contentlength, o.contentlength) as contentlength -- 内容长度
    ,nvl(n.contentstatus, o.contentstatus) as contentstatus -- 内容状态
    ,nvl(n.doccontent, o.doccontent) as doccontent -- 文档内容
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.filepath, o.filepath) as filepath -- 文件路径
    ,nvl(n.fullpath, o.fullpath) as fullpath -- 文件全路径
    ,nvl(n.filesavemode, o.filesavemode) as filesavemode -- 文件保存类型
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.begintime, o.begintime) as begintime -- 发送开始时间
    ,nvl(n.endtime, o.endtime) as endtime -- 发送完成时间
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.filebusicode, o.filebusicode) as filebusicode -- esb文件管理平台唯一标识
    ,nvl(n.oldattachmentno, o.oldattachmentno) as oldattachmentno -- 原附件编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,case when
            n.attachmentno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.attachmentno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.attachmentno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_doc_attachment_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_doc_attachment where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.attachmentno = n.attachmentno
where (
        o.attachmentno is null
    )
    or (
        n.attachmentno is null
    )
    or (
        o.filename <> n.filename
        or o.contenttype <> n.contenttype
        or o.contentlength <> n.contentlength
        or o.contentstatus <> n.contentstatus
        or o.doccontent <> n.doccontent
        or o.remark <> n.remark
        or o.filepath <> n.filepath
        or o.fullpath <> n.fullpath
        or o.filesavemode <> n.filesavemode
        or o.objecttype <> n.objecttype
        or o.objectno <> n.objectno
        or o.begintime <> n.begintime
        or o.endtime <> n.endtime
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.corporgid <> n.corporgid
        or o.filebusicode <> n.filebusicode
        or o.oldattachmentno <> n.oldattachmentno
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_doc_attachment_cl(
            attachmentno -- 附件编号
            ,filename -- 文件名
            ,contenttype -- 内容类型
            ,contentlength -- 内容长度
            ,contentstatus -- 内容状态
            ,doccontent -- 文档内容
            ,remark -- 备注
            ,filepath -- 文件路径
            ,fullpath -- 文件全路径
            ,filesavemode -- 文件保存类型
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,begintime -- 发送开始时间
            ,endtime -- 发送完成时间
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,filebusicode -- esb文件管理平台唯一标识
            ,oldattachmentno -- 原附件编号
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_doc_attachment_op(
            attachmentno -- 附件编号
            ,filename -- 文件名
            ,contenttype -- 内容类型
            ,contentlength -- 内容长度
            ,contentstatus -- 内容状态
            ,doccontent -- 文档内容
            ,remark -- 备注
            ,filepath -- 文件路径
            ,fullpath -- 文件全路径
            ,filesavemode -- 文件保存类型
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,begintime -- 发送开始时间
            ,endtime -- 发送完成时间
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,filebusicode -- esb文件管理平台唯一标识
            ,oldattachmentno -- 原附件编号
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.attachmentno -- 附件编号
    ,o.filename -- 文件名
    ,o.contenttype -- 内容类型
    ,o.contentlength -- 内容长度
    ,o.contentstatus -- 内容状态
    ,o.doccontent -- 文档内容
    ,o.remark -- 备注
    ,o.filepath -- 文件路径
    ,o.fullpath -- 文件全路径
    ,o.filesavemode -- 文件保存类型
    ,o.objecttype -- 对象类型
    ,o.objectno -- 对象编号
    ,o.begintime -- 发送开始时间
    ,o.endtime -- 发送完成时间
    ,o.inputorgid -- 登记机构
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 更新机构
    ,o.updateuserid -- 更新人
    ,o.updatedate -- 更新日期
    ,o.corporgid -- 法人机构编号
    ,o.filebusicode -- esb文件管理平台唯一标识
    ,o.oldattachmentno -- 原附件编号
    ,o.migtflag -- 
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
from ${iol_schema}.icms_doc_attachment_bk o
    left join ${iol_schema}.icms_doc_attachment_op n
        on
            o.attachmentno = n.attachmentno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_doc_attachment_cl d
        on
            o.attachmentno = d.attachmentno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_doc_attachment;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_doc_attachment') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_doc_attachment drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_doc_attachment add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_doc_attachment exchange partition p_${batch_date} with table ${iol_schema}.icms_doc_attachment_cl;
alter table ${iol_schema}.icms_doc_attachment exchange partition p_20991231 with table ${iol_schema}.icms_doc_attachment_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_doc_attachment to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_doc_attachment_op purge;
drop table ${iol_schema}.icms_doc_attachment_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_doc_attachment_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_doc_attachment',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
