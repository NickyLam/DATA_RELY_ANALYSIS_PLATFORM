/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_noas_oa_form_data_attachment
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
create table ${iol_schema}.noas_oa_form_data_attachment_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.noas_oa_form_data_attachment;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_form_data_attachment_op purge;
drop table ${iol_schema}.noas_oa_form_data_attachment_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_form_data_attachment_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_form_data_attachment where 0=1;

create table ${iol_schema}.noas_oa_form_data_attachment_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_form_data_attachment where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_form_data_attachment_cl(
            attachment_id -- 主键
            ,attach_name -- 附件唯一名
            ,attach_path -- 附件实际存放路径
            ,attach_order -- 附件顺序
            ,show_attach_name -- 附件显示名
            ,party_id -- 上传人
            ,attachment_type -- 文件类型：0正文类型，1附件类型,2合成文件，3，表单附件
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,content_type_id -- 文号类型，用于记录当前合成文件所用的模板类型
            ,is_cheack_stlye -- 排版环节标记是否已重新合成
            ,upper_level_id -- 父级ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_form_data_attachment_op(
            attachment_id -- 主键
            ,attach_name -- 附件唯一名
            ,attach_path -- 附件实际存放路径
            ,attach_order -- 附件顺序
            ,show_attach_name -- 附件显示名
            ,party_id -- 上传人
            ,attachment_type -- 文件类型：0正文类型，1附件类型,2合成文件，3，表单附件
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,content_type_id -- 文号类型，用于记录当前合成文件所用的模板类型
            ,is_cheack_stlye -- 排版环节标记是否已重新合成
            ,upper_level_id -- 父级ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.attachment_id, o.attachment_id) as attachment_id -- 主键
    ,nvl(n.attach_name, o.attach_name) as attach_name -- 附件唯一名
    ,nvl(n.attach_path, o.attach_path) as attach_path -- 附件实际存放路径
    ,nvl(n.attach_order, o.attach_order) as attach_order -- 附件顺序
    ,nvl(n.show_attach_name, o.show_attach_name) as show_attach_name -- 附件显示名
    ,nvl(n.party_id, o.party_id) as party_id -- 上传人
    ,nvl(n.attachment_type, o.attachment_type) as attachment_type -- 文件类型：0正文类型，1附件类型,2合成文件，3，表单附件
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- bosent自带最后修改时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- bosent自带最后修改时间
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- bosent自带创建时间
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- bosent自带创建时间
    ,nvl(n.content_type_id, o.content_type_id) as content_type_id -- 文号类型，用于记录当前合成文件所用的模板类型
    ,nvl(n.is_cheack_stlye, o.is_cheack_stlye) as is_cheack_stlye -- 排版环节标记是否已重新合成
    ,nvl(n.upper_level_id, o.upper_level_id) as upper_level_id -- 父级ID
    ,case when
            n.attachment_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.attachment_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.attachment_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.noas_oa_form_data_attachment_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.noas_oa_form_data_attachment where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.attachment_id = n.attachment_id
where (
        o.attachment_id is null
    )
    or (
        n.attachment_id is null
    )
    or (
        o.attach_name <> n.attach_name
        or o.attach_path <> n.attach_path
        or o.attach_order <> n.attach_order
        or o.show_attach_name <> n.show_attach_name
        or o.party_id <> n.party_id
        or o.attachment_type <> n.attachment_type
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.content_type_id <> n.content_type_id
        or o.is_cheack_stlye <> n.is_cheack_stlye
        or o.upper_level_id <> n.upper_level_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_form_data_attachment_cl(
            attachment_id -- 主键
            ,attach_name -- 附件唯一名
            ,attach_path -- 附件实际存放路径
            ,attach_order -- 附件顺序
            ,show_attach_name -- 附件显示名
            ,party_id -- 上传人
            ,attachment_type -- 文件类型：0正文类型，1附件类型,2合成文件，3，表单附件
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,content_type_id -- 文号类型，用于记录当前合成文件所用的模板类型
            ,is_cheack_stlye -- 排版环节标记是否已重新合成
            ,upper_level_id -- 父级ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_form_data_attachment_op(
            attachment_id -- 主键
            ,attach_name -- 附件唯一名
            ,attach_path -- 附件实际存放路径
            ,attach_order -- 附件顺序
            ,show_attach_name -- 附件显示名
            ,party_id -- 上传人
            ,attachment_type -- 文件类型：0正文类型，1附件类型,2合成文件，3，表单附件
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,content_type_id -- 文号类型，用于记录当前合成文件所用的模板类型
            ,is_cheack_stlye -- 排版环节标记是否已重新合成
            ,upper_level_id -- 父级ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.attachment_id -- 主键
    ,o.attach_name -- 附件唯一名
    ,o.attach_path -- 附件实际存放路径
    ,o.attach_order -- 附件顺序
    ,o.show_attach_name -- 附件显示名
    ,o.party_id -- 上传人
    ,o.attachment_type -- 文件类型：0正文类型，1附件类型,2合成文件，3，表单附件
    ,o.last_updated_stamp -- bosent自带最后修改时间
    ,o.last_updated_tx_stamp -- bosent自带最后修改时间
    ,o.created_stamp -- bosent自带创建时间
    ,o.created_tx_stamp -- bosent自带创建时间
    ,o.content_type_id -- 文号类型，用于记录当前合成文件所用的模板类型
    ,o.is_cheack_stlye -- 排版环节标记是否已重新合成
    ,o.upper_level_id -- 父级ID
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.noas_oa_form_data_attachment_bk o
    left join ${iol_schema}.noas_oa_form_data_attachment_op n
        on
            o.attachment_id = n.attachment_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.noas_oa_form_data_attachment_cl d
        on
            o.attachment_id = d.attachment_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.noas_oa_form_data_attachment;

-- 4.2 exchange partition
alter table ${iol_schema}.noas_oa_form_data_attachment exchange partition p_19000101 with table ${iol_schema}.noas_oa_form_data_attachment_cl;
alter table ${iol_schema}.noas_oa_form_data_attachment exchange partition p_20991231 with table ${iol_schema}.noas_oa_form_data_attachment_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.noas_oa_form_data_attachment to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_form_data_attachment_op purge;
drop table ${iol_schema}.noas_oa_form_data_attachment_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.noas_oa_form_data_attachment_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'noas_oa_form_data_attachment',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
